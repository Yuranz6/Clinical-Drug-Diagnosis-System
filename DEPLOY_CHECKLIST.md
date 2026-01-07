# 部署检查清单

## 📋 部署前准备

### 代码检查
- [ ] 所有文件已提交到 GitHub
- [ ] `render.yaml` 配置正确
- [ ] `requirements.txt` 包含所有依赖
- [ ] `config.js` 已准备好（稍后更新为实际 Render URL）
- [ ] `index.html` 和 `drug_combination_analyzer.html` 存在

### 文件确认
- [ ] `cdss_api.py` - 后端 API
- [ ] `gunicorn_config.py` - Gunicorn 配置
- [ ] `models/` 目录（包含模型文件）
- [ ] `.github/workflows/deploy-pages.yml` - GitHub Actions workflow

---

## 🚀 后端部署到 Render

### 步骤 1: 创建 Render 服务
- [ ] 登录 Render (yuranzhang6@gmail.com)
- [ ] 创建新的 Web Service
- [ ] 连接 GitHub 仓库: `Yuranz6/Clinical-Drug-Diagnosis-System`
- [ ] 使用 `render.yaml` 自动配置，或手动配置：
  - [ ] Name: `cdss-api`
  - [ ] Environment: `Python 3`
  - [ ] Build Command: `pip install -r requirements.txt && python download_data.py || echo "数据文件下载失败，部分功能将不可用"`
  - [ ] Start Command: `gunicorn cdss_api:app`
  - [ ] Python Version: `3.9.18`

### 步骤 2: 环境变量（可选）
如果需要从 B2 下载数据：
- [ ] `B2_KEY_ID` - Backblaze B2 Key ID
- [ ] `B2_APPLICATION_KEY` - Backblaze B2 Application Key
- [ ] `B2_BUCKET_NAME` - B2 Bucket 名称

### 步骤 3: 部署
- [ ] 点击 "Create Web Service"
- [ ] 等待构建完成（检查构建日志）
- [ ] 确认服务运行正常
- [ ] **复制 Render 服务 URL**（例如: `https://cdss-api-xxxx.onrender.com`）

### 步骤 4: 验证后端
- [ ] 访问 `https://your-render-url.onrender.com/health`
  - 预期: `{"status":"healthy",...}`
- [ ] 访问 `https://your-render-url.onrender.com/`
  - 预期: API 文档 JSON

---

## 🎨 前端部署到 GitHub Pages

### 步骤 1: 更新 API 配置
- [ ] 编辑 `config.js`
- [ ] 将 `window.API_BASE_URL` 更新为您的 Render URL
- [ ] 提交更改:
  ```bash
  git add config.js
  git commit -m "更新 API 地址为 Render URL"
  git push origin main
  ```

### 步骤 2: 启用 GitHub Pages

**方法 A: 使用 GitHub Actions（推荐）**
- [ ] 提交 workflow 文件: `git add .github/workflows/deploy-pages.yml && git commit -m "添加部署配置" && git push`
- [ ] 访问: https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System/settings/pages
- [ ] Source: 选择 "GitHub Actions"
- [ ] 保存设置
- [ ] 等待 GitHub Actions 完成部署（在 Actions 标签页查看进度）
- [ ] **注意**: 如果看不到 "GitHub Actions" 选项，确保 workflow 文件已提交

**方法 B: 手动部署**
- [ ] 访问: https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System/settings/pages
- [ ] Source: 选择 "Deploy from a branch"
- [ ] Branch: `main` (或 `master`)
- [ ] Folder: `/ (root)`
- [ ] 保存设置

### 步骤 3: 验证前端
- [ ] 访问: `https://yuranz6.github.io/Clinical-Drug-Diagnosis-System/`
  - 预期: 自动跳转到应用页面
- [ ] 访问: `https://yuranz6.github.io/Clinical-Drug-Diagnosis-System/drug_combination_analyzer.html`
  - 预期: 显示应用界面
- [ ] 打开浏览器控制台（F12）
  - [ ] 检查是否有错误
  - [ ] 检查 API 请求是否发送到正确的 Render URL

---

## ✅ 集成测试

### 功能测试
- [ ] **预测功能**
  - [ ] 输入患者数据
  - [ ] 点击预测
  - [ ] 验证返回结果

- [ ] **预警功能**
  - [ ] 输入药物组合
  - [ ] 点击预警
  - [ ] 验证风险提示

- [ ] **药物组合分析**
  - [ ] 选择药物
  - [ ] 分析组合
  - [ ] 验证分析结果

### API 连接测试
- [ ] 浏览器控制台无 CORS 错误
- [ ] Network 标签显示 API 请求成功
- [ ] API 响应时间合理（首次可能较慢，因为 Render 免费计划会休眠）

---

## 🔧 故障排除

### 后端问题
- [ ] 检查 Render 构建日志
- [ ] 检查 Render 运行日志
- [ ] 确认所有依赖已安装
- [ ] 确认模型文件存在或可以从 B2 下载

### 前端问题
- [ ] 检查 GitHub Pages 设置
- [ ] 检查 `config.js` 中的 URL
- [ ] 检查浏览器控制台错误
- [ ] 确认文件已提交到 GitHub

### 连接问题
- [ ] 确认后端服务正在运行
- [ ] 测试后端健康检查端点
- [ ] 检查 CORS 配置（后端已配置 `CORS(app)`）
- [ ] 尝试使用 URL 参数: `?api=https://your-render-url.onrender.com`

---

## 📝 部署后任务

- [ ] 更新 README.md 中的部署链接
- [ ] 测试所有功能
- [ ] 记录实际部署的 URL
- [ ] 分享应用！

---

## 🔗 重要链接

- **GitHub 仓库**: https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System
- **GitHub Pages**: https://yuranz6.github.io/Clinical-Drug-Diagnosis-System/
- **Render Dashboard**: https://dashboard.render.com
- **GitHub Pages 设置**: https://github.com/Yuranz6/Clinical-Drug-Diagnosis-System/settings/pages

---

## 📚 参考文档

- `DEPLOYMENT_GUIDE.md` - 详细部署指南
- `QUICK_DEPLOY.md` - 快速部署指南
- `render.yaml` - Render 配置文件
