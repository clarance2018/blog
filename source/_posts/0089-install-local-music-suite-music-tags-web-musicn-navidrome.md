---
title: 安装本地音乐套件：music-tags-web + musicn + navidrome
categories: Docker运维
tags: [技术笔记,记录,经验分享,docker]
date: 2024-12-24 09:00:34
id: 0089
top_img:
swiper_index: 
cover: 
---

如果你希望在你的本地环境中搭建一个功能强大的音乐管理系统，那么将 `music-tags-web`、`musicn` 和 `navidrome` 这三个服务结合起来是一个很好的选择。本文将指导你如何使用 Docker Compose 来安装和配置这些服务。

#### 前提条件

1. 你需要在你的系统上安装 Docker 和 Docker Compose。
2. 确保你有足够的磁盘空间来存储音乐文件。

#### 步骤一：创建 Docker Compose 文件

首先，你需要创建一个名为 `docker-compose.yml` 的文件，并将以下内容复制粘贴到该文件中。

```yaml
# 使用Docker Compose文件的最新版本3.8
version: '3.8'

# 定义服务列表
services:
  # music-tag服务配置
  music-tag:
    # 指定使用的镜像
    image: xhongc/music_tag_web:latest
    # 设置容器的名称
    container_name: music-tag-web
    # 端口映射，将宿主机的8681端口映射到容器的8002端口
    ports:
      - "8681:8002"
    # 卷挂载，用于数据持久化或共享数据
    volumes:
      # 将宿主机的/vol1/1000/影视资源/Music目录挂载到容器的/app/media目录，并设置为读写模式
      - type: bind
        source: /vol1/1000/影视资源/Music
        target: /app/media
      # 将宿主机的/vol2/1000/docker/Music/music_tag_web/config目录挂载到容器的/app/data目录
      - type: bind
        source: /vol2/1000/docker/Music/music_tag_web/config
        target: /app/data
    # 在容器非正常退出时最多重启3次
    restart: on-failure:3

  # musicn服务配置
  musicn:
    image: ghcr.io/wy580477/musicn-container:latest
    container_name: musicn
    restart: on-failure:3
    # 覆盖容器的默认入口点
    entrypoint: ["/sbin/tini", "--", "msc", "-q"]
    ports:
      - "7478:7478"
    volumes:
      - type: bind
        source: /vol2/1000/docker/Music/Musicn/data
        target: /data

  # navidrome服务配置
  navidrome:
    image: deluan/navidrome:latest
    container_name: navidrome
    ports:
      - "8680:4533"
    # 环境变量配置，用于设置Navidrome的行为
    environment:
      ND_SCANSCHEDULE: "12h"
      ND_LASTFM_ENABLED: "false"
      ND_LASTFM_APIKEY: "你的Last.fm API密钥"
      ND_LASTFM_SECRET: "你的Last.fm API密钥秘密"
      ND_SPOTIFY_ID: "你的Spotify客户端ID"
      ND_SPOTIFY_SECRET: "你的Spotify客户端密钥"
      ND_LASTFM_LANGUAGE: "zh"
      ND_DEFAULTLANGUAGE: "zh"
      ND_LOGLEVEL: "info"
      ND_SESSIONTIMEOUT: "24h"
      ND_ENABLEDOWNLOADS: "false"
      ND_ENABLEFAVOURITES: "true"
      ND_ENABLESHARING: "false"
      ND_ENABLESTARRATING: "true"
      ND_BASEURL: ""
      ND_ENABLETRANSCODINGCONFIG: "true"
      ND_TRANSCODINGCACHESIZE: "4000M"
      ND_IMAGECACHESIZE: "1000M"
    volumes:
      # 将宿主机的/vol2/1000/docker/Music/navidrome/data目录挂载到容器的/data目录
      - type: bind
        source: /vol2/1000/docker/Music/navidrome/data
        target: /data
      # 将宿主机的/vol1/1000/影视资源/Music目录挂载到容器的/music目录，并设置为只读模式
      - type: bind
        source: /vol1/1000/影视资源/Music
        target: /music
        read_only: true
    restart: on-failure:3
    # 将服务连接到名为appnet的网络
    networks:
      - appnet

# 定义网络列表
networks:
  # 定义一个名为appnet的网络，使用bridge驱动模式
  appnet:
    driver: bridge
```

#### 步骤二：准备数据目录

根据你的 `docker-compose.yml` 文件中的配置，你需要准备以下目录：

1. `/vol1/1000/影视资源/Music`：用于存放你的音乐文件。
2. `/vol2/1000/docker/Music/music_tag_web/config`：用于存放 `music-tag-web` 的配置文件。
3. `/vol2/1000/docker/Music/Musicn/data`：用于存放 `musicn` 的数据。
4. `/vol2/1000/docker/Music/navidrome/data`：用于存放 `navidrome` 的数据。

确保这些目录已经创建，并且你有适当的读写权限。

#### 步骤三：启动服务

在终端中导航到包含 `docker-compose.yml` 文件的目录，并运行以下命令来启动服务：

```bash
docker-compose up -d
```

这将下载所需的 Docker 镜像，并启动 `music-tag-web`、`musicn` 和 `navidrome` 容器。

#### 步骤四：访问服务

- `music-tag-web`：在浏览器中访问 `http://localhost:8681`。
- `musicn`：在浏览器中访问 `http://localhost:7478`。
- `navidrome`：在浏览器中访问 `http://localhost:8680`。

根据你的配置，你可能需要输入一些额外的信息（如 Last.fm API 密钥和 Spotify 客户端 ID/密钥）来完成服务的设置。

#### 结论

现在你已经成功地在本地环境中安装了 `music-tags-web`、`musicn` 和 `navidrome`。你可以根据需要进一步配置这些服务，并开始享受你的音乐之旅！