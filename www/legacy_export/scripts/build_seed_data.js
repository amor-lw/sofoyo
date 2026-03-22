#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const WWW_ROOT = path.resolve(ROOT, '..');
const META_DIR = path.join(ROOT, 'db', 'meta');
const CSV_DIR = path.join(ROOT, 'db', 'csv_utf8');

const PRODUCT_CATEGORIES = [
  { legacyClassId: 47, name: '西班牙筒瓦系列', slug: 'spanish-barrel-tiles', sortOrder: 1 },
  { legacyClassId: 53, name: '前沿瓦系列', slug: 'frontier-tiles', sortOrder: 2 },
  { legacyClassId: 54, name: '青瓦系列', slug: 'grey-tiles', sortOrder: 3 },
  { legacyClassId: 55, name: '古建瓦系列', slug: 'heritage-tiles', sortOrder: 4 },
  { legacyClassId: 56, name: '古建花格系列', slug: 'heritage-lattice', sortOrder: 5 },
  { legacyClassId: 57, name: '琉璃瓦系列', slug: 'glazed-tiles', sortOrder: 6 },
  { legacyClassId: 58, name: '袖珍装饰瓦系列', slug: 'mini-decor-tiles', sortOrder: 7 },
  { legacyClassId: 59, name: '琉璃瓦配件系列', slug: 'glazed-accessories', sortOrder: 8 },
  { legacyClassId: 60, name: '西班牙瓦系列', slug: 'spanish-tiles', sortOrder: 9 },
  { legacyClassId: 61, name: '欧式平板瓦系列', slug: 'european-flat-tiles', sortOrder: 10 },
  { legacyClassId: 62, name: '欧式圣塔瓦系列', slug: 'european-santa-tiles', sortOrder: 11 },
  { legacyClassId: 63, name: '英式石板瓦系列', slug: 'english-slate-tiles', sortOrder: 12 },
  { legacyClassId: 64, name: '意大利瓦系列', slug: 'italian-tiles', sortOrder: 13 },
  { legacyClassId: 65, name: '鱼鳞瓦系列', slug: 'fish-scale-tiles', sortOrder: 14 },
  { legacyClassId: 66, name: '中式罗曼瓦系列', slug: 'chinese-roman-tiles', sortOrder: 15 },
  { legacyClassId: 67, name: '闽南红砖系列', slug: 'minnan-red-bricks', sortOrder: 16 },
  { legacyClassId: 68, name: '中式泰山瓦系列', slug: 'taishan-tiles', sortOrder: 17 },
  { legacyClassId: 69, name: '中式脊瓦系列', slug: 'ridge-tiles', sortOrder: 18 },
  { legacyClassId: 70, name: '法式脊瓦系列', slug: 'french-ridge-tiles', sortOrder: 19 },
  { legacyClassId: 71, name: '滴水系列', slug: 'drip-edge-series', sortOrder: 20 },
  { legacyClassId: 72, name: '中式古典瓦系列', slug: 'classic-chinese-tiles', sortOrder: 21 },
  { legacyClassId: 73, name: '中式古建连体瓦系列', slug: 'linked-heritage-tiles', sortOrder: 22 },
  { legacyClassId: 74, name: '墙砖系列', slug: 'wall-tiles', sortOrder: 23 },
  { legacyClassId: 75, name: '微派青瓦系列', slug: 'micro-grey-tiles', sortOrder: 24 },
  { legacyClassId: 76, name: '地砖系列', slug: 'floor-tiles', sortOrder: 25 },
  { legacyClassId: 77, name: '连锁瓦配件系列', slug: 'interlock-accessories', sortOrder: 26 },
  { legacyClassId: 78, name: '西式瓦配件系列', slug: 'western-accessories', sortOrder: 27 },
  { legacyClassId: 79, name: '波型瓦配件系列', slug: 'wave-accessories', sortOrder: 28 },
  { legacyClassId: 80, name: '生态地铺石系列', slug: 'eco-paving-stones', sortOrder: 29 }
];

const NEWS_CATEGORIES = [
  { legacyClassId: 10, name: '企业新闻', slug: 'company-news', sortOrder: 1 },
  { legacyClassId: 11, name: '行业动态', slug: 'industry-updates', sortOrder: 2 },
  { legacyClassId: 12, name: '媒体报道', slug: 'media-coverage', sortOrder: 3 }
];

