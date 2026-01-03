# 部署指南

本指南将帮助您将CDSS系统部署到GitHub Pages（前端）和Render（后端）。

## 目录

1. [后端部署到Render](#后端部署到render)
2. [前端部署到GitHub Pages](#前端部署到github-pages)
3. [配置前后端连接](#配置前后端连接)
4. [常见问题](#常见问题)

---

## 后端部署到Render

### 前提条件

- Render账户（免费版即可）
- GitHub仓库已包含所有代码

### 步骤

1. **登录Render**
   - 访问 [https://render.com](https://render.com)
   - 使用GitHub账户登录

2. **创建新的Web服务**
   - 点击 "New +" → "Web Service"
   - 连接您的GitHub仓库
   - 选择包含CDSS代码的仓库

3. **配置服务**
   - **Name**: `cdss-api` (或您喜欢的名称)
   - **Region**: 选择离您最近的区域
   - **Branch**: `main` (或您的主分支)
   - **Root Directory**: 留空（如果代码在根目录）
   - **Runtime**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn cdss_api:app`
   - **Plan**: 选择 Free 计划（或付费计划以获得更好性能）

4. **环境变量** (可选)
   - 通常不需要额外配置
   - Render会自动设置 `PORT` 环境变量

5. **部署**
   - 点击 "Create Web Service"
   - Render将自动构建和部署您的应用
   - 部署完成后，您会得到一个URL，例如：`https://cdss-api.onrender.com`

6. **重要提示**
   - ⚠️ **模型文件**: 确保 `models/` 目录和模型文件已提交到Git仓库
   - ⚠️ **数据文件**: 如果 `eicu_mimic_lab_time.csv` 很大，考虑：
     - 使用Git LFS
     - 或上传到云存储（如S3），然后从代码中下载
   - ⚠️ **首次启动**: 首次部署可能需要几分钟时间加载模型

7. **验证部署**
   - 访问 `https://your-app-name.onrender.com/health`
   - 应该返回JSON响应：`{"status": "healthy", ...}`

### 使用render.yaml（可选）

如果您使用 `render.yaml` 文件，可以直接在Render Dashboard中导入：
- 点击 "New +" → "Blueprint"
- 选择包含 `render.yaml` 的仓库

---

## 前端部署到GitHub Pages

### 前提条件

- GitHub账户
- 代码已推送到GitHub仓库

### 步骤

#### 方法1：使用GitHub Pages（推荐）

1. **准备文件**
   - 确保 `drug_combination_analyzer.html` 和 `config.js` 在仓库中

2. **启用GitHub Pages**
   - 进入您的GitHub仓库
   - 点击 "Settings" → "Pages"
   - 在 "Source" 部分：
     - 选择分支：`main` (或您的主分支)
     - 选择文件夹：`/ (root)` 或 `/docs`（如果HTML在docs文件夹）
   - 点击 "Save"

3. **配置API地址**
   - 编辑 `config.js` 文件
   - 将 `API_BASE_URL` 设置为您的Render后端地址：
     ```javascript
     window.API_BASE_URL = 'https://your-app-name.onrender.com';
     ```
   - 提交更改

4. **访问前端**
   - GitHub Pages URL通常是：`https://your-username.github.io/your-repo-name/`
   - 或如果使用自定义域名：`https://your-domain.com`

5. **更新HTML文件引用config.js**
   - 确保 `drug_combination_analyzer.html` 中包含了 `<script src="config.js"></script>`
   - 已经在 `<head>` 标签中添加

#### 方法2：使用URL参数（灵活配置）

前端也支持通过URL参数动态设置API地址：

```
https://your-username.github.io/your-repo-name/drug_combination_analyzer.html?api=https://your-app-name.onrender.com
```

---

## 配置前后端连接

### CORS配置

后端已经配置了CORS（跨域资源共享），允许所有来源的请求。这是通过以下代码实现的：

```python
from flask_cors import CORS
app = Flask(__name__)
CORS(app)  # 允许跨域请求
```

### 配置前端API地址

有几种方式配置前端API地址：

1. **修改config.js**（推荐用于生产环境）
   ```javascript
   window.API_BASE_URL = 'https://your-app-name.onrender.com';
   ```

2. **使用URL参数**（用于测试或临时切换）
   ```
   https://your-site.com/page.html?api=https://different-api.com
   ```

3. **本地开发**
   - 默认使用 `http://localhost:5003`
   - 或在 `config.js` 中设置本地地址

---

## 常见问题

### 后端部署问题

#### 1. 模型文件太大，GitHub拒绝上传

**解决方案**:
- 使用 Git LFS (Large File Storage)
  ```bash
  git lfs install
  git lfs track "*.pkl"
  git add .gitattributes
  git add models/*.pkl
  git commit -m "Add model files with LFS"
  ```
- 或上传到云存储，在部署时下载

#### 2. Render部署超时

**解决方案**:
- 免费版有构建时间限制（通常是10-15分钟）
- 考虑：
  - 优化模型加载时间
  - 使用更小的模型文件
  - 升级到付费计划

#### 3. 首次请求很慢（冷启动）

**原因**: Render免费版会在15分钟无活动后休眠应用

**解决方案**:
- 使用付费计划（不会休眠）
- 或设置自动ping服务保持活跃

#### 4. 内存不足

**解决方案**:
- 检查模型文件大小
- 优化数据加载（延迟加载、分批处理）
- 升级到更大的实例

### 前端部署问题

#### 1. CORS错误

**症状**: 浏览器控制台显示 "CORS policy" 错误

**解决方案**:
- 确保后端 `CORS(app)` 已启用
- 检查API地址是否正确
- 确认后端服务正在运行

#### 2. API连接失败

**症状**: 前端无法连接到API

**检查清单**:
- ✅ API地址是否正确（包含 `https://`）
- ✅ Render服务是否运行（检查Render Dashboard）
- ✅ 浏览器控制台是否有错误信息
- ✅ 网络请求是否被浏览器阻止

#### 3. GitHub Pages未更新

**解决方案**:
- 等待几分钟（GitHub Pages需要时间更新）
- 强制刷新浏览器（Ctrl+F5 或 Cmd+Shift+R）
- 检查GitHub Actions日志（如果有）

### 性能优化建议

1. **后端优化**
   - 使用缓存减少重复计算
   - 优化模型加载（延迟加载）
   - 使用CDN加速静态资源

2. **前端优化**
   - 压缩HTML/CSS/JavaScript
   - 使用CDN加载库文件
   - 启用浏览器缓存

---

## 部署检查清单

### 后端（Render）
- [ ] 代码已推送到GitHub
- [ ] requirements.txt 包含所有依赖
- [ ] 模型文件已提交（或配置下载）
- [ ] render.yaml 配置正确（如果使用）
- [ ] 服务成功部署
- [ ] /health 端点返回成功
- [ ] CORS已启用

### 前端（GitHub Pages）
- [ ] HTML文件已提交
- [ ] config.js 已配置正确的API地址
- [ ] GitHub Pages已启用
- [ ] 前端可以访问
- [ ] 前端可以连接到后端API
- [ ] 功能测试通过

---

## 获取帮助

如果遇到问题：
1. 检查Render日志：Dashboard → Your Service → Logs
2. 检查浏览器控制台：F12 → Console
3. 查看网络请求：F12 → Network
4. 验证API端点：直接访问API URL测试

---

## 更新部署

### 更新后端
1. 修改代码
2. 提交到GitHub
3. Render会自动检测更改并重新部署

### 更新前端
1. 修改代码
2. 提交到GitHub
3. GitHub Pages会自动更新（可能需要几分钟）

---

祝部署顺利！🎉

