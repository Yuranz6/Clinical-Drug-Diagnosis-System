#!/bin/bash
# Backblaze B2 文件上传脚本
# 用于上传 eicu_mimic_lab_time.csv 到 B2 存储

set -e

# B2 配置（请设置环境变量或修改这里）
B2_KEY_ID="${B2_KEY_ID:-005f3bca11c7bdf0000000001}"
B2_APPLICATION_KEY="${B2_APPLICATION_KEY:-}"  # 请设置此环境变量
B2_BUCKET_NAME="${B2_BUCKET_NAME:-cdss-data}"  # 您的bucket名称
FILE_NAME="eicu_mimic_lab_time.csv"

echo "=========================================="
echo "上传文件到 Backblaze B2"
echo "=========================================="
echo ""

# 检查文件是否存在
if [ ! -f "$FILE_NAME" ]; then
    echo "❌ 错误: 文件 $FILE_NAME 不存在"
    exit 1
fi

# 检查文件大小
FILE_SIZE=$(du -h "$FILE_NAME" | cut -f1)
echo "文件: $FILE_NAME"
echo "大小: $FILE_SIZE"
echo ""

# 检查是否安装了 b2 命令行工具
if ! command -v b2 &> /dev/null; then
    echo "📦 安装 b2 命令行工具..."
    
    # 检测操作系统
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install b2-tools || pip3 install b2
        else
            pip3 install b2
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        pip3 install b2
    else
        echo "❌ 无法自动安装，请手动安装: pip install b2"
        exit 1
    fi
fi

# 检查应用密钥
if [ -z "$B2_APPLICATION_KEY" ]; then
    echo "⚠️  警告: B2_APPLICATION_KEY 环境变量未设置"
    echo ""
    echo "请设置应用密钥："
    echo "  export B2_APPLICATION_KEY='your-application-key'"
    echo ""
    echo "或者在Backblaze B2控制台获取："
    echo "  1. 登录 https://secure.backblaze.com/"
    echo "  2. 进入 B2 Cloud Storage"
    echo "  3. App Keys → 查看 Application Key"
    echo ""
    read -p "请输入 Application Key: " B2_APPLICATION_KEY
    if [ -z "$B2_APPLICATION_KEY" ]; then
        echo "❌ 错误: 未提供 Application Key"
        exit 1
    fi
fi

# 授权
echo "🔐 正在授权 B2..."
b2 authorize-account "$B2_KEY_ID" "$B2_APPLICATION_KEY"

# 检查bucket是否存在，如果不存在则创建
echo "📦 检查bucket..."
if ! b2 list-buckets | grep -q "$B2_BUCKET_NAME"; then
    echo "创建新bucket: $B2_BUCKET_NAME"
    b2 create-bucket "$B2_BUCKET_NAME" allPublic  # allPublic 表示公开访问，如果需要私有访问使用 allPrivate
else
    echo "Bucket $B2_BUCKET_NAME 已存在"
fi

# 上传文件
echo ""
echo "📤 正在上传文件..."
b2 upload-file "$B2_BUCKET_NAME" "$FILE_NAME" "$FILE_NAME"

echo ""
echo "=========================================="
echo "✅ 上传完成！"
echo "=========================================="
echo ""
echo "文件URL（如果bucket是公开的）:"
echo "  https://f000.backblazeb2.com/file/$B2_BUCKET_NAME/$FILE_NAME"
echo ""
echo "或者使用下载脚本从B2下载文件"
echo ""

