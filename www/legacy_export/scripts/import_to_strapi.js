#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const cp = require('child_process');

const ROOT = path.resolve(__dirname, '..');
const META_DIR = path.join(ROOT, 'db', 'meta');
const REPORTS_DIR = path.join(ROOT, 'reports');
const SEED_PATH = path.join(META_DIR, 'site_seed.json');

const args = Object.fromEntries(
  process.argv.slice(2).map((arg) => {
    const [key, value] = arg.replace(/^--/, '').split('=');
    return [key, value ?? '1'];
  })
);

const TYPE = args.type || 'all';
const DRY_RUN = String(process.env.DRY_RUN || '1') !== '0';
const STRAPI_URL = (process.env.STRAPI_URL || '').replace(/\/$/, '');
const STRAPI_TOKEN = process.env.STRAPI_TOKEN || '';
const BATCH_SIZE = Number(args.batchSize || 50);

const ENDPOINTS = {
  productCategories: '/api/product-categories',
  products: '/api/products',
  newsCategories: '/api/news-categories',
  news: '/api/news-items',
  sitePages: '/api/site-pages',
  siteConfig: '/api/site-config',
  migrationStat: '/api/migration-stat'
};

function ensureSeedFile() {
  if (!fs.existsSync(SEED_PATH)) {
    cp.execFileSync('node', [path.join(__dirname, 'build_seed_data.js')], {
      stdio: 'inherit'
    });
  }
}

function readSeed() {
  ensureSeedFile();
  return JSON.parse(fs.readFileSync(SEED_PATH, 'utf8'));
}

function nowId() {
  return new Date().toISOString().replace(/[.:]/g, '-');
}

function getHeaders() {
  return {
    'Content-Type': 'application/json',
    ...(STRAPI_TOKEN ? { Authorization: `Bearer ${STRAPI_TOKEN}` } : {})
  };
}

async function request(url, options = {}) {
  const response = await fetch(url, {
    ...options,
    headers: {
      ...getHeaders(),
      ...(options.headers || {})
    }
  });

  const text = await response.text();
  let data = {};
  try {
    data = text ? JSON.parse(text) : {};
  } catch {
    data = { raw: text };
  }

  if (!response.ok) {
    const error = new Error(`HTTP ${response.status}`);
    error.status = response.status;
    error.response = data;
    throw error;
  }

  return data;
}

function createChunk(list, size) {
  const output = [];
  for (let index = 0; index < list.length; index += size) {
    output.push(list.slice(index, index + size));
  }
  return output;
}

function seoPayload(title, description) {
  return {
    seo: {
      title,
      description
    }
  };
}

async function fetchOneByField(endpoint, field, value) {
  const url = `${STRAPI_URL}${endpoint}?filters[${field}][$eq]=${encodeURIComponent(String(value))}&pagination[pageSize]=1`;
  const data = await request(url, { method: 'GET' });
  return data?.data?.[0] || null;
}

async function upsertCollection(endpoint, uniqueField, payload) {
  const existing = await fetchOneByField(endpoint, uniqueField, payload[uniqueField]);
  if (existing?.documentId) {
    await request(`${STRAPI_URL}${endpoint}/${existing.documentId}`, {
      method: 'PUT',
      body: JSON.stringify({ data: payload })
    });
    return { action: 'updated', id: existing.documentId };
  }

  const created = await request(`${STRAPI_URL}${endpoint}`, {
    method: 'POST',
    body: JSON.stringify({ data: payload })
  });

  return { action: 'created', id: created?.data?.documentId || created?.data?.id || null };
}

async function upsertSingle(endpoint, payload) {
  const method = 'PUT';
  const result = await request(`${STRAPI_URL}${endpoint}`, {
    method,
    body: JSON.stringify({ data: payload })
  });
  return { action: 'upserted', id: result?.data?.documentId || result?.data?.id || null };
}

function productPayload(item, categoryId) {
  return {
    legacyId: item.legacyId,
    title: item.title,
    slug: item.slug,
    code: item.code,
    summary: item.summary,
    content: item.content,
    legacyCoverPath: item.legacyCoverPath,
    hits: item.hits,
    publishedAtLegacy: item.publishedAtLegacy || null,
    specNl: item.specNl,
    specWg: item.specWg,
    specXj: item.specXj,
    specKg: item.specKg,
    specCh: item.specCh,
    category: categoryId || null,
    ...seoPayload(item.seoTitle, item.seoDescription)
  };
}

function newsPayload(item, categoryId) {
  return {
    legacyId: item.legacyId,
    title: item.title,
    slug: item.slug,
    subtitle: item.subtitle,
    content: item.content,
    legacyCoverPath: item.legacyCoverPath,
    hits: item.hits,
    publishedAtLegacy: item.publishedAtLegacy || null,
    legacySort: item.legacySort,
    isFeatured: item.isFeatured,
    category: categoryId || null,
    ...seoPayload(item.seoTitle, item.seoDescription)
  };
}

function sitePagePayload(item) {
  return {
    key: item.key,
    title: item.title,
    slug: item.slug,
    heroImage: item.heroImage,
    content: item.content,
    ...seoPayload(item.seoTitle, item.seoDescription)
  };
}

