---
title: div、article、section 到底怎么选？一个让 HTML 变得有意义的决定
categories: Web开发
tags: [HTML5,语义化,前端开发,ARIA,网页结构,无障碍]
date: 2020-06-11 14:37:42
updated: 2026-07-24 10:00:00
id: 0005
---

说实话，我刚写网页那几年，整个页面全是 `<div>`。

不是我不想用别的标签，是**我不知道它们有什么区别**。article 和 section 看起来都像"区块"，div 又是最熟悉的"盒子"——选哪个好像没差。

后来我才发现，**这不是一个样式问题，是一个意义问题。**

**一句话理解：** `div` 是你告诉浏览器"这有个区域"，`section` 是"这有个主题区域"，`article` 是"这有个独立内容"——语义的强度从低到高。

## 先搞清楚：为什么要有语义标签

HTML5 之前，整个网页就是一个 `<div>` 的海洋。

```html
<div class="header">网站标题</div>
<div class="nav">导航</div>
<div class="content">主要内容</div>
<div class="footer">版权信息</div>
```

这能跑，但浏览器、搜索引擎、辅助工具（屏幕阅读器）**完全不知道这些区块是什么意思**。它们只能看到一堆无语义的"盒子"。

HTML5 引入的语义标签解决了这个问题。它们让 HTML 不只是"显示内容"，而是"**描述内容的含义**"。

> **经验之谈：** 我花了很多年才意识到，好的 HTML 不是给人类看的，是给机器看的——给搜索引擎看的、给屏幕阅读器看的、给未来可能出现的各种工具看的。

## div：万能的容器，但空有容器

`<div>` 是 HTML 里最通用的块级元素。它代表一个"分割区（division）"，**本身没有任何语义**。

它的真正用途只有两个：
- **样式容器**：你要给一组元素统一加样式
- **布局挂钩**：你要用 CSS Flexbox/Grid 做页面布局

其他时候，优先考虑语义标签。

```html
<!-- ❌ 无语义 -->
<div class="navigation">
  <a href="/">首页</a>
  <a href="/about">关于</a>
</div>

<!-- ✅ 有语义 -->
<nav>
  <a href="/">首页</a>
  <a href="/about">关于</a>
</nav>
```

## section：有主题的「章节」

`<section>` 表示一个**有主题的独立章节**。它应该有自己的标题（`h1`-`h6`）。

什么时候用：
- 文章里的一个章节
- 首页的"最新文章"区块
- 产品页的"特性介绍"区块

```html
<section>
  <h2>为什么选择语义标签</h2>
  <p>语义标签带来三个核心好处：SEO、无障碍、可维护性...</p>
</section>
```

**判断标准：** 这段内容能否放进一个文档的目录中？如果能用"3.2"这样编号的，就是 section。

### section 的常见误用

很多人把 `<section>` 当成"有语义的 div"来用，这是错的。

```html
<!-- ❌ section 当样式容器 -->
<section class="card" style="border: 1px solid #ccc;">
  <p>内容</p>
</section>

<!-- ✅ 这才是 div 的活 -->
<div class="card" style="border: 1px solid #ccc;">
  <p>内容</p>
</div>
```

**section 的核心是"主题"，不是"盒子"。** 一个没有标题的 section 基本上就是误用。

## article：独立成篇的内容

`<article>` 代表一个**独立的、完整的内容单元**。它应该能够脱离页面独自存在。

什么时候用：
- 博客文章
- 新闻条目
- 论坛帖子
- 用户评论
- 产品卡片

```html
<article>
  <header>
    <h2>语义标签实战指南</h2>
    <p>发布时间：<time datetime="2024-03-15">2024年3月15日</time></p>
  </header>
  <p>本文介绍如何在实际项目中正确使用 HTML5 语义标签...</p>
</article>
```

一个很直观的判断：**如果这段内容可以出现在 RSS 订阅里，它就是 article。** 不能的话，考虑 section。

### article 嵌套的经典模式

博客文章里的评论就是最典型的嵌套场景：

