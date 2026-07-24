---
title: 到底什么是网站根目录？——搞错这个文件夹，整个网站都打不开
categories: Web开发
tags: [网站根目录,服务器,Nginx,Docker,建站入门,主机配置]
date: 2020-06-11 14:37:58
updated: 2026-07-24 10:00:00
id: 0037
---

我刚开始做网站时，遇到过一件很丢人的事——

把 `index.html` 上传到了主机，但怎么访问都是 403 Forbidden。

我一遍遍检查代码，没问题。检查权限，没问题。检查文件路径……等等，**我上传到哪个目录了？**

后来问了人才知道：我把文件传到了 FTP 的根目录，但网站服务器的根目录是 `htdocs`——我传错文件夹了。

**一句话理解：** 网站根目录就是"当有人访问你的域名时，服务器去哪个文件夹找文件"。

## 不同环境下的根目录

### 传统虚拟主机

如果你用的是老式虚拟主机或云虚拟主机，常见的根目录名称：

| 服务商 | 根目录名称 |
|--------|-----------|
| 阿里云/万网 | `htdocs/` |
| 西部数码 | `wwwroot/` 或 `web/` |
| 新网 | `www/` |
| 美橙互联 | `wwwroot/` |
| 香港主机 | 通常有 `DB/`、`LOG/`、`WEB/` 三个文件夹，`WEB/` 才是 |

这些其实都是同一个东西——**放 `index.html`、`index.php` 的地方。**

> **经验之谈：** 我第一次搞清楚这事是因为在主机控制面板里发现了一个"默认首页设置"——我才明白，根目录下没有 `index.html` 的话，服务器不知道展示什么，就给你看 403 了。

### Nginx/Apache 环境

如果你自己搭建服务器（不管是物理机还是云服务器），根目录就在配置文件里定义：

```nginx
# Nginx 配置
server {
    listen 80;
    server_name 6mal.com;

    # 这就是网站根目录
    root /var/www/6mal.com;
    
    # 或者用 alias 指向另一个路径
    location /blog {
        alias /var/www/blog;
    }
}
```

`root` 和 `alias` 有一个关键区别：

```nginx
# root：会把路径附加到根目录后
root /var/www/6mal.com;
# 请求 /archives/0037/ → 找 /var/www/6mal.com/archives/0037/

# alias：会直接替换路径前缀
location /blog {
    alias /var/www/blog;
    # 请求 /blog/0037/ → 找 /var/www/blog/0037/
}
```

这个区别我一开始总是弄混。**root 是"拼接"，alias 是"替换"。**

### Docker 环境

2026 年很多网站都用 Docker 部署了。在 Docker 下，"根目录"的概念又变了——它指的是容器内部的路径，通过"卷挂载"映射到宿主机。

```yaml
# docker-compose.yml
version: '3'
services:
  web:
    image: nginx:alpine
    volumes:
      # 宿主机:容器内部
      - ./public:/usr/share/nginx/html
```

在这个例子里，容器的根目录是 `/usr/share/nginx/html`，而宿主机上对应的是 `./public`。部署时你把文件丢到 `./public`，容器里的 Nginx 就能访问到。

```bash
# 检查容器内根目录内容的命令
docker exec -it my-nginx ls /usr/share/nginx/html
```

### CI/CD 部署中的根目录

如果你用 GitHub Actions 或 GitLab CI 做自动化部署，根目录的路径还会受部署工具的影响：

```yaml
# GitHub Actions 示例：部署到 Nginx
- name: Deploy to Server
  run: |
    rsync -avz --delete \
      ./public/ \                    # 构建产物在 public/
      user@server:/var/www/html/     # 服务器上的根目录
```

这时根目录有两个含义：
- **构建产物根目录**：本地 `./public/`
- **服务器部署根目录**：远程 `/var/www/html/`

两者通过 `rsync` 同步，**搞错任何一个，部署都会翻车。**

## 2026 年如何找到根目录

| 场景 | 方法 |
|------|------|
| 传统虚拟主机 | 登录 FTP 或主机管理面板，看 `wwwroot`/`htdocs`/`public_html` |
| 自建 Nginx | 查 `/etc/nginx/sites-enabled/` 下的配置文件的 `root` 字段 |
| Docker | 查 `docker-compose.yml` 或 `Dockerfile` 的 `WORKDIR` |
| Vercel/Netlify | 在项目设置里配置 `Publish Directory` |
| Hexo | `public/` 目录就是生成的网站根目录 |

我用 Hexo 博客，根目录就是 `public/`，生成的静态文件都在那里。部署时，我把这个目录的内容 rsync 到服务器上 Nginx 配置的 `root` 路径。

## 容易混淆的概念

- **网站根目录 ≠ 系统根目录**：系统根目录是 `/`（Linux）或 `C:\`（Windows），网站根目录通常是 `/var/www/html/` 这样的子路径
- **网站根目录 ≠ 模板目录**：别把 `theme/` 或 `template/` 目录当成根目录——模板目录在根目录下
- **网站根目录 ≠ git 仓库根目录**：很多人的仓库根目录不是网站根目录，还需要通过构建步骤（如 Hexo 的 `public/`）生成

## 相关推荐

- [绝对路径和相对路径：让我吃过亏才真正理解的区别](/archives/0028/)
- [网站基础术语入门——你该知道的 20 个核心概念](/archives/0018/)
- [到底什么是 SSL 和 HTTPS？](/archives/0026/)

**P.S.** 回到开头那个故事——后来我学乖了：上传文件前先 `pwd` 或在 FTP 里看一眼确认目录。再后来我连 FTP 都不用了，全改成 `rsync` 自动部署。手动操作的次数越少，犯错的概率就越低。**自动化不仅仅是提高效率，更是减少人为失误的最后一道防线。**
