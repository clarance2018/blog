---
title: 如何给你的网站添加 OG 标签——社交分享优化实战
categories: Web开发
tags: [OG标签,社交分享,Open Graph,Twitter Cards,SEO,SMO]
date: 2023-02-03 10:11:00
updated: 2026-07-24 10:00:00
id: 0029
---

有一次我把一篇文章分享到微信群里，结果出来的是这样：

标题：我网站的 URL
描述：空
封面图：没有

说实话，那一刻很尴尬。点进去的人肯定觉得这是个"半成品"网站。

后来我才知道——**问题出在了 OG 标签上。**

**一句话理解：** OG 标签是告诉你分享到的平台（微信、Twitter、Facebook）"这篇文章的标题是什么、封面图是哪个、描述怎么写"。

## 什么是 OG 标签

OG（Open Graph Protocol，开放图谱协议）是 Facebook 在 2010 年提出的一套 Meta 标签标准。现在它已经成为社交分享的"事实标准"——支持它的不只是 Facebook，还有微信、Twitter、LinkedIn、Slack、Discord 等等。

```html
<!-- 最基本的 OG 标签 -->
<meta property="og:title" content="文章标题（社交分享时显示）">
<meta property="og:description" content="文章描述（社交分享时显示在标题下方）">
<meta property="og:image" content="https://example.com/cover.jpg">
<meta property="og:url" content="https://example.com/article">
<meta property="og:type" content="article">
<meta property="og:site_name" content="站点名称">
```

## OG 标签和结构化数据有什么不同？

这是很多人容易搞混的问题：

| | OG 标签 | 结构化数据 |
|------|---------|-----------|
| 目的 | 社交分享展示 | 搜索引擎理解内容 |
| 使用者 | 微信、Twitter、Facebook | Google、百度、Bing |
| 格式 | `<meta property="og:...">` | JSON-LD |
| 影响 | 分享时的卡片效果 | 搜索结果的富结果 |

简单说就是：**OG 标签管分享，结构化数据管搜索。** 两者都建议加上，不冲突。

> **经验之谈：** 我之前一个项目没加 OG 标签，文章被大 V 转载后，分享到微信的卡片只有光秃秃的链接。后来加上 OG 标签后，同样的文章再被分享——出现了封面图、标题和描述。从那个项目的经验来看，**加 OG 标签前后，分享点击率大概提升了 2-3 倍。**

## Twitter Cards

Twitter 有自己的卡片规范，和 OG 类似但略有不同：

```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="文章标题">
<meta name="twitter:description" content="文章描述">
<meta name="twitter:image" content="https://example.com/cover.jpg">
```

`twitter:card` 有几个可选值：
- `summary`：小图卡片
- `summary_large_image`：大图卡片（推荐）
- `app`：应用下载卡片
- `player`：视频/音频卡片

好消息是：**大部分社交平台在读取 OG 标签时也兼容 Twitter Cards。** 你甚至可以只配 OG 标签，让 Twitter 自动 fallback。

但建议两者都配——Twitter 的 `summary_large_image` 卡片在移动端的展示效果比 fallback 好很多。

## 2026 年完整的社交分享标签

```html
<!-- Open Graph（通用） -->
<meta property="og:title" content="文章标题">
<meta property="og:description" content="文章描述摘要，建议 80-140 字符">
<meta property="og:image" content="https://example.com/cover.jpg">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:url" content="https://example.com/article">
<meta property="og:type" content="article">
<meta property="og:site_name" content="飞鲤的自留地">
<meta property="og:locale" content="zh_CN">

<!-- Twitter Cards -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@你的Twitter账号">
<meta name="twitter:creator" content="@文章作者Twitter账号">
```

### 图片的建议尺寸

| 平台 | 推荐尺寸 | 比例 |
|------|---------|:----:|
| Facebook | 1200×630 | 1.91:1 |
| Twitter | 1200×600 | 2:1 |
| 微信 | 900×500 | 1.8:1 |
| LinkedIn | 1200×627 | 1.91:1 |

一个 1200×630 的封面图能兼容大部分平台。

## 不同平台怎么加 OG 标签

### Hexo

这个博客用的是 Hexo + Butterfly 主题。多数 Hexo 主题已经内置了 OG 标签支持。如果不支持，可以安装插件：

```bash
npm install hexo-generator-seo-friendly-sitemap
```

或者直接在主题配置中开启 OG 标签选项。Butterfly 主题在 `_config.butterfly.yml` 里有专门的 OG 配置项。

### WordPress

WordPress 可以通过插件或主题 functions.php 添加：

```php
// 添加到主题的 functions.php
function theme_og_tags() {
    if (is_single() || is_page()) {
        ?>
        <meta property="og:title" content="<?php echo get_the_title(); ?>">
        <meta property="og:description" content="<?php echo get_the_excerpt(); ?>">
        <meta property="og:image" content="<?php echo get_the_post_thumbnail_url(); ?>">
        <meta property="og:url" content="<?php echo get_permalink(); ?>">
        <?php
    }
}
add_action('wp_head', 'theme_og_tags');
```

更省心的方式是使用 SEO 插件——Yoast SEO、Rank Math、All in One SEO 都内置了 OG 标签自动生成。

### 手动 HTML

最通用的方式，在其他平台也能用：

```html
<head>
  <!-- 通用 -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>文章标题</title>
  <meta name="description" content="文章描述">
  
  <!-- OG 标签 -->
  <meta property="og:title" content="文章标题">
  <meta property="og:description" content="文章描述">
  <meta property="og:image" content="https://example.com/cover.jpg">
  <meta property="og:url" content="https://example.com/article">
  <meta property="og:type" content="article">
  <meta property="og:site_name" content="站点名称">
</head>
```

## 怎么测试 OG 标签

写完之后一定要测试：

- **Facebook Sharing Debugger**：输入 URL 就能看到 OG 标签的解析结果
- **Twitter Card Validator**：检测 Twitter Cards 是否配置正确
- **微信开发者工具**：可以在公众号后台的"素材管理"里测试

如果测试发现封面图没显示出来——**最常见的三个原因：**
1. 图片 URL 不是绝对路径（必须 `https://` 开头）
2. 图片尺寸太小（微信要求至少 300×200）
3. 图片访问需要登录权限（比如私人 CDN 的防盗链）

## 相关推荐

- [SEO 结构化数据优化——JSON-LD 实战指南](/archives/2/)
- [Meta 标签功能大全——你可能不知道的 20 种用法](/archives/6/)
- [常见 Meta 标签参考和用途介绍](/archives/38/)

**P.S.** 我后来养成了一个习惯：每发一篇文章，先把它分享到微信和 Twitter 上看看卡片展示效果。如果封面图没出来，马上修。**让第一次见到你网站的人，在任何地方看到你的内容都是"完整的"。** 这不是完美主义，是基本的尊重。
