#!/usr/bin/env node
'use strict';
// Run from apps/cms. Default is a filesystem-only audit. Never publishes.
const fs = require('node:fs');
const fsp = require('node:fs/promises');
const path = require('node:path');
const crypto = require('node:crypto');
const PRODUCT = 'api::product.product';
const CATEGORY = 'api::product-category.product-category';
async function sha256(file) {
  const hash = crypto.createHash('sha256');
  for await (const block of fs.createReadStream(file)) hash.update(block);
  return hash.digest('hex');
}
async function validate(manifest, sourceRoot, sample) {
  if (manifest.version !== 1 || !Array.isArray(manifest.products)) throw new Error('Unsupported manifest');
  const seen = new Set(), categories = new Set(), selected = [];
  const candidates = sample ? [...manifest.products].sort((a,b) => Number((a.flags || []).includes('review-nonproduct-asset')) - Number((b.flags || []).includes('review-nonproduct-asset'))) : manifest.products;
  for (const item of candidates) {
    if (!item.sourceId || !item.sourceKey || !item.categoryCode || !item.images.length || seen.has(item.sourceKey)) throw new Error('Missing or duplicate identity/images: ' + item.sourceKey);
    seen.add(item.sourceKey);
    if (sample && categories.has(item.categoryCode)) continue;
    categories.add(item.categoryCode);
    for (const image of item.images) {
      const file = path.resolve(sourceRoot, image.path);
      if (!file.startsWith(path.resolve(sourceRoot) + path.sep)) throw new Error('Image path escapes source directory');
      if (!/\.(png|jpe?g|webp)$/i.test(file)) throw new Error('Unsupported image: ' + image.path);
      if (await sha256(file) !== image.sha256) throw new Error('Image changed since inventory: ' + image.path);
    }
    selected.push(item);
  }
  return selected;
}
async function importProducts(strapi, items, sourceRoot, report, save, updateDrafts = false) {
  const categories = new Map();
  const uploadService = strapi.plugin('upload').service('upload');
  const previousGetSettings = uploadService.getSettings;
  // Scope settings to this CLI process/run: preserve the original bytes while generating derivatives.
  // Do not change the site's persisted media-library settings.
  if (previousGetSettings) uploadService.getSettings = async () => ({
    ...await previousGetSettings.call(uploadService),
    sizeOptimization: false, autoOrientation: false, responsiveDimensions: true
  });
  async function category(item) {
    const key = 'rooltiles:category:' + item.categoryCode;
    if (categories.has(key)) return categories.get(key);
    let row = await strapi.documents(CATEGORY).findFirst({ status: 'draft', filters: { sourceKey: key } });
    if (!row) row = await strapi.documents(CATEGORY).create({ data: { sourceKey: key, name: item.category, slug: 'catalog-' + item.categoryCode, sortOrder: Number(item.categoryCode), isActive: true, showOnWebsite: false, showOnMiniprogram: false } });
    categories.set(key, row);
    return row;
  }
  async function upload(image, title) {
    const name = 'catalog-sha256-' + image.sha256 + path.extname(image.path).toLowerCase();
    let file = await strapi.db.query('plugin::upload.file').findOne({ where: { name } });
    if (!file) {
      const filepath = path.resolve(sourceRoot, image.path);
      const stat = await fsp.stat(filepath);
      const ext = path.extname(filepath).toLowerCase();
      const rows = await uploadService.upload({
        data: { fileInfo: { name, alternativeText: title, caption: '资料原图 SHA-256: ' + image.sha256 } },
        files: { filepath, originalFilename: name, mimetype: ext === '.png' ? 'image/png' : ext === '.webp' ? 'image/webp' : 'image/jpeg', size: stat.size }
      });
      file = rows[0];
    }
    return file.id;
  }
  try {
  for (const item of items) {
    const result = { sourceKey: item.sourceKey, sourcePath: item.sourcePath, flags: item.flags };
    try {
      const existing = await strapi.documents(PRODUCT).findFirst({ status: 'draft', filters: { sourceKey: item.sourceKey } });
      if (existing && existing.sourceFingerprint === item.fingerprint) {
        result.action = 'unchanged';
      } else if (existing && (!updateDrafts || await strapi.documents(PRODUCT).findOne({ documentId: existing.documentId, status: 'published' }))) {
        result.action = 'conflict'; result.reason = 'Source changed; explicit --update-drafts allowed only for drafts without a current published version';
      } else {
        const cat = await category(item), ids = [], mapping = [];
        for (const image of item.images) {
          const id = await upload(image, item.title); ids.push(id); mapping.push({ ...image, mediaId: id });
        }
        const data = { sourceKey: item.sourceKey, sourcePath: item.sourcePath, sourceFingerprint: item.fingerprint, importMediaMap: mapping, cover: ids[0], gallery: ids.slice(1) };
        // Existing human-authored names, relations, sorting and channel switches are preserved.
        if (existing) await strapi.documents(PRODUCT).update({ documentId: existing.documentId, data });
        else await strapi.documents(PRODUCT).create({ data: { ...data, title: item.title, code: item.sourceId, slug: 'catalog-' + crypto.createHash('sha256').update(item.sourceKey).digest('hex').slice(0, 24), category: cat.documentId, showOnWebsite: false, showOnMiniprogram: false } });
        result.action = existing ? 'updated-draft' : 'created-draft';
      }
    } catch (error) { result.action = 'failed'; result.reason = error.message; }
    report.results.push(result); await save(report);
  }
  } finally { if (previousGetSettings) uploadService.getSettings = previousGetSettings; }
  return report;
}
async function main() {
  const args = process.argv.slice(2);
  const option = (flag, fallback) => args.includes(flag) ? args[args.indexOf(flag) + 1] : fallback;
  const manifestPath = option('--manifest');
  if (!manifestPath) throw new Error('Usage: node scripts/import-miniprogram.js --manifest /absolute/inventory.json [--source /absolute/assets] [--sample] [--apply] [--update-drafts] [--report /absolute/result.json]');
  const manifest = JSON.parse(await fsp.readFile(manifestPath, 'utf8'));
  const source = path.resolve(option('--source', manifest.sourceRoot));
  const items = await validate(manifest, source, args.includes('--sample'));
  if (!args.includes('--apply')) { console.log(JSON.stringify({ mode: 'dry-run', products: items.length, categories: new Set(items.map(i => i.categoryCode)).size, images: items.reduce((n,i) => n + i.images.length,0) }, null, 2)); return; }
  const reportPath = path.resolve(option('--report', './import-miniprogram-report.json'));
  const report = { startedAt: new Date().toISOString(), mode: 'draft-only', results: [] };
  const save = async data => { await fsp.mkdir(path.dirname(reportPath), {recursive:true}); await fsp.writeFile(reportPath + '.tmp', JSON.stringify(data, null, 2)); await fsp.rename(reportPath + '.tmp', reportPath); };
  const core = require('@strapi/core');
  const app = await core.createStrapi(await core.compileStrapi()).load();
  // Hold a dedicated PostgreSQL advisory lock for the whole run, including across transactions.
  const connection = await app.db.connection.client.acquireConnection();
  let locked = false;
  try {
    const lock = await app.db.connection.raw('select pg_try_advisory_lock(734072619) as locked').connection(connection);
    locked = lock.rows[0].locked;
    if (!locked) throw new Error('Another catalog import is active');
    await importProducts(app, items, source, report, save, args.includes('--update-drafts'));
    report.finishedAt = new Date().toISOString(); await save(report);
    const counts = report.results.reduce((out,r) => {out[r.action] = (out[r.action] || 0) + 1; return out;}, {});
    console.log(JSON.stringify({ reportPath, counts }, null, 2));
    if (counts.failed || counts.conflict) process.exitCode = 1;
  } finally {
    if (locked) await app.db.connection.raw('select pg_advisory_unlock(734072619)').connection(connection);
    await app.db.connection.client.releaseConnection(connection);
    await app.destroy();
  }
}
module.exports = { validate, importProducts, sha256 };
if (require.main === module) main().catch(e => { console.error(e.message); process.exitCode = 1; });
