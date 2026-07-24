---
title: 网站防盗链实战指南——别再让别人白嫖你的服务器资源了
categories: Web开发
tags: [防盗链,热链接,Nginx,Apache,IIS,网站安全,CDN]
date: 2020-06-11 14:38:37
updated: 2026-07-24 10:00:00
id: 0003
---

大概好几年前，我查看服务器日志时发现一个惊人的数字：

**一天之内，我的服务器为某个"图片资源站"提供了几个 G 的流量。**

对方直接在网站上引用了我的图片链接，我服务器上的图片成了他们网站的"免费图床"。用户访问他们的页面，浏览器加载图片请求到了我服务器上——**流量钱全是我出的。**

**一句话理解：** 防盗链就是让别人的网站不能"借用"你服务器上的文件——通常是图片、视频、下载文件等资源。

## 什么是盗链

盗链（Hotlinking）的直接表现就是：A 网站的页面里直接引用了 B 网站的图片地址。

```html
<!-- A 网站的 HTML -->
<img src="https://B网站.com/images/photo.jpg">
<!-- ↑ 这张图片存在 B 的服务器上，但被 A 白嫖了 -->
```

每次用户访问 A 网站，浏览器都会向 B 服务器请求这张图片——**B 在帮 A 出流量费。**

盗链的常见对象：
- 图片（最常见）
- 视频/音频文件
- 下载文件（exe、zip、rar）
- CSS/JS 文件

## Nginx 防盗链（最推荐）

如果你用 Nginx，防盗链非常简单——用 `valid_referers` 指令：

```nginx
# 只允许本站和搜索引擎引用图片
location ~ \.(gif|jpg|jpeg|png|webp|avif)$ {
    valid_referers none blocked 
        ~.google\.com
        ~.bing\.com
        6mal.com *.6mal.com;
    
    if ($invalid_referer) {
        return 403;
        # 或者重定向到一张"禁止盗链"的提示图
        # rewrite ^ /images/block.jpg last;
    }
}

# 禁止其他网站引用下载文件
location ~ \.(exe|zip|rar|tar|gz)$ {
    valid_referers none blocked 6mal.com *.6mal.com;
    
    if ($invalid_referer) {
        return 403;
    }
}
```

`valid_referers` 的几个参数含义：

| 参数 | 含义 |
|------|------|
| `none` | 允许直接访问（输入 URL、收藏夹打开） |
| `blocked` | 允许没有 Referer 的请求（隐私模式） |
| `6mal.com` | 允许本站域名 |
| `*.6mal.com` | 允许所有子域名 |

> **经验之谈：** `none` 和 `blocked` 加了之后，不会误伤那些隐私模式下的用户。不加的话，用户直接从地址栏打开你的图片都会 403。我第一次配的时候没加 `none`，结果自己网站的图片都看不到了——**调试了半小时才发现这个细节。**

## Apache 防盗链

```apache
# .htaccess 配置
RewriteEngine On
RewriteCond %{HTTP_REFERER} !^$
RewriteCond %{HTTP_REFERER} !^http(s)?://(www\.)?6mal.com [NC]
RewriteCond %{HTTP_REFERER} !^http(s)?://(www\.)?google.com [NC]
RewriteRule \.(jpg|jpeg|png|gif|webp|avif)$ - [NC,F,L]
```

## IIS 防盗链

如果你还在用 IIS，可以通过 URL Rewrite 模块实现：

```xml
<!-- web.config -->
<system.webServer>
  <rewrite>
    <rules>
      <rule name="AntiHotlinking" stopProcessing="true">
        <match url="\.(gif|jpg|jpeg|png|webp|avif)$" />
        <conditions>
          <add input="{HTTP_REFERER}" pattern="^$" negate="true" />
          <add input="{HTTP_REFERER}" pattern="^https?://([a-z0-9]+\.)?6mal\.com/" negate="true" />
        </conditions>
        <action type="CustomResponse" statusCode="403" />
      </rule>
    </rules>
  </rewrite>
</system.webServer>
```

## CDN 级别的防盗链（更推荐）

如果你用了 Cloudflare、AWS CloudFront 等 CDN，**直接在 CDN 层面做防盗链更优雅**——请求在 CDN 边缘就被拒绝了，不会到达你的源服务器。

```nginx
# Cloudflare 方式：在 Nginx 源站验证 CF 请求
# 或者直接在 Cloudflare 控制台开启 "Hotlink Protection"
```

Cloudflare 的 Hotlink Protection 开启后，会自动验证请求来源——只有你的域名和搜索引擎能引用你的图片。

## Referrer Policy 与防盗链的关系

现代浏览器对 Referer（来源地址）的发送策略越来越严格。很多隐私模式下浏览器不发送 Referer，这可能导致防盗链配置误拦截。

这就是为什么防盗链配置里要加 `none` 和 `blocked`——**允许没有 Referer 的请求通过。**

同时，你自己的网站应该设置合理的 Referrer Policy：

```nginx
# Nginx 配置
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
```

这个策略的意思是：同域请求发完整 Referer，跨域请求只发域名——既保护隐私又不影响防盗链。

## 如果你不想防那么严

有时候"盗链"不一定是恶意的。比如你的文章被一个人气网站转载了，对方引用了你的图片，虽然消耗了流量但也带来了曝光。

一个折中的方案是：**不禁止，但加水印限速。**

```nginx
# Nginx 限制图片请求速度（每秒处理 1 张）
location ~ \.(jpg|png|gif)$ {
    limit_rate 100k;  # 限制下载速度为 100KB/s
    valid_referers none blocked 6mal.com *.6mal.com;
    
    if ($invalid_referer) {
        # 加水印版本或者低分辨率版本
        rewrite ^ /watermark/$uri last;
    }
}
```

## 相关推荐

- [网站使用 CDN 加速会影响 SEO 吗？](/archives/0017/)
- [对付 DDoS 攻击的现代防御策略](/archives/0036/)
- [网站常见安全漏洞与防范——2026 安全实践](/archives/0015/)

**P.S.** 后来我发现 "盗链我" 的那个网站，站长在联系页面留下了一个 QQ 号。我加了他，跟他说明了情况。他说："啊，我不知道这样会消耗你的流量，抱歉。"然后撤掉了所有盗链图片。**很多盗链不是恶意的，是"不知道这样不行"的。** 但不管怎样，保护自己的服务器资源总是没错的——毕竟，流量不是大风刮来的，是花钱买的。
