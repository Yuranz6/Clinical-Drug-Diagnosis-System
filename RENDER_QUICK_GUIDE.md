# Render 部署命令快速指南

## 📋 当前配置

在 `render.yaml` 中，您的配置如下：

```yaml
buildCommand: |
  pip install -r requirements.txt
  python3 download_data.py || echo "数据文件下载失败，部分功能将不可用"
startCommand: gunicorn cdss_api:app
```

---

## 🔨 Build Command（构建命令）

**作用**: 在部署前执行，准备运行环境

**当前命令**:
```bash
pip install -r requirements.txt
python3 download_data.py || echo "数据文件下载失败，部分功能将不可用"
```

### 步骤说明

1. **`pip install -r requirements.txt`**
   - 安装所有Python依赖包
   - 包括: Flask, pandas, scikit-learn, gunicorn, b2sdk 等

2. **`python3 download_data.py`**
   - 从Backblaze B2下载数据文件
   - 如果下载失败（`||`），显示警告但继续部署

### 何时执行

- ✅ 每次部署前自动执行
- ✅ 如果构建失败，部署会停止

---

## 🚀 Start Command（启动命令）

**作用**: 启动Web服务

**当前命令**:
```bash
gunicorn cdss_api:app
```

### 参数说明

- **`gunicorn`** - Python生产级Web服务器
- **`cdss_api`** - 您的Python文件名（`cdss_api.py`，不含扩展名）
- **`app`** - Flask应用实例名称（在代码中: `app = Flask(__name__)`）

### 为什么使用 gunicorn？

- ✅ 生产环境标准
- ✅ 多进程，性能更好
- ✅ 更稳定可靠
- ✅ 自动处理并发请求

### 等价命令

这等价于本地运行：
```bash
python cdss_api.py
```
但gunicorn更适合生产环境。

---

## 📝 在 Render Dashboard 中配置

如果您在Dashboard中手动配置，填写：

### Build Command
```
pip install -r requirements.txt && python3 download_data.py || echo "数据文件下载失败，部分功能将不可用"
```

### Start Command
```
gunicorn cdss_api:app
```

---

## ✅ 验证配置

确保以下文件存在：

- ✅ `cdss_api.py` - Flask应用文件
- ✅ `requirements.txt` - 依赖列表  
- ✅ `app = Flask(__name__)` - 在cdss_api.py中（第17行）

---

## 🔧 可选：添加更多参数

如果您想自定义gunicorn配置：

```yaml
startCommand: gunicorn cdss_api:app --workers 2 --timeout 120
```

参数说明：
- `--workers 2` - 工作进程数
- `--timeout 120` - 请求超时（秒）

---

## 📚 相关文档

- `RENDER_COMMANDS.md` - 详细说明文档
- `render.yaml` - 配置文件
- `cdss_api.py` - Flask应用代码

