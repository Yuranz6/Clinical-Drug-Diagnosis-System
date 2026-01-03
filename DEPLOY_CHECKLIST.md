# 部署检查清单 ✅

使用此清单确保所有步骤都已完成。

## 📋 部署前准备

### 代码检查
- [ ] 所有代码已提交到Git
- [ ] `.gitignore` 文件已创建并正确配置
- [ ] 模型文件（`models/*.pkl`）已提交（或使用Git LFS）
- [ ] `requirements.txt` 包含所有依赖（包括 `gunicorn`）
- [ ] `cdss_api.py` 已修改以支持Render环境（使用环境变量PORT和HOST）

### 文件检查
- [ ] `render.yaml` 文件已创建
- [ ] `config.js` 文件已创建
- [ ] `drug_combination_analyzer.html` 已包含 `<script src="config.js"></script>`
- [ ] `gunicorn_config.py` 已创建（可选）

---

## 🚀 后端部署（Render）

### 步骤1：创建Render服务
- [ ] 已登录 [render.com](https://render.com)
- [ ] 已创建新的Web Service
- [ ] 已连接到GitHub仓库

### 步骤2：配置服务
- [ ] Name: `cdss-api` (或自定义名称)
- [ ] Region: 已选择
- [ ] Branch: `main` (或主分支)
- [ ] Build Command: `pip install -r requirements.txt`
- [ ] Start Command: `gunicorn cdss_api:app`
- [ ] Plan: Free (或付费计划)

### 步骤3：部署
- [ ] 已点击 "Create Web Service"
- [ ] 部署成功（无错误）
- [ ] 已复制后端URL（例如：`https://cdss-api.onrender.com`）

### 步骤4：验证
- [ ] 访问 `/health` 端点返回成功
  ```
  https://your-app-name.onrender.com/health
  ```
- [ ] 响应包含：`{"status": "healthy", ...}`
- [ ] 检查日志无严重错误

---

## 🌐 前端部署（GitHub Pages）

### 步骤1：配置API地址
- [ ] 已编辑 `config.js`
- [ ] 已将 `window.API_BASE_URL` 设置为Render后端地址
  ```javascript
  window.API_BASE_URL = 'https://your-app-name.onrender.com';
  ```
- [ ] 已提交更改到Git

### 步骤2：启用GitHub Pages
- [ ] 已进入仓库 Settings → Pages
- [ ] Source: 已选择分支（`main`）
- [ ] Folder: 已选择文件夹（`/ (root)` 或 `/docs`）
- [ ] 已保存设置

### 步骤3：验证
- [ ] GitHub Pages URL可访问
- [ ] 前端页面正常加载
- [ ] 浏览器控制台无CORS错误
- [ ] API请求成功（F12 → Network标签检查）

---

## 🔍 功能测试

### 基本功能
- [ ] 页面加载正常
- [ ] 语言切换功能正常
- [ ] 药物搜索功能正常
- [ ] 可以选择药物

### API功能
- [ ] 可以加载药物列表（`/drugs/list`）
- [ ] 可以分析药物组合（`/drug_combinations`）
- [ ] 可以获取预测结果（`/predict`）
- [ ] 可以获取推荐药物（`/drugs/recommend`）

### 端到端测试
- [ ] 选择2个或更多药物
- [ ] 点击"开始分析"
- [ ] 显示分析结果
- [ ] 显示风险评估
- [ ] 显示预测结果（如果模型已加载）
- [ ] 显示推荐药物（如果有）

---

## ⚠️ 常见问题检查

### 后端问题
- [ ] 模型文件是否太大？（考虑使用Git LFS）
- [ ] 首次请求是否很慢？（正常，Render免费版会休眠）
- [ ] 内存是否足够？（检查Render日志）
- [ ] CORS是否已启用？（已默认启用）

### 前端问题
- [ ] API地址是否正确？（包含 `https://`）
- [ ] `config.js` 是否正确加载？（检查浏览器Network标签）
- [ ] 是否有CORS错误？（检查浏览器Console）
- [ ] GitHub Pages是否已更新？（可能需要几分钟）

---

## 📝 后续步骤

### 可选优化
- [ ] 设置自定义域名（Render和GitHub Pages都支持）
- [ ] 配置自动ping保持Render服务活跃（免费版）
- [ ] 设置GitHub Actions自动部署
- [ ] 添加监控和日志服务

### 文档
- [ ] 更新README.md添加部署信息
- [ ] 记录部署URL
- [ ] 保存配置信息

---

## 🎉 完成！

如果所有项目都已完成，您的应用应该已成功部署！

**前端URL**: `https://your-username.github.io/your-repo-name/`
**后端URL**: `https://your-app-name.onrender.com`

---

## 需要帮助？

查看详细文档：
- [完整部署指南](DEPLOY.md)
- [快速部署指南](README_DEPLOY.md)

