#!/bin/bash

set -o pipefail

# === 获取项目根目录 ===
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📁 项目根目录: $ROOT_DIR"

# === 检查并杀死占用端口 ===
PORT=8080
PID=$(lsof -ti tcp:$PORT)
if [ -n "$PID" ]; then
  echo "⚠️ 端口 $PORT 已被占用，正在关闭 PID: $PID..."
  kill -9 $PID
  sleep 1
fi

# === 启动 Go 后端服务 ===
echo "🚀 启动 Go 后端服务..."
cd "$ROOT_DIR/Astral3DEditorGoBack" || { echo "❌ 找不到 Astral3DEditorGoBack 目录"; exit 1; }
bee run &
sleep 2

# === 启动 Astral3DEditor 前端 ===
echo "🌐 启动 Astral3DEditor 前端服务..."
cd "$ROOT_DIR/Astral3DEditor" || { echo "❌ 找不到 Astral3DEditor 目录"; exit 1; }
npm run dev &
sleep 2

# === 可选：Rocksi 调试服务 ===
echo "🧪 启动 Rocksi 开发服务..."
cd "$ROOT_DIR/Rocksi-master" || { echo "❌ 找不到 Rocksi-master 目录"; exit 1; }
npm run dev &

wait

