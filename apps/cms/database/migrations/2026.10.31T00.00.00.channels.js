'use strict';
module.exports = {
  async up(knex) {
    for (const table of ['products', 'product_categories']) {
      if (!(await knex.schema.hasTable(table))) continue;
      if (!(await knex.schema.hasColumn(table, 'show_on_website'))) {
        await knex.schema.alterTable(table, t => t.boolean('show_on_website').defaultTo(false));
        await knex(table).update({ show_on_website: true });
      }
      if (!(await knex.schema.hasColumn(table, 'show_on_miniprogram'))) {
        await knex.schema.alterTable(table, t => t.boolean('show_on_miniprogram').defaultTo(false));
      }
    }
  }
};
