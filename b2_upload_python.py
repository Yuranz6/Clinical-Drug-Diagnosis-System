#!/usr/bin/env python3
"""
使用 Python b2 SDK 上传文件到 Backblaze B2
这是更可靠的方案，避免了命令行工具的兼容性问题
"""

import os
import sys

# 配置
B2_KEY_ID = os.environ.get('B2_KEY_ID', '005f3bca11c7bdf0000000001')
B2_APPLICATION_KEY = os.environ.get('B2_APPLICATION_KEY', 'K005Inrhhjnd7znhJ1fyFVKGQZSFoRw')
B2_BUCKET_NAME = os.environ.get('B2_BUCKET_NAME', 'cdss-data')
FILE_NAME = 'eicu_mimic_lab_time.csv'

def main():
    print("=" * 60)
    print("使用 Python SDK 上传文件到 Backblaze B2")
    print("=" * 60)
    print(f"Key ID: {B2_KEY_ID}")
    print(f"Key Name: cdss")
    print(f"Bucket: {B2_BUCKET_NAME}")
    print(f"文件: {FILE_NAME}")
    print()
    
    # 检查文件是否存在
    if not os.path.exists(FILE_NAME):
        print(f"❌ 错误: 文件 {FILE_NAME} 不存在")
        return 1
    
    file_size = os.path.getsize(FILE_NAME) / (1024 * 1024)  # MB
    print(f"文件大小: {file_size:.1f} MB")
    print()
    
    # 安装 b2sdk（如果未安装）
    try:
        import b2sdk
    except ImportError:
        print("📦 安装 b2sdk...")
        import subprocess
        try:
            subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'b2sdk', '--quiet'])
            import b2sdk
            print("✅ b2sdk 安装成功")
        except Exception as e:
            print(f"❌ 安装失败: {e}")
            print("请手动安装: pip install b2sdk")
            return 1
    
    from b2sdk.v1 import InMemoryAccountInfo, B2Api
    from b2sdk.v1.exception import B2Error
    
    try:
        # 初始化 B2 API
        print("🔐 正在授权...")
        info = InMemoryAccountInfo()
        b2_api = B2Api(info)
        b2_api.authorize_account("production", B2_KEY_ID, B2_APPLICATION_KEY)
        print("✅ 授权成功")
        print()
        
        # 获取bucket
        print(f"📦 查找bucket: {B2_BUCKET_NAME}...")
        try:
            bucket = b2_api.get_bucket_by_name(B2_BUCKET_NAME)
            print(f"✅ 找到bucket: {B2_BUCKET_NAME}")
        except B2Error as e:
            print(f"⚠️  Bucket '{B2_BUCKET_NAME}' 不存在")
            print("是否创建新bucket? (y/n): ", end='', flush=True)
            response = input().strip().lower()
            if response in ['y', 'yes']:
                print(f"创建bucket (Private)...")
                bucket = b2_api.create_bucket(B2_BUCKET_NAME, bucket_type='allPrivate')
                print(f"✅ Bucket创建成功")
            else:
                print("❌ 请先创建bucket或使用现有的bucket名称")
                return 1
        print()
        
        # 检查文件是否已存在
        print("🔍 检查文件是否已存在...")
        try:
            file_info = bucket.get_file_info_by_name(FILE_NAME)
            print(f"⚠️  文件已存在于bucket中 (大小: {file_info.size / (1024*1024):.1f} MB)")
            print("是否覆盖? (y/n): ", end='', flush=True)
            response = input().strip().lower()
            if response not in ['y', 'yes']:
                print("跳过上传")
                return 0
        except B2Error:
            print("✅ 文件不存在，准备上传")
        print()
        
        # 上传文件
        print(f"📤 开始上传文件（这可能需要几分钟）...")
        print(f"文件: {FILE_NAME} ({file_size:.1f} MB)")
        print()
        
        uploaded_file = bucket.upload_local_file(
            local_file=FILE_NAME,
            file_name=FILE_NAME,
            progress_listener=None  # 可以添加进度监听器
        )
        
        print()
        print("=" * 60)
        print("✅ 上传成功！")
        print("=" * 60)
        print()
        print(f"文件ID: {uploaded_file.id_}")
        print(f"文件名: {uploaded_file.file_name}")
        print(f"文件大小: {uploaded_file.size / (1024*1024):.1f} MB")
        print(f"上传时间: {uploaded_file.upload_timestamp}")
        print()
        print("下一步：")
        print("1. 在Render Dashboard中设置环境变量：")
        print(f"   B2_KEY_ID = {B2_KEY_ID}")
        print(f"   B2_APPLICATION_KEY = {B2_APPLICATION_KEY}")
        print(f"   B2_BUCKET_NAME = {B2_BUCKET_NAME}")
        print()
        print("2. 提交代码并部署到Render")
        print()
        
        return 0
        
    except B2Error as e:
        print(f"❌ B2错误: {e}")
        return 1
    except Exception as e:
        print(f"❌ 错误: {e}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == '__main__':
    sys.exit(main())

