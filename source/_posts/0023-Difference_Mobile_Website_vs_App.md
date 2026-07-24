---
title: 手机网站 vs App——2026 年你不需要二选一了
categories: Web开发
tags: [移动端,PWA,App,手机网站,Web应用,用户增长]
date: 2020-06-11 14:38:26
updated: 2026-07-24 10:00:00
id: 0023
---

以前有个朋友问我："我想做移动端的业务，是做个手机网站好，还是做个 App 好？"

我说："你预算多少？"

他说："没多少钱。"

我说："那先做手机网站。等你有了足够的用户验证了商业模式，再做 App。"

这不是敷衍——是**我见过太多花了几十万做 App，最后日活不到 100 的项目。**

**一句话理解：** 手机网站和 App 不是"二选一"的关系——**PWA 是桥梁，可以让你先用网站验证产品，再用 App 满足重度用户。**

## 手机网站 vs App 对比

| 维度 | 手机网站（PWA） | 原生 App |
|------|---------------|---------|
| 开发成本 | 低（一个响应式网站即可） | 高（iOS + Android 两套） |
| 发布门槛 | 无（发布到服务器就有人能访问） | 高（应用商店审核） |
| 更新速度 | 即时（改完刷新即可） | 慢（需要审核周期） |
| 用户获取 | SEO、社交分享、链接 | 应用商店搜索、广告投放 |
| 离线能力 | PWA 可实现部分离线 | 完全离线 |
| 系统 API 访问 | 有限（PWA 可访问部分） | 完整 |
| 性能 | 受限于浏览器 | 原生性能 |
| 用户留存 | 较低（没有桌面图标） | 较高（在主屏上） |

## PWA：手机网站和 App 之间的桥梁

PWA（Progressive Web App）是 2026 年最好的"折中方案"——它让手机网站拥有接近 App 的体验。

```json
// manifest.json——让网站可以"安装"到手机主屏
{
  "name": "飞鲤的自留地",
  "short_name": "飞鲤",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#2d8cf0",
  "icons": [
    { "src": "/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
```

### 需要 PWA 的场景

- 内容型网站（博客、新闻、文档）→ **PWA 完全够用**
- 工具型应用（计算器、笔记、待办）→ **PWA 完全够用**
- 电商网站 → **PWA 够用，但支付需要后端配合**
- 社交应用、游戏、音视频编辑 → **可能需要原生 App**

### 不需要 PWA 的场景

- 需要频繁在后台运行的 App
- 需要访问蓝牙、NFC 等硬件接口的应用
- 需要高性能图形渲染的游戏

## Service Worker：让网站离线也能用

Service Worker 是 PWA 的核心技术——一个独立于网页的 JavaScript 文件，可以拦截网络请求并实现离线缓存。

```javascript
// service-worker.js
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open('v1').then((cache) => {
      return cache.addAll([
        '/',
        '/styles.css',
        '/app.js',
        '/offline.html',
      ]);
    })
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      // 有缓存就用缓存，没有就请求网络
      return response || fetch(event.request);
    })
  );
});
```

## 2026 年的建议

| 你的情况 | 推荐方案 |
|---------|---------|
| 预算有限，想验证想法 | 响应式网站 + PWA |
| 内容型产品（博客、资讯） | PWA 完全足够 |
| 工具型产品（记账、笔记） | PWA 为主，需要时加 App |
| 社交/电商产品 | 先用 PWA 验证，再根据数据决定是否做 App |
| 游戏/音视频/硬件交互 | 直接做原生 App |

> **经验之谈：** 我见过最成功的"渐进式"策略是这样的：先用微信公众号 + H5 网站验证需求 → 用户量起来后做小程序 → 再进一步做 App。每一步都有明确的"是否继续"的判断标准。而不是一上来就花 50 万做个 App，结果上线后没人用。

## 相关推荐

- [HTML5 移动端前端开发要点——2026 年更新版](/archives/0004/)
- [网页打开太慢？2026 年性能优化指南](/archives/0021/)
- [响应式设计实战——从媒体查询到容器查询](/archives/0009/)

**P.S.** 我那个朋友最后做了个手机网站，上线三个月后积累了 2000 个用户。然后他用这些数据去谈了一笔投资——做 App。**先验证，再投入。** 这个道理适用于做产品，也适用于很多其他事情。
