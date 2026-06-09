---
title: Blossom笔记软件Docker Compose部署指南
categories: Docker运维
tags: [技术笔记,记录,经验分享,docker]
date: 2025-01-17 09:00:34
id: 0092
top_img:
swiper_index: 
cover: 
---



### **一、Blossom简介**

Blossom是一款专为注重隐私和数据安全的用户设计的笔记软件。虽然它本身定位为一个云端软件，但你也可以选择在本地进行私有部署。这意味着你的数据和图片都将保存在你自己的设备上，无需依赖任何第三方图床或对象存储。Blossom支持Windows端和ARM架构的Mac端，同时还提供了响应式网页移动端，方便你在各种设备上随时访问和管理你的笔记。

### **二、为什么选择Blossom**

1. **开源与自由**：Blossom作为一款开源软件，提供了不同于市面上其他笔记软件的新选择。你可以自由地使用、修改和分发它，无需受到任何商业限制。

2. **完善的文件关系管理**：Blossom提供了完善的图片管理功能，让你轻松查看图片被哪些文章所使用，并一键替换它们。这解决了许多笔记软件中图片管理混乱、误删难以找回等问题。

3. **简单的迁移**：所有图片和文章都支持一键备份和导出，让你在不想使用或想要迁移笔记时能够轻松转移。Blossom不会绑架你的数据，导出的文件可以无缝使用VS Code、Obsidian等本地软件正常打开。

4. **丰富的附加功能**：除了基本的笔记功能外，Blossom还提供了计划安排、待办事项、快捷便签、番茄钟等实用功能。此外，它还支持多用户、字数统计、字数折线图、编辑热力图、天气预报和主题设置等丰富特性，满足你的多样化需求。

### **三、Docker Compose部署指南**

为了确保Blossom的顺利部署，我们推荐使用Docker Compose。以下是一个详细的部署指南：

1. **准备工作**

   - 确保你已经安装了Docker和Docker Compose。
   - 根据你的操作系统和配置，准备好相应的Docker Compose配置文件（`docker-compose.yml`）。

2. **编写Docker Compose配置文件**

   创建一个名为`docker-compose.yml`的文件，并添加以下内容（根据你的实际需求进行调整）：

   ```yaml
   version: "3.8"

   networks:
     blossomnet:
       driver: bridge

   services:
     blossom:
       image: jasminexzzz/blossom:latest
       container_name: blossom-backend
       volumes:
         - /path/to/your/blossom/data:/home/bl/  # 修改为你的数据保存路径
       environment:
         SPRING_DATASOURCE_URL: jdbc:mysql://blmysql:3306/blossom?useUnicode=true&characterEncoding=utf-8&allowPublicKeyRetrieval=true&allowMultiQueries=true&useSSL=false&serverTimezone=GMT%2B8
         SPRING_DATASOURCE_USERNAME: root
         SPRING_DATASOURCE_PASSWORD: your_mysql_password  # 修改为你的MySQL密码
       ports:
         - "9999:9999"
       networks:
         - blossomnet
       healthcheck:
         test: ["CMD", "curl", "-f", "http://localhost:9999/sys/alive"]
         interval: 30s
         timeout: 10s
         retries: 3
         start_period: 5s
       restart: always
       depends_on:
         blmysql:
           condition: service_healthy

     blmysql:
       image: mysql:8.0.31
       container_name: blossom-mysql
       restart: on-failure:3
       volumes:
         - /path/to/your/mysql/data:/var/lib/mysql  # 修改为你的MySQL数据保存路径
         - /path/to/your/mysql/log:/var/log/mysql  # 修改为你的MySQL日志保存路径
         - /path/to/your/mysql-files/log:/var/lib/mysql-files  # 可选，根据你的需求调整
       environment:
         MYSQL_DATABASE: blossom
         MYSQL_ROOT_PASSWORD: your_mysql_password  # 修改为你的MySQL密码
         LANG: C.UTF-8
         TZ: Asia/Shanghai
       ports:
         - "3306:3306"
       networks:
         - blossomnet
       healthcheck:
         test: ["CMD", "mysqladmin", "-uroot", "-pyour_mysql_password", "ping", "-h", "localhost"]  # 修改为你的MySQL密码
         interval: 10s
         timeout: 3s
         retries: 12
   ```

   注意：在上面的配置文件中，你需要将`/path/to/your/blossom/data`、`/path/to/your/mysql/data`等路径替换为你实际运行Docker的设备上的路径。同时，你也需要根据你的MySQL密码修改相应的环境变量。

3. **启动服务**

   在`docker-compose.yml`文件所在的目录下，运行以下命令启动服务：

   ```bash
   docker-compose up -d
   ```

   这将启动Blossom后端和MySQL数据库服务。你可以通过`docker-compose logs`命令查看日志信息，确认服务是否成功启动。

4. **访问Blossom**

   部署完成后，你可以通过浏览器访问`http://localhost:9999`（如果你在本地部署）来访问Blossom的网页端。登录后，你可以开始使用Blossom来管理你的笔记了。

### **四、总结**

通过Docker Compose部署Blossom笔记软件，你可以轻松地在本地搭建一个私有、安全的笔记平台。Blossom提供了完善的文件关系管理、简单的迁移和丰富的附加功能，满足你的多样化需求。希望这篇指南能够帮助你顺利部署和使用Blossom！