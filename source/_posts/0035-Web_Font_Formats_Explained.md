---
title: 网页字体格式详解——2026 年，WOFF2 已成标配
categories: Web开发
tags: [字体格式,Web字体,font-display,可变字体,WOFF2,前端性能,LCP优化]
date: 2020-06-11 14:37:38
updated: 2026-07-24 10:00:00
id: 0035
---

我有一个朋友做品牌官网，设计师选了一款非常漂亮的字体。上线后，设计师很满意——但用户反馈说"网页打开好慢"。

查了一下，那个字体文件 800KB。

**一句话理解：** 网页字体是双刃剑——用好了让网站更有设计感，用不好就是最大的性能杀手。

## 字体格式进化史

| 格式 | 出现时间 | 压缩率 vs TTF | 浏览器支持 | 2026 年建议 |
|------|---------|:------------:|:----------:|:----------:|
| TTF | 1990s | - | 所有浏览器 | ❌ 不推荐 |
| OTF | 1996 | - | 所有浏览器 | ❌ 不推荐 |
| EOT | 1997 | - | 仅 IE | ❌ 已淘汰 |
| WOFF | 2009 | 小 40% | 95%+ | ❌ 已过时 |
| **WOFF2** | 2014 | **小 50%+** | **95%+** | ✅ **唯一推荐** |

2026 年，**WOFF2 已经获得了 95%+ 的浏览器支持。** 你只需要提供 WOFF2 格式就够了，不再需要为不同浏览器准备多个格式。

```css
/* 2026 年的 @font-face —— 只需要 WOFF2 */
@font-face {
  font-family: 'MyFont';
  src: url('/fonts/myfont.woff2') format('woff2');
  font-display: swap;
  font-weight: 400;
  font-style: normal;
}
```

## font-display——这个属性比字体本身还重要

`font-display` 控制浏览器在字体加载期间的"降级策略"。它有五个可选值，但最重要的只有两个：

```css
/* 推荐：先用系统字体显示，等字体加载完再替换 */
@font-face {
  font-family: 'MyFont';
  src: url('/fonts/myfont.woff2') format('woff2');
  font-display: swap;
}

/* 极致性能：如果字体没在 100ms 内加载完，就用系统字体，永远不替换 */
@font-face {
  font-family: 'MyFont';
  src: url('/fonts/myfont.woff2') format('woff2');
  font-display: optional;
}
```

`font-display: swap` 和 `optional` 的区别：

```
swap：    等待字体加载 → 未加载时用系统字体 → 加载后替换
optional：等待 100ms → 未加载则永远用系统字体
```

> **经验之谈：** 我之前一个项目的 LCP（最大内容渲染）一直在 2.8s 徘徊。排查后发现是字体文件阻塞了渲染。把 `font-display` 设为 `optional` 之后，LCP 降到了 1.5s——**一行代码优化了 46% 的性能。** 从那以后，字体优化是我做性能优化时第一项检查的。

## 字体子集化

字体文件大的主要原因是它包含了**所有字符**——包括你可能用不到的希腊字母、西里尔字母、标点符号等。

子集化就是"只保留你需要的字符"：

```bash
# 使用 glyphhanger 或 fonttools 做子集化
# 只保留中文字符和英文标点
pyftsubset myfont.woff2 \
  --unicodes="U+0020-007F,U+4E00-9FFF" \
  --output-file=myfont-subset.woff2
```

中文字体做子集化后，文件大小可以从 5MB 降到 200KB 左右——**差了 25 倍。**

## 可变字体

可变字体是近年来的一个重要进展——**一个文件包含多个字重和字宽。**

```css
/* 可变字体：一个文件替代多个文件 */
@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-Variable.woff2') format('woff2');
  font-weight: 100 900;  /* 100 到 900 所有字重 */
  font-stretch: 75% 125%; /* 宽度范围 */
}

/* 使用任意字重 */
h1 { font-weight: 700; }
p  { font-weight: 400; }
.light { font-weight: 300; }
```

传统做法需要加载 `Inter-Regular.woff2`、`Inter-Bold.woff2`、`Inter-Light.woff2` 三个文件（总共约 90KB），而可变字体只需要一个文件（约 50KB）。

## 字体加载的最佳实践

```html
<!-- 预加载关键字体 -->
<link rel="preload" href="/fonts/Inter-Variable.woff2" as="font" type="font/woff2" crossorigin>

<!-- Google Fonts 的现代加载方式（使用 display=swap） -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400..700&display=swap" rel="stylesheet">
```

```css
/* 同时使用自定义字体和系统字体做降级 */
body {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 
               'Segoe UI', Roboto, 'Helvetica Neue', Arial, 
               'Noto Sans SC', sans-serif;
}
```

## 2026 年字体方案推荐

| 场景 | 推荐方案 |
|------|---------|
| 个人博客/文档站 | 系统字体（无需加载外部字体） |
| 品牌官网 | WOFF2 + `font-display: swap` + 子集化 |
| 中文内容站 | 思源黑体/Noto Sans SC 子集化 |
| 英文内容站 | Inter / Source Sans - 可变字体 |
| 极致性能需求 | `font-display: optional` + 系统字体降级 |

## 相关推荐

- [字体图标和 SVG 图标——2026 年的选择](/archives/33/)
- [网页打开太慢？性能优化实战指南](/archives/21/)
- [网页颜色搭配——从十六进制到现代 CSS](/archives/19/)

**P.S.** 我博客目前用的是系统字体——没有加载任何外部字体文件。不是因为我不在乎设计，而是因为我更在乎加载速度。**字体是"视觉加分项"，但它不能成为"性能减分项"。** 在你确定需要自定义字体才能传达品牌价值之前，用系统字体完全足够。
