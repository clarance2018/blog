---
title: 怎样查看一个网站是用什么程序搭建的——2026 年识别技巧
categories: Web开发
tags: [网站识别,Wappalyzer,BuiltWith,前端开发,开源程序,建站技术栈]
date: 2020-06-11 14:38:24
updated: 2026-07-24 10:00:00
id: 0012
---

我有一个"坏习惯"：每次看到一个好看的网站，第一反应不是欣赏设计——**是右键查看源代码，看它用什么技术搭的。**

但说实话，靠看源代码来识别网站平台，越来越不靠谱了。现在的网站经过构建工具打包后，很多特征都被隐藏或混淆了。

还好有更好的工具可以用。

**一句话理解：** 识别一个网站的技术栈，不需要"猜"——有专门的分析工具一键搞定。

## 方法一：浏览器扩展（最推荐）

### Wappalyzer

这是我用了很多年的扩展，几乎每天都在用。装好之后，访问任何网站，点击 Wappalyzer 图标，它会列出：

- Web 框架（React、Vue、Next.js……）
- 分析工具（Google Analytics、Umami……）
- CDN（Cloudflare、Fastly……）
- 编程语言（PHP、Node.js……）
- CMS（WordPress、Hexo……）

### BuiltWith

比 Wappalyzer 更全面，但略复杂。适合做竞品分析——可以查一个网站用了哪些技术、用了什么 CDN、做了哪些 SEO 优化。

> **经验之谈：** 我曾经用 BuiltWith 分析了一个竞品网站，发现它居然用了和我们的项目一样的第三方支付服务。后来用这种方式找到了更便宜的供应商。**技术栈分析不只是满足好奇心，它能帮你发现更好的工具选择。**

## 方法二：查看网页源代码（经典方法）

手动查看源代码还是有效，只是要掌握技巧：

### 查看 HTML 特征

```html
<!-- WordPress：搜索 wp-content -->
<link href="/wp-content/themes/twentytwentyfour/style.css">

<!-- Hexo：通常有 hexo-generator 的 meta -->
<meta name="generator" content="Hexo 7.3.0">

<!-- Vue/React 构建的 SPA：根部只有一个 div -->
<div id="app"></div>
<div id="root"></div>
```

### 查看 HTTP 响应头

```bash
curl -I https://example.com

# 我博客的响应头片段
server: nginx/1.24.0
x-powered-by: Hexo
```

## 方法三：在线工具

- **Wappalyzer 在线版**：直接输入 URL，在线分析
- **BuiltWith**：输入 URL，看非常详细的技术栈报告
- **WhatRuns**：类似 Wappalyzer，但会显示具体的版本号

## 常见 CMS 的识别特征

| 平台 | 典型特征 | 后台地址 |
|------|---------|---------|
| WordPress | `wp-content`、`wp-includes` | `/wp-admin/` |
| Hexo | `generator` meta 标签为 Hexo | 无后台（静态站） |
| Hugo | `meta generator` 为 Hugo | 无后台 |
| Next.js | `__NEXT_DATA__` 脚本 | 取决于配置 |
| Ghost | Content-Type 含 `Ghost` | `/ghost/` |
| Shopify | `/cdn/shop/` 文件路径 | `/admin/` |

## 手动 vs 工具

| 方式 | 优势 | 劣势 |
|------|------|------|
| 手动查看源代码 | 不依赖第三方 | 效率低，被构建工具混淆 |
| Wappalyzer | 一键识别，信息完整 | 部分技术可能识别不到 |
| BuiltWith | 非常详细，有可视化报告 | 免费版有限制 |
| 查看 HTTP 头 | 可以看到服务器和框架 | 很多网站隐藏了这些信息 |

## 相关推荐

- [判断一个网站是由哪种语言开发的](/archives/0031/)
- [12 种最常用的网页编程语言](/archives/0041/)
- [网站基础术语入门](/archives/0018/)

**P.S.** 有一次我在咖啡馆看到一个做得特别好的网站，掏出手机想查它用的什么技术栈，发现 Wappalyzer 在手机浏览器上装不了。于是我在 URL 后面加了 `/wp-admin/`——果然跳到了 WordPress 登录页。然后我默默喝了口咖啡，心想：**有些老方法，在工具失效的时候还是挺管用的。**
