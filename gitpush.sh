#!/bin/bash

# 参数说明：
# $1 - 必填，提交信息
# $2 - 选填，操作类型：
#      cl  : 执行 hexo clean && hexo g
#      g   : 执行 hexo g（默认行为）

# 检查提交信息参数
if [ -z "$1" ]; then
    echo "错误：请提供提交信息作为第一个参数。"
    echo "用法：./gitpush.sh '提交信息' [操作类型]"
    echo "操作类型选项："
    echo "  cl : 执行完整清理并生成（hexo clean && hexo g）"
    echo "  g  : 仅生成静态文件（默认）"
    exit 1
fi

# 设置默认操作类型
ACTION_TYPE=${2:-"g"}

# Docker容器操作（根据参数执行不同生成方式）
case $ACTION_TYPE in
    cl)
        echo "执行完整清理并生成静态文件..."
        if ! sudo docker exec -it hexo-blog bash -c "hexo clean && hexo g"; then
            echo "错误：Hexo清理生成失败！"
            exit 1
        fi
        NEED_REINIT_GIT=true  # 标记需要重新初始化Git
        ;;
    g)
        echo "仅生成静态文件..."
        if ! sudo docker exec -it hexo-blog bash -c "hexo g"; then
            echo "错误：Hexo生成失败！"
            exit 1
        fi
        ;;
    *)
        echo "错误：未知操作类型 '$ACTION_TYPE'"
        echo "可用操作类型：cl | g"
        exit 1
        ;;
esac

# 切换到public目录
TARGET_DIR="/vol3/1000/docker/hexo-blog/public"
echo "正在切换到目标目录：$TARGET_DIR"
cd "$TARGET_DIR" || {
    echo "错误：无法进入目标目录 $TARGET_DIR"
    exit 1
}

# 在 gitpush.sh 中找到这一行并修改
SSH_KEY="/home/admin/.ssh/id_ed25519"  # 使用新密钥路径

# 同时确保设置了正确的权限
chmod 600 "$SSH_KEY"

# 处理Git仓库初始化（当执行clean操作时）
if [ "$NEED_REINIT_GIT" = true ]; then
    echo "检测到需要重新初始化Git仓库..."
    
    # 删除残留的.git目录（如果存在）
    if [ -d ".git" ]; then
        echo "移除现有.git目录..."
        rm -rf .git || {
            echo "错误：无法移除.git目录"
            exit 1
        }
    fi

    # 初始化新仓库
    git init || {
        echo "错误：Git初始化失败"
        exit 1
    }
    
    # 设置远程仓库（请替换为你的实际地址）
    git remote add origin git@github.com:clarance2018/blog.git || {
        echo "错误：添加远程仓库失败"
        exit 1
    }
    
    # 创建自定义.gitignore（可选）
    echo "创建.gitignore文件..."
    cat > .gitignore << EOF
# 忽略临时文件
*.tmp
*.log
# 保留public目录内容
!/**/*
EOF
fi

# 强制添加所有文件（解决.gitignore冲突）
echo -e "\n将更改添加到Git仓库..."
if ! git add -f .; then
    echo "错误：git add 操作失败！"
    exit 1
fi

# 提交更改
echo -e "\n提交更改（提交信息：'$1'）..."
if ! git commit -m "$1"; then
    echo "错误：git commit 操作失败！"
    exit 1
fi

# 推送分支（首次需要强制推送）
echo -e "\n推送到远程main分支..."
if [ "$NEED_REINIT_GIT" = true ]; then
    git push -u origin main --force || {
        echo "错误：git push 失败！"
        exit 1
    }
else
    git push origin main || {
        echo "错误：git push 失败！"
        exit 1
    }
fi

# 保持原有的rsync同步步骤
REMOTE_USER="root"
REMOTE_IP="10.147.19.85"
REMOTE_PATH="/opt/1panel/apps/openresty/openresty/www/sites/blog/index"
SSH_KEY="/root/.ssh/124.220.71.26_20250416093341_id_rsa"
TARGET_DIRs="/vol3/1000/docker/hexo-blog/public"
echo -e "\n正在同步静态文件到远程服务器..."
sudo rsync -ahvz --delete --progress \
    --partial \
    --filter='P .git/' \
    --exclude='.git/***' \
    -e "ssh -i \"$SSH_KEY\" -o StrictHostKeyChecking=no" \
    "$TARGET_DIRs/" \
    "$REMOTE_USER@$REMOTE_IP:$REMOTE_PATH" || {
    echo "错误：文件同步失败！"
    exit 1
}

echo -e "\n所有操作已完成！博客已成功更新并发布。"