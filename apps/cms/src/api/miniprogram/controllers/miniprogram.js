'use strict';
module.exports = ({ strapi }) => {
  const service = () => strapi.service('api::miniprogram.miniprogram');
  return {
    async home(ctx) { ctx.body = { data: await service().home() }; },
    async contact(ctx) { ctx.body = { data: await service().contact() }; },
    async categories(ctx) { ctx.body = { data: await service().categories() }; },
    async products(ctx) {
      try { ctx.body = await service().products(ctx.query); }
      catch (error) { if (error.status === 400) return ctx.badRequest(error.message); throw error; }
    },
    async product(ctx) {
      const id = ctx.params.documentId;
      if (typeof id !== 'string' || !/^[a-zA-Z0-9_-]{1,100}$/.test(id)) return ctx.notFound();
      const product = await service().product(id);
      if (!product) return ctx.notFound('Product unavailable');
      ctx.body = { data: product };
    }
  };
};
