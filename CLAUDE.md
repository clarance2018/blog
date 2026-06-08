# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Hexo 7.3.0 个人博客，使用 Butterfly 主题，中文站点，部署地址：https://6mal.com
- 站点标题：飞鲤的自留地
- 作者：飞鲤（GitHub: clarance2018）

## Common Commands

```bash
# 安装依赖
npm install

# 本地开发预览（端口 4000）
npm run server

# 生成静态文件到 public/
npm run build

# 清理生成的文件
npm run clean

# 清理 + 重新生成
npm run clean && npm run build

# 部署（通过 Docker 容器构建 + git push + rsync 同步到远程服务器）
./gitpush.sh "提交信息"        # 仅生成（默认）
./gitpush.sh "提交信息" cl     # 清理后重新生成
```

## Architecture

### Configuration（双配置文件结构）

- `_config.yml` — Hexo 主配置（站点信息、URL、分页、高亮等）
- `_config.butterfly.yml` — Butterfly 主题配置（导航、社交链接、封面、404 页、Swiper 等）

Hexo 的约定：主题配置文件命名为 `_config.<theme>.yml` 时，会覆盖主题目录下的 `_config.yml`，无需修改主题源码。

### Content Structure

- `source/_posts/` — 文章存放目录（Markdown 文件）
- `source/_data/link.yml` — 友链配置
- `source/about/` — 关于页面
- `source/album/` — 相册页面
- `source/tool.md` — 工具页面
- `scaffolds/` — 新建文章的模板（post.md / draft.md / page.md）
- 文章 front matter 格式：`title`, `date`, `tags`, 可选 `categories`

### Key Settings（_config.yml）

- 文章永久链接格式：`/archives/:id/`
- 每页 10 篇文章
- 语法高亮：highlight.js，启用行号
- Atom feed 路径：`/atom.xml`
- 时区：Asia/Shanghai

### Deployment Pipeline

部署通过 `gitpush.sh` 完成，流程：
1. 在 `hexo-blog` Docker 容器中执行 `hexo g`（或 `hexo clean && hexo g`）
2. 将 `public/` 目录推送到 GitHub（`clarance2018/blog`）的 main 分支
3. 通过 rsync + SSH 同步到远程服务器（OpenResty/nginx）

Docker 容器配置见 `docker-compose.yml`，使用 `spurin/hexo` 镜像，端口映射 8056:4000。
- 容器挂载路径：`/vol3/1000/docker/hexo-blog:/app`
- 远程服务器部署路径：`/opt/1panel/apps/openresty/openresty/www/sites/blog/index`

### Installed Plugins

| Plugin | Purpose |
|--------|---------|
| hexo-admin | Web 管理界面 |
| hexo-butterfly-extjs | Butterfly 主题扩展脚本 |
| hexo-generator-archive | 归档页生成 |
| hexo-generator-category | 分类页生成 |
| hexo-generator-feed | RSS/Atom feed |
| hexo-generator-index | 首页生成 |
| hexo-generator-tag | 标签页生成 |
| hexo-renderer-ejs | EJS 模板渲染 |
| hexo-renderer-marked | Markdown 渲染 |
| hexo-renderer-pug | Pug 模板渲染 |
| hexo-renderer-stylus | Stylus CSS 预处理 |
| hexo-server | 本地开发服务器 |

## Important Notes

- `source/` 目录和 `themes/butterfly/` 目录在新 clone 后需要通过 `npm install` 安装依赖（butterfly 主题通过 npm 包管理）
- `public/` 和 `node_modules/` 被 `.gitignore` 忽略，不入版本控制
- Butterfly 主题定制全部在 `_config.butterfly.yml` 中完成，不要直接改主题目录下的文件
- 部署脚本 `gitpush.sh` 使用 SSH 密钥认证，密钥路径：`/root/.ssh/124.220.71.26_20250416093341_id_rsa`
