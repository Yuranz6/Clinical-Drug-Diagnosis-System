#!/bin/bash
# 测试 Backblaze B2 上传（使用您提供的凭据）

set -e

# 使用您提供的凭据
export B2_KEY_ID="005f3bca11c7bdf0000000001"
export B2_APPLICATION_KEY="K005Inrhhjnd7znhJ1fyFVKGQZSFoRw"
export B2_BUCKET_NAME="cdss-data"

FILE_NAME="eicu_mimic_lab_time.csv"

echo "=========================================="
echo "测试 Backblaze B2 连接和上传"
echo "=========================================="
echo ""
echo "Key ID: $B2_KEY_ID"
echo "Key Name: cdss"
echo "Bucket: $B2_BUCKET_NAME"
echo "文件: $FILE_NAME"
echo ""

# 检查文件是否存在
if [ ! -f "$FILE_NAME" ]; then
    echo "❌ 错误: 文件 $FILE_NAME 不存在"
    exit 1
fi

FILE_SIZE=$(du -h "$FILE_NAME" | cut -f1)
echo "文件大小: $FILE_SIZE"
echo ""

# 安装 b2 工具（如果未安装）
if ! command -v b2 &> /dev/null; then
    echo "📦 安装 b2 命令行工具..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install b2-tools 2>/dev/null || pip3 install b2
        else
            pip3 install b2
        fi
    else
        pip3 install b2
    fi
fi

# 测试授权
echo "🔐 测试授权..."
if b2 authorize-account "$B2_KEY_ID" "$B2_APPLICATION_KEY"; then
    echo "✅ 授权成功"
else
    echo "❌ 授权失败"
    exit 1
fi

echo ""

# 检查bucket是否存在
echo "📦 检查bucket..."
if b2 list-buckets | grep -q "$B2_BUCKET_NAME"; then
    echo "✅ Bucket '$B2_BUCKET_NAME' 已存在"
    
    # 显示bucket信息
    echo ""
    echo "Bucket信息:"
    b2 list-buckets | grep "$B2_BUCKET_NAME"
else
    echo "⚠️  Bucket '$B2_BUCKET_NAME' 不存在"
    echo "是否创建新bucket? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "创建bucket (Private)..."
        b2 create-bucket "$B2_BUCKET_NAME" allPrivate
        echo "✅ Bucket创建成功"
    else
        echo "❌ 请先创建bucket或使用现有的bucket名称"
        exit 1
    fi
fi

echo ""

# 测试上传（先检查文件是否已存在）
echo "🔍 检查文件是否已存在..."
if b2 list-file-names "$B2_BUCKET_NAME" "$FILE_NAME" 1000 | grep -q "$FILE_NAME"; then
    echo "⚠️  文件已存在于bucket中"
    echo "是否覆盖? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "跳过上传"
        exit 0
    fi
fi

echo ""
echo "📤 开始上传文件（这可能需要几分钟，文件大小约305MB）..."
if b2 upload-file "$B2_BUCKET_NAME" "$FILE_NAME" "$FILE_NAME"; then
    echo ""
    echo "=========================================="
    echo "✅ 上传成功！"
    echo "=========================================="
    echo ""
    echo "文件信息:"
    b2 get-file-info "$B2_BUCKET_NAME" "$FILE_NAME" 2>/dev/null || echo "（无法获取文件信息）"
    echo ""
    echo "下一步："
    echo "1. 在Render Dashboard中设置环境变量："
    echo "   B2_KEY_ID = $B2_KEY_ID"
    echo "   B2_APPLICATION_KEY = $B2_APPLICATION_KEY"
    echo "   B2_BUCKET_NAME = $B2_BUCKET_NAME"
    echo ""
    echo "2. 提交代码并部署到Render"
else
    echo ""
    echo "❌ 上传失败"
    exit 1
fi

