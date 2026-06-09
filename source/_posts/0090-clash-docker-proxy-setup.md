---
title: Clash for Linux 配置指南：轻松解决 Docker 镜像拉取难题
categories: Docker运维
tags: [技术笔记,记录,经验分享]
date: 2025-01-06 09:00:34
id: 0090
top_img:
swiper_index: 
cover: 
---

#### 前言

面对网络限制及国内 Docker 镜像源服务的减少，拉取 Docker 镜像成为一项挑战。除了借助国外云服务器，挂载代理是另一可行方案。本指南将指导你如何在 Linux 环境下，通过 Clash for Linux 配置代理，以顺畅拉取 Docker 镜像。所有操作需通过 SSH 以 root 用户身份执行。

#### Clash for Linux 安装与配置

1. **克隆项目**

   在指定目录 `/vol2/1000/docker/` 下，创建 Clash 项目目录并克隆代码：

   ```bash
   mkdir -p /vol2/1000/docker/clash
   cd /vol2/1000/docker/clash
   git clone https://github.com/Elegycloud/clash-for-linux-backup.git clash-for-linux
   cd clash-for-linux
   ```

2. **编辑 `.env` 文件**

   使用文本编辑器（如 `vim`）打开 `.env` 文件，修改 `CLASH_URL` 为你的订阅链接。同时，注意 `CLASH_SECRET` 为自定义 Clash Secret，若留空，脚本将自动生成随机字符串：

   ```bash
   vim .env
   ```

3. **启动 Clash**

   运行启动脚本 `start.sh`：

   ```bash
   sudo bash start.sh
   ```

   启动成功后，你将看到订阅地址可访问、配置文件下载成功及服务启动成功的提示。同时，会获得 Clash Dashboard 的访问地址及 Secret。

4. **加载环境变量与开启代理**

   执行以下命令加载环境变量并开启系统代理：

   ```bash
   source /etc/profile.d/clash.sh
   proxy_on
   ```

5. **检查服务状态**

   通过 `netstat` 检查服务端口，通过 `env` 检查环境变量，确保服务正常运行：

   ```bash
   netstat -tln | grep -E '9090|789.'
   env | grep -E 'http_proxy|https_proxy'
   ```

#### Clash for Linux 的高级操作

1. **修改配置与重启服务**

   若需修改 Clash 配置，请编辑 `conf/config.yaml` 文件，然后运行 `restart.sh` 脚本重启服务。注意，重启脚本不会更新订阅信息：

   ```bash
   cd /vol2/1000/docker/clash/clash-for-linux
   sudo bash restart.sh
   ```

2. **关闭服务**

   进入项目目录，运行 `shutdown.sh` 脚本关闭服务，并关闭系统代理：

   ```bash
   cd /vol2/1000/docker/clash/clash-for-linux
   sudo bash shutdown.sh
   proxy_off
   ```

3. **访问 Clash Dashboard**

   通过浏览器访问 Clash Dashboard，进行更详细的配置。在 API Base URL 中输入服务地址，在 Secret 中输入启动时获取的 Secret：

   ```
   http://<你的IP>:9090/ui
   ```

4. **终端界面选择代理节点**

   对于无法通过浏览器操作的用户，提供了 `scripts/clash_proxy-selector.sh` 脚本，可在 Linux 终端进行配置。使用前需修改脚本中的 Secret 变量值。

#### 常见问题与解决方案

- 若运行脚本出现报错，可能是系统默认的 shell 被更改为 dash。建议使用 `bash xxx.sh` 运行脚本。
- 若在 UI 界面找不到代理节点，可能是因为配置文件格式不符合 Clash 标准。项目已集成自动识别和转换功能，若仍无法使用，建议通过自建或第三方平台（注意泄露风险）转换订阅地址。