#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const core = require('@strapi/core');

const seedPath = process.argv[2]
  ? path.resolve(process.cwd(), process.argv[2])
  : path.resolve(process.cwd(), '../../www/legacy_export/db/meta/site_seed.json');

function ensureSeed() {
  if (!fs.existsSync(seedPath)) {
    throw new Error(`Seed file not found: ${seedPath}`);
  }
  return JSON.parse(fs.readFileSync(seedPath, 'utf8'));
}

async function findOneByField(strapi, uid, field, value) {
  const results = await strapi.entityService.findMany(uid, {
    filters: {
      [field]: value
    },
    limit: 1
  });

  return Array.isArray(results) ? results[0] || null : results || null;
}

async function upsertCollection(strapi, uid, field, value, data) {
  const existing = await findOneByField(strapi, uid, field, value);

  if (existing?.documentId) {
    const updated = await strapi.documents(uid).update({
      documentId: existing.documentId,
      status: 'published',
      data
    });
    return { action: 'updated', id: existing.id, documentId: updated.documentId };
  }

  const created = await strapi.documents(uid).create({
    status: 'published',
    data
  });
  return { action: 'created', id: created.id, documentId: created.documentId };
}

async function upsertSingle(strapi, uid, data) {
  const existing = await strapi.documents(uid).findFirst({ status: 'draft' });

  if (existing?.documentId) {
    await strapi.documents(uid).update({
      documentId: existing.documentId,
      status: 'published',
      data
    });
    return { action: 'updated', documentId: existing.documentId };
  }

  const created = await strapi.documents(uid).create({
    status: 'published',
    data
  });
  return { action: 'created', documentId: created.documentId };
}

async function ensureSingle(strapi, uid, data, options = {}) {
  const { overwrite = false } = options;
  const existing = await strapi.documents(uid).findFirst({ status: 'draft' });

  if (existing?.documentId) {
    if (!overwrite) {
      return { action: 'skipped', documentId: existing.documentId };
    }

    await strapi.documents(uid).update({
      documentId: existing.documentId,
      status: 'published',
      data
    });
    return { action: 'updated', documentId: existing.documentId };
  }

  const created = await strapi.documents(uid).create({
    status: 'published',
    data
  });
  return { action: 'created', documentId: created.documentId };
}

function withSeo(item) {
  return {
    seo: {
      title: item.seoTitle || item.title || item.siteName || '',
      description: item.seoDescription || item.heroSubtitle || item.summary || item.subtitle || ''
    }
  };
}

function normalizeDate(value) {
  if (!value) return null;

  if (/^\d{4}-\d{2}-\d{2}T/.test(value)) {
    return value;
  }

  const parsed = new Date(value);
  if (!Number.isNaN(parsed.getTime())) {
    return parsed.toISOString();
  }

  const match = String(value).match(
    /^(\d{1,2})\/(\d{1,2})\/(\d{2,4})(?:\s+(\d{1,2}):(\d{2})(?::(\d{2}))?)?$/
  );

  if (!match) return null;

  const [, month, day, yearRaw, hour = '0', minute = '0', second = '0'] = match;
  const year = Number(yearRaw.length === 2 ? `20${yearRaw}` : yearRaw);
  const iso = new Date(
    Date.UTC(Number(year), Number(month) - 1, Number(day), Number(hour), Number(minute), Number(second))
  );

  return Number.isNaN(iso.getTime()) ? null : iso.toISOString();
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

async function main() {
  const seed = ensureSeed();
  const overwriteSingles = process.env.FORCE_SINGLE_TYPES === '1';
  const appContext = await core.compileStrapi();
  const strapi = await core.createStrapi(appContext).load();

  const productCategoryIds = new Map();
  const newsCategoryIds = new Map();
  const summary = {
    productCategories: 0,
    newsCategories: 0,
    sitePages: 0,
    products: 0,
    news: 0,
    singleTypes: 0
  };

  try {
    for (const item of seed.productCategories) {
      const result = await upsertCollection(
        strapi,
        'api::product-category.product-category',
        'legacyClassId',
        item.legacyClassId,
        {
          legacyClassId: item.legacyClassId,
          name: item.name,
          slug: safeSlug(item.slug || item.name, `product-category-${item.legacyClassId}`),
          sortOrder: item.sortOrder,
          isActive: true,
          publishedAt: new Date().toISOString()
        }
      );
      productCategoryIds.set(item.legacyClassId, result.id);
      summary.productCategories += 1;
    }

    for (const item of seed.newsCategories) {
      const result = await upsertCollection(
        strapi,
        'api::news-category.news-category',
        'legacyClassId',
        item.legacyClassId,
        {
          legacyClassId: item.legacyClassId,
          name: item.name,
          slug: safeSlug(item.slug || item.name, `news-category-${item.legacyClassId}`),
          sortOrder: item.sortOrder,
          publishedAt: new Date().toISOString()
        }
      );
      newsCategoryIds.set(item.legacyClassId, result.id);
      summary.newsCategories += 1;
    }

    for (const item of seed.sitePages) {
      await upsertCollection(strapi, 'api::site-page.site-page', 'key', item.key, {
        key: item.key,
        title: item.title,
        slug: safeSlug(item.slug || item.key, item.key),
        heroImage: item.heroImage,
        content: item.content,
        ...withSeo(item),
        publishedAt: new Date().toISOString()
      });
      summary.sitePages += 1;
    }

    await ensureSingle(strapi, 'api::site-config.site-config', {
      ...seed.siteConfig,
      ...withSeo(seed.siteConfig)
    }, {
      overwrite: overwriteSingles
    });

    await ensureSingle(strapi, 'api::migration-stat.migration-stat', seed.feedbackStats, {
      overwrite: overwriteSingles
    });
    summary.singleTypes += 2;

    for (const item of seed.products) {
      await upsertCollection(strapi, 'api::product.product', 'legacyId', item.legacyId, {
        legacyId: item.legacyId,
        title: item.title,
        slug: safeSlug(`${item.slug || item.title}-${item.legacyId}`, `product-${item.legacyId}`),
        code: item.code,
        summary: item.summary,
        content: item.content,
        legacyCoverPath: item.legacyCoverPath,
        category: productCategoryIds.get(item.categoryLegacyClassId) || null,
        specNl: item.specNl,
        specWg: item.specWg,
        specXj: item.specXj,
        specKg: item.specKg,
        specCh: item.specCh,
        hits: item.hits,
        publishedAtLegacy: normalizeDate(item.publishedAtLegacy),
        ...withSeo(item),
        publishedAt: new Date().toISOString()
      });
      summary.products += 1;
    }

    for (const item of seed.news) {
      await upsertCollection(strapi, 'api::news.news', 'legacyId', item.legacyId, {
        legacyId: item.legacyId,
        title: item.title,
        slug: safeSlug(`${item.slug || item.title}-${item.legacyId}`, `news-${item.legacyId}`),
        subtitle: item.subtitle,
        content: item.content,
        legacyCoverPath: item.legacyCoverPath,
        category: newsCategoryIds.get(item.categoryLegacyClassId) || null,
        hits: item.hits,
        isFeatured: item.isFeatured,
        legacySort: item.legacySort,
        publishedAtLegacy: normalizeDate(item.publishedAtLegacy),
        ...withSeo(item),
        publishedAt: new Date().toISOString()
      });
      summary.news += 1;
    }

    console.log(
      JSON.stringify(
        {
          seedPath,
          summary
        },
        null,
        2
      )
    );
  } finally {
    try {
      await strapi.destroy();
    } catch (error) {
      if (!String(error.message || '').includes('aborted')) {
        throw error;
      }
    }
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
