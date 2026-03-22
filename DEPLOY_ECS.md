# 阿里云 ECS 部署说明

本文档面向当前仓库的生产部署方式：

- `postgres`：PostgreSQL 17
- `cms`：Strapi 5
- `web`：Astro
- `nginx`：统一对外入口，转发前台、后台、API 和上传文件

## 1. 服务器准备

推荐环境：

- 阿里云 ECS
- Ubuntu 22.04 或 24.04
- 至少 `2C4G`
- 已绑定公网 IP

安全组建议只开放：

- `22`
- `80`
- `443`

不要对公网开放：

- `5432`
- `1337`
- `4321`

## 2. 安装 Docker

```bash
apt update
apt install -y docker.io docker-compose-plugin
systemctl enable docker
systemctl start docker
```

检查：

```bash
docker --version
docker compose version
```

## 3. 上传项目

建议部署目录：

```bash
mkdir -p /srv/sofoyo
```

把本地项目上传到服务器，例如：

```bash
scp -r /path/to/sofoyo/* root@your-ecs-ip:/srv/sofoyo/
```

上传完成后进入目录：

```bash
cd /srv/sofoyo
```

## 4. 配置生产环境变量

在项目根目录创建 `.env`：

```bash
cp .env.example .env
```

按实际情况修改：

```env
POSTGRES_DB=sofoyo
POSTGRES_USER=sofoyo
POSTGRES_PASSWORD=请改成强密码

STRAPI_URL=http://cms:1337
PUBLIC_STRAPI_URL=https://你的域名
PUBLIC_SITE_URL=https://你的域名
STRAPI_API_TOKEN=前台只读 token

APP_KEYS=四个随机字符串，逗号分隔
API_TOKEN_SALT=随机字符串
ADMIN_JWT_SECRET=随机字符串
TRANSFER_TOKEN_SALT=随机字符串
JWT_SECRET=随机字符串
```

说明：

- `PUBLIC_STRAPI_URL` 必须是正式访问域名，不能填 `localhost`
- `PUBLIC_SITE_URL` 建议与站点正式域名一致
- `STRAPI_API_TOKEN` 用于前台读取 CMS 数据

## 5. 首次启动

在项目根目录执行：

```bash
docker compose up -d --build
```

检查容器状态：

```bash
docker compose ps
```

正常情况下应看到：

- `postgres`
- `cms`
- `web`
- `nginx`

## 6. 访问方式

当前 `nginx` 已代理以下路径：

- `/` -> `web`
- `/admin` -> `cms`
- `/api` -> `cms`
- `/uploads` -> `cms`
- `Strapi` 插件根路径，例如：
  - `/content-manager`
  - `/users-permissions`
  - `/upload`
  - `/i18n`

访问地址：

- 前台：`http://你的域名/`
- 后台：`http://你的域名/admin`

## 7. 初始化和导入数据

如果这是全新服务器，需要准备数据库内容和前台 token。

### 7.1 导入种子数据

进入 CMS 容器或本地运行导入命令均可。若在宿主机直接执行，需要本机可用 `Node 20`。

示例：

```bash
cd /srv/sofoyo/apps/cms
npm run import:seed -- ../../www/legacy_export/db/meta/site_seed.json
```

### 7.2 生成前台只读 token

```bash
cd /srv/sofoyo/apps/cms
npm run token:web -- sofoyo-web-readonly
```

把生成的 token 写回根目录 `.env` 的 `STRAPI_API_TOKEN`。

然后重启前台：

```bash
cd /srv/sofoyo
docker compose up -d web nginx
```

## 8. 数据持久化

当前 Compose 已配置两个关键卷：

- `postgres_data`
- `cms_uploads`

作用：

- `postgres_data` 保存数据库
- `cms_uploads` 保存 Strapi 后台上传文件

注意：

- 不要随意执行 `docker compose down -v`
- `-v` 会删除数据卷，数据库和上传文件都会丢失

## 9. 常用运维命令

查看状态：

```bash
docker compose ps
```

查看日志：

```bash
docker compose logs --tail=200 cms
docker compose logs --tail=200 web
docker compose logs --tail=200 nginx
```

重启服务：

```bash
docker compose restart cms web nginx
```

更新代码后重新部署：

```bash
git pull
docker compose up -d --build
```

## 10. HTTPS

当前仓库默认是 HTTP。

正式上线建议二选一：

### 方案 A：服务器本机 Nginx + Certbot

- 在 ECS 上申请 Let’s Encrypt 证书
- `nginx` 监听 `443`
- 自动续期

### 方案 B：阿里云负载均衡 / CDN 终止 HTTPS

- 域名接到负载均衡或 CDN
- HTTPS 在云侧终止
- 回源到 ECS 的 `80`

如果采用方案 B，部署更简单，也更适合后续扩展。

## 11. 备份建议

至少备份两类数据：

- PostgreSQL 数据库
- Strapi 上传目录

最少要求：

- 每天备份数据库
- 定期备份 `cms_uploads` 卷

如果站点内容会持续由后台维护，建议把备份纳入定时任务。

## 12. 故障排查

### 后台 `localhost/admin` 或域名 `/admin` 报错

优先检查：

```bash
docker compose ps
docker compose logs --tail=200 cms
docker compose logs --tail=200 nginx
```

已知关键点：

- `cms` 必须使用生产启动，不要改回 `strapi develop`
- `nginx` 必须保留 Strapi 插件接口代理规则，否则后台登录后会报错

### 图片不显示

检查：

- `.env` 里的 `PUBLIC_STRAPI_URL` 是否是正式域名
- `cms_uploads` 卷是否存在上传文件
- `/uploads/...` 是否能通过浏览器直接访问

### 前台拿不到 CMS 数据

检查：

- `STRAPI_API_TOKEN` 是否填写
- `cms` 是否正常启动
- `http://你的域名/api/...` 是否可访问

## 13. 当前仓库的部署注意事项

- `apps/cms` 依赖 `Node 20`
- `PUBLIC_STRAPI_URL` 在线上必须是正式域名
- 后台上传文件依赖 `cms_uploads` 卷持久化
- 新站前台仍会使用 `www/legacy_export/site_assets` 中的旧媒体资源
