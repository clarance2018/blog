---
title: 使用Frp实现内网穿透详细步骤
categories: 知识充电
tags: [技术笔记,记录,经验分享,docker]
date: 2024-12-24 09:00:34
id: 0088
top_img:
swiper_index: 
cover: 
---

在实现内网穿透时，若IPv6访问受限（例如公司网络未启用IPv6），Lucky等工具将无法正常工作。这时，我们可以使用Frp这样的内网穿透软件。Frp部署包括服务端（frps）和客户端（frpc），需要在拥有固定公网IP的云服务器上部署frps，在内网设备（如飞牛）上部署frpc。以下是详细步骤：

#### 一、Frps部署（云服务器）

1. **创建目录与文件**
   - 在云服务根目录下创建一个名为`docker`的文件夹，并在其中创建一个名为`frps`的子文件夹。
   - 在`frps`文件夹中，新建两个文件：`docker-compose.yml`和`frps.toml`。

   ```bash
   mkdir -p /docker/frps
   touch /docker/frps/docker-compose.yml
   touch /docker/frps/frps.toml
   ```

2. **配置docker-compose.yml**

   ```yaml
   version: '3.3'
   services:
       frps:
           restart: always
           network_mode: host
           volumes:
               - '/docker/frps/frps.toml:/etc/frp/frps.toml'
           container_name: frps
           image: snowdreamtech/frps:0.60
   ```

3. **配置frps.toml**

   ```toml
   bindAddr = "0.0.0.0"
   bindPort = 7000

   auth.method = "token"
   auth.token = "password"  # 自定义token

   webServer.addr = "0.0.0.0"
   webServer.port = 7100
   webServer.user = "username"  # 自定义用户名
   webServer.password = "password"  # 自定义密码
   ```

4. **启动frps**

   ```bash
   cd /docker/frps
   docker-compose up -d
   ```

   访问`云服务器ip:7100`，使用配置的用户名和密码登录Frp的Web UI。

#### 二、Frpc部署（内网设备，如飞牛）

1. **创建目录与文件**
   - 在文件管理器中找到docker存储路径下的`appshare`文件夹，新建一个名为`frpc`的文件夹。
   - 在`frpc`文件夹中，新建两个文件：`docker-compose.yml`和`frpc.toml`。

2. **配置docker-compose.yml**

   ```yaml
   version: '3.3'
   services:
       frpc:
           restart: always
           network_mode: host
           volumes:
               - '/vol1/@appshare/frpc/frpc.toml:/etc/frp/frpc.toml'
           container_name: frpc
           image: snowdreamtech/frpc:0.60
   ```

3. **配置frpc.toml**

   ```toml
   serverAddr = "云服务器ip"
   serverPort = 7000

   log.to = "console"
   log.level = "trace"
   log.maxDays = 3
   log.disablePrintColor = true

   auth.method = "token"
   auth.token = "password"  # 与frps配置中的token保持一致

   [[proxies]]
   name = "sunpanel"
   type = "tcp"
   localIP = "127.0.0.1"
   localPort = 3002
   remotePort = 3003

   [[proxies]]
   name = "项目X"
   type = "tcp"
   localIP = "127.0.0.1"
   localPort = xxx  # 替换为实际端口
   remotePort = xxx  # 替换为实际端口
   ```

4. **启动frpc**

   ```bash
   cd /vol1/@appshare/frpc
   docker-compose up -d
   ```

#### 三、访问内网服务

部署成功后，访问`服务器ip:3003`即可访问飞牛中部署的`sunpanel`服务。若配置了其他服务，请确保访问对应的`remotePort`。

---

按照以上步骤，您应该能够成功使用Frp实现内网穿透，从而在外网访问内网服务。