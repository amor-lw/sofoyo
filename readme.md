# sofoyo 重构执行记录

> 主执行文档。后续进度统一写这里，`www/README.MD` 保留为历史扫描稿。

## 当前结论
- 旧站是 Classic ASP + Access + IIS，代码和数据库均存在明显安全与维护风险。
- 现有 `www/legacy_export/` 已完成数据库导出、媒体归档、字段映射、批处理准备，是新系统的数据输入层。
- 新系统正式采用 `Astro + Strapi 5 + PostgreSQL`，目标是在 WSL/Linux 上通过 Docker Compose 本地跑通。
- 当前容器数据库基线已调整为 `PostgreSQL 17`。
- 当前 `docker compose` 已可启动 `postgres`、`cms`、`web` 三个服务，前台已能读取真实 CMS 数据。
- 首版只做核心展示链路：首页、关于类页面、产品列表/详情、新闻列表/详情、联系页；历史留言只保留聚合统计。

## 实施计划
1. 统一文档和断点续跑入口，收拢扫描结果与执行状态。
2. 新建 `apps/cms`，落地 Strapi 内容模型、运行配置和导入脚本。
3. 新建 `apps/web`，落地 Astro 前台、数据访问层和新版视觉。
4. 用 `compose.yml` 编排 `postgres`、`cms`、`web`，让本地开发路径固定。
5. 继续沿用 `www/legacy_export/` 作为迁移输入与报告输出目录。

## 已完成
- 复核 `www.txt`、`www/README.MD`、`www/legacy_export/` 现状。
- 确认仓库中还没有任何新站代码，需要从骨架开始搭建。
- 确认旧站产品分类、新闻分类、静态页菜单可从 ASP 文件和导出结果中恢复。
- 新增执行文档 `www/readme.md`。
- 新增 `apps/cms` Strapi 工程骨架与内容模型定义。
- 新增 `apps/web` Astro 工程骨架、核心页面、样式与 CMS 数据访问层。
- 新增 `compose.yml`、容器 Dockerfile、环境样例。
- 新增 `www/legacy_export/scripts/build_seed_data.js`，用于从旧站页面与 CSV 生成导入用 JSON 种子。
- 重写 `www/legacy_export/scripts/import_to_strapi.js`，支持分类、静态页、配置、统计、产品、新闻的 dry-run/live 导入流程。
- 已执行 `node www/legacy_export/scripts/build_seed_data.js`，生成 `www/legacy_export/db/meta/site_seed.json`。
- 已执行 `DRY_RUN=1 node www/legacy_export/scripts/import_to_strapi.js --type=all`，dry-run 通过。
- 已完成 `PostgreSQL 17` 容器切换与干净库重建。
- 已完成 Strapi live import，并重新生成前台只读 API token 写入仓库根 `.env`。
- 已修复 Astro 前台运行时环境读取问题，首页、内容页、新闻页、联系页都已确认能输出真实 CMS 数据。
- 已修复旧站静态资源挂载路径，`/legacy-assets/...` 图片现在可由前台直接访问。
- 已修复富文本中的旧相对图片地址重写，正文内 `image/...`、`uploadpic/...` 等资源会自动映射到 `/legacy-assets/...`。

## 待执行
- 根据启动效果继续微调页面结构、SEO 和缺失字段。
- 补做产品详情、新闻详情和分页等更细的内容抽样。
- 继续优化旧 HTML 正文清洗，例如正文内仍存在相对图片路径和个别 HTML 实体。
- 继续补正式 HTTPS、备份脚本与云上发布收口。

## 目录说明
- `apps/cms`: Strapi 5 后台
- `apps/web`: Astro 前台
- `www/legacy_export/db`: 旧库导出结果
- `www/legacy_export/site_assets`: 旧站可复用媒体
- `www/legacy_export/reports`: 各阶段报告与导入运行日志
- `www/legacy_export/state`: 断点与执行状态

## 运行步骤
1. 生成迁移种子：
   - `node www/legacy_export/scripts/build_seed_data.js`
2. 启动服务：
   - `docker compose up --build -d`
3. 导入数据：
   - `source ~/.nvm/nvm.sh && nvm use 20`
   - 在 `apps/cms` 下执行 `npm run import:seed -- ../../www/legacy_export/db/meta/site_seed.json`
4. 生成前台读取用 token：
   - 在 `apps/cms` 下执行 `npm run token:web -- sofoyo-web-readonly`
   - 脚本会把 `STRAPI_API_TOKEN=...` 写到仓库根 `.env`
5. 重启前台容器读取新 token：
   - `docker compose up -d web`

## 生产部署
- 阿里云 ECS 的完整部署步骤见仓库根文档 `DEPLOY_ECS.md`
  - 包含服务器准备、环境变量、启动、域名、HTTPS、备份与故障排查
  - 当前默认入口：
    - `/` -> `web`
    - `/admin`、`/api`、`/uploads` -> `cms`
  - 已补充 Strapi 后台插件接口的 `nginx` 代理规则，避免 `/admin` 登录后内容管理页报错

