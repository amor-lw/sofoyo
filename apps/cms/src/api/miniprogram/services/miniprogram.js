'use strict';
const PRODUCT = 'api::product.product';
const CATEGORY = 'api::product-category.product-category';
const { media, serializeProduct, serializeCategory, parseQuery } = require('../../../utils/miniprogram');
const categoryFilters = { showOnMiniprogram: true, isActive: true };
const productPopulate = { category: { populate: ['cover'] }, cover: true, gallery: true };
module.exports = ({ strapi }) => {
  const base = () => strapi.config.get('server.miniprogramMediaOrigin', 'https://www.sofoyo.com');
  const rawCategories = () => strapi.documents(CATEGORY).findMany({ status: 'published', filters: categoryFilters, sort: ['sortOrder:asc', 'documentId:asc'], populate: ['cover'] });
  const filtersFor = ids => ({ showOnMiniprogram: true, category: { documentId: { $in: ids }, publishedAt: { $notNull: true }, ...categoryFilters } });
  async function contact() {
    const config = await strapi.documents('api::site-config.site-config').findFirst({ status: 'published' });
    return { siteName: config && config.siteName || 'SOFOYO', about: config && config.homepageAbout || '', phone: config && config.contactPhone || '', email: config && config.contactEmail || '', address: config && config.address || '' };
  }
  async function products(query) {
    const { page, pageSize, category, q } = parseQuery(query);
    const cats = await rawCategories();
    const ids = cats.filter(c => !category || c.documentId === category).map(c => c.documentId);
    if (!ids.length) return { data: [], meta: { page, pageSize, total: 0, pageCount: 0 } };
    const filters = filtersFor(ids);
    if (q) filters.$or = ['title', 'code'].map(field => ({ [field]: { $containsi: q } }));
    const [rows, total] = await Promise.all([
      strapi.documents(PRODUCT).findMany({ status: 'published', filters, populate: productPopulate, sort: ['sortOrder:asc', 'documentId:asc'], start: (page - 1) * pageSize, limit: pageSize }),
      strapi.documents(PRODUCT).count({ status: 'published', filters })
    ]);
    return { data: rows.map(p => serializeProduct(p, base())), meta: { page, pageSize, total, pageCount: Math.ceil(total / pageSize) } };
  }
  return {
    contact, products,
    async categories() { return (await rawCategories()).map(c => serializeCategory(c, base())); },
    async product(documentId) {
      const cats = await rawCategories();
      if (!cats.length) return null;
      const row = await strapi.documents(PRODUCT).findFirst({ status: 'published', filters: { ...filtersFor(cats.map(c => c.documentId)), documentId }, populate: productPopulate });
      return row ? serializeProduct(row, base()) : null;
    },
    async home() {
      const [config, cats] = await Promise.all([
        strapi.documents('api::miniprogram-config.miniprogram-config').findFirst({ status: 'published', populate: { hero: true, categories: true, products: true } }), rawCategories()
      ]);
      const selectedCats = config && config.categories || [];
      const catMap = new Map(cats.map(c => [c.documentId, c]));
      const categories = (selectedCats.length ? selectedCats.map(c => catMap.get(c.documentId)).filter(Boolean) : cats).map(c => serializeCategory(c, base()));
      let featured = [];
      if (cats.length) {
        const chosen = config && config.products || [];
        const filters = filtersFor(cats.map(c => c.documentId));
        if (chosen.length) filters.documentId = { $in: chosen.map(p => p.documentId) };
        else filters.isFeatured = true;
        featured = await strapi.documents(PRODUCT).findMany({ status: 'published', filters, populate: productPopulate, sort: ['sortOrder:asc', 'documentId:asc'], limit: chosen.length || 8 });
        if (chosen.length) featured.sort((a,b) => chosen.findIndex(p => p.documentId === a.documentId) - chosen.findIndex(p => p.documentId === b.documentId));
      }
      return { title: config && config.title || '泥土的温度，建筑的表情', subtitle: config && config.subtitle || '陶土 · 砖石 · 瓦', hero: media(config && config.hero, base()), categories, products: featured.slice(0, 8).map(p => serializeProduct(p, base())) };
    }
  };
};
