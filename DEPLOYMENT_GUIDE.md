# 部署指南

本指南将帮助您将前端部署到 GitHub Pages，后端部署到 Render。

## 📋 部署概览

- **前端**: GitHub Pages (https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System)
- **后端**: Render (yuranzhang6@gmail.com)

---

## 🎨 前端部署到 GitHub Pages

### 方法 1: 使用 GitHub Actions 自动部署（推荐）

1. **提交 workflow 文件和其他必要文件**
   ```bash
   git add .github/workflows/deploy-pages.yml
   git add index.html drug_combination_analyzer.html config.js
   git commit -m "添加 GitHub Pages 部署配置"
   git push origin main
   ```

2. **启用 GitHub Pages**
   - 访问 https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System/settings/pages
   - 在 "Source" 部分选择 "GitHub Actions"
   - 系统会自动检测并使用 `.github/workflows/deploy-pages.yml`
   - 如果看不到 "GitHub Actions" 选项，请确保 workflow 文件已提交并推送到 GitHub

3. **访问前端**
   - 部署完成后，访问: `https://yuranz6.github.io/Clinical-Drug-Diagnosis-System/`
   - 或直接访问: `https://yuranz6.github.io/Clinical-Drug-Diagnosis-System/drug_combination_analyzer.html`
   - 首次部署可能需要几分钟，可以在 Actions 标签页查看部署进度

### 方法 2: 手动部署

1. **启用 GitHub Pages**
   - 访问 https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System/settings/pages
   - 在 "Source" 部分选择 "Deploy from a branch"
   - 选择分支: `main` (或 `master`)
   - 选择文件夹: `/ (root)`
   - 点击 "Save"

2. **提交必要文件**
   确保以下文件在仓库根目录：
   - ✅ `index.html` - 入口文件（自动跳转）
   - ✅ `drug_combination_analyzer.html` - 主应用页面
   - ✅ `config.js` - API 配置文件

3. **更新 API 地址**
   - 部署后端后，更新 `config.js` 中的 `window.API_BASE_URL` 为您的 Render URL
   - 或通过 URL 参数传递: `?api=https://your-render-url.onrender.com`

---

## 🚀 后端部署到 Render

### 步骤 1: 准备 Render 账户

1. 访问 https://render.com
2. 使用 `yuranzhang6@gmail.com` 登录或注册
3. 验证邮箱（如需要）

### 步骤 2: 连接 GitHub 仓库

1. 在 Render Dashboard 点击 "New +"
2. 选择 "Web Service"
3. 连接 GitHub 账户（如未连接）
4. 选择仓库: `Yuranz6/Clinical-Drug-Diagnosis-System`

### 步骤 3: 配置服务

使用 `render.yaml` 自动配置，或手动配置：

**手动配置参数：**
- **Name**: `cdss-api` (或您喜欢的名称)
- **Environment**: `Python 3`
- **Build Command**: 
  ```bash
  pip install -r requirements.txt && python download_data.py || echo "数据文件下载失败，部分功能将不可用"
  ```
- **Start Command**: 
  ```bash
  gunicorn cdss_api:app
  ```
- **Python Version**: `3.9.18`

### 步骤 4: 环境变量（可选）

如果需要从 Backblaze B2 下载数据，在 Render Dashboard 中添加环境变量：

- `B2_KEY_ID`: 您的 B2 Key ID
- `B2_APPLICATION_KEY`: 您的 B2 Application Key
- `B2_BUCKET_NAME`: `cdss-data` (或您的 bucket 名称)

### 步骤 5: 部署

1. 点击 "Create Web Service"
2. Render 会自动：
   - 克隆仓库
   - 安装依赖
   - 运行构建命令
   - 启动服务

3. **获取服务 URL**
   - 部署完成后，Render 会提供一个 URL，例如: `https://cdss-api-xxxx.onrender.com`
   - 复制这个 URL

### 步骤 6: 更新前端 API 地址

部署后端后，更新前端的 API 配置：

1. **方法 1: 更新 config.js**
   ```javascript
   window.API_BASE_URL = 'https://your-render-url.onrender.com';
   ```
   然后提交并推送到 GitHub，GitHub Pages 会自动更新。

2. **方法 2: 使用 URL 参数（临时）**
   访问前端时添加参数:
   ```
   https://yuranz6.github.io/Clinical-Drug-Diagnosis-System/?api=https://your-render-url.onrender.com
   ```

---

## ✅ 部署检查清单

### 前端检查
- [ ] 文件已提交到 GitHub
- [ ] GitHub Pages 已启用
- [ ] 可以访问前端页面
- [ ] `config.js` 中的 API 地址已更新

### 后端检查
- [ ] Render 服务已创建
- [ ] 构建成功（检查 Render 日志）
- [ ] 服务运行正常（访问 `/health` 端点）
- [ ] API 可以响应请求（检查 `/` 端点）
- [ ] CORS 配置正确（前端可以调用 API）

### 集成检查
- [ ] 前端可以成功调用后端 API
- [ ] 预测功能正常
- [ ] 预警功能正常
- [ ] 药物组合分析功能正常

---

## 🔧 故障排除

### 前端问题

**问题**: GitHub Pages 显示 404
- **解决**: 确保 `index.html` 在仓库根目录
- **解决**: 检查 GitHub Pages 设置中的分支和文件夹配置

**问题**: 前端无法连接后端
- **解决**: 检查 `config.js` 中的 API 地址是否正确
- **解决**: 检查浏览器控制台的 CORS 错误
- **解决**: 确认后端服务正在运行

### 后端问题

**问题**: Render 构建失败
- **解决**: 检查 `requirements.txt` 是否完整
- **解决**: 查看 Render 构建日志中的错误信息
- **解决**: 确保 Python 版本兼容（3.9.18）

**问题**: 服务启动失败
- **解决**: 检查 `gunicorn` 是否在 `requirements.txt` 中
- **解决**: 检查 `cdss_api.py` 中的导入是否正确
- **解决**: 查看 Render 日志中的错误信息

**问题**: 模型文件缺失
- **解决**: 确保 `models/` 目录已提交到 GitHub
- **解决**: 或使用 `download_data.py` 从 B2 下载

**问题**: 数据文件缺失
- **解决**: 配置 B2 环境变量，让 `download_data.py` 自动下载
- **解决**: 或手动上传数据文件到 Render

---

## 📝 重要提示

1. **首次部署**: Render 的免费计划在 15 分钟无活动后会休眠，首次访问可能需要等待 30-60 秒唤醒。

2. **API 地址**: 部署后端后，记得更新前端的 `config.js` 文件。

3. **数据文件**: 如果数据文件很大，建议使用 Backblaze B2 存储，并在部署时自动下载。

4. **环境变量**: 敏感信息（如 B2 密钥）应通过 Render Dashboard 的环境变量设置，不要提交到代码仓库。

5. **监控**: 定期检查 Render Dashboard 中的服务状态和日志。

---

## 🔗 有用的链接

- **GitHub 仓库**: https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System
- **Render Dashboard**: https://dashboard.render.com
- **GitHub Pages 设置**: https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System/settings/pages

---

## 📞 需要帮助？

如果遇到问题：
1. 检查 Render 构建和运行日志
2. 检查浏览器控制台的错误信息
3. 查看本文档的故障排除部分
4. 检查 GitHub 和 Render 的文档

