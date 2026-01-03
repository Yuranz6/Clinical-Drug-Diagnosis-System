# Backblaze B2 快速开始指南

## 📋 您已提供的信息

- **Key ID**: `f3bca11c7bdf`
- **Key Name**: Master Application Key

## 🚀 快速步骤

### 1. 获取 Application Key（必需）

您还需要 Application Key（应用密钥）：

1. 登录 https://secure.backblaze.com/
2. 进入 **B2 Cloud Storage**
3. 点击 **App Keys**
4. 找到 keyName 为 "Master Application Key" 的密钥
5. 复制 **Application Key**（这是敏感信息，请妥善保管）

### 2. 创建 Bucket（如果还没有）

1. 在 B2 控制台中，点击 **Buckets**
2. 点击 **Create a Bucket**
3. 设置：
   - **Bucket Name**: `cdss-data`（或您喜欢的名称）
   - **Files in Bucket are**: 
     - **Private**（推荐，更安全）或
     - **Public**（如果选择公开，下载时不需要Application Key）
4. 点击 **Create a Bucket**

### 3. 上传文件到 B2

#### 方法A：使用脚本（推荐）

```bash
# 设置环境变量
export B2_APPLICATION_KEY='your-application-key-here'  # 替换为实际的密钥
export B2_BUCKET_NAME='cdss-data'  # 如果使用不同的bucket名称

# 运行上传脚本
./b2_upload.sh
```

#### 方法B：使用命令行工具

```bash
# 安装 b2 工具
pip install b2

# 授权
b2 authorize-account f3bca11c7bdf your-application-key-here

# 上传文件
b2 upload-file cdss-data eicu_mimic_lab_time.csv eicu_mimic_lab_time.csv
```

### 4. 配置 Render 环境变量

在 Render Dashboard 中设置环境变量：

1. 登录 https://dashboard.render.com/
2. 选择您的服务（cdss-api）
3. 进入 **Environment**
4. 添加以下环境变量：

```
B2_KEY_ID = f3bca11c7bdf
B2_APPLICATION_KEY = your-application-key-here
B2_BUCKET_NAME = cdss-data
```

**重要**：
- 如果bucket是公开的，可以只设置 `B2_BUCKET_NAME`
- 不要在代码中硬编码密钥
- 密钥是敏感信息，只在Render Dashboard中设置

### 5. 部署

1. 提交代码到 GitHub
2. Render 会自动触发部署
3. 查看部署日志，应该看到数据文件下载成功

## 📝 已创建的文件

- ✅ `b2_upload.sh` - 上传脚本
- ✅ `b2_download.sh` - 下载脚本（bash版本）
- ✅ `download_data.py` - 下载脚本（Python版本，用于Render）
- ✅ `B2_SETUP.md` - 完整配置指南
- ✅ `render.yaml` - 已更新，包含下载步骤

## ⚠️ 注意事项

1. **Application Key 是敏感信息**
   - 不要在代码中硬编码
   - 不要在GitHub中提交
   - 只在环境变量中设置

2. **Bucket 访问权限**
   - **Private**（推荐）：需要Application Key，更安全
   - **Public**：不需要Application Key，但文件公开可访问

3. **文件大小**
   - 您的文件约305MB，完全在B2限制内（单个文件最大10GB）

4. **成本**
   - 存储：约 $0.0015/月（非常便宜）
   - 下载：前1GB/天免费，之后 $0.01/GB

## 🔍 验证上传

上传成功后，您应该看到：

```
✅ 上传完成！
文件URL（如果bucket是公开的）:
  https://f000.backblazeb2.com/file/cdss-data/eicu_mimic_lab_time.csv
```

## 📚 详细文档

查看 [B2_SETUP.md](B2_SETUP.md) 获取完整的配置指南和故障排除。

## 🆘 需要帮助？

如果遇到问题：
1. 检查 Application Key 是否正确
2. 检查 bucket 名称是否正确
3. 检查 bucket 权限设置
4. 查看 [B2_SETUP.md](B2_SETUP.md) 的故障排除部分

