# Backblaze B2 存储配置指南

本指南将帮助您将 `eicu_mimic_lab_time.csv` 文件上传到 Backblaze B2，并在 Render 部署时自动下载。

## 前提条件

1. Backblaze B2 账户
2. Key ID: `f3bca11c7bdf`
3. Application Key（应用密钥，需要从Backblaze控制台获取）

## 步骤 1: 获取 Application Key

1. 登录 [Backblaze B2 控制台](https://secure.backblaze.com/)
2. 进入 **B2 Cloud Storage**
3. 点击 **App Keys**
4. 找到您的 Key（keyName: Master Application Key）
5. 复制 **Application Key**（注意：这是敏感信息，请妥善保管）

## 步骤 2: 创建 Bucket（如果还没有）

1. 在 B2 控制台中，点击 **Buckets**
2. 点击 **Create a Bucket**
3. 设置：
   - **Bucket Name**: `cdss-data`（或您喜欢的名称）
   - **Files in Bucket are**: 
     - **Private** - 需要认证访问（推荐，更安全）
     - **Public** - 公开访问（如果选择这个，可以不设置Application Key）
4. 点击 **Create a Bucket**

## 步骤 3: 上传文件到 B2

### 方法1：使用脚本上传（推荐）

```bash
# 设置环境变量
export B2_APPLICATION_KEY='your-application-key-here'
export B2_BUCKET_NAME='cdss-data'  # 如果使用不同的bucket名称

# 运行上传脚本
./b2_upload.sh
```

### 方法2：使用 b2 命令行工具手动上传

```bash
# 安装 b2 工具
pip install b2

# 授权
b2 authorize-account f3bca11c7bdf your-application-key-here

# 上传文件
b2 upload-file cdss-data eicu_mimic_lab_time.csv eicu_mimic_lab_time.csv
```

### 方法3：使用 Backblaze B2 Web 界面

1. 在 B2 控制台中，进入您的 bucket
2. 点击 **Upload/Download** → **Upload Files**
3. 选择 `eicu_mimic_lab_time.csv` 文件
4. 点击 **Upload**

## 步骤 4: 获取文件的公开URL（如果bucket是公开的）

如果您的bucket设置为公开访问，可以获取文件的公开URL：

1. 在 B2 控制台中，点击文件
2. 复制 **Friendly URL** 或 **Direct File URL**
3. URL格式类似：`https://f000.backblazeb2.com/file/cdss-data/eicu_mimic_lab_time.csv`

**注意**：如果使用公开URL，可以跳过步骤5中的环境变量设置。

## 步骤 5: 配置 Render 环境变量

### 在 Render Dashboard 中设置

1. 登录 [Render Dashboard](https://dashboard.render.com/)
2. 选择您的服务（cdss-api）
3. 进入 **Environment**
4. 添加以下环境变量：

```
B2_KEY_ID = f3bca11c7bdf
B2_APPLICATION_KEY = your-application-key-here
B2_BUCKET_NAME = cdss-data
```

**重要**：如果您的bucket是公开的，可以只设置 `B2_BUCKET_NAME`，不需要设置 `B2_APPLICATION_KEY`。

### 使用 render.yaml（可选）

如果您使用 `render.yaml`，可以取消注释环境变量部分：

```yaml
envVars:
  - key: B2_KEY_ID
    value: f3bca11c7bdf
  - key: B2_APPLICATION_KEY
    value: your-application-key-here  # 请替换为实际的密钥
  - key: B2_BUCKET_NAME
    value: cdss-data
```

**注意**：不建议在 `render.yaml` 中直接写密钥，更安全的做法是在 Render Dashboard 中设置。

## 步骤 6: 验证部署

1. 推送代码到 GitHub
2. Render 会自动触发部署
3. 查看部署日志，应该看到：
   ```
   正在从 Backblaze B2 下载数据文件...
   ✅ 下载完成
   ```
4. 检查服务日志，应该看到：
   ```
   药物组合分析系统初始化成功
   ```

## 故障排除

### 问题1：下载失败

**症状**：部署日志显示 "数据文件下载失败"

**解决方案**：
- 检查环境变量是否正确设置
- 检查 Application Key 是否正确
- 检查 bucket 名称是否正确
- 如果bucket是私有的，确保 Application Key 有读取权限

### 问题2：权限错误

**症状**：`b2 authorize-account` 失败

**解决方案**：
- 验证 Key ID 和 Application Key 是否正确
- 检查 Key 是否被禁用
- 确认 Key 有访问该bucket的权限

### 问题3：文件太大，下载超时

**症状**：下载过程中超时

**解决方案**：
- Render 免费版有构建时间限制
- 考虑使用付费计划
- 或者使用公开URL（如果bucket是公开的）

### 问题4：使用公开URL

如果您的bucket是公开的，可以修改 `download_data.py` 或 `b2_download.sh` 使用公开URL：

```python
# 在 download_data.py 中
PUBLIC_URL = "https://f000.backblazeb2.com/file/cdss-data/eicu_mimic_lab_time.csv"
```

然后在 `render.yaml` 中，构建命令可以简化为：

```yaml
buildCommand: |
  pip install -r requirements.txt
  wget https://f000.backblazeb2.com/file/cdss-data/eicu_mimic_lab_time.csv || curl -o eicu_mimic_lab_time.csv https://f000.backblazeb2.com/file/cdss-data/eicu_mimic_lab_time.csv
```

## 安全建议

1. **不要在代码中硬编码密钥**
   - 使用环境变量
   - 不要在 GitHub 中提交密钥

2. **使用私有bucket（推荐）**
   - 更安全
   - 需要认证访问

3. **定期轮换密钥**
   - 定期更新 Application Key
   - 删除不再使用的 Key

4. **限制Key权限**
   - 只授予必要的权限
   - 使用专门的Key用于部署，而不是Master Key

## 文件大小限制

- Backblaze B2 单个文件大小限制：10GB（免费账户）
- 您的文件：约 305MB，完全在限制内

## 成本估算

Backblaze B2 定价（2024年）：
- **存储**: $0.005/GB/月
- **下载**: 前 1GB/天免费，之后 $0.01/GB
- **上传**: 免费

对于 305MB 文件：
- 存储成本：约 $0.0015/月（非常便宜）
- 下载成本：几乎免费（除非每天下载超过1GB）

## 相关文件

- `b2_upload.sh` - 上传脚本
- `b2_download.sh` - 下载脚本（bash版本）
- `download_data.py` - 下载脚本（Python版本，推荐用于Render）
- `render.yaml` - Render配置文件

## 下一步

1. 完成文件上传
2. 配置 Render 环境变量
3. 部署并验证
4. 查看 [DEPLOY.md](DEPLOY.md) 获取完整部署指南

