---
title: 安装部署指南：使用Lucky实现IPv6动态解析和HTTPS访问NAS服务
categories: 知识充电
tags: [技术笔记,记录,经验分享,docker]
date: 2024-12-09 09:00:34
id: 0087
top_img:
swiper_index: 
cover: 
---
## 概述
本指南将指导您通过Lucky实现外网访问家中NAS上部署的SunPanel服务，包括IPv6动态解析和HTTPS安全访问。请确保您的NAS支持公网IPv6。

## 前言
Lucky是一个多功能工具，最初为个人使用而开发，现已成为广泛信赖的工具。它的核心程序使用Golang编写，前端采用Vue3.2技术，提供前后端分离架构。

## 功能模块
Lucky集成了以下功能：
- 端口转发
- 动态域名(DDNS)
- Web服务
- Stun内网穿透
- 网络唤醒
- 计划任务
- ACME自动证书
- 网络存储

## 部署Lucky
我们将使用Docker在飞牛上部署Lucky。

### 步骤1：拉取Docker镜像
首先，连接到飞牛的SSH。使用Xshell或其他SSH客户端，输入以下命令进入root模式：
```bash
sudo -i
```
然后，拉取Lucky的Docker镜像：
```bash
docker pull gdy666/lucky
```

### 步骤2：创建配置文件路径
建议将Docker项目的配置文件放在飞牛的应用文件中。在文件管理器中找到`appshare`文件夹，新建一个`lucky`文件夹，并在其中新建`luckyconf`文件夹。

### 步骤3：Docker部署Lucky
使用SSH命令一键部署Lucky，确保使用正确的路径替换为您的`luckyconf`文件夹的实际地址：
```bash
docker run -d --name lucky --restart=always --net=host -v /vol1/@appshare/lucky/luckyconf:/goodluck gdy666/lucky
```
部署成功后，访问`127.0.0.2:16601`（将`127.0.0.2`替换为飞牛的IP地址）进入Lucky的Web UI界面。

偷懒的方案：
1. 使用可视化窗口拉取镜像
![拉取镜像](/img/2024/12/lucky01.png "拉取镜像")
2. 使用compose进行容器的创建
```bash
 services:
  lucky:
    image: gdy666/lucky
    container_name: lucky
    volumes:
      - /vol2/1000/docker/lucky:/goodluck
    network_mode: host
    restart: always
 ```

### 默认账号密码
- 账号：666
- 密码：666

登录后请更改账号密码。

### 步骤4：获取AccessKey
以腾讯云为例，获取域名解析的AccessKey。保存好AccessKey，返回Lucky添加DDNS任务，填入对应信息，选择IPv6类型。
https://console.cloud.tencent.com/cam/capi
![腾讯云密钥](/img/2024/12/lucky02.png "腾讯云密钥")

### 步骤5：添加DDNS任务
添加任务后，检查Lucky的任务列表和域名解析服务处是否自动增加了一条泛域名的AAAA记录。
![添加ddns](/img/2024/12/lucky03.png "添加ddns")
![泛解析记录](/img/2024/12/lucky05.png "泛解析记录")
### 步骤6：获取SSL证书
使用Lucky自带的证书申请模块申请证书。
![获取SSL证书](/img/2024/12/lucky06.png "获取SSL证书")
### 步骤7：配置反向代理
在服务规则中，勾选tcp6，设置监听端口（例如8888），开启TLS。编辑子规则，选择反向代理，输入二级域名。
![配置反向代理](/img/2024/12/lucky04.png "配置反向代理")
![配置子规则](/img/2024/12/lucky041.png "配置子规则")
### 步骤8：实现HTTP自动跳转HTTPS
新增一条web服务规则，监听8888端口，不开启TLS。在默认规则中设置重定向到`https://{host}:8888`。
![泛解析记录](/img/2024/12/lucky07.png "泛解析记录")


## 完成
按照以上步骤操作后，您应该可以通过域名+端口的方式在外网访问家中NAS上的SunPanel服务，并通过HTTPS确保连接安全。

请根据实际情况调整命令和配置，确保每一步操作正确无误。
