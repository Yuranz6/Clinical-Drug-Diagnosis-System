# Backblaze B2 凭据配置完成

## ✅ 已配置的凭据

- **Key ID**: `005f3bca11c7bdf0000000001`
- **Key Name**: `cdss`
- **Application Key**: `K005Inrhhjnd7znhJ1fyFVKGQZSFoRw`
- **Bucket Name**: `cdss-data`（默认，可以根据实际情况修改）

## 🚨 安全提醒

**重要**: Application Key 是敏感信息，请务必：

1. ✅ **不要**将 Application Key 提交到 Git
2. ✅ **不要**在代码中硬编码 Application Key
3. ✅ 只在环境变量或 Render Dashboard 中设置
4. ✅ 已添加到 `.gitignore`，`.env` 文件不会被提交

## 📝 已更新的文件

以下文件的默认 Key ID 已更新：

- ✅ `b2_upload.sh`
- ✅ `b2_download.sh`
- ✅ `download_data.py`
- ✅ `render.yaml`

## 🚀 快速测试上传

### 方法1：使用测试脚本（推荐）

```bash
# 运行测试脚本（会自动使用您提供的凭据）
./test_b2_upload.sh
```

### 方法2：手动测试

```bash
# 设置环境变量
export B2_KEY_ID="005f3bca11c7bdf0000000001"
export B2_APPLICATION_KEY="K005Inrhhjnd7znhJ1fyFVKGQZSFoRw"
export B2_BUCKET_NAME="cdss-data"

# 运行上传脚本
./b2_upload.sh
```

### 方法3：使用 b2 命令行工具

```bash
# 安装工具（如果未安装）
pip install b2

# 授权
b2 authorize-account 005f3bca11c7bdf0000000001 K005Inrhhjnd7znhJ1fyFVKGQZSFoRw

# 检查bucket
b2 list-buckets

# 上传文件
b2 upload-file cdss-data eicu_mimic_lab_time.csv eicu_mimic_lab_time.csv
```

## 🔧 配置 Render 环境变量

在 Render Dashboard 中设置以下环境变量：

1. 登录 https://dashboard.render.com/
2. 选择您的服务（cdss-api）
3. 进入 **Environment**
4. 添加环境变量：

```
B2_KEY_ID = 005f3bca11c7bdf0000000001
B2_APPLICATION_KEY = K005Inrhhjnd7znhJ1fyFVKGQZSFoRw
B2_BUCKET_NAME = cdss-data
```

## 📋 检查清单

- [ ] 测试上传脚本运行成功
- [ ] 文件已上传到 B2 bucket
- [ ] 在 Render Dashboard 中设置了环境变量
- [ ] 代码已提交到 GitHub（不包含 Application Key）
- [ ] Render 部署成功，数据文件下载成功

## 🔍 验证上传

上传成功后，可以验证：

```bash
# 授权
b2 authorize-account 005f3bca11c7bdf0000000001 K005Inrhhjnd7znhJ1fyFVKGQZSFoRw

# 列出bucket中的文件
b2 list-file-names cdss-data

# 获取文件信息
b2 get-file-info cdss-data eicu_mimic_lab_time.csv
```

## 🆘 常见问题

### Q: 上传失败，提示bucket不存在？

A: 需要先创建bucket：
```bash
b2 authorize-account 005f3bca11c7bdf0000000001 K005Inrhhjnd7znhJ1fyFVKGQZSFoRw
b2 create-bucket cdss-data allPrivate  # 私有bucket
# 或
b2 create-bucket cdss-data allPublic   # 公开bucket
```

### Q: 如何知道文件上传成功？

A: 运行验证命令：
```bash
b2 list-file-names cdss-data
```

### Q: Application Key 安全吗？

A: Application Key 应该：
- ✅ 只在环境变量中使用
- ✅ 只在 Render Dashboard 中设置
- ❌ 不要提交到 Git
- ❌ 不要在代码中硬编码

## 📚 相关文档

- [B2_QUICK_START.md](B2_QUICK_START.md) - 快速开始指南
- [B2_SETUP.md](B2_SETUP.md) - 完整配置指南

