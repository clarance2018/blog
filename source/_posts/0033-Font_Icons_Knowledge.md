---
title: 关于字体图标和 SVG 图标——2026 年你该知道的选择
categories: Web开发
tags: [字体图标,SVG图标,Icon,前端开发,Font Awesome,网页设计]
date: 2020-06-11 14:37:55
updated: 2026-07-24 10:00:00
id: 0033
---

我早期做网站时，图标全部用的是图片——每个图标一张 PNG。

后来我发现了字体图标（Font Icon），感觉就像发现了新大陆：**一套字体搞定所有图标，用 CSS 就能控制颜色和大小。**

但字体图标也有它的问题。2026 年，我大部分项目开始转向 SVG 图标了。

**一句话理解：** 字体图标是把图标放进"字体文件"，用字符来显示；SVG 图标是用 HTML 标签直接画图标——各有优劣，看场景选择。

## 字体图标 vs SVG 图标

| 维度 | 字体图标 | SVG 图标 |
|------|---------|---------|
| 渲染原理 | 字体渲染 | 矢量图形渲染 |
| 颜色支持 | 单色（或 CSS 渐变色） | **多色、多层级** |
| 缩放 | 矢量，不失真 | 矢量，不失真 |
| 性能 | 好（字体文件一次加载） | 好（每个图标独立加载） |
| 可访问性 | 可用 aria-label | 支持 title/desc |
| 深色模式 | 通过 CSS 控制 | 通过 CSS 变量控制 |
| CSS 控制 | font-size/color | width/height/fill/stroke |

## 字体图标的时代

Font Awesome 和 Iconfont（阿里巴巴矢量图标库）是字体图标的代表：

```html
<!-- 引入 Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<!-- 使用图标 -->
<i class="fa-solid fa-user"></i>
<i class="fa-solid fa-heart" style="color: red;"></i>
```

字体图标的优点：**方便、快速、一套字体解决图标需求。**

字体图标的缺点：
- **只有单色**——不能在一个图标里用两种颜色
- **依赖字体文件**——加载失败所有图标变方块
- **可访问性差**——屏幕阅读器可能把它们当成文字读出来

## SVG 图标：更现代的选择

```html
<!-- 内联 SVG 图标：最灵活的方式 -->
<svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor">
  <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
</svg>
```

SVG 图标的优点：
- **多色**——一个图标可以有多种颜色
- **可样式化**——通过 CSS 控制 fill、stroke、透明度
- **可访问**——可以加 title 和 desc 元素
- **无外部依赖**——不需要加载字体文件

### 流行的 SVG 图标库

| 库 | 特点 | 使用方式 |
|------|------|---------|
| **Lucide** | 开源，轻量 | npm 包或 CDN |
| **Heroicons** | 由 Tailwind CSS 团队制作 | React/Vue 组件 |
| **Phosphor Icons** | 6 种风格 | 灵活多变 |
| **Tabler Icons** | 4000+ 图标 | SVG sprite |

```bash
# 以 Lucide 为例
npm install lucide

# 在 React 中使用
import { User, Heart } from 'lucide-react';

function MyComponent() {
  return (
    <div>
      <User size={24} />
      <Heart className="text-red-500" size={24} />
    </div>
  );
}
```

> **经验之谈：** 我从 Font Awesome 切换到 Lucide 的主要原因有两个：**一是图标可以多色了，二是按需加载**——Font Awesome 加载整个字体文件（几百 KB），Lucide 按组件打包（几 KB）。在性能敏感的页面上，这个差异很明显。

## 怎么选

**选字体图标：**
- 项目需要快速集成、不需要多色图标
- 团队对字体图标更熟悉
- 站点已经用了 Font Awesome，没必要换

**选 SVG 图标：**
- 需要多色图标或自定义样式
- 性能敏感（按需加载优于字体文件）
- 使用 React/Vue 等组件化框架
- 需要更好的无障碍支持

## 相关推荐

- [网页字体格式详解——font-display 和可变字体](/archives/0035/)
- [网页配色技巧——从十六进制到现代 CSS 颜色](/archives/0019/)
- [网页前端性能优化——图标加载策略](/archives/0021/)

**P.S.** 说到字体图标的"单色缺陷"，我以前有个项目要求图标在不同状态下显示不同颜色，但还要求 hover 时变成渐变色。字体图标做不到，最后用 SVG 图标解决了。**有时候限制会逼你发现更好的方案。** 如果字体图标完全满足你的需求，继续用——但如果它的限制开始成为问题，是时候看看 SVG 图标了。
