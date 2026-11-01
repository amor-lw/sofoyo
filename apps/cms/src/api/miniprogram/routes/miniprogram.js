'use strict';
module.exports = { routes: [
  ['GET', '/miniprogram/home', 'home'],
  ['GET', '/miniprogram/contact', 'contact'],
  ['GET', '/miniprogram/categories', 'categories'],
  ['GET', '/miniprogram/products', 'products'],
  ['GET', '/miniprogram/products/:documentId', 'product']
].map(([method, path, action]) => ({ method, path, handler: `miniprogram.${action}`, config: { auth: false, policies: [], middlewares: [] } })) };