const STATIC_PAGES = [
  { key: 'about', title: '企业简介', source: 'about.asp', heroImage: '/legacy-assets/image/aboutpic.jpg' },
  { key: 'honor', title: '企业荣誉', source: 'honor.asp', heroImage: '/legacy-assets/image/honor.jpg' },
  { key: 'culture', title: '企业文化', source: 'culture.asp', heroImage: '/legacy-assets/image/aboutpic.jpg' },
  { key: 'workshop', title: '生产流程', source: 'workshop.asp', heroImage: '/legacy-assets/image/liucheng.jpg' },
  { key: 'history', title: '海外投资', source: 'history.asp', heroImage: '/legacy-assets/image/haiwai.jpg' },
  { key: 'service', title: '营销网络', source: 'service.asp', heroImage: '/legacy-assets/image/servicepic.jpg' },
  { key: 'service-join', title: '招商加盟', source: 'serivce1.asp', heroImage: '/legacy-assets/image/join.jpg' },
  { key: 'service-method', title: '施工方法', source: 'serivce2.asp', heroImage: '/legacy-assets/image/method.jpg' },
  { key: 'service-knowledge', title: '屋瓦常识', source: 'knowledge.asp', heroImage: '/legacy-assets/image/servicepic.jpg' },
  { key: 'service-projects', title: '工程案例', source: 'serivce3.asp', heroImage: '/legacy-assets/image/servicepic.jpg' },
  { key: 'job', title: '人才战略', source: 'job.asp', heroImage: '/legacy-assets/image/jobpic.jpg' },
  { key: 'job-openings', title: '岗位需求', source: 'job1.asp', heroImage: '/legacy-assets/image/jobpic.jpg' },
  { key: 'contact', title: '联系方式', source: 'contact.asp', heroImage: '/legacy-assets/image/contactpic.jpg' }
];

function readAsUtf8FromGb(filePath) {
  return new TextDecoder('gb18030').decode(fs.readFileSync(filePath));
}

