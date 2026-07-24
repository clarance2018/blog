---
title: 为什么不再用 Table 做网页布局？——从 Table 到 Flexbox 到 Grid 的进化史
categories: Web开发
tags: [HTML,CSS,布局,Table, Flexbox,CSS Grid,前端开发,响应式设计]
date: 2020-06-11 14:38:00
updated: 2026-07-24 10:00:00
id: 0001
---

你有见过那种 2000 年代初的网站吗？满屏的 `<table>` 嵌套 `<table>`，像俄罗斯套娃一样，一个表格里塞一个表格，再塞一个表格……

我刚开始学做网页的时候，用的就是 table 布局。**不是因为 table 布局好，是因为那时候我只知道这一种布局方式。**

后来学了 CSS，才发现以前用 table 做的很多事，CSS 只需要几行代码就能搞定，而且更灵活、更高效。

**一句话理解：** `<table>` 是用来展示表格数据的，不是用来搭页面框架的——就像你不会用筷子喝汤一样，工具要用对地方。

## Table 布局的问题在哪

| 问题 | 说明 |
|------|------|
| **代码臃肿** | Table 布局需要大量嵌套标签，比 Flexbox/Grid 多出 50-70% 的 HTML |
| **渲染阻塞** | 浏览器必须等整个 `<table>` 加载完才能开始渲染（包括内容） |
| **响应式困难** | 表格天生定宽，要适配手机非常麻烦 |
| **语义错误** | 用 `table` 做布局等于告诉搜索引擎"这是数据表格"，影响 SEO |
| **可维护性差** | 改一个地方的布局，可能要动十几层嵌套的 table 结构 |

> **经验之谈：** 我第一次重构一个 table 布局的站时，发现一个"看似简单"的页面里嵌了 7 层 `<table>`。改成 Flexbox 后，HTML 代码量减少了 60%，而且后面改版时改 CSS 就行，不用动 HTML 结构。**那可维护性的提升，是我坚持用 CSS 布局的根本原因。**

## 2026 年的正确选择

### CSS Grid——二维布局的首选

CSS Grid 是专门为"二维布局"设计的——同时控制行和列：

```css
/* 三栏布局：自动适应的 sidebar + main + sidebar */
.layout {
  display: grid;
  grid-template-columns: 200px 1fr 200px;
  gap: 20px;
}

/* 响应式：自动换行 */
.gallery {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 16px;
}
```

Grid 的核心理念是：**你告诉它"放哪里"，而不是"怎么放"。**

### Flexbox——一维布局的王者

Flexbox 适合"一行或一列"的排列：

```css
/* 水平居中对齐 */
.nav {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 24px;
}

/* 自动撑开等宽 */
.card-group {
  display: flex;
  gap: 16px;
}
.card-group > * {
  flex: 1;
}
```

### 什么时候用 Table

2026 年，`<table>` 唯一的合法用途是——**展示表格数据。**

```html
<table>
  <thead>
    <tr>
      <th>产品</th>
      <th>价格</th>
      <th>库存</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>商品 A</td>
      <td>¥99</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
```

## 布局方案对比

| 方案 | 适合场景 | 浏览器支持 | 学习曲线 |
|------|---------|:----------:|:--------:|
| Table 布局 | ❌ 已淘汰 | 100% | 低（但不值得学了） |
| Flexbox | 一维排列（导航、卡片组） | 98%+ | 中 |
| CSS Grid | 二维布局（页面整体、相册） | 96%+ | 中高 |
| 多列布局 | 文字排版（类似报纸） | 95%+ | 低 |
| Container Queries | 组件级响应式 | 85%+ | 新特性 |

## 相关推荐

- [HTML5 div、article、section 到底怎么选？](/archives/5/)
- [响应式设计从 Table 到 Grid 的进化](/archives/9/)
- [网页配色技巧——从十六进制到 OKLCH](/archives/19/)

**P.S.** 我家里现在还存着一本 2008 年的《Dreamweaver 网页设计教程》，里面有一整章在教怎么用 table 做页面布局。现在翻出来看，感觉像在看考古文献一样。技术的迭代就是这么快——**五年前的主流实践，五年后可能就成了反面教材。** 保持学习，保持怀疑，是我在这行学到的最重要的事。
