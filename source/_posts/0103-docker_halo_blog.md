---
title: 用 Docker Compose 一键跑起 Halo 2.21：从 0 到可访问的完整记
categories: Docker运维
tags:
  - 技术笔记
  - 记录
  - 经验分享
id: 103
top_img:
swiper_index:
cover:
created: 2025-10-11 8:42
updated: 2025-10-11T09:35

---

## 0. 为什么要写这篇
Halo 2.x 官方文档已经给出了 Docker/Compose 示例，但在 Windows 本机开发时，**路径写法、权限、MySQL 8 认证插件** 这几个坑依旧会把不少人劝退。  
我把踩过的坑和最终能跑通的 `compose.yml` 整理出来，**直接复制即可用**，省掉你自己试错的时间。

---

## 1. 最终目录结构
```
D:\docker\halo
├─ halo2           # Halo 数据卷（文章、主题、附件）
├─ mysql           # MySQL 数据卷
├─ mysqlBackup     # 定时备份目录（可外挂 cron）
└─ compose.yml     # 本文主角
```

---

## 2. compose.yml（Windows 直拷版）
```yaml
version: "3"
services:
  halo:
    image: registry.fit2cloud.com/halo/halo:2.21
    restart: on-failure:3
    depends_on:
      halodb:
        condition: service_healthy
    networks: [halo_network]
    volumes:
      # Windows 绝对路径写法，左宿右容
      - D:\docker\halo\halo2:/root/.halo2
    ports:
      - 8090:8090
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8090/actuator/health/readiness"]
      interval: 30s
      timeout: 5s
      retries: 5
      start_period: 30s
    environment:
      - JVM_OPTS=-Xmx256m -Xms256m
    command:
      # ↓ 以下 4 行与 halodb 的环境变量保持一致
      - --spring.r2dbc.url=r2dbc:pool:mysql://halodb:3306/halo
      - --spring.r2dbc.username=root
      - --spring.r2dbc.password=root@11223366
      - --spring.sql.init.platform=mysql
      - --halo.external-url=http://localhost:8090/

  halodb:
    image: mysql:8.1.0
    restart: on-failure:3
    networks: [halo_network]
    command: >
      --default-authentication-plugin=caching_sha2_password
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_general_ci
      --explicit_defaults_for_timestamp=true
    volumes:
      - D:\docker\halo\mysql:/var/lib/mysql
      - D:\docker\halo\mysqlBackup:/data/mysqlBackup
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "--silent"]
      interval: 3s
      retries: 5
      start_period: 30s
    environment:
      MYSQL_ROOT_PASSWORD: root@11223366
      MYSQL_DATABASE: halo

networks:
  halo_network:
```

---

## 3. 三步启动
1. **把上面的文件保存为** `D:\docker\halo\compose.yml`  
2. **在该目录打开 PowerShell**  
   ```powershell
   docker compose up -d
   ```
3. **浏览器访问**  
   ```
   http://localhost:8090
   ```
   第一次会进入初始化向导，跟着填即可。

---

## 4. 常见坑 & 解决方案

| 现象 | 原因 | 解决 |
|---|---|---|
| `halo` 容器一直 `unhealthy` | MySQL 还没 ready | 等 30s 左右，或 `docker logs halo` 看报错 |
| 中文附件乱码 | 没加 `utf8mb4` | 已在 `halodb.command` 里配置 |
| 无法登录 MySQL (caching_sha2) | 老客户端不支持 | Halo 2.21 已内置驱动，无需改回 `mysql_native_password` |
| Windows 路径报错 “invalid mount config” | 用了反斜杠 `\` | 用正斜杠 `/` 或双反斜杠 `\\` |
| 端口冲突 | 本机 8090 被占用 | 改 `ports` 为 `18090:8090` 即可 |

---

## 5. 备份与升级
- **备份**：  
  ```powershell
  docker exec halodb mysqldump -uroot -proot@11223366 halo > D:\docker\halo\mysqlBackup\halo_$(Get-Date -Format yyyyMMdd).sql
  ```
- **升级 Halo**：  
  改 `image: halo:2.xx`，然后  
  ```powershell
  docker compose pull && docker compose up -d
  ```

---

## 6. 一键脚本（可选）
把下面内容存成 `up.ps1`，双击即可：
```powershell
cd $PSScriptRoot
docker compose up -d
Start-Sleep 5
Start-Process "http://localhost:8090"
```

---

## 7. 写在最后
这套配置在我 Win11 + Docker Desktop 4.30 上稳定跑了 3 个月，**开发、演示、博客** 三不误。  
如果你用的是 Linux，把路径改成 `/opt/halo/xxx` 即可，其余不变。  

  
  
