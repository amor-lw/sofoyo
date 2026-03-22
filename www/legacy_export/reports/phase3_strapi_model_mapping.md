# Phase 3 - Strapi 数据模型设计与字段映射（首版）

时间：2026-03-19 00:27 (Asia/Shanghai)

## 1. 代码真实使用到的旧表（已核验）
基于 ASP SQL 扫描并与 Access 实际表名交集后，当前前台真实依赖表仅 4 张：

1. `CY_hdtp`（产品）
2. `cy_news3`（新闻/知识）
3. `CY_feedback2`（留言）
4. `CY_productclass`（产品分类，代码里存在引用，但前台大量页面仍硬编码 class_id）

扫描结果文件：`legacy_export/reports/used_tables_from_code.json`

---

## 2. Strapi 内容类型建议

## 2.1 ProductCategory（产品分类）
- `legacyClassId` (integer, unique)
- `name` (string, required)
- `slug` (uid, based on name)
- `sortOrder` (integer)
- `isActive` (boolean, default true)

## 2.2 Product（产品）
- `legacyId` (integer, unique)
- `title` (string, required)
- `code` (string)
- `summary` (text)  ← 旧字段可来自 `j1/j2` 或摘要生成
- `content` (richtext) ← 旧字段 `content`
- `cover` (media, single) ← 旧字段 `page`
- `gallery` (media, multiple) ← 可由 `bpage`/附图扩展
- `category` (relation -> ProductCategory)
- `spec_nl` / `spec_wg` / `spec_xj` / `spec_kg` / `spec_ch` (string，可选)
- `hits` (integer)
- `publishedAtLegacy` (datetime)
- `seoTitle` / `seoDescription` (string/text)

## 2.3 NewsCategory（新闻分类）
- `legacyClassId` (integer, unique)  # 10/11/12/16 等
- `name` (string, required)
- `slug` (uid)
- `sortOrder` (integer)

## 2.4 News（新闻）
- `legacyId` (integer, unique)
- `title` (string, required)
- `subtitle` (string) ← `title2`
- `content` (richtext, required)
- `cover` (media, single) ← `page`
- `category` (relation -> NewsCategory)
- `hits` (integer)
- `isFeatured` (boolean) ← 可由 `btype`/`bcount` 规则推导
- `publishedAtLegacy` (datetime)
- `legacySort` (integer) ← `px`

## 2.5 ContactMessage（联系留言，保留）
> 建议默认仅后台可见，不对外暴露 API。

- `legacyId` (integer, unique)
- `name` (string) ← `CataName`
- `phone` (string) ← `web`
- `email` (email)
- `subject` (string) ← `title`
- `message` (text) ← `remark`
- `address` (string)
- `createdAtLegacy` (datetime) ← `time`
- `source` (string, default "legacy")

## 2.6 SitePage（静态页面内容）
用于“关于/服务/联系”等原先硬编码页面，避免继续写死在模板里。
- `key` (uid, e.g. `about`, `culture`, `history`, `contact`)
- `title` (string)
- `content` (richtext)
- `seoTitle` / `seoDescription`

---

## 3. 核心映射规则（旧 -> 新）

## 3.1 产品（CY_hdtp -> Product）
- `ID` -> `legacyId`
- `title` -> `title`
- `code` -> `code`
- `content` -> `content`
- `page` -> `cover`（路径重写到 `/uploads/...`）
- `class_ID` -> `category.legacyClassId`
- `hits` -> `hits`
- `time` -> `publishedAtLegacy`

## 3.2 新闻（cy_news3 -> News）
- `ID` -> `legacyId`
- `title` -> `title`
- `title2` -> `subtitle`
- `content` -> `content`
- `page` -> `cover`
- `class_ID` -> `category.legacyClassId`
- `hits` -> `hits`
- `time` / `bdate` -> `publishedAtLegacy`（优先 `time`）
- `px` -> `legacySort`

## 3.3 留言（CY_feedback2 -> ContactMessage）
- `ID` -> `legacyId`
- `CataName` -> `name`
- `web` -> `phone`
- `email` -> `email`
- `title` -> `subject`
- `remark` -> `message`
- `address` -> `address`
- `time` -> `createdAtLegacy`

---

## 4. 下一步实现（Phase 4）

1. 生成 `legacy_export/db/meta/field_mapping.json`
2. 创建导入脚本（Node.js）：
   - 读取 `csv_utf8/*.csv`
   - 建立分类（ProductCategory / NewsCategory）
   - 分批导入 Product / News（每批 50）
   - 导入媒体并回填 URL
3. 导入前先起 Docker 基础服务：`postgres + strapi`（先不接 Astro）

---

## 5. 需你确认的一个决策

`CY_feedback2`（历史留言）处理策略：
- ✅ 采用方案 B：不导入正文，仅保留统计数据（更干净、合规风险更低）。
- 导入实现：仅生成聚合统计（总留言数、按年份分布、按来源字段分布如可用），不迁移姓名/电话/邮箱/留言内容。
