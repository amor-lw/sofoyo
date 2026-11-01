'use strict';
function absolute(path, base) {
  if (!path || typeof path !== 'string') return '';
  try {
    const url = new URL(path, base);
    return url.protocol === 'https:' ? url.href : '';
  } catch { return ''; }
}
function media(item, base) {
  if (!item) return null;
  const url = absolute(item.formats && item.formats.large && item.formats.large.url || item.url, base);
  if (!url) return null;
  return { url, originalUrl: absolute(item.url, base), thumbnail: absolute(item.formats && (item.formats.small || item.formats.thumbnail) && (item.formats.small || item.formats.thumbnail).url, base) || url, width: item.width, height: item.height, alt: item.alternativeText || '' };
}
function serializeCategory(c, base) { return { documentId: c.documentId, name: c.name, slug: c.slug, cover: media(c.cover, base) }; }
function serializeProduct(p, base) {
  let cover = media(p.cover, base);
  if (!cover && p.legacyCoverPath) {
    const path = p.legacyCoverPath.startsWith('/') || /^https:\/\//.test(p.legacyCoverPath) ? p.legacyCoverPath : '/legacy-assets/' + p.legacyCoverPath;
    const url = absolute(path, base);
    if (url) cover = { url, originalUrl: url, thumbnail: url, alt: p.title };
  }
  const specs = [['产品编号', p.code], ['泥料', p.specNl], ['规格', p.specWg], ['吸水率', p.specXj], ['抗弯强度', p.specKg], ['尺寸', p.specCh]].filter(([,value]) => value != null && String(value).trim() && !/^0(?:\.0+)?$/.test(String(value).trim())).map(([label,value]) => ({ label, value: String(value).trim() }));
  const gallery = (p.gallery || []).map(i => media(i, base)).filter(Boolean).filter((i,index,all) => (!cover || i.originalUrl !== cover.originalUrl) && all.findIndex(j => j.originalUrl === i.originalUrl) === index);
  return { documentId: p.documentId, title: p.title, code: p.code || '', summary: p.summary || '', category: serializeCategory(p.category, base), cover, gallery, specs };
}
function parseQuery(query = {}) {
  function scalar(name) {
    const value = query[name];
    if (value == null) return '';
    if (typeof value !== 'string' && typeof value !== 'number') throw Object.assign(new Error('Invalid ' + name), { status: 400 });
    return String(value).trim();
  }
  function integer(name, fallback, max) {
    const value = scalar(name);
    if (!value) return fallback;
    if (!/^\d+$/.test(value) || !Number.isSafeInteger(Number(value)) || Number(value) < 1 || Number(value) > max) throw Object.assign(new Error('Invalid ' + name), { status: 400 });
    return Number(value);
  }
  const q = scalar('q'), category = scalar('category');
  if (q.length > 80 || category.length > 100) throw Object.assign(new Error('Query too long'), { status: 400 });
  return { page: integer('page', 1, 100000), pageSize: integer('pageSize', 20, 50), q, category };
}
module.exports = { absolute, media, serializeCategory, serializeProduct, parseQuery };
