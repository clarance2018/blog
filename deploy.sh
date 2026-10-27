#!/usr/bin/env bash
# 博客一键部署：Docker 容器内 hexo 清理重建 → 重启容器 → 提交推送到 GitHub
# 用法: ./deploy.sh ["提交信息"]
set -euo pipefail

CONTAINER=hexo-blog
BRANCH=main
MSG="${1:-chore: 更新博客内容}"

cd "$(dirname "$0")"

# ---- 前置检查 ----
docker inspect "$CONTAINER" >/dev/null 2>&1 \
    || { echo "✗ 容器 $CONTAINER 不存在，请先: docker compose up -d"; exit 1; }
[ "$(docker inspect -f '{{.State.Running}}' "$CONTAINER")" = "true" ] \
    || { echo "✗ 容器 $CONTAINER 未运行，请先: docker start $CONTAINER"; exit 1; }

# ---- [1/4] 清理 ----
echo "==> [1/4] hexo clean（容器内）"
docker exec -w /app "$CONTAINER" hexo clean

# ---- [2/4] 重新生成 ----
echo "==> [2/4] hexo generate（容器内）"
docker exec -w /app "$CONTAINER" hexo generate

# ---- [3/4] 重启容器 ----
echo "==> [3/4] 重启容器 $CONTAINER"
docker restart "$CONTAINER" >/dev/null && echo "    容器已重启"

# ---- [4/4] 提交并推送 ----
echo "==> [4/4] 提交并推送到 GitHub"
git add -A
if git diff --cached --quiet; then
    echo "    无内容改动，跳过提交"
else
    git commit -m "$MSG"
fi
git pull --rebase origin "$BRANCH"
git push origin "$BRANCH"

echo "✓ 部署完成"
