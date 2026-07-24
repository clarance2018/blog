---
title: 常见 Meta 标签参考和用途介绍——前端开发的速查表
categories: Web开发
tags: [Meta标签,HTML,前端开发,SEO,移动端,编码]
date: 2020-06-11 14:38:28
updated: 2026-07-24 10:00:00
id: 0038
---

我刚开始做前端的时候，Meta 标签对我来说就是"一堆要复制粘贴的东西"。

直到后来面试被问到"viewport 的 `user-scalable=no` 有什么问题"——我才意识到 Meta 标签不仅仅是"加上就行"，**每个标签背后都有它为什么要这样用的道理。**

**一句话理解：** Meta 标签是网页的"配置信息"，告诉浏览器、搜索引擎和其他工具"该怎么处理这个页面"。

## 速查表（2026 年推荐配置）

### 必加项

```html
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>页面标题 - 站点名</title>
<meta name="description" content="页面描述，建议 80-120 字符">
```

### SEO 相关

```html
<meta name="robots" content="index, follow">
<meta name="keywords" content="关键词1,关键词2,关键词3">
<!-- ↑ 关键词标签搜索引擎已经基本不参考了，但加上无妨 -->
```

### 社交分享

```html
<meta property="og:title" content="分享标题">
<meta property="og:description" content="分享描述">
<meta property="og:image" content="https://example.com/cover.jpg">
<meta property="og:url" content="https://example.com/page">
<meta property="og:type" content="article">
<meta property="og:site_name" content="站点名称">

<meta name="twitter:card" content="summary_large_image">
```

### 移动端和 PWA

```html
<!-- 主题色——手机浏览器顶部栏颜色 -->
<meta name="theme-color" content="#2d8cf0" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#1a1a2e" media="(prefers-color-scheme: dark)">

<!-- 自动识别控制 -->
<meta name="format-detection" content="telephone=no, email=no">

<!-- iOS 添加到主屏 -->
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="apple-mobile-web-app-title" content="站点名称">

<!-- 颜色方案适配 -->
<meta name="color-scheme" content="light dark">
```

### 安全相关

```html
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<!-- ↑ IE 已退役，这个主要是兼容老系统 -->

<meta name="referrer" content="strict-origin-when-cross-origin">

<!-- Content Security Policy（高级） -->
<meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self'">
```

## 一些注意事项

### theme-color：最被低估的 Meta 标签

`theme-color` 是我认为性价比最高的 Meta 标签——只用一行代码，就能让你的网站在手机浏览器上看起来更专业。

```html
<!-- 不同主题色 -->
<meta name="theme-color" content="#ffffff" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#000000" media="(prefers-color-scheme: dark)">
```

效果：Android Chrome 顶部栏、任务视图中的颜色会变成你设置的颜色。

### viewport 中不要禁用缩放

```html
<!-- ❌ 错误做法：user-scalable=no 违反了 WCAG 无障碍标准 -->
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">

<!-- ✅ 正确做法：允许用户缩放 -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

WCAG 2.1 标准要求页面内容必须可以放大到 200%。`user-scalable=no` 直接违反了这条规则。

### robots 和搜索引擎控制

```html
<!-- 允许收录和跟踪链接 -->
<meta name="robots" content="index, follow">

<!-- 禁止收录 -->
<meta name="robots" content="noindex">

<!-- 禁止跟踪链接 -->
<meta name="robots" content="nofollow">

<!-- 禁止收录和跟踪 -->
<meta name="robots" content="noindex, nofollow">
```

需要注意的是，`robots` meta 标签只是一个"请求"，搜索引擎可以选择忽略。但正规的搜索引擎（Google、百度、Bing）都会遵守。

## 我的建议

对于大多数网站，加上以下这些 Meta 标签就足够了：

```html
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="页面描述">
<meta name="theme-color" content="#2d8cf0">
<meta name="format-detection" content="telephone=no">
<meta property="og:title" content="页面标题">
<meta property="og:description" content="页面描述">
<meta property="og:image" content="封面图">
```

其他标签按需添加。**不要为了"越多越全"而加一堆用不到的 Meta 标签。**

## 相关推荐

- [Meta 标签功能大全——你可能不知道的 20 种用法](/archives/0006/)
- [SEO 结构化数据优化——JSON-LD 实战指南](/archives/0002/)
- [如何给你的网站添加 OG 标签——社交分享优化](/archives/0029/)

**P.S.** 我自己的博客的 `<head>` 里大概有 20 多个 Meta 标签——但重要的其实就前面那 5 个。多出来的那些里，一半是主题自带的，一半是插件生成的。**加上 Meta 标签不难，难的是知道哪些该删掉。** 有空的话，看看你网站的 `<head>`，删掉那些没用的标签，它会变轻一些。
