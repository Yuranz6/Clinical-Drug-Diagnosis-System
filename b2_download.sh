#!/bin/bash
# Backblaze B2 文件下载脚本
# 用于在部署时从 B2 下载数据文件

set -e

# B2 配置（从环境变量读取）
B2_KEY_ID="${B2_KEY_ID:-005f3bca11c7bdf0000000001}"
B2_APPLICATION_KEY="${B2_APPLICATION_KEY:-}"
B2_BUCKET_NAME="${B2_BUCKET_NAME:-cdss-data}"
FILE_NAME="eicu_mimic_lab_time.csv"

echo "正在从 Backblaze B2 下载数据文件..."

# 如果文件已存在，跳过下载
if [ -f "$FILE_NAME" ]; then
    echo "✅ 文件已存在，跳过下载"
    exit 0
fi

# 如果应用密钥未设置，尝试使用公开URL下载（如果bucket是公开的）
if [ -z "$B2_APPLICATION_KEY" ]; then
    echo "⚠️  B2_APPLICATION_KEY 未设置，尝试使用公开URL下载..."
    
    # 尝试公开URL（需要根据您的实际bucket URL修改）
    PUBLIC_URL="https://f000.backblazeb2.com/file/$B2_BUCKET_NAME/$FILE_NAME"
    
    if command -v wget &> /dev/null; then
        wget -O "$FILE_NAME" "$PUBLIC_URL" || {
            echo "❌ 公开URL下载失败，请设置 B2_APPLICATION_KEY 环境变量"
            exit 1
        }
    elif command -v curl &> /dev/null; then
        curl -o "$FILE_NAME" "$PUBLIC_URL" || {
            echo "❌ 公开URL下载失败，请设置 B2_APPLICATION_KEY 环境变量"
            exit 1
        }
    else
        echo "❌ 未找到 wget 或 curl，无法下载文件"
        exit 1
    fi
    
    echo "✅ 下载完成"
    exit 0
fi

# 使用 b2 命令行工具下载
if ! command -v b2 &> /dev/null; then
    echo "📦 安装 b2 命令行工具..."
    pip3 install b2 || {
        echo "❌ 无法安装 b2 工具，尝试使用公开URL..."
        PUBLIC_URL="https://f000.backblazeb2.com/file/$B2_BUCKET_NAME/$FILE_NAME"
        if command -v wget &> /dev/null; then
            wget -O "$FILE_NAME" "$PUBLIC_URL"
        elif command -v curl &> /dev/null; then
            curl -o "$FILE_NAME" "$PUBLIC_URL"
        else
            echo "❌ 无法下载文件"
            exit 1
        fi
        exit 0
    }
fi

# 授权
b2 authorize-account "$B2_KEY_ID" "$B2_APPLICATION_KEY" 2>/dev/null || true

# 下载文件
b2 download-file-by-name "$B2_BUCKET_NAME" "$FILE_NAME" "$FILE_NAME" || {
    echo "❌ 下载失败，尝试使用公开URL..."
    PUBLIC_URL="https://f000.backblazeb2.com/file/$B2_BUCKET_NAME/$FILE_NAME"
    if command -v wget &> /dev/null; then
        wget -O "$FILE_NAME" "$PUBLIC_URL"
    elif command -v curl &> /dev/null; then
        curl -o "$FILE_NAME" "$PUBLIC_URL"
    else
        echo "❌ 无法下载文件"
        exit 1
    fi
}

echo "✅ 下载完成"

