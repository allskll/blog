#!/bin/bash

# 1. 锁定目录 (防止在别的目录下运行出错)
cd "$(dirname "$0")"

# === 配置区域 ===
DATA_FILE="data.js"   # 你的数据文件
BRANCH="main"         # 分支名 (通常是 main 或 master)

# === 辅助函数: 颜色转换 ===
# 把你输入的 red/green 转成 CSS 里的简写 r/g
get_color_code() {
    case "$1" in
        red|r) echo "r" ;;
        green|g) echo "g" ;;
        blue|b) echo "b" ;;
        *) echo "w" ;; # 默认白色
    esac
}

clear
echo "================================================="
echo "          TERMINAL BLOG CONTROLLER"
echo "================================================="

# === 第一阶段：写博客逻辑 (仅当有参数时触发) ===
if [ -n "$1" ]; then
    
    # 1. 获取输入参数
    CONTENT=$1
    # 如果没输第二个参数，默认是 white
    COLOR_INPUT=${2:-white}
    COLOR_CODE=$(get_color_code "$COLOR_INPUT")
    # 如果没输第三个参数，默认标签是 Log
    TAG=${3:-Log}
    
    # 2. 获取当前时间 [2025-12-13 19:30]
    TIME=$(date "+%Y-%m-%d %H:%M")
    
    # 3. 生成 JS 代码行
    # 格式: add('2025-xx-xx', '内容', 'r', 'Tag');
    JS_LINE="add('$TIME', '$CONTENT', '$COLOR_CODE', '$TAG');"
    
    echo "✍️  正在写入新日志..."
    echo "    [时间]: $TIME"
    echo "    [内容]: $CONTENT"
    echo "    [颜色]: $COLOR_CODE"
    echo "    [标签]: $TAG"
    
    # 4. 追加到 data.js 末尾
    # 检查 data.js 是否存在，不存在这就尴尬了
    if [ ! -f "$DATA_FILE" ]; then
        echo "❌ 错误: 找不到 $DATA_FILE，请先创建它！"
        exit 1
    fi
    
    echo "$JS_LINE" >> "$DATA_FILE"
    echo "✅ 写入完成！"
    
else
    echo "🔍 未检测到输入参数，跳过写入，直接同步..."
fi

# === 第二阶段：Git 同步逻辑 (保留了你原来的核心) ===

echo ""
echo "🔄 正在拉取云端更新 (git pull)..."
git pull origin "$BRANCH"

# 检查是否有变化
if [ -z "$(git status --porcelain)" ]; then 
  echo "✅ 本地没有变化，已经是最新状态。"
  exit 0
fi

echo "📤 正在上传 (git push)..."
git add .

# 智能生成提交信息
if [ -n "$1" ]; then
    COMMIT_MSG="Update: $1"
else
    COMMIT_MSG="Update: $(date '+%Y-%m-%d %H:%M')"
fi

git commit -m "$COMMIT_MSG"
git push origin "$BRANCH"

echo ""
echo "🎉 操作完成！All systems operational."