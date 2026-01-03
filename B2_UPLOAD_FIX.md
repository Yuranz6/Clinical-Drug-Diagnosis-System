# Backblaze B2 上传问题修复

## 问题

b2 命令行工具在某些环境下会出现兼容性问题（如您遇到的 `SystemError: buffer overflow`）。

## 解决方案

已创建使用 Python b2sdk 的替代方案，更可靠且跨平台兼容。

## 使用方法

### 方法1：使用 Python 脚本上传（推荐）⭐

```bash
# 设置环境变量（可选，脚本中已有默认值）
export B2_KEY_ID="005f3bca11c7bdf0000000001"
export B2_APPLICATION_KEY="K005Inrhhjnd7znhJ1fyFVKGQZSFoRw"
export B2_BUCKET_NAME="cdss-data"

# 运行 Python 上传脚本
python3 b2_upload_python.py
```

### 方法2：直接在 Python 中运行

```bash
python3 b2_upload_python.py
```

脚本会使用您之前提供的凭据（已硬编码在脚本中）。

## 优势

使用 Python b2sdk 相比命令行工具：

1. ✅ **更可靠** - 避免了命令行工具的兼容性问题
2. ✅ **跨平台** - 在所有平台上都能正常工作
3. ✅ **更好的错误处理** - 提供更清晰的错误信息
4. ✅ **进度显示** - 可以添加上传进度（可选）
5. ✅ **依赖管理** - 通过 requirements.txt 管理

## 下载脚本也已更新

`download_data.py` 已更新，优先使用 b2sdk，如果失败则回退到其他方法。

## 更新内容

1. ✅ 创建了 `b2_upload_python.py` - 使用 Python SDK 的上传脚本
2. ✅ 更新了 `download_data.py` - 优先使用 b2sdk
3. ✅ 更新了 `requirements.txt` - 添加了 b2sdk 依赖

## 快速开始

```bash
# 1. 运行上传脚本
python3 b2_upload_python.py

# 2. 脚本会自动：
#    - 安装 b2sdk（如果未安装）
#    - 授权 B2 账户
#    - 检查/创建 bucket
#    - 上传文件
```

## 注意事项

1. 脚本中包含了您的 Application Key（仅用于本地测试）
2. 不要将包含密钥的脚本提交到 Git
3. 在生产环境（Render）中，使用环境变量而不是硬编码的密钥

## 如果还有问题

如果 Python SDK 也有问题，可以考虑：

1. **使用 Backblaze Web 界面**直接上传文件
2. **使用公开 URL**（如果 bucket 是公开的）
3. **使用其他工具**如 rclone

