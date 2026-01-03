# 快速部署指南

## 🚀 快速开始

### 1️⃣ 后端部署到Render（5分钟）

1. 访问 [https://render.com](https://render.com) 并登录
2. 点击 "New +" → "Web Service"
3. 连接您的GitHub仓库
4. 配置：
   - **Name**: `cdss-api`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn cdss_api:app`
   - **Plan**: Free
5. 点击 "Create Web Service"
6. 等待部署完成，复制URL（例如：`https://cdss-api.onrender.com`）

### 2️⃣ 前端部署到GitHub Pages（3分钟）

1. 编辑 `config.js`，设置您的Render后端地址：
   ```javascript
   window.API_BASE_URL = 'https://cdss-api.onrender.com';  // 替换为您的Render URL
   ```
2. 提交并推送到GitHub
3. 在GitHub仓库中：Settings → Pages
4. Source 选择：`main` 分支，`/ (root)` 文件夹
5. 保存后访问：`https://your-username.github.io/your-repo-name/`

## 📝 详细说明

查看 [DEPLOY.md](DEPLOY.md) 获取完整的部署指南和故障排除。

## ⚠️ 重要提示

- **模型文件**：确保 `models/` 目录已提交到Git（如果文件很大，考虑使用Git LFS）
- **数据文件**：`eicu_mimic_lab_time.csv` 如果很大，可能需要特殊处理
- **CORS**：后端已配置CORS，无需额外配置

## 🔗 相关链接

- [完整部署文档](DEPLOY.md)
- [Render文档](https://render.com/docs)
- [GitHub Pages文档](https://docs.github.com/pages)

