---
title: 网页颜色搭配——从十六进制到现代 CSS 颜色方案
categories: Web开发
tags: [CSS,颜色,配色,OKLCH,color-mix,前端开发,网页设计]
date: 2020-06-11 14:38:22
updated: 2026-07-24 10:00:00
id: 0019
---

我做第一个网站时，配色是这样的：蓝色标题、白色背景、灰色正文。

不是因为这样好看——是因为我根本不会配色。大学设计课的配色理论我全部还给老师了，唯一记住的就是"蓝色代表专业"。

后来我学会了用一些工具来辅助配色，才慢慢不再害怕"选颜色"这件事。

**一句话理解：** 好的网页配色不是靠天赋，是**靠工具和规范**——2026 年的 CSS 甚至可以直接帮你做颜色计算。

## 2026 年 CSS 颜色的变化

### OKLCH：人眼感知更均匀的颜色空间

传统 RGB/HSL 有一个问题：颜色的"亮度"变化在人眼中是不均匀的。比如同样 `lightness: 50%`，黄色的感觉比蓝色亮得多。

OKLCH 解决了这个问题——它基于人眼感知来设计的颜色空间：

```css
/* OKLCH 色彩空间 */
.element {
  background: oklch(70% 0.15 200);
  /*    ↑亮度   ↑彩度 ↑色相 */
}
```

### color-mix()：用 CSS 混合颜色

以前混合颜色需要设计师在 Figma 里调，或者用 Sass 的 `mix()` 函数。现在 CSS 原生支持了：

```css
.brand-mixed {
  /* 把品牌蓝和品牌红按 70:30 混合 */
  background: color-mix(in oklab, #2d8cf0 70%, #ff4d4f 30%);
}

.lighten {
  /* 加入白色变浅 */
  background: color-mix(in oklab, var(--primary), white 20%);
}

.darken {
  /* 加入黑色变深 */
  background: color-mix(in oklab, var(--primary), black 20%);
}
```

### light-dark()：自动适配主题

```css
:root {
  color-scheme: light dark;
}

body {
  /* 浅色模式文字用黑色，深色模式文字用白色 */
  color: light-dark(#333, #eee);
  background: light-dark(#fff, #1a1a2e);
}
```

### 相对颜色语法

这是最强大的新特性——基于一个颜色"衍生"出相关颜色：

```css
:root {
  --primary: #2d8cf0;
}

.button {
  background: var(--primary);
  /* 从主色派生出 hover 色：提高 10% 亮度 */
  &:hover {
    background: rgb(from var(--primary) calc(r + 20) g b);
  }
}

.card {
  background: rgb(from var(--primary) r g b / 0.1);
  /* 10% 透明度的主色 */
}
```

## 实用配色方案

### 1. 单色系方案（最安全）

选一种主色，通过明度和饱和度变化搭建整个界面：

```css
:root {
  --primary: #2d8cf0;
  --primary-light: color-mix(in oklab, var(--primary), white 40%);
  --primary-lighter: color-mix(in oklab, var(--primary), white 70%);
  --primary-dark: color-mix(in oklab, var(--primary), black 30%);
}
```

适合：个人博客、企业官网（不容易出错）

### 2. 双色系方案（有活力）

选一种主色 + 一种强调色（通常是对比色）：

```css
:root {
  --blue: #2d8cf0;
  --orange: #f0a02d;
  --green: #52c41a;
  --red: #ff4d4f;
}
```

适合：品牌网站、SaaS 产品

### 3. 配色工具

| 工具 | 用途 |
|------|------|
| **Coolors** | 快速生成配色方案 |
| **Adobe Color** | 基于色轮的色彩规则 |
| **Realtime Colors** | 实时预览配色在 UI 上的效果 |
| **Leonardo** | 对比度分析，确保可访问性 |

> **经验之谈：** 我以前做网站配色，经常在"这个蓝色太淡了"和"这个蓝色太深了"之间反复横跳。后来发现一个规律：**选一个主色，把它的浅色版本用在背景上，深色版本用在文字上，纯色用在按钮和链接上。** 就这一条规则，解决了 80% 的配色难题。

## 颜色无障碍

配色不只是"好不好看"——还关乎"能不能看清"。

WCAG 要求正文文本和背景之间的对比度至少为 **4.5:1**。大号文本（18px 粗体或 24px 以上）至少为 **3:1**。

```css
/* 检查对比度的工具方法 */
@function contrast-ratio($color1, $color2) {
  // 用相对亮度公式计算
}

/* 好在现代浏览器 DevTools 已经内置了对比度检查 */
/* 打开 Elements 面板 → 选中元素 → 查看 Color 旁边的对比度 */
```

我的推荐：**在用任何颜色组合前，先用对比度检查工具验证一下。** 保证在明暗两种主题下都可读。

## 基础法则（依然有效）

| 原则 | 说明 |
|------|------|
| 60-30-10 法则 | 60%主色（背景）、30%辅助色、10%强调色 |
| 深底浅字/浅底深字 | 保证阅读对比度 |
| 不超过三种色系 | 多了就杂了 |
| 用灰度先检验 | 去掉颜色后，看布局是否仍然清晰 |

## 相关推荐

- [CSS 响应式设计实战——从媒体查询到容器查询](/archives/0009/)
- [网页字体格式详解——font-display 和可变字体](/archives/0035/)
- [字体图标那些事——SVG 替代方案](/archives/0033/)

**P.S.** 翻看 2020 年写的那篇"Bgcolor 颜色代码列表"，发现密密麻麻列了几十行 #E8FFE8、#F1FAFA 之类的十六进制色值。那是我一穷二白时从某个论坛复制来的。现在我会用 OKLCH 和 color-mix 了——**但每次看到那些十六进制码，还是能让我想起那个对着颜色面板选蓝色的下午。**
