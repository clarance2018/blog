---
title: Hexo博客维护操作全记录
categories: Web开发
tags:
  - 技术笔记
  - 记录
  - 经验分享
  - git
id: 100
top_img: 
swiper_index: 
cover: 
date: 2025-06-02 16:44:00
updated: 2025-06-03 14:52:00
progress: 待整理
---

## 部署架构演进
### 第一阶段：纯服务器部署
我的hexo一开始是直接搭建的服务器的docker上面，通过git来进行更新，主要是将source目录push到git,然后在服务器clone下来，执行hexo g生成静态文件，一通操作下来特别繁琐。
考虑过直接在git上展示，不需要通过服务器，但是觉得gitweb的访问速度实在是感人，还是放弃了。

- 原始方案：在云服务器Docker容器运行Hexo
- 痛点：`source目录`→推送Git→服务器拉取→生成静态文件的冗长流程

### 第二阶段：NAS混合方案
后来在网上偶然看到nas相关的内容，便想办法自己搞了一个，收了一个不知道几手的“蜗牛星际”，搭建了一个自己的fnos nas,可以愉快的玩耍docker以及搭建自己的影视资源库，也是够用了。

有了nas,我便将我的hexo放在了nas上，服务器和git上改成存放生成的静态文件。下面的主要还是记录按照这个方式部署之后的一些代码片段。

- 硬件升级：蜗牛星际矿机改造NAS
- 系统架构：
  - NAS：运行Hexo生成服务
  - 云服务器：托管静态文件
  - GitHub：作为版本控制仓库

## 基础配置核查
### 环境验证命令
```bash
# 校验Git全局配置
git config --global --list

# SSH密钥连通性测试
ssh -T git@github.com
```

### 核心路径信息
```markdown
GitHub静态仓库：git@github.com:clarance2018/blog.git
NAS工作目录：/vol2/1000/docker/hexo-blog
服务器部署点：/www/wwwroot/blog
```

## 标准操作流程
### 常规内容更新
```bash
# 进入Docker容器生成文件
sudo docker exec -it hexo-blog bash
hexo g
exit

# 提交静态文件更新
cd /vol2/1000/docker/hexo-blog/public
git add .
git commit -m "常规更新"
git push origin main
```

### 服务器同步方案
```bash
cd /www/wwwroot/blog
git fetch origin
git reset --hard origin/main  # 或使用 git pull origin main
```

## 特殊操作场景：强制更新流程

在一些时候我们修改了hexo的系统设置，或者更新了css等等这里会出现一个问题，使用hexo g生成静态文件后修改并不会生效，那么我们就需要使用‘hexo clean’清除缓存。那么这个操作又会产生一个新的问题，就是会将public内的.git目录删除，导致重新生成的public没有.git目录，所以需要重新进行一个环境的初始化，然后在进行提交。
### 容器内缓存清理
```bash
# 容器内缓存清理（自定义命令）
sudo docker exec -it hexo-blog bash
hexo cl  # 等效于hexo clean的自定义别名
hexo g
exit
```
### 环境初始化配置
```bash
# 全局Git设置（首次部署执行）
git config --global init.defaultBranch main
git config --global user.name "clarance2018"
git config --global user.email "hcshi@outlook.com"
git remote add origin git@github.com:clarance2018/blog.git
```

###  强制推送更新
```bash
# 强制推送更新
cd /vol2/1000/docker/hexo-blog/public
git add .
git commit -m "紧急修复"
git push --force origin main
```


## 操作风险管控
### 高危命令清单
| 命令                  | 风险说明                     | 安全替代方案              |
|----------------------|----------------------------|-------------------------|
| `git push --force`   | 覆盖远程提交历史            | `git push --force-with-lease` |
| `git reset --hard`   | 丢失未提交修改              | 先执行`git stash`        |
| `hexo cl`            | 自定义命令需确认实际效果     | 使用标准`hexo clean`     |

### 数据保护建议
1. 建立自动备份机制
```bash
# 每周日凌晨创建备份标签
0 3 * * 0 git tag archive-$(date +\%Y\%m\%d)
```
2. 关键操作前创建检查点
```bash
git checkout -b temp-branch  # 创建临时分支操作
```

## 常见问题备忘录
### 异常情况处理
```bash
# 遭遇文件锁定时
rm -f .git/index.lock

# 容器启动失败时
docker logs hexo-blog --tail 50
```

### 配置验证清单
```markdown
1. [ ] 确认NAS与服务器时间同步
2. [ ] 验证Git远程仓库读写权限
3. [ ] 检查Docker容器存储卷挂载状态
```

> 这个方案算是告一段落了，虽然不是很满意但是暂时也没有想到更好的解决方案。当然满意是不可能满意的，如果后续看到更好的方案肯定还是会进一步进行优化的。玩这个不就是为了折腾吗？为了每天都有点新的变化不是。