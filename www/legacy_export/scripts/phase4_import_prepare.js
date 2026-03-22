#!/usr/bin/env node
/*
 Phase 4 preparer (safe mode)
 - Read csv_utf8
 - Build normalized payload preview for Product/News
 - Build CY_feedback2 aggregate stats only (no PII content migration)
 - Split into batches (default 50)
*/

const fs = require('fs');
const path = require('path');

const ROOT = '/home/mo/sofoyo/www';
const BASE = path.join(ROOT, 'legacy_export');
const META = path.join(BASE, 'db/meta/field_mapping.json');

function readText(p) {
  return fs.readFileSync(p, 'utf8');
}

function parseCsv(content) {
  const rows = [];
  let row = [];
  let cell = '';
  let i = 0;
  let inQuotes = false;

  while (i < content.length) {
    const ch = content[i];

    if (inQuotes) {
      if (ch === '"') {
        if (content[i + 1] === '"') {
          cell += '"';
          i += 2;
          continue;
        }
        inQuotes = false;
        i++;
        continue;
      }
      cell += ch;
      i++;
      continue;
    }

    if (ch === '"') {
      inQuotes = true;
      i++;
      continue;
    }

    if (ch === ',') {
      row.push(cell);
      cell = '';
      i++;
      continue;
    }

    if (ch === '\n') {
      row.push(cell);
      rows.push(row);
      row = [];
      cell = '';
      i++;
      continue;
    }

    if (ch === '\r') {
      i++;
      continue;
    }

    cell += ch;
    i++;
  }

  if (cell.length > 0 || row.length > 0) {
    row.push(cell);
    rows.push(row);
  }

  if (!rows.length) return [];
  const header = rows[0];
  return rows.slice(1).filter(r => r.some(v => (v || '').trim() !== '')).map((r) => {
    const obj = {};
    for (let i = 0; i < header.length; i++) obj[header[i]] = r[i] ?? '';
    return obj;
  });
}

function toInt(v, fallback = 0) {
  const n = Number(String(v || '').trim());
  return Number.isFinite(n) ? Math.trunc(n) : fallback;
}

function toDateIso(v) {
  const s = String(v || '').trim();
  if (!s) return null;
  const d = new Date(s);
  if (!Number.isNaN(d.getTime())) return d.toISOString();
  return null;
}

function pickSummary(a, b) {
  const s1 = String(a || '').trim();
  const s2 = String(b || '').trim();
  return s1 || s2 || '';
}

function splitBatches(list, size) {
  const out = [];
  for (let i = 0; i < list.length; i += size) out.push(list.slice(i, i + size));
  return out;
}

function normalizeProduct(rows) {
  return rows.map((r) => ({
    legacyId: toInt(r.ID, null),
    title: String(r.title || '').trim(),
    code: String(r.code || '').trim(),
    summary: pickSummary(r.j1, r.j2),
    content: String(r.content || '').trim(),
    coverPath: String(r.page || '').trim(),
    categoryLegacyClassId: toInt(r.class_ID, null),
    hits: toInt(r.hits, 0),
    publishedAtLegacy: toDateIso(r.time),
    spec_nl: String(r.nl || '').trim(),
    spec_wg: String(r.wg || '').trim(),
    spec_xj: String(r.xj || '').trim(),
    spec_kg: String(r.kg || '').trim(),
    spec_ch: String(r.ch || '').trim()
  })).filter(x => x.legacyId !== null && x.title);
}

function normalizeNews(rows) {
  return rows.map((r) => ({
    legacyId: toInt(r.ID, null),
    title: String(r.title || '').trim(),
    subtitle: String(r.title2 || '').trim(),
    content: String(r.content || '').trim(),
    coverPath: String(r.page || '').trim(),
    categoryLegacyClassId: toInt(r.class_ID, null),
    hits: toInt(r.hits, 0),
    publishedAtLegacy: toDateIso(r.time) || toDateIso(r.bdate),
    legacySort: toInt(r.px, 0),
    isFeatured: toInt(r.btype, 0) !== 0
  })).filter(x => x.legacyId !== null && x.title);
}

function feedbackStats(rows) {
  const byYear = {};
  const bySource = {};

  for (const r of rows) {
    const t = toDateIso(r.time);
    if (t) {
      const y = new Date(t).getUTCFullYear();
      byYear[y] = (byYear[y] || 0) + 1;
    } else {
      byYear['unknown'] = (byYear['unknown'] || 0) + 1;
    }

    const src = String(r.laiyuan || '').trim() || 'unknown';
    bySource[src] = (bySource[src] || 0) + 1;
  }

  return {
    total: rows.length,
    byYear,
    bySource,
    policy: 'stats_only_no_body_migration'
  };
}

function main() {
  const mapping = JSON.parse(readText(META));
  const batchSize = Number(process.argv[2]) || mapping.batch.size || 50;

  const productCsv = readText(path.join(ROOT, mapping.sources.product));
  const newsCsv = readText(path.join(ROOT, mapping.sources.news));
  const feedbackCsv = readText(path.join(ROOT, mapping.sources.feedback));

  const productRows = parseCsv(productCsv);
  const newsRows = parseCsv(newsCsv);
  const feedbackRows = parseCsv(feedbackCsv);

  const products = normalizeProduct(productRows);
  const news = normalizeNews(newsRows);
  const fstats = feedbackStats(feedbackRows);

  const productBatches = splitBatches(products, batchSize);
  const newsBatches = splitBatches(news, batchSize);

  const outDir = path.join(BASE, 'db/meta');
  fs.mkdirSync(outDir, { recursive: true });

  const payload = {
    generatedAt: new Date().toISOString(),
    batchSize,
    counts: {
      productRaw: productRows.length,
      productValid: products.length,
      productBatches: productBatches.length,
      newsRaw: newsRows.length,
      newsValid: news.length,
      newsBatches: newsBatches.length,
      feedbackRaw: feedbackRows.length
    },
    feedbackStats: fstats,
    samples: {
      product: products[0] || null,
      news: news[0] || null
    }
  };

  fs.writeFileSync(path.join(outDir, 'phase4_import_preview.json'), JSON.stringify(payload, null, 2), 'utf8');
  fs.writeFileSync(path.join(outDir, 'phase4_product_batches.json'), JSON.stringify(productBatches, null, 2), 'utf8');
  fs.writeFileSync(path.join(outDir, 'phase4_news_batches.json'), JSON.stringify(newsBatches, null, 2), 'utf8');

  const report = [
    '# Phase 4 导入准备报告',
    '',
    `- 生成时间: ${payload.generatedAt}`,
    `- 批次大小: ${batchSize}`,
    `- Product: ${payload.counts.productValid}/${payload.counts.productRaw}（${payload.counts.productBatches} 批）`,
    `- News: ${payload.counts.newsValid}/${payload.counts.newsRaw}（${payload.counts.newsBatches} 批）`,
    `- Feedback2(仅统计): ${payload.feedbackStats.total}`,
    '',
    '## Feedback2 统计（按年份）',
    ...Object.entries(payload.feedbackStats.byYear).map(([k, v]) => `- ${k}: ${v}`),
    '',
    '## Feedback2 统计（按来源）',
    ...Object.entries(payload.feedbackStats.bySource).map(([k, v]) => `- ${k}: ${v}`)
  ].join('\n');

  fs.writeFileSync(path.join(BASE, 'reports', `phase4_prepare_${Date.now()}.md`), report, 'utf8');

  console.log(JSON.stringify(payload.counts, null, 2));
}

main();
