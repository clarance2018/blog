---
name: deploy-blog
description: 部署/发布博客。当用户要求"部署博客"、"发布文章"、"上线"、"push 代码到 GitHub"，或确认完内容修改后要求执行部署流程时使用。执行：Docker 容器内 hexo 清理重建 → 重启 hexo-blog 容器 → 提交并推送到 GitHub。
---

# 博客部署

一键部署脚本：`deploy.sh`（仓库根目录）。

## 什么时候用

- 用户明确要求部署、发布、上线博客
- 内容修改完成并经用户确认后，用户要求 push / 部署
- 用户单独说"push 代码到 GitHub"时也可使用（脚本末两步等价于提交推送）

**注意**：内容刚改完但用户未确认发布时，不要主动调用；等用户明确指示。

## 如何执行

```bash
./deploy.sh "提交信息"
```

- 提交信息遵循仓库惯例：`feat:`（新文章）、`fix:`（修复）、`chore:`（其他），后接中文描述
- 由 Claude 发起的提交，信息末尾追加署名行（换行传入即可）：
  `Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>`
- 示例：
  ```bash
  ./deploy.sh "feat: 新增文章0212（QQ接入DSH教程）

  Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>"
  ```

## 脚本流程（固定顺序）

1. 前置检查 `hexo-blog` 容器存在且在运行
2. `docker exec -w /app hexo-blog hexo clean`
3. `docker exec -w /app hexo-blog hexo generate`
4. `docker restart hexo-blog`
5. `git add -A` → 有改动则 commit → `git pull --rebase` → `git push origin main`

## 约束与注意事项

- hexo 构建**必须走容器**，不要在本机直接跑 `node_modules/.bin/hexo`，保证与部署环境一致
- 脚本会 `git add -A`，包括 `public/` 静态产物——这是仓库既有模式，不要排除
- 脚本终点是 GitHub（`clarance2018/blog` main 分支）；rsync 同步远程线上服务器不在本流程内，由用户另行处理
- 若容器不存在或未运行，脚本会报错退出——先检查 `docker ps -a | grep hexo`，与用户确认后再 `docker start hexo-blog`
- push 失败（如远程分叉、SSH 认证问题）时，把错误原样报告给用户，不要反复重试
