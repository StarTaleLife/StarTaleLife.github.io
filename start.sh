#!/bin/bash

# 本地预览启动脚本
# 作用：清理旧容器，启动新容器，并自动在一个友好的日志界面中等待

set -e

# 进入脚本所在目录，确保在任何地方调用都能正常工作
cd "$(dirname "$0")"

echo "=== 📚 GitBook 本地预览启动助手 ==="

# 1. 检查 Docker 状态
if ! docker info > /dev/null 2>&1; then
    echo "❌ 错误: Docker 未运行，请先启动 Docker Desktop。"
    exit 1
fi

# 2. 清理旧环境
echo "🧹 正在清理旧的服务..."
docker-compose down 2>/dev/null || true

# 3. 启动服务
echo "🚀 正在启动服务 (端口 4000)..."
docker-compose up -d

# 4. 提示信息
echo ""
echo "✅ 服务已启动!" 
echo "👉 访问地址: http://localhost:4000"
echo ""
echo "📋 正在展示实时日志 (按 Ctrl+C 可退出日志查看，服务仍会在后台运行)"
echo "💡 若需要停止服务，请执行: docker-compose down"
echo "---------------------------------------------------------"

# 5. 持续显示日志
docker-compose logs -f
