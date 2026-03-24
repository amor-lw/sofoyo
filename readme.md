## 1) 当前站点扫描结论

### 1.1 技术与部署现状
- 语言/框架：Classic ASP (VBScript)
- 运行环境：IIS + Windows
- 编码：页面含 gb2312（代码里可见 GB->UTF 处理）
- 数据库：Access `.mdb`
  - `Databases/lskajdflkjasdf.mdb`
  - `Databases/lskajdflkjasdf1.mdb`（备份）
- 连接方式：`conn.asp` 内 `Microsoft.Jet.OLEDB.4.0` + `Server.MapPath("Databases/...mdb")`

### 1.2 文件与资源规模
- 主要文件类型统计：
  - `78` 个 `.asp`
  - `47` 个 `.jpg`
  - `34` 个 `.png`
  - `28` 个 `.js`
  - `7` 个 `.css`
  - `7` 个 `.gif`
  - 其余：`.swf/.rar/.mdb/.log` 等
- 关键目录：
  - 页面与逻辑：根目录大量 `*.asp` + `INC/`
  - 媒体资源：`banner/`, `image/`, `img/`, `propic/`, `uploadpic/`, `uploads/`
  - 数据库：`Databases/`
  - 日志：`wwwlogs/`
  - 迁移输出预留：`legacy_export/`

### 1.3 页面结构
- 首页：`index.asp`
- 关于：`about.asp`, `culture.asp`, `history.asp`, `honor.asp`, `workshop.asp`
- 产品：`pro.asp`, `pro1.asp` ... `pro28.asp`
- 新闻：`news.asp`, `news1.asp`, `news2.asp`
- 服务：`service.asp`, `serivce1.asp`, `serivce2.asp`, `serivce3.asp`, `knowledge.asp`
- 招聘：`job.asp`, `job1.asp`, `job2.asp`
- 联系与留言：`contact.asp`, `feedback.asp`
- 公共模板：`top.asp`, `bottom.asp`, `promenu.asp`, `newsmenu.asp`, `jobmenu.asp` 等

### 1.4 已识别的数据表（代码引用推断）
- `CY_hdtp`（产品）
- `cy_news3`（新闻/资讯）
- `CY_feedback2`（留言/反馈）
- `gbook`（旧留言板）

### 1.5 风险与问题（高优先级）
1. **高风险暴露**：`Databases/*.mdb`、`wwwlogs/*` 位于 Web 根目录（历史上容易被下载/遍历）。
2. **SQL 注入风险**：典型字符串拼接写法，未见参数化。
3. **表单防护弱**：留言/应聘类入口潜在刷库、注入、垃圾提交风险。
4. **上传风险**：存在上传组件（`INC/UpLoadClass.asp`），需核查后台是否可达、后缀/MIME 校验是否严格。
5. **可维护性差**：大量重复模板页（pro1~pro28），改版成本高。
6. **平台锁定**：Classic ASP + Access，天然偏 Windows/IIS，不利于 Linux 容器化。

---

## 2) 重构方案建议

## 2.1 结论
- Astro：静态化友好，页面性能好，适合官网展示。
- Strapi：内容管理方便，后续你自己改图文不用改代码。
- PostgreSQL：稳、通用、后续扩展性好。

---

## 3) 分阶段执行计划

### Phase 0：迁移基线
- 建立 `legacy_export/` 标准目录：
  - `legacy_export/db/`
  - `legacy_export/site_assets/`
  - `legacy_export/reports/`

### Phase 1：数据库导出（Access -> UTF-8）
- 目标：把 `.mdb` 表结构与数据导出到 `legacy_export/db/`
- 交付：
  - `schema/*.sql`
  - `data/*.csv`（UTF-8）
  - `manifest.json`（表名、行数、导出时间）
- 优先表：`CY_hdtp`, `cy_news3`, `CY_feedback2`, `gbook`

### Phase 2：媒体资产导出与映射
- 目标：把可用媒体统一导到 `legacy_export/site_assets/`
- 动作：
  - 去重、规范命名（保留原路径映射表）
  - 输出 `assets-map.csv`（old_path -> new_path）

### Phase 3：新站数据模型设计
- Strapi 内容类型：
  - `ProductCategory`, `Product`
  - `NewsCategory`, `News`
  - `Page`（关于/服务/联系等静态页）
  - `SiteConfig`（站点配置）
- 输出模型文档 + 字段映射表

### Phase 4：导入脚本与数据灌入
- 编写导入脚本（CSV/SQL -> Strapi + PostgreSQL）
- 导入媒体并重写内容中的链接引用

### Phase 5：Astro 前台开发
- 页面模板：首页、产品列表/详情、新闻列表/详情、招聘、联系
- SEO、站点地图、基础性能优化

### Phase 6：Docker Compose 本地运行
- 服务：`astro`, `strapi`, `postgres`,（可选）`nginx`
- 提供一键启动/停止、日志查看、备份脚本

### Phase 7：验收与切换准备
- URL 对照与 301 规划
- 内容抽检、图片完整性校验、SEO 核查
- 上线 checklist

---

## 4) 已完成的依赖修复
- `mdbtools` 已安装，`mdb-tables / mdb-export / mdb-count` 可用。

---

## 5) 数据库导出进展
- 已导出 PostgreSQL schema：
  - `legacy_export/db/schema/schema.postgres.sql`
- 已导出关键业务表 UTF-8 CSV：
  - `legacy_export/db/csv_utf8/CY_hdtp.csv`（394）
  - `legacy_export/db/csv_utf8/cy_news3.csv`（50）
  - `legacy_export/db/csv_utf8/CY_feedback2.csv`（235）
  - `legacy_export/db/csv_utf8/guestbook.csv`（0）
- 清单文件：
  - `legacy_export/db/meta/key_table_rows.csv`
  - `legacy_export/db/meta/manifest.keytables.json`
- 说明：已验证 UTF-8 编码（示例 `cy_news3.csv`）。

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
