# 快速部署指南

## 🚀 后端部署到 Render（5分钟）

### 1. 登录 Render
访问 https://render.com，使用 `yuranzhang6@gmail.com` 登录

### 2. 创建新服务
- 点击 "New +" → "Web Service"
- 连接 GitHub 账户（如未连接）
- 选择仓库: `Yuranz6/Clinical-Drug-Diagnosis-System`

### 3. 配置服务
**方式 A: 使用 render.yaml（推荐）**
- Render 会自动检测 `render.yaml` 文件
- 直接点击 "Apply" 即可

**方式 B: 手动配置**
- **Name**: `cdss-api`
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

### 4. 部署
- 点击 "Create Web Service"
- 等待构建完成（约 3-5 分钟）
- **复制服务 URL**（例如: `https://cdss-api-xxxx.onrender.com`）

---

## 🎨 前端部署到 GitHub Pages（3分钟）

### 方法 1: 使用 GitHub Actions（推荐）

1. **提交 workflow 文件和其他文件**
   ```bash
   git add .github/workflows/deploy-pages.yml
   git add index.html drug_combination_analyzer.html config.js
   git commit -m "准备部署"
   git push origin main
   ```

2. **启用 GitHub Pages**
   - 访问: https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System/settings/pages
   - Source: 选择 "GitHub Actions"
   - 保存设置
   - 等待 GitHub Actions 完成部署（可以在 Actions 标签页查看进度）
   - **注意**: 如果看不到 "GitHub Actions" 选项，请确保 `.github/workflows/deploy-pages.yml` 文件已提交并推送

3. **更新 API 地址**
   - 编辑 `config.js`
   - 将 `window.API_BASE_URL` 替换为您的 Render URL
   - 提交并推送:
     ```bash
     git add config.js
     git commit -m "更新 API 地址"
     git push origin main
     ```

### 方法 2: 手动部署

1. **启用 GitHub Pages**
   - 访问: https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System/settings/pages
   - Source: 选择 "Deploy from a branch"
   - Branch: `main`, Folder: `/ (root)`
   - 保存

2. **更新 API 地址**（同上）

---

## ✅ 验证部署

### 检查后端
1. 访问: `https://your-render-url.onrender.com/health`
   - 应该返回: `{"status":"healthy",...}`

2. 访问: `https://your-render-url.onrender.com/`
   - 应该返回 API 文档

### 检查前端
1. 访问: `https://yuranz6.github.io/Clinical-Drug-Diagnosis-System/`
   - 应该显示应用界面

2. 打开浏览器控制台（F12）
   - 检查是否有 API 连接错误
   - 测试预测功能是否正常

---

## 🔧 常见问题

**Q: Render 服务启动失败？**
- 检查构建日志中的错误
- 确保 `requirements.txt` 包含所有依赖
- 确保 `gunicorn` 在依赖列表中

**Q: 前端无法连接后端？**
- 检查 `config.js` 中的 URL 是否正确
- 检查浏览器控制台的 CORS 错误
- 确认后端服务正在运行（访问 `/health`）

**Q: GitHub Pages 显示 404？**
- 确保 `index.html` 在根目录
- 检查 GitHub Pages 设置中的分支配置

---

## 📝 下一步

部署完成后：
1. ✅ 测试所有功能
2. ✅ 更新 README.md 中的链接
3. ✅ 分享您的应用！

---

**需要帮助？** 查看 `DEPLOYMENT_GUIDE.md` 获取详细说明。

