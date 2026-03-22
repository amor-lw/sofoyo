# sofoyo legacy 网站扫描与迁移记录（断点续跑）

> 最后扫描时间：2026-03-19 00:05 (Asia/Shanghai)
> 扫描人：肥虾助手
> 目标：从 Classic ASP + Access 迁移到 Linux 可部署的新站（候选：Astro + Strapi 5 + PostgreSQL）

---

## 1) 当前站点扫描结论（已完成）

### 1.1 技术与部署现状
- 语言/框架：Classic ASP (VBScript)
- 运行环境：IIS + Windows
- 编码：页面含 gb2312（代码里可见 GB->UTF 处理）
- 数据库：Access `.mdb`
  - `Databases/lskajdflkjasdf.mdb`
  - `Databases/lskajdflkjasdf1.mdb`（备份）
- 连接方式：`conn.asp` 内 `Microsoft.Jet.OLEDB.4.0` + `Server.MapPath("Databases/...mdb")`

### 1.2 文件与资源规模（扫描快照）
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
  - 迁移输出预留：`legacy_export/`（目前为空）

### 1.3 页面结构（业务信息架构）
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

## 2) 重构方案建议（待你确认）

## 2.1 结论先说
你选的 `Astro + Strapi 5 + PostgreSQL` 可行，且非常适合这个站：
- Astro：静态化友好，页面性能好，适合官网展示。
- Strapi：内容管理方便，后续你自己改图文不用改代码。
- PostgreSQL：稳、通用、后续扩展性好。

## 2.2 备选对比（简短）
- 备选 A：`Next.js + Strapi + PostgreSQL`（动态能力更强，但复杂度更高）
- 备选 B：`Astro + Directus + PostgreSQL`（后台更偏“可视化表格管理”）

> 建议：当前项目优先用你定的栈，不折腾。

---

## 3) 分阶段执行计划（你确认后开干）

### Phase 0：迁移基线与防中断机制（先做）
- 建立 `legacy_export/` 标准目录：
  - `legacy_export/db/`
  - `legacy_export/site_assets/`
  - `legacy_export/reports/`
- 所有过程产出落盘（可断点恢复）
- 每完成一个子阶段就更新本 README（状态、命令、结果、下一步）

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

### Phase 6：Docker Compose 本地运行（WSL）
- 服务：`astro`, `strapi`, `postgres`,（可选）`nginx`
- 提供一键启动/停止、日志查看、备份脚本

### Phase 7：验收与切换准备
- URL 对照与 301 规划
- 内容抽检、图片完整性校验、SEO 核查
- 上线 checklist

---

## 4) 长任务中断风险 & 处理策略（先处理）

1. **会话超时/中断**
   - 策略：每个阶段产出落盘 + 本 README 实时更新，保证断点续跑。
2. **工具缺失导致卡住（如 mdb 导出工具）**
   - 策略：先做依赖探测；缺依赖时先给安装清单，不盲跑。
3. **权限不足（目录、Docker、socket）**
   - 策略：先预检权限，不满足就立即回报并给一条命令修复。
4. **编码转换失败（gbk/gb2312 -> utf8）**
   - 策略：先抽样验证，再全量转换，保留原始副本。
5. **导出数据脏/字段异常**
   - 策略：导出后自动统计空值、异常字符、超长字段，出报告再导入。
6. **媒体路径丢失**
   - 策略：建立 `assets-map.csv`，导入后做链接回填校验。
7. **Docker 服务启动后不可用**
   - 策略：提供健康检查 + `docker compose logs` 诊断脚本。

---

## 5) 飞书状态同步方式（满足“别像挂了”）

- 执行中我会按阶段给你发进度：
  - `开始阶段`
  - `阶段完成 + 产出路径`
  - `阻塞点 + 需要你确认`
- 若任务特别长（>20-30 分钟），我会插入中途心跳更新，避免你以为挂了。

---

## 6) 当前需要/建议你确认的权限

### 已具备
- 读取 `~/sofoyo/www`：已确认
- Docker socket：已确认可访问

### 可能还需要（按阶段触发）
1. **系统依赖安装权限（sudo）**：用于安装 mdb 导出工具（如 `mdbtools`）。
2. **联网拉镜像权限**：`docker pull` 需要网络。
3. **目标域名/上线环境信息**（后期才需要）：用于反向代理和 HTTPS。

---

## 7) 下一步（等待你一句“继续”）

我将开始 **Phase 0 + Phase 1**：
1. 建立 `legacy_export/db`、`legacy_export/site_assets`、`legacy_export/reports`
2. 探测并安装（或提示安装）Access 导出依赖
3. 导出关键表到 UTF-8（CSV + schema）
4. 输出第一版 `manifest.json` 与导出报告

---

## 8) 超时风险专项检查（agent timeoutSeconds=1000）

### 8.1 评估结论
- 1000 秒约 16 分 40 秒，**不适合一口气跑完整迁移**。
- 当前项目中最容易超时的环节：
  1) 全量媒体拷贝 + 校验
  2) Access 导出（若工具缺失重试会拖时）
  3) Docker 首次拉取镜像

### 8.2 已修复（已落地）
- 已创建可断点目录结构：
  - `legacy_export/db`
  - `legacy_export/site_assets`
  - `legacy_export/reports`
  - `legacy_export/state`
  - `legacy_export/scripts`
- 已新增预检脚本：
  - `legacy_export/scripts/preflight_timeout.sh`
  - 输出示例：`legacy_export/reports/preflight_timeout_*.md`
- 已新增可恢复执行脚本（分步+每步超时540秒）：
  - `legacy_export/scripts/run_resumable_phase.sh`
  - 断点文件：`legacy_export/state/checkpoint.env`
  - 运行日志：`legacy_export/reports/run_*.log`
- 已完成媒体资产分目录导出与校验（防止单次任务过长）：
  - 导出位置：`legacy_export/site_assets/*`
  - 校验清单：`legacy_export/reports/site_assets.sha1`

### 8.3 当前剩余风险
- Docker 首次拉镜像仍可能耗时较久（网络相关，已通过“分步骤执行”规避单次超时）。
- 全量数据导入 Strapi 阶段仍需继续拆分批次（后续执行时处理）。

### 8.4 已完成的依赖修复
- `mdbtools` 已安装，`mdb-tables / mdb-export / mdb-count` 可用。

---

## 9) 数据库导出进展（已执行）
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

---

## 10) 状态记录
- [x] 初始代码扫描完成
- [x] 迁移计划草案完成
- [x] 目录初始化（legacy_export/*）
- [x] 数据库导出（UTF-8，关键业务表已完成）
- [x] 媒体导出（分步断点版）
- [ ] 新站骨架与 compose
- [x] Phase 3 模型设计（首版） -> `legacy_export/reports/phase3_strapi_model_mapping.md`
- [x] 迁移决策：`CY_feedback2` 不导入正文，仅保留统计
- [x] Phase 4 准备：`field_mapping.json` + 批次预处理文件
- [x] Phase 4 导入执行器（dry-run）已验证（Product首批50 / News首批50）
