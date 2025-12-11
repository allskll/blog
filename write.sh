#!/bin/bash

# 确保脚本在当前目录下运行，这样才能找到 data.js
cd "$(dirname "$0")"

# 定义数据文件名
DATA_FILE="data.js"

clear
echo "================================================="
echo "           MAC 博客写作终端"
echo "================================================="
echo ""

# 1. 输入内容
read -e -p "[内容]: " content

# 如果没写内容直接回车，就退出
if [ -z "$content" ]; then
    echo "内容为空，退出。"
    exit 1
fi

# *防崩坏处理*：把英文双引号 " 自动替换为单引号 '，防止代码出错
content=${content//\"/\'}

# 2. 输入颜色
read -p "[颜色 (w=白 r=红 b=蓝 g=绿) 默认白]: " color
if [ -z "$color" ]; then color="w"; fi

# 3. 输入分类
read -p "[分类 (例如 日常) 默认日常]: " tag
if [ -z "$tag" ]; then tag="日常"; fi

# 自动给分类加 # 号
if [[ $tag != \#* ]]; then
    tag="#$tag"
fi

# 4. 获取时间
current_time=$(date "+%Y-%m-%d %H:%M")

# 5. 生成代码行
# 格式: add("时间", "内容", "颜色", "分类");
js_line="add(\"$current_time\", \"$content\", \"$color\", \"$tag\");"

# 6. 写入 data.js
echo "$js_line" >> "$DATA_FILE"

echo ""
echo "✅ 写入成功！"
echo "-------------------------------------------------"
echo "刚才写入的内容："
echo "时间: $current_time"
echo "正文: $content"
echo "-------------------------------------------------"