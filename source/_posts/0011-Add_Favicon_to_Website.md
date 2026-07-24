---
title: 怎样给自己的网站加上 Favicon——2026 年最佳实践
categories: Web开发
tags: [Favicon,网站图标,SVG,前端开发,PWA,apple-touch-icon]
date: 2020-06-11 14:38:36
updated: 2026-07-24 10:00:00
id: 0011
---

你有没有在浏览器标签栏的一堆标签页里，靠图标来找你想看的那个网页？

我就是这样。当 tab 开多了，文字标题被遮挡，**唯一能帮我定位网页的就是那个小图标。**

这就是 favicon 的作用——不显眼，但没有它，你的网站在浏览器里就是"无名氏"。

**一句话理解：** Favicon 是网站的"头像"——它出现在浏览器标签页、收藏夹、地址栏旁边，是用户第一眼识别你网站的标志。

## 2026 年推荐方案

### SVG Favicon（推荐）

以前 favicon 只能用 `.ico` 格式，现在可以用 SVG 了：

```html
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
```

SVG 的好处：
- **矢量**：任何分辨率下都清晰，Retina 屏也没问题
- **多色**：可以包含多种颜色
- **体积小**：通常几百字节到几 KB
- **支持 dark mode**：可以跟随系统主题

### 多尺寸兼容

虽然 SVG 是趋势，但不是所有地方都支持它。稳妥的做法是提供多个尺寸：

```html
<!-- 推荐方案 -->
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16.png">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
```

### 深色主题支持

```html
<!-- 浅色主题用彩色图标 -->
<link rel="icon" type="image/svg+xml" href="/favicon-light.svg" 
      media="(prefers-color-scheme: light)">
<!-- 深色主题用白色或浅色图标 -->
<link rel="icon" type="image/svg+xml" href="/favicon-dark.svg" 
      media="(prefers-color-scheme: dark)">
```

### Apple Touch Icon

iOS 用户把网站添加到主屏时需要这个：

```html
<!-- 基础版 -->
<link rel="apple-touch-icon" href="/apple-touch-icon.png">

<!-- 完整版 -->
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon-180.png">
<link rel="apple-touch-icon" sizes="152x152" href="/apple-touch-icon-152.png">
<link rel="apple-touch-icon" sizes="120x120" href="/apple-touch-icon-120.png">
```

> **经验之谈：** Apple touch icon 不需要自己做圆角——iOS 系统会自动给图标加上圆角和高光。你只需要提供一个 180×180 的纯方形图标就好了。我做第一次时花了半小时给图标加圆角，后来发现 iOS 会自动加——白忙活了。

## 完整配置

这是我的博客目前的 favicon 配置：

```html
<!-- 基础 favicon -->
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">

<!-- 深色模式适配 -->
<link rel="icon" type="image/svg+xml" href="/favicon-dark.svg" 
      media="(prefers-color-scheme: dark)">

<!-- Apple touch icon -->
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">

<!-- PWA manifest -->
<link rel="manifest" href="/site.webmanifest">

<!-- Windows 磁贴 -->
<meta name="msapplication-TileColor" content="#2d8cf0">
<meta name="theme-color" content="#2d8cf0">
```

## 制作工具

2026 年不需要手动做 ico 了：

1. **SVG 图标**：用 Figma 或 Sketch 设计，导出为 SVG
2. **Favicon 生成器**：传入一张图片，自动生成所有尺寸（推荐：realfavicongenerator.net）
3. **Emoji 临时方案**：没设计好图标前，可以用 Emoji 当 Favicon（通过 SVG 内嵌 Emoji）

## 相关推荐

- [到底什么是网站根目录？](/archives/0037/)
- [Meta 标签功能大全——Apple-touch-icon 配置](/archives/0006/)
- [2026 年如何给你的网站添加 OG 标签](/archives/0029/)

**P.S.** 我博客的 favicon 是一个很简单的"飞鲤"首字母变形——一共花了半小时设计。但就是这半小时的投入，让朋友第一次看到我的博客时说"这个图标挺有意思"。**很多时候，好的细节不是花了很多时间做的，是用心做的。** 如果你还没有 favicon，今天花 10 分钟做一个吧。