function slugify(value) {
  return String(value || '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9\u4e00-\u9fa5]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .replace(/-+/g, '-');
}

function safeSlug(value, fallback) {
  const slug = String(value || '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9-_.~]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .replace(/-+/g, '-');

  return slug || fallback;
}

function parseCsv(text) {
  const rows = [];
  let row = [];
  let cell = '';
  let inQuotes = false;

  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    const next = text[i + 1];

    if (char === '"') {
      if (inQuotes && next === '"') {
        cell += '"';
        i += 1;
      } else {
        inQuotes = !inQuotes;
      }
      continue;
    }

    if (char === ',' && !inQuotes) {
      row.push(cell);
      cell = '';
      continue;
    }

    if ((char === '\n' || char === '\r') && !inQuotes) {
      if (char === '\r' && next === '\n') {
        i += 1;
      }
      row.push(cell);
      cell = '';
      if (row.length > 1 || row[0] !== '') {
        rows.push(row);
      }
      row = [];
      continue;
    }

    cell += char;
  }

  if (cell.length > 0 || row.length > 0) {
    row.push(cell);
    rows.push(row);
  }

  const [header, ...data] = rows;
  return data.map((values) => {
    const item = {};
    header.forEach((key, index) => {
      item[key] = values[index] || '';
    });
    return item;
  });
}

function firstMatch(text, patterns) {
  for (const pattern of patterns) {
    const match = text.match(pattern);
    if (match) {
      return match[1].trim();
    }
  }
  return '';
}

function extractHtmlBlock(html, candidates) {
  return firstMatch(html, candidates)
    .replace(/<%[\s\S]*?%>/g, '')
    .replace(/<script[\s\S]*?<\/script>/gi, '')
    .replace(/^\s+|\s+$/g, '');
}

function extractDivById(html, ids) {
  for (const id of ids) {
    const startRe = new RegExp(`<div[^>]*id=["']${id}["'][^>]*>`, 'i');
    const startMatch = startRe.exec(html);
    if (!startMatch) continue;

    let depth = 1;
    let index = startMatch.index + startMatch[0].length;

    while (index < html.length) {
      const nextOpen = html.slice(index).search(/<div\b[^>]*>/i);
      const nextClose = html.slice(index).search(/<\/div>/i);

      if (nextClose === -1) break;

      if (nextOpen !== -1 && nextOpen < nextClose) {
        depth += 1;
        index += nextOpen + html.slice(index + nextOpen).match(/<div\b[^>]*>/i)[0].length;
        continue;
      }

      depth -= 1;
      const closeIndex = index + nextClose;
      if (depth === 0) {
        return html
          .slice(startMatch.index + startMatch[0].length, closeIndex)
          .replace(/<%[\s\S]*?%>/g, '')
          .replace(/<script[\s\S]*?<\/script>/gi, '')
          .trim();
      }
      index = closeIndex + 6;
    }
  }

  return '';
}

function makeLegacyAssetPath(type, fileName) {
  if (!fileName) return '';
  if (type === 'product') return `/legacy-assets/uploadpic/product/${fileName}`;
  if (type === 'news') return `/legacy-assets/uploadpic/downwall/${fileName}`;
  return `/legacy-assets/${fileName.replace(/^\/+/, '')}`;
}

function readCsv(fileName) {
  return parseCsv(fs.readFileSync(path.join(CSV_DIR, fileName), 'utf8'));
}

function splitSqlTuple(tuple) {
  const values = [];
  let cell = '';
  let depth = 0;

  for (let i = 0; i < tuple.length; i += 1) {
    const char = tuple[i];

    if (char === '(') {
      depth += 1;
      if (depth === 1) continue;
    }

    if (char === ')') {
      depth -= 1;
      if (depth === 0) {
        values.push(cell.trim());
        cell = '';
        continue;
      }
    }

    if (char === ',' && depth === 1) {
      values.push(cell.trim());
      cell = '';
      continue;
    }

    cell += char;
  }

  return values;
}

function parseSqlInsertRows(fileName, columns) {
  const raw = fs.readFileSync(path.join(ROOT, 'db', 'csv', fileName), 'utf8').trim();
  const tuples = raw.match(/\((?:[^()]|\([^()]*\))*\)/g) || [];

  return tuples.map((tuple) => {
    const values = splitSqlTuple(tuple);
    const item = {};

    columns.forEach((column, index) => {
      const value = values[index] || '';
      item[column] = value === 'NULL' ? '' : value;
    });

    return item;
  });
}

function buildKnowledgeContent() {
  const rows = readCsv('cy_news3.csv')
    .filter((row) => String(row.class_ID) === '16' && String(row.bcount || '0') === '0')
    .sort((a, b) => Number(b.ID) - Number(a.ID));

  if (!rows.length) return '';

  return `<ul>${rows
    .map(
      (row) => {
        const title = row.title || '未命名文章';
        const slug = safeSlug(`${slugify(title) || title}-${row.ID}`, `news-${row.ID}`);
        const excerpt = (row.content || '')
          .replace(/<[^>]+>/g, ' ')
          .replace(/\s+/g, ' ')
          .trim()
          .slice(0, 140);

        return `<li><strong><a href="/news/${slug}?from=knowledge">${title}</a></strong><p>${excerpt}</p></li>`;
      }
    )
    .join('')}</ul>`;
}

function buildJobOpeningsContent() {
  const columns = [
    'id',
    'name',
    'sort',
    'specialty',
    's_sort',
    'place',
    'kind',
    'num',
    'sex',
    'edu',
    'remark',
    'pay',
    'pay2',
    'time',
    'hits',
    'uid',
    'bdate',
    'date',
    'age',
    'age1',
    'object'
  ];

  const rows = parseSqlInsertRows('CY_job.csv', columns).filter((row) => String(row.object || '0') === '0');

  if (!rows.length) return '';

  return `<ul>${rows
    .map(
      (row) => `<li>
        <p><strong>职位：</strong>${row.name || '未命名职位'}（${row.num || '若干'}人）</p>
        <p><strong>部门：</strong>${row.pay2 || '待补充'}</p>
        <p><strong>学历：</strong>${row.edu || '不限'}</p>
        <p><strong>待遇：</strong>${row.pay || '面议'}</p>
        <p><strong>要求：</strong>${(row.remark || '待补充').replace(/<br\s*\/?>/gi, '<br />')}</p>
      </li>`
    )
    .join('')}</ul>`;
}

function buildStaticPages() {
  const pageContentIds = {
    about: ['content'],
    honor: ['workshop'],
    culture: ['culture'],
    workshop: ['liucheng'],
    history: ['haiwai'],
    service: ['content'],
    'service-join': ['join'],
    'service-method': ['method'],
    'service-projects': ['project'],
    'service-knowledge': ['knowledge'],
    job: ['content'],
    'job-openings': ['job'],
    contact: ['contact']
  };

  return STATIC_PAGES.map((page) => {
    const html = readAsUtf8FromGb(path.join(WWW_ROOT, page.source));
    let content = extractDivById(html, pageContentIds[page.key] || []);

    if (page.key === 'service-knowledge') {
      content = buildKnowledgeContent();
    }

    if (page.key === 'job-openings') {
      content = buildJobOpeningsContent();
    }

    if (page.key === 'honor') {
      content =
        '<p>企业荣誉页原站主要为图集展示，当前导出保留了栏目结构，建议后续在 Strapi 中继续补录荣誉证书图片与说明。</p>';
    }

    return {
      key: page.key,
      title: page.title,
      slug: page.key,
      heroImage: page.heroImage,
      content,
      seoTitle: `${page.title} | sofoyo`,
      seoDescription: `${page.title} 页面内容来自旧站迁移。`
    };
  });
}

function buildSiteConfig() {
  const html = readAsUtf8FromGb(path.join(WWW_ROOT, 'contact.asp'));
  const contactBlock = extractHtmlBlock(html, [/<div class="contact">([\s\S]*?)<\/div>/i]);
  const lines = Array.from(contactBlock.matchAll(/<p[^>]*>([\s\S]*?)<\/p>/gi)).map((m) =>
    m[1].replace(/<[^>]+>/g, '').trim()
  );

  const companyName = lines[0] || '福建省泉州盛福建材科技有限公司';
  const address = (lines.find((line) => line.includes('地址')) || '').replace(/^地址[:：]?\s*/, '');
  const postcode = (lines.find((line) => line.includes('邮编')) || '').replace(/^邮编[:：]?\s*/, '');
  const phone = (lines.find((line) => line.includes('电话')) || '').replace(/^电话[:：]?\s*/, '');
  const fax = (lines.find((line) => line.includes('传真')) || '').replace(/^传真[:：]?\s*/, '');
  const email = (lines.find((line) => line.includes('电子邮箱')) || '').replace(/^电子邮箱[:：]?\s*/, '');

  return {
    siteName: companyName,
    siteUrl: 'http://localhost:4321',
    contactEmail: email,
    contactPhone: phone,
    fax,
    postcode,
    address,
    footerText: `${companyName} 版权所有`,
    heroTitle: '专注陶瓷屋面系统与古建材料',
    heroSubtitle: '聚焦屋面系统解决方案，服务现代建筑与古建修缮场景。',
    homepageAbout:
      '舒菲娅长期专注陶瓷屋面系统、古建配套材料与工程应用服务，产品覆盖西式屋瓦、中式古建瓦及多类配套构件。'
  };
}

function buildProducts() {
  const rows = readCsv('CY_hdtp.csv');
  const categoryMap = new Map(PRODUCT_CATEGORIES.map((item) => [String(item.legacyClassId), item]));

  return rows.map((row) => {
    const title = row.title || `product-${row.ID}`;
    const category = categoryMap.get(String(row.class_ID));
    return {
      legacyId: Number(row.ID),
      title,
      slug: slugify(title),
      code: row.code || '',
      summary: [row.j1, row.j2].filter(Boolean).join(' / '),
      content: row.content || '',
      legacyCoverPath: makeLegacyAssetPath('product', row.page),
      categoryLegacyClassId: Number(row.class_ID || 0),
      categorySlug: category ? category.slug : 'uncategorized',
      hits: Number(row.hits || 0),
      publishedAtLegacy: row.time || '',
      specNl: row.nl || '',
      specWg: row.wg || '',
      specXj: row.xj || '',
      specKg: row.kg || '',
      specCh: row.ch || '',
      seoTitle: `${title} | sofoyo`,
      seoDescription: row.j1 || row.title || ''
    };
  });
}

function buildNews() {
  const rows = readCsv('cy_news3.csv');
  const categoryMap = new Map(NEWS_CATEGORIES.map((item) => [String(item.legacyClassId), item]));

  return rows.map((row) => {
    const title = row.title || `news-${row.ID}`;
    const category = categoryMap.get(String(row.class_ID));
    return {
      legacyId: Number(row.ID),
      title,
      slug: slugify(title) || `news-${row.ID}`,
      subtitle: row.title2 || '',
      content: row.content || '',
      legacyCoverPath: makeLegacyAssetPath('news', row.page),
      categoryLegacyClassId: Number(row.class_ID || 0),
      categorySlug: category ? category.slug : 'company-news',
      hits: Number(row.hits || 0),
      publishedAtLegacy: row.time || row.bdate || '',
      legacySort: Number(row.px || 0),
      isFeatured: String(row.btype || 0) !== '0',
      seoTitle: `${title} | sofoyo`,
      seoDescription: row.title2 || title
    };
  });
}

function buildFeedbackStats() {
  const preview = JSON.parse(fs.readFileSync(path.join(META_DIR, 'phase4_import_preview.json'), 'utf8'));
  return {
    key: 'legacy-feedback',
    total: preview.feedbackStats.total,
    byYear: preview.feedbackStats.byYear,
    bySource: preview.feedbackStats.bySource,
    note: preview.feedbackStats.policy
  };
}

function main() {
  fs.mkdirSync(META_DIR, { recursive: true });

  const seed = {
    generatedAt: new Date().toISOString(),
    productCategories: PRODUCT_CATEGORIES,
    newsCategories: NEWS_CATEGORIES,
    sitePages: buildStaticPages(),
    siteConfig: buildSiteConfig(),
    feedbackStats: buildFeedbackStats(),
    products: buildProducts(),
    news: buildNews()
  };

  const outPath = path.join(META_DIR, 'site_seed.json');
  fs.writeFileSync(outPath, JSON.stringify(seed, null, 2), 'utf8');

  console.log(
    JSON.stringify(
      {
        output: outPath,
        counts: {
          productCategories: seed.productCategories.length,
          newsCategories: seed.newsCategories.length,
          sitePages: seed.sitePages.length,
          products: seed.products.length,
          news: seed.news.length
        }
      },
      null,
      2
    )
  );
}

main();
