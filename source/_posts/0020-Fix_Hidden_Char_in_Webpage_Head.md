---
title: 网页开头出现隐藏字符 #65279 的解决方法——BOM 这个坑你一定遇到过
categories: Web开发
tags: [BOM,UTF-8,编码问题,隐藏字符,网页调试,HTML]
date: 2020-06-11 14:38:33
updated: 2026-07-24 10:00:00
id: 0020
---

很久以前我改了一个网页文件，上传到服务器后，页面顶部莫名其妙多了一条空白。

按 F12 检查，在 `<body>` 之后有一个 `&#65279;`。但我在编辑器里看代码完全没有这个字符。

折腾了很久，删了重写、复制粘贴、换行缩进反复试——空白依旧。最后在一个论坛里找到答案：**这是 BOM 问题。**

**一句话理解：** BOM 是微软记事本在保存 UTF-8 文件时偷偷加在文件头部的三个不可见字节——它们不是内容，但浏览器会把它当作内容显示出来。

## BOM 到底是什么

BOM（Byte Order Mark，字节顺序标记）是 Unicode 标准中用来标记文件编码方式的"标记符"。

在 UTF-8 中，BOM 对应的三个字节是 `EF BB BF`。Windows 记事本在保存 UTF-8 文件时，会自动在最前面加上这三个字节。

```
文件内容（带 BOM）：[EF BB BF] <!DOCTYPE html> ...
文件内容（无 BOM）：<!DOCTYPE html> ...
```

浏览器在解析 HTML 时，会把 `EF BB BF` 解析成一个不可见的零宽字符（`ZERO WIDTH NO-BREAK SPACE`，Unicode `U+FEFF`），**但有时候它会在页面上产生可见的空白。** 特别是在表格中或设置了背景色的容器里，这个空白会被明显看到。

## BOM 带来的问题

| 问题 | 表现 | 严重程度 |
|------|------|:--------:|
| 页面顶部空白 | 网页顶部出现一行无法消除的空隙 | ⚠️ 常见 |
| Header 偏移 | `<head>` 中的 Meta 标签被挤到 `<body>` | ⚠️ 偶发 |
| Cookie 失效 | PHP 因为 BOM 提前输出了内容，导致 Header 无法设置 Cookie | 🔴 严重 |
| JSON 解析失败 | API 返回的 JSON 因为 BOM 导致解析失败 | 🔴 严重 |
| HTML 验证报错 | W3C 验证器报告第一行有非法字符 | ⚠️ 提示 |

> **经验之谈：** 我有一次排查了一个小时的"登录不了"的问题，最后发现是 PHP 文件带 BOM——PHP 解析器把 BOM 当作输出内容，导致 `header()` 函数无法发送 Cookie。那把火从"为什么这个按钮点不了"一直烧到"为什么 PHP 文件不能用记事本编辑"——最后源头是开发人员用记事本改了一个 PHP 文件。

## 如何检测和修复

### 检测 BOM

```bash
# Linux/Mac 用 hexdump 查看文件头
head -c 3 file.html | xxd
# 如果输出是 ef bb ff，那就是有 BOM

# 批量搜索 BOM 文件
grep -rl $'\xEF\xBB\xBF' ./src/
```

### 修复 BOM（把带 BOM 的文件转成无 BOM）

```bash
# 使用 sed 移除 BOM
sed -i '1s/^\xEF\xBB\xBF//' file.html

# 使用 vim
:set nobomb
:wq

# 批量转换（推荐）
find ./src/ -type f -name "*.html" -exec sed -i '1s/^\xEF\xBB\xBF//' {} \;
```

### 在编辑器中设置无 BOM

- **VS Code**：底部状态栏点击 `UTF-8` → `Save with Encoding` → `UTF-8 without BOM`
- **Sublime Text**：`File` → `Save with Encoding` → `UTF-8 without BOM`
- **Notepad++**：`编码` → `以 UTF-8 无 BOM 格式编码`
- **WebStorm**：`File` → `File Properties` → `Remove BOM`

### 代码中处理 BOM（应急方案）

```javascript
// 前端 JS 移除 BOM（应急，不推荐长期使用）
document.body.innerHTML = document.body.innerHTML.replace(/﻿/g, '');
```

但最根本的解决方案是：**不在代码中处理 BOM，而是不让 BOM 进入你的文件。**

## 2026 年的建议

- **编辑器中关闭 BOM**：所有现代编辑器默认都不加 BOM。如果你还在用会加 BOM 的编辑器，换一个
- **版本控制中使用 `.gitattributes`**：在 Git 仓库中配置自动检测 BOM
- **CI/CD 中加入检查**：在构建流程中加入 BOM 检测脚本

```git
# .gitattributes — 让 Git 处理文件编码
*.php   text diff
*.html  text diff
*.css   text diff
*.js    text diff
*.md    text diff

# 设置 Git 自动处理换行符和 BOM
* text=auto
```

## 相关推荐

- [GB2312、GBK 和 UTF-8 的区别——2026 年还在纠结编码？](/archives/0008/)
- [Meta 标签功能大全——编码标签的正确用法](/archives/0006/)
- [常见 Meta 标签参考和用途介绍](/archives/0038/)

**P.S.** 那次排查 BOM 问题花了我一个多小时——现在回想起来，如果当时知道看 `xxd` 输出或者 `git diff` 就知道是 BOM 问题了。**有些问题不是难，是你还不知道看哪个地方。** 下次遇到页面顶部空白，不要调 CSS margin 了，先查文件编码。