async function importSeed(seed) {
  const report = {
    startedAt: new Date().toISOString(),
    dryRun: DRY_RUN,
    stages: []
  };

  const productCategoryMap = new Map();
  const newsCategoryMap = new Map();

  const stages = [
    'productCategories',
    'newsCategories',
    'sitePages',
    'siteConfig',
    'migrationStat',
    'products',
    'news'
  ];

  for (const stage of stages) {
    if (TYPE !== 'all' && TYPE !== stage && !(TYPE === 'product' && stage === 'products') && !(TYPE === 'news' && stage === 'news')) {
      continue;
    }

    const stageReport = {
      stage,
      ok: 0,
      fail: 0,
      failures: []
    };

    if (stage === 'productCategories') {
      for (const item of seed.productCategories) {
        const payload = {
          legacyClassId: item.legacyClassId,
          name: item.name,
          slug: item.slug,
          sortOrder: item.sortOrder,
          isActive: true
        };

        if (DRY_RUN) {
          stageReport.ok += 1;
          productCategoryMap.set(item.legacyClassId, `dry-run-${item.legacyClassId}`);
          continue;
        }

        try {
          const result = await upsertCollection(ENDPOINTS.productCategories, 'legacyClassId', payload);
          productCategoryMap.set(item.legacyClassId, result.id);
          stageReport.ok += 1;
        } catch (error) {
          stageReport.fail += 1;
          stageReport.failures.push({ key: item.legacyClassId, message: error.message, response: error.response || null });
        }
      }
    }

    if (stage === 'newsCategories') {
      for (const item of seed.newsCategories) {
        const payload = {
          legacyClassId: item.legacyClassId,
          name: item.name,
          slug: item.slug,
          sortOrder: item.sortOrder
        };

        if (DRY_RUN) {
          stageReport.ok += 1;
          newsCategoryMap.set(item.legacyClassId, `dry-run-${item.legacyClassId}`);
          continue;
        }

        try {
          const result = await upsertCollection(ENDPOINTS.newsCategories, 'legacyClassId', payload);
          newsCategoryMap.set(item.legacyClassId, result.id);
          stageReport.ok += 1;
        } catch (error) {
          stageReport.fail += 1;
          stageReport.failures.push({ key: item.legacyClassId, message: error.message, response: error.response || null });
        }
      }
    }

    if (stage === 'sitePages') {
      for (const item of seed.sitePages) {
        if (DRY_RUN) {
          stageReport.ok += 1;
          continue;
        }

        try {
          await upsertCollection(ENDPOINTS.sitePages, 'key', sitePagePayload(item));
          stageReport.ok += 1;
        } catch (error) {
          stageReport.fail += 1;
          stageReport.failures.push({ key: item.key, message: error.message, response: error.response || null });
        }
      }
    }

    if (stage === 'siteConfig') {
      if (DRY_RUN) {
        stageReport.ok = 1;
      } else {
        try {
          await upsertSingle(ENDPOINTS.siteConfig, {
            ...seed.siteConfig,
            ...seoPayload(seed.siteConfig.siteName, seed.siteConfig.heroSubtitle)
          });
          stageReport.ok = 1;
        } catch (error) {
          stageReport.fail = 1;
          stageReport.failures.push({ key: 'site-config', message: error.message, response: error.response || null });
        }
      }
    }

    if (stage === 'migrationStat') {
      if (DRY_RUN) {
        stageReport.ok = 1;
      } else {
        try {
          await upsertSingle(ENDPOINTS.migrationStat, seed.feedbackStats);
          stageReport.ok = 1;
        } catch (error) {
          stageReport.fail = 1;
          stageReport.failures.push({ key: 'migration-stat', message: error.message, response: error.response || null });
        }
      }
    }

    if (stage === 'products') {
      for (const batch of createChunk(seed.products, BATCH_SIZE)) {
        for (const item of batch) {
          const payload = productPayload(item, productCategoryMap.get(item.categoryLegacyClassId) || null);

          if (DRY_RUN) {
            stageReport.ok += 1;
            continue;
          }

          try {
            await upsertCollection(ENDPOINTS.products, 'legacyId', payload);
            stageReport.ok += 1;
          } catch (error) {
            stageReport.fail += 1;
            stageReport.failures.push({ key: item.legacyId, message: error.message, response: error.response || null });
          }
        }
      }
    }

    if (stage === 'news') {
      for (const batch of createChunk(seed.news, BATCH_SIZE)) {
        for (const item of batch) {
          const payload = newsPayload(item, newsCategoryMap.get(item.categoryLegacyClassId) || null);

          if (DRY_RUN) {
            stageReport.ok += 1;
            continue;
          }

          try {
            await upsertCollection(ENDPOINTS.news, 'legacyId', payload);
            stageReport.ok += 1;
          } catch (error) {
            stageReport.fail += 1;
            stageReport.failures.push({ key: item.legacyId, message: error.message, response: error.response || null });
          }
        }
      }
    }

    report.stages.push(stageReport);
  }

  report.finishedAt = new Date().toISOString();
  return report;
}

async function main() {
  fs.mkdirSync(REPORTS_DIR, { recursive: true });

  if (!DRY_RUN && !STRAPI_URL) {
    throw new Error('DRY_RUN=0 requires STRAPI_URL');
  }

  const report = await importSeed(readSeed());
  const outputPath = path.join(REPORTS_DIR, `phase4_import_run_${nowId()}.json`);
  fs.writeFileSync(outputPath, JSON.stringify(report, null, 2), 'utf8');

  console.log(JSON.stringify({ output: outputPath, report }, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
