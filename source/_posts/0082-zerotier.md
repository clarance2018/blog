---
title: NAS内网穿透工具ZeroTier——Docker Compose配置方案
categories: Docker运维
tags: [技术笔记,记录,docker]
date: 2024-10-08 09:00:34
id: 0082
top_img:
swiper_index: 
cover: 
---

### NAS内网穿透工具ZeroTier——Docker Compose配置方案

在构建家庭或企业网络时，NAS（网络附加存储）设备的使用变得越来越普遍。然而，如何安全、有效地从远程访问这些设备一直是一个挑战。ZeroTier是一款强大的内网穿透工具，可以帮助你将不同网络环境下的设备组成一个虚拟局域网，使局域网内的设备可以互相访问。本文将详细介绍如何使用ZeroTier和Docker Compose在NAS上实现内网穿透。

#### 一、ZeroTier简介

ZeroTier是一款开源的异地组网工具，通过它将不同网络环境的设备组到一个虚拟局域网内，使局域网内的设备可以互相访问。ZeroTier的使用非常简单，只需要在路由器、家里的电脑或NAS上安装ZeroTier进行组网，就可以实现远程私网IP访问家庭局域网。

#### 二、准备工作

1. **申请ZeroTier账号**：
   - 前往[ZeroTier官网](https://www.zerotier.com/)申请账号。
   - 登录后，创建一个新的网络，并记录Network ID备用。

2. **安装Docker和Docker Compose**：
   - 在你的NAS上安装Docker和Docker Compose。可以参考Docker官方文档进行安装，并确保安装成功。

#### 三、配置Docker Compose

Docker Compose是一个用于定义和运行多容器Docker应用程序的工具。通过YAML文件配置应用服务，然后使用单个命令，即可创建并启动所有服务。

1. **创建项目目录**：
   ```bash
   mkdir myproject
   cd myproject
   ```

2. **创建Docker Compose配置文件**：
   在项目目录中创建一个名为`docker-compose.yml`的文件，用于定义服务和容器的配置。

   ```yaml
   version: '3'
   services:
     zerotier:
       image: zerotier/zerotier
       container_name: zerotier
       restart: always
       network_mode: host
       devices:
         - /dev/net/tun:/dev/net/tun
       cap_add:
         - NET_ADMIN
         - SYS_ADMIN
       volumes:
         - /volume1/docker/zerotier:/var/lib/zerotier-one
   ```

   在这个配置文件中，我们定义了一个名为`zerotier`的服务，使用`zerotier/zerotier`镜像，并配置了一些必要的参数，如`network_mode: host`、`devices`和`cap_add`等。这些配置允许容器访问宿主机的网络设备和进行网络管理操作。

3. **启动Docker Compose**：
   在项目目录中运行以下命令，启动Docker Compose：

   ```bash
   docker-compose up -d
   ```

   这条命令会根据`docker-compose.yml`文件中的配置启动和管理容器。

#### 四、配置ZeroTier

1. **进入容器**：
   使用以下命令进入ZeroTier容器：

   ```bash
   docker exec -it zerotier /bin/bash
   ```

2. **加入ZeroTier网络**：
   在容器内，运行以下命令加入之前创建的ZeroTier网络：

   ```bash
   zerotier-cli join <你的Network ID>
   ```

   将`<你的Network ID>`替换为你之前在ZeroTier官网创建的网络的Network ID。

3. **验证连接**：
   在ZeroTier控制台中，检查设备是否已成功加入网络，并记下设备的IP。

4. **配置防火墙和路由**：
   根据需求，你可能需要在路由器或NAS上配置防火墙规则和路由，以允许ZeroTier网络内的设备互相访问。

#### 五、安装ZeroTier客户端

为了从远程访问NAS，你需要在你的计算机或移动设备上安装ZeroTier客户端。

1. **下载并安装客户端**：
   - 前往ZeroTier官网，下载适合你操作系统的客户端。
   - 安装客户端后，运行它，并加入之前创建的ZeroTier网络。

2. **验证连接**：
   在ZeroTier客户端中，你应该能看到你的设备已成功加入网络，并能看到其他设备的IP。

#### 六、访问NAS

现在，你可以通过ZeroTier分配的IP地址来访问NAS设备了。例如，如果你的NAS在内网中的IP是`192.168.1.100`，而在ZeroTier网络中的IP是`10.144.0.10`，那么你可以从远程计算机上通过`10.144.0.10`来访问NAS。

#### 七、注意事项

1. **安全性**：
   - 确保你的ZeroTier网络设置为私有（Private），以防止未经授权的访问。
   - 在路由器或NAS上配置防火墙规则，以限制对ZeroTier网络的访问。

2. **性能**：
   - ZeroTier的性能取决于你的网络环境和设备性能。在配置和使用过程中，注意监控网络性能和资源使用情况。

3. **备份**：
   - 在进行任何网络配置更改之前，确保你已经备份了重要的数据和配置。

4. **更新**：
   - 定期更新ZeroTier客户端和Docker镜像，以确保你使用的是最新版本，并获得最新的安全和功能更新。

#### 八、常见问题解答

1. **如何查看ZeroTier网络的设备列表？**
   - 登录ZeroTier控制台，点击你的网络名称，然后在设备列表中查看。

2. **如何更改ZeroTier网络的名称？**
   - 登录ZeroTier控制台，点击你的网络名称，然后在设置中更改名称。

3. **如何删除ZeroTier网络中的设备？**
   - 登录ZeroTier控制台，点击你的网络名称，在设备列表中找到要删除的设备，然后取消勾选。

4. **如何查看ZeroTier客户端的日志？**
   - 在客户端设置中，通常有一个选项可以查看日志。此外，你也可以在NAS上通过Docker容器的日志来查看ZeroTier的日志。

通过本文的介绍，你应该已经了解了如何使用ZeroTier和Docker Compose在NAS上实现内网穿透。这种方法不仅简单易行，而且具有较高的安全性和灵活性。希望本文能对你有所帮助！