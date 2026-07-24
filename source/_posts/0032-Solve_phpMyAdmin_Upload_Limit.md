---
title: 别再为 phpMyAdmin 上传限制发愁了——2026 年，你有更好的选择
categories: Web开发
tags: [phpMyAdmin,MySQL,数据库管理,Adminer,Docker,DBeaver,运维工具]
date: 2020-06-11 14:38:00
updated: 2026-07-24 10:00:00
id: 0032
---

我以前写过怎么修改 phpMyAdmin 的配置文件来突破上传限制——改 `upload_max_filesize`、改 `post_max_size`、改 `max_execution_time`……

后来我发现一个道理：**当一个工具要你改这么多配置才能用的时候，可能不是配置问题，是工具本身的问题。**

**一句话理解：** phpMyAdmin 上传大文件的限制主要来自 PHP 本身的运行机制——而 2026 年，你完全可以用更好的工具来管理数据库。

## 传统方法：修改 phpMyAdmin 配置

但首先，如果你还没法换工具，这里还是教你怎么改。

### 修改 PHP 配置（php.ini）

```ini
; 找到这些参数并调大
upload_max_filesize = 128M    ; 文件上传大小限制
post_max_size = 128M          ; POST 数据大小限制
max_execution_time = 600      ; 执行时间限制（秒）
max_input_time = 600          ; 输入时间限制（秒）
memory_limit = 256M           ; 内存限制
```

修改后重启 PHP-FPM 或 Apache：

```bash
sudo systemctl restart php8.1-fpm
# 或
sudo systemctl restart apache2
```

### 修改 phpMyAdmin 配置

```php
// config.inc.php
$cfg['ExecTimeLimit'] = 0;  // 0 = 无时间限制
$cfg['UploadDir'] = 'upload';  // 使用上传目录方式
```

然后在 phpMyAdmin 根目录创建 `upload/` 文件夹，把 SQL 文件放进去。通过"从服务器上传文件夹导入"可以绕过 Web 上传大小限制。

## 更好的选择（2026 年推荐）

说实话，2026 年还在用 phpMyAdmin 操作数据库的人越来越少了。以下是更好的替代方案：

| 工具 | 类型 | 优点 | 适用场景 |
|------|------|------|---------|
| **Adminer** | 单文件 PHP | 只需 1 个文件，覆盖 phpMyAdmin 所有功能 | **个人站长首选** |
| **DBeaver** | 桌面客户端 | 支持所有数据库，界面现代化 | 开发/运维人员 |
| **TablePlus** | 桌面客户端 | 界面精美，操作流畅 | Mac 用户 |
| **MySQL Workbench** | 桌面客户端 | Oracle 官方工具，功能完整 | 数据库设计 |
| **Docker phpMyAdmin** | Docker 容器 | 一行命令启动，环境隔离 | Docker 用户 |

### Adminer：phpMyAdmin 的最佳替代

Adminer 是一个只有 500KB 左右的单文件 PHP 程序，功能却覆盖了 phpMyAdmin 90% 以上的操作。**基本没有上传限制问题**，因为它直接连接数据库执行操作，不需要通过文件上传。

```bash
# 一行命令部署 Adminer
wget -O adminer.php https://www.adminer.org/latest.php
# 然后访问 https://你的网站/adminer.php
```

### Docker 方式运行数据库管理工具

```yaml
# docker-compose.yml
version: '3'
services:
  adminer:
    image: adminer
    ports:
      - "8080:8080"
    restart: always

  phpmyadmin:
    image: phpmyadmin
    ports:
      - "8081:80"
    environment:
      PMA_HOST: mysql  # 指定你的 MySQL 容器名
      UPLOAD_LIMIT: 500M  # Docker 版本可以直接设置上传限制
```

Docker 版本的 phpMyAdmin 可以通过环境变量 `UPLOAD_LIMIT` 直接设置上传限制，省去了手动改配置的麻烦。

```bash
# 一行命令启动 phpMyAdmin Docker
docker run --name myadmin -d -e PMA_HOST=dbhost -e UPLOAD_LIMIT=500M -p 8080:80 phpmyadmin
```

> **经验之谈：** 我自己已经好几年没用过 phpMyAdmin 了。平时开发用 TablePlus，线上数据库迁移用 MySQL 命令行。需要快速看一眼数据时，用 Adminer 的 Docker 容器一键启动，用完就删。**工具要服务于工作流，不是让工作流去适配工具。**

### 命令行方式（最推荐！）

对于数据库导入操作，最稳妥的方式永远是命令行：

```bash
# 导出数据库
mysqldump -u username -p database_name > backup.sql

# 导入数据库（100MB 的 SQL 几秒就导完）
mysql -u username -p database_name < backup.sql

# 压缩导入
gzip -dc backup.sql.gz | mysql -u username -p database_name
```

命令行不需要经过 Web 服务器，没有超时限制，没有上传大小限制——**而且速度比 phpMyAdmin 快 10 倍以上。**

```bash
# 在 Docker 容器内执行数据库操作
docker exec -i mysql-container mysql -u root -p123456 mydb < large-file.sql
```

## 但我还要说一句

如果你的网站还在用 phpMyAdmin 做日常数据库管理，并且经常遇到上传限制问题——**说明你的操作方式可能需要升级了。**

不是说不让你用 phpMyAdmin，而是：**如果你每月要导入 SQL 超过 3 次，你对数据库的管理方式可能有问题。** 生产环境的数据操作应该通过正式的迁移工具或脚本来完成，而不是靠 phpMyAdmin 上传 SQL 文件。

## 相关推荐

- [虚拟主机到 Docker——网站部署方案怎么选？](/archives/16/)
- [网站基础术语入门——数据库相关概念](/archives/18/)
- [各大邮箱 SMTP 限制对比——2026 年版](/archives/34/)

**P.S.** 这篇文章其实是写给以前的我自己的——当年我为了改 phpMyAdmin 的上传限制，花了好几个小时。后来换了 Adminer 发现什么配置都不用改——**有时候不是问题太难，是工具没选对。**
