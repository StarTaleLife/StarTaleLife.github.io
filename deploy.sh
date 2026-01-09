#!/bin/bash

# 部署脚本 - 将 GitBook 构建并推送到 GitHub Pages

# 1. 配置信息
# GitHub 用户名或组织名
GITHUB_USER="StarTaleLife"
# 仓库名称 (必须是 <username>.github.io 才能通过根域名访问)
REPO_NAME="StarTaleLife.github.io"
# 目标分支 (User Pages 必须使用 main 或 master)
TARGET_BRANCH="main"
# 远程仓库地址
REMOTE_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

# 2. 检查 Docker 环境
if ! command -v docker-compose &> /dev/null; then
    echo "错误: 未找到 docker-compose。请确保已安装 Docker。"
    exit 1
fi

echo "=== 开始构建 GitBook ==="

# 3. 使用 Docker 构建项目
# 我们使用 docker-compose run 来执行一次性构建命令
# 注意：这里我们覆盖了默认命令，执行 gitbook install 和 gitbook build
docker-compose run --rm --entrypoint "sh -c 'cd /book && gitbook install && gitbook build'" gitbook_serve

if [ ! -d "_book" ]; then
    echo "错误: 构建失败，未找到 _book 目录"
    exit 1
fi

# 复制 .nojekyll 防止 GitHub Pages 忽略下划线文件
if [ -f ".nojekyll" ]; then
    cp .nojekyll _book/
else
    touch _book/.nojekyll
fi

echo "=== 构建完成，准备部署 ==="

# 4. 部署到 GitHub
# 进入构建输出目录
cd _book

# 初始化临时的 git 仓库
git init
git checkout -b $TARGET_BRANCH

# 添加所有文件
git add -A

# 提交
git commit -m "Deploy site: $(date '+%Y-%m-%d %H:%M:%S')"

# 添加远程仓库
git remote add origin $REMOTE_URL

echo "=== 正在推送到 GitHub ($REMOTE_URL) ==="
echo "注意：如果是第一次推送，可能需要验证 GitHub 账号密码"

# 强制推送到远程分支
# -f (force) 是必须的，因为我们要覆盖远程的历史记录，只保留最新的构建状态
git push -f origin $TARGET_BRANCH

echo "=== 部署成功! ==="
echo "请访问: https://$GITHUB_USER.github.io"
