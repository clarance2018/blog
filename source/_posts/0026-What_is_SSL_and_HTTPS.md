---
title: 什么是 SSL 和 HTTPS？——2026 年，每个网站都应该知道的加密知识
categories: Web开发
tags: [SSL,TLS,HTTPS,Let's Encrypt,网络安全,证书,网站加密]
date: 2020-06-11 14:37:31
updated: 2026-07-24 10:00:00
id: 0026
---

几年前我帮朋友弄他的个人网站，他说"网站做好了，你帮我看看"。我打开浏览器一访问——**"此网站不安全"**，一个大大的红色警告。

他说："没事，反正就几个朋友看，不用弄 HTTPS 了吧？"

我说："不是需要不需要的问题——**2026 年，没有一个浏览器会信任 HTTP 网站。** Chrome 会在地址栏直接标红，Safari 会弹警告，用户看到这个页面第一反应是关掉。"

他最后还是上了 HTTPS，花了半小时配好 Let's Encrypt，之后跟我说：**"早知道这么简单，我早就弄了。"**

**一句话理解：** HTTP 是"明信片"，路上的任何人都能看内容；HTTPS 是"信封"，只有收信的人能打开看。

## SSL 还是 TLS？先弄清楚名字

先说一个很多人搞混的事。

SSL（Secure Sockets Layer）是 Netscape 在 1994 年发明的，**但 SSL 2.0 和 3.0 早就被淘汰了**——因为它们有严重的安全漏洞。

现在我们用的其实是 **TLS（Transport Layer Security）**，目前的主流版本是 TLS 1.2 和 TLS 1.3。

所以严格来说，"SSL证书"这个说法是错的——应该叫"TLS 证书"。但大家叫习惯了，证书商也继续这么卖，也就沿用了。

| 年份 | 协议 | 状态 |
|------|------|------|
| 1994 | SSL 1.0 | 未公开 |
| 1995 | SSL 2.0 | ❌ 已废弃 |
| 1996 | SSL 3.0 | ❌ 2015 年废弃 |
| 1999 | TLS 1.0 | ❌ 已废弃 |
| 2006 | TLS 1.1 | ❌ 已废弃 |
| 2008 | TLS 1.2 | ✅ 仍广泛使用 |
| 2018 | TLS 1.3 | ✅ 当前推荐 |

**一句话：不要在意名字，重要的是知道你用的是 TLS 1.2 或 1.3。**

## HTTPS 解决了三个问题

HTTPS = HTTP + TLS，它做三件事：

| 问题 | 解决方案 | 类比 |
|------|---------|------|
| 别人能看到传输内容 | **加密** | 把信装进信封 |
| 无法确认对方是谁 | **身份验证** | 看对方身份证 |
| 内容可能被篡改 | **完整性校验** | 信的封口有蜡封 |

### 加密：为什么必须的

没有 HTTPS 的时候，你在咖啡厅连公共 Wi-Fi，你输入的任何密码、银行卡号——**同一个 Wi-Fi 下任何人都能抓包看到。**

```bash
# 用 tcpdump 抓 HTTP 包（明文）
tcpdump -A port 80
# 你会直接看到 POST 请求里的密码
```

有了 HTTPS 之后，抓包看到的是乱码——因为没有私钥解不开。

### 身份验证：你是不是真的

HTTPS 证书的另一个作用是**验证"你是不是你声称的网站"**。一个钓鱼网站可以模仿你的页面，但如果没有你的 SSL 证书，浏览器地址栏就会显示"不安全"。

### 完整性：内容没被改过

TLS 通过消息认证码（MAC）来检测内容是否被篡改。如果有人在中途改了你的网页内容，浏览器会发现 MAC 对不上，然后断开连接。

## 关于证书类型：99% 的网站选免费的就够了

证书分三种验证级别：

| 类型 | 验证内容 | 费用 | 推荐场景 |
|------|---------|------|---------|
| DV（域名验证） | 证明你拥有域名 | 免费 | 个人网站、博客、小型企业 |
| OV（组织验证） | 验证企业身份 | 付费 | 正规企业网站 |
| EV（扩展验证） | 深度验证企业 | 付费 | 银行、金融、政府 |

对于 99% 的网站，**DV 证书完全足够了**。EV 证书在过去会在地址栏显示绿色的公司名，但 2026 年几乎所有浏览器都已经移除了这个 UI——所以 EV 的"视觉优势"已经不存在了。

> **经验之谈：** 我以前也买过付费证书，一年花几百块，就为了地址栏那把绿色的锁。后来 Chrome 取消了 EV 的绿色标识，我才意识到——那些年我花了几百块买的"安全感"，其实 Let's Encrypt 免费证书完全能做到。从那以后我所有项目都只用 Let's Encrypt。

## 实操：用 Certbot + Let's Encrypt 免费搞定 HTTPS

Let's Encrypt 是一个免费的、自动化的证书颁发机构（CA），由 Linux 基金会运营。它让 HTTPS 的普及发生了质的变化。

```bash
# 安装 Certbot（Ubuntu/Debian）
sudo apt install certbot python3-certbot-nginx

# 自动获取并配置证书
sudo certbot --nginx -d 6mal.com -d www.6mal.com

# 就这么简单，HTTPS 就配好了
```

Certbot 会自动：
1. 验证你对域名的所有权
2. 签发证书
3. 配置 Nginx 使用 HTTPS
4. 设置自动续期

用 `acme.sh` 也可以，更轻量：

```bash
# 安装 acme.sh
curl https://get.acme.sh | sh

# 签发证书
acme.sh --issue -d 6mal.com --nginx

# 安装证书到 Nginx
acme.sh --install-cert -d 6mal.com \
  --key-file /etc/nginx/ssl/6mal.com.key \
  --fullchain-file /etc/nginx/ssl/fullchain.cer
```

**Let's Encrypt 证书有效期是 90 天**，但 Certbot 和 acme.sh 都会自动续期。配置好后你基本不需要再管它。

```bash
# 测试自动续期是否正常工作
sudo certbot renew --dry-run
```

## HTTPS 之后：HSTS 别忘记

HSTS（HTTP Strict Transport Security）是 HTTPS 的"好搭档"。它告诉浏览器：**以后永远用 HTTPS 访问我这个网站，不要试图用 HTTP。**

```nginx
# Nginx 配置
add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
```

加上这个头之后，浏览器会记住：这个网站只能 HTTPS 访问。即使有人在中间做了 HTTP 劫持，浏览器也不会响应。

还有一个更强的方式：**提交到 HSTS Preload List**。这样用户在第一次访问之前，浏览器就已经知道这个网站必须用 HTTPS——连第一次 HTTP 请求都不会发出去。

## 2026 年 SSL/TLS 配置速查

如果你自己搭建服务器，Mozilla 有一个非常好用的 **SSL Configuration Generator**（ssl-config.mozilla.org），选择你的服务器类型和需要的兼容性等级，它会生成推荐配置。

```nginx
# Nginx + TLS 1.3 推荐配置片段
server {
    listen 443 ssl http2;
    server_name 6mal.com;
    
    ssl_certificate /etc/letsencrypt/live/6mal.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/6mal.com/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    
    add_header Strict-Transport-Security "max-age=63072000";
}
```

## 相关推荐

- [网站有哪些常见安全漏洞？如何防范？——2026 安全实践](/archives/0015/)
- [对付 DDoS 攻击的现代防御策略](/archives/0036/)
- [到底什么是网站根目录？搞错了整个网站都打不开](/archives/0037/)

**P.S.** 回到开头那个朋友——他后来自己学会了用 Certbot，两年内帮他的好几个朋友也配了 HTTPS。他跟我说配完 SSL 之后的感受是："原来困扰了我好几年的事，其实就一行命令搞定。"**技术的门槛往往不在技术本身，在于你不知道有这么简单的解决方案。**
