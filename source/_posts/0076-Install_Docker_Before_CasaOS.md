---
title: 安装 CasaOS 之前需要先安装 Docker
categories: 知识充电
tags: [技术笔记,记录]
date: 2024-06-19 22:00:34
id: 0076
top_img:
cover: 
---

安装 CasaOS 之前需要先安装 Docker


出现这个错误提示意味着在安装 CasaOS 之前需要先安装 Docker，因为 CasaOS 可能依赖于 Docker 来运行容器。错误提示建议你运行 Docker 的安装脚本，但你可能已经遇到了之前因为 `curl` 未安装而导致的问题。

以下是你应该遵循的步骤来安装 Docker 并再次尝试安装 CasaOS：

1. 首先，确保你已经安装了 `curl`。如果还没有安装，使用以下命令安装它：

```bash
sudo apt update
sudo apt install curl
```

2. 安装 Docker。使用 Docker 官方提供的安装脚本：

```bash
curl -fsSL https://get.docker.com | sudo bash
```

这个脚本会自动检测你的 Linux 发行版并为你安装 Docker。安装过程中可能需要你输入用户密码以进行确认。

3. 安装 Docker 后，确保 Docker 服务正在运行：

```bash
sudo systemctl start docker
```

并且设置 Docker 服务在开机时自启：

```bash
sudo systemctl enable docker
```

4. 现在你可以重新运行 CasaOS 的安装脚本了：

```bash
curl -fsSL https://get.casaos.io | sudo bash
```

请注意，根据 CasaOS 的安装脚本和你的系统配置，可能还需要执行一些额外的步骤或满足一些依赖要求。务必遵循 CasaOS 官方文档中的安装说明。

如果在安装 Docker 或 CasaOS 的过程中遇到任何错误，请查看错误信息以获取更详细的指示，并根据需要搜索或询问相关社区以获取帮助。