```html
<article>
  <header>
    <h2>语义标签实战指南</h2>
  </header>
  <p>正文内容...</p>
  
  <section>
    <h3>评论</h3>
    
    <article>
      <header>
        <h4>小明说：</h4>
        <time datetime="2024-03-15T14:30:00">14:30</time>
      </header>
      <p>写得太好了，收藏！</p>
    </article>
    
    <article>
      <header>
        <h4>小红说：</h4>
        <time datetime="2024-03-15T15:00:00">15:00</time>
      </header>
      <p>有一个地方我没看懂，求更详细的解释</p>
    </article>
  </section>
</article>
```

每一条评论都是一个独立的 `article`——它们可以被单独引用、展示、moderate。这就是"独立"的含义。

> **经验之谈：** 我曾经在一个博客项目里把所有条目都用了 `<article>`，包括侧边栏的"关于我"。直到有一天我意识到这篇文章"脱离页面"需要个独立 URL——而"关于我"并没有独立存在的意义，它属于页面的一个区块。那次之后我对 article 的理解才算真正到位了。

## 决策树：到底用哪个？

| 场景 | 该用 | 理由 |
|------|------|------|
| 页面布局容器、样式挂钩 | `div` | 无语义，纯结构和样式 |
| 一篇文章、一条新闻、一条评论 | `article` | 内容独立可复用 |
| 有主题的章节，需要标题 | `section` | 属于整体但自成主题 |
| 主导航 | `nav` | 专门的导航标签 |
| 侧边栏、广告、相关内容 | `aside` | 附属内容 |
| 页眉区域（不可复用） | `header` | 介绍性内容 |
| 页脚信息 | `footer` | 版权、链接 |

简单的判断流程：

```
这段内容能独立存在吗？
   ├── 是 → 用 <article>
   └── 否 → 它有明确的主题/标题吗？
              ├── 是 → 用 <section>
              └── 否 → 纯样式/结构需要 → 用 <div>
```

## 无痕的彩蛋：ARIA Landmarks

当你正确使用了语义标签后，浏览器会自动把它们映射到 **ARIA Landmark Roles**（地标角色）。屏幕阅读器用户可以快速跳转到页面的不同区域。

```html
<!-- 这些标签会自动关联 ARIA roles -->
<nav>       → role="navigation"
<main>      → role="main"
<article>   → role="article"
<section>   → role="region"（需要 aria-label 或标题）
<aside>     → role="complementary"
<header>    → role="banner"（仅在页面级别时）
<footer>    → role="contentinfo"（仅在页面级别时）
<form>      → role="form"
```

这意味着你不需要写 `role="navigation"`，用 `<nav>` 就够了。**语义标签 = 免费的无障碍支持。**

这也是我不再写 `<div class="nav">` 的根本原因——`<div>` 不会产生任何 landmark role，屏幕阅读器用户需要额外加 `role="navigation"` 才行。

## 一个真实案例

我之前接手过一个遗留项目，整个页面是这种结构：

```html
<div class="header">
  <div class="logo">Logo</div>
  <div class="menu">导航链接...</div>
</div>
<div class="content">
  <div class="post">
    <div class="post-title">标题</div>
    <div class="post-body">正文...</div>
  </div>
</div>
```

改造后：

```html
<header>
  <span>Logo</span>
  <nav>导航链接...</nav>
</header>
<main>
  <article>
    <header>
      <h2>标题</h2>
    </header>
    <p>正文...</p>
  </article>
</main>
```

结果呢？SEO 友好度提升，Google Search Console 的"结构数据"报告有明显改进。更重要的是，项目组的人再看 HTML 的时候，**一眼就能知道每一块是干什么的**——这就是语义化的价值。

## 相关推荐

- [HTML5 移动端前端开发要点](/archives/0004/)
- [Meta 标签功能大全——你可能不知道的 20 种用法](/archives/0006/)
- [H1 标签到底怎么用才正确？一个被低估的 SEO 因素](/archives/0007/)

**P.S.** 我第一次认真研究语义标签时，发现自己在之前一个项目里写了 200 多个 `<div>`——那个项目只有 5 个页面。写这篇文章的时候翻出那段代码看了一眼，嘴角不自觉地上扬了。有些习惯改了，就再也回不去了。
