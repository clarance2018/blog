---
title: 在Ubuntu上配置SSH
categories: Docker运维
tags: [技术笔记,记录]
date: 2024-06-17 22:00:34
id: 0074
top_img:
cover: 
---

在Ubuntu上配置SSH服务通常涉及以下步骤：

### 步骤 1: 安装SSH服务

首先，确保您的Ubuntu系统是最新的，并安装OpenSSH服务器。

```bash
sudo apt update
sudo apt install openssh-server
```

### 步骤 2: 启动SSH服务

安装完成后，启动SSH服务。

```bash
sudo systemctl start ssh
```

### 步骤 3: 设置SSH服务开机自启

为了确保每次系统启动时SSH服务都能自动运行，设置其开机自启。

```bash
sudo systemctl enable ssh
```

### 步骤 4: 配置防火墙以允许SSH连接

默认情况下，SSH服务监听端口22。配置防火墙以允许通过此端口的连接。

```bash
sudo ufw allow ssh
```

### 步骤 5: （可选）修改SSH配置（sshd_config）

如果您需要个性化SSH服务（如修改默认端口或禁用root登录），可以编辑`/etc/ssh/sshd_config`文件。

- **修改默认端口**（确保新端口未被占用）：

  在`sshd_config`文件中找到`#Port 22`（如果已存在则取消注释并修改），或者添加一行`Port 2222`（或其他您选择的端口号）。

- **禁用root登录**：

  在`sshd_config`文件中找到`#PermitRootLogin yes`，修改为`PermitRootLogin no`。

### 步骤 6: 重启SSH服务以应用更改

完成配置修改后，重启SSH服务以应用这些更改。

```bash
sudo systemctl restart ssh
```

### 步骤 7: 测试SSH连接

完成以上步骤后，您应该能够从客户端使用SSH连接到Ubuntu服务器。

- **使用默认端口连接**：

  ```bash
  ssh username@your_server_ip
  ```

- **如果更改了默认端口**：

  确保在连接时指定新的端口号。

  ```bash
  ssh -p 2222 username@your_server_ip
  ```

通过以上步骤，您应该能够成功在Ubuntu上配置并测试SSH服务。