## 阿里云部署实战经验
- 本项目在阿里云 ECS 上可以稳定跑通，但 `cms` 的 Docker 构建对内存比较敏感。`1.6Gi` 内存且无 swap 时，`strapi build` 很容易在镜像构建阶段触发 `JavaScript heap out of memory`。
- 当前验证可用的做法是：
  - 服务器先补 `4G` swap
  - `apps/cms/Dockerfile` 默认使用 `BUILD_NODE_OPTIONS=--max-old-space-size=2048`
  - `compose.yml` 里显式把 `CMS_BUILD_NODE_OPTIONS` 传给 `cms.build.args`
- `sharp` 依赖安装在云服务器上也容易慢或失败。当前已在 `apps/cms/Dockerfile` 中固定：
  - `npm ci --no-audit --no-fund`
  - `NPM_REGISTRY=https://registry.npmmirror.com`
  - `SHARP_BINARY_HOST=https://registry.npmmirror.com/-/binary/sharp`
  - `SHARP_LIBVIPS_BINARY_HOST=https://registry.npmmirror.com/-/binary/sharp-libvips`
- 数据导入在服务器上实测通过。导入命令可以直接在容器内执行：
  - `docker cp www/legacy_export/db/meta/site_seed.json sofoyo-cms-1:/tmp/site_seed.json`
  - `docker compose exec -T cms sh -lc 'cd /app && npm run import:seed -- /tmp/site_seed.json'`
- `npm run import:seed` 结束时仍可能打印 `tarn aborted` 并返回非零退出码，但只要导入 summary 正常输出，且 API / 数据库计数正确，这通常只是 Strapi 关闭阶段噪音，不代表导入失败。
- 数据导入后必须重新生成前台只读 token，并写回服务器根目录 `.env` 的 `STRAPI_API_TOKEN`。否则前台请求 `site-config`、`products`、`news-items` 时会持续返回 `401`。
- `web` 使用新 token 后需要重启才能读到更新：
  - `docker compose up -d web nginx`
- 如果只想更新前台，不要习惯性执行 `docker compose up -d --build web nginx`。这会连带重新 build 依赖图中的服务，实测可能把 `cms` 也一起重建。只改环境变量时优先用不带 `--build` 的启动命令。
- 线上验证至少要覆盖：
  - `curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:1337/api/site-config?populate=*`
  - `curl -g -H "Authorization: Bearer $TOKEN" 'http://127.0.0.1:1337/api/products?populate=category&pagination[pageSize]=2'`
  - `curl -g -H "Authorization: Bearer $TOKEN" 'http://127.0.0.1:1337/api/news-items?populate=category&sort[0]=publishedAtLegacy:desc&pagination[pageSize]=3'`
  - `curl -I http://127.0.0.1/`
  - `curl http://127.0.0.1/products`
- 当前线上还验证过一个前端修复：手机端首页导航已改为折叠式菜单，避免原先移动端整块漂浮子菜单直接铺开。

## 已知限制
- `cover` 媒体字段保留给后续 Strapi 媒体入库使用；首版前台先使用 `legacyCoverPath` 从 `legacy_export/site_assets` 直接读旧图。
- `CY_productclass.csv` 导出结果不完整，因此产品分类首版按旧前台菜单与 `pro*.asp` 的 `class_id` 显式映射。
- `apps/cms` 当前使用 `Node 20` 运行。Strapi 5.12.2 的 `engines.node` 限制是 `>=20 <=22.x`，因此不建议用本机 `Node 24` 直接跑 CMS 脚本。
- `npm run import:seed` 在完成导入后会因 Strapi 关闭阶段的 `tarn aborted` 噪音返回非零退出码，但当前已确认导入主体实际完成。
- 由于启用了 `draftAndPublish`，数据库表中的记录总数会高于前台可见的已发布数量，这是 Strapi 文档版本存储带来的结果。
- 部分旧正文仍保留原始 HTML 片段，后续需要继续清洗相对资源路径和编码实体。
- 本地联调时 `PUBLIC_STRAPI_URL` 应为 `http://localhost:1337`；生产环境必须改为正式域名，避免前台输出 `localhost` 媒体地址。

## 本次校验
- `node --check www/legacy_export/scripts/build_seed_data.js`
- `node --check www/legacy_export/scripts/import_to_strapi.js`
- `node www/legacy_export/scripts/build_seed_data.js`
- `DRY_RUN=1 node www/legacy_export/scripts/import_to_strapi.js --type=all`
- `docker compose up --build -d`
- `npm run import:seed -- ../../www/legacy_export/db/meta/site_seed.json`
- `npm run token:web -- sofoyo-web-readonly`
- `curl http://localhost:1337/api/site-config?populate=*`（携带 token）
- `curl http://localhost:4321`
- `curl http://localhost:4321/pages/about`
- `curl http://localhost:4321/news`
- `curl http://localhost:4321/contact`
- `curl -I http://localhost:4321/legacy-assets/banner/1.jpg`
- `curl -I http://localhost:4321/legacy-assets/uploadpic/product/2021/5/2021052669088465.jpg`
- 结果：
  - 生成了 `site_seed.json`
  - 统计到 29 个产品分类、3 个新闻分类、13 个静态页、394 个产品、50 篇新闻
  - dry-run 导入 7 个阶段全部通过
  - `PostgreSQL` 版本已切到 `17.9`
  - `cms` 管理后台可访问：`http://localhost:1337/admin`
  - 前台可访问：`http://localhost:4321`
  - 首页、关于页、新闻页、联系页已确认显示真实 CMS 数据
  - 旧站 banner、产品图与正文内嵌图已确认返回 `200`
