#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const core = require('@strapi/core');

const tokenName = process.argv[2] || 'sofoyo-web-readonly';
const rootEnvPath = path.resolve(process.cwd(), '../../.env');

function setEnvValue(filePath, key, value) {
  const existing = fs.existsSync(filePath) ? fs.readFileSync(filePath, 'utf8') : '';
  const line = `${key}=${value}`;

  if (!existing.trim()) {
    fs.writeFileSync(filePath, `${line}\n`, 'utf8');
    return;
  }

  if (new RegExp(`^${key}=`, 'm').test(existing)) {
    fs.writeFileSync(filePath, existing.replace(new RegExp(`^${key}=.*$`, 'm'), line), 'utf8');
    return;
  }

  fs.writeFileSync(filePath, `${existing.replace(/\s*$/, '\n')}${line}\n`, 'utf8');
}

async function main() {
  const appContext = await core.compileStrapi();
  const strapi = await core.createStrapi(appContext).load();

  try {
    const service = strapi.admin.services['api-token'];
    const existing = await service.getByName(tokenName);

    let accessKey = null;

    if (existing?.id) {
      const regenerated = await service.regenerate(existing.id);
      accessKey = regenerated.accessKey;
    } else {
      const created = await service.create({
        name: tokenName,
        description: 'Read-only API token for the Astro frontend',
        type: 'read-only',
        lifespan: null
      });
      accessKey = created.accessKey;
    }

    setEnvValue(rootEnvPath, 'STRAPI_API_TOKEN', accessKey);

    console.log(
      JSON.stringify(
        {
          name: tokenName,
          envFile: rootEnvPath,
          tokenPreview: `${accessKey.slice(0, 8)}...${accessKey.slice(-6)}`
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
