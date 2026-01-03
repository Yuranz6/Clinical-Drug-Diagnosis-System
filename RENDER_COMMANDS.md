# Render 部署命令说明

## Build Command（构建命令）

**用途**: 在部署前执行，用于安装依赖和准备环境

**当前配置**:
```bash
pip install -r requirements.txt
python3 download_data.py || echo "数据文件下载失败，部分功能将不可用"
```

**说明**:
1. `pip install -r requirements.txt` - 安装所有Python依赖包
2. `python3 download_data.py` - 从Backblaze B2下载数据文件
3. `|| echo "..."` - 如果下载失败，显示警告但继续部署（服务仍可启动，部分功能不可用）

**执行时机**: 每次部署前自动执行

---

## Start Command（启动命令）

**用途**: 启动Web服务，让Render知道如何运行您的应用

**当前配置**:
```bash
gunicorn cdss_api:app
```

**说明**:
- `gunicorn` - Python WSGI HTTP服务器（生产环境推荐）
- `cdss_api` - 您的Python文件名（不含.py扩展名）
- `app` - Flask应用实例的名称（在cdss_api.py中定义为 `app = Flask(__name__)`）

**执行时机**: 构建完成后，服务启动时执行

---

## 命令详解

### Build Command 详解

```bash
# 步骤1: 安装依赖
pip install -r requirements.txt
# 这会安装所有依赖，包括：
# - flask, flask-cors (Web框架)
# - pandas, numpy, scikit-learn (数据处理和机器学习)
# - joblib (模型加载)
# - gunicorn (Web服务器)
# - requests, b2sdk (B2存储)

# 步骤2: 下载数据文件
python3 download_data.py || echo "数据文件下载失败，部分功能将不可用"
# - 尝试从Backblaze B2下载数据文件
# - 如果失败，显示警告但继续（服务仍可启动）
```

### Start Command 详解

```bash
gunicorn cdss_api:app
```

**参数说明**:
- `cdss_api` - 模块名（对应 `cdss_api.py` 文件）
- `app` - Flask应用实例（在代码中: `app = Flask(__name__)`）

**等价命令**:
这个命令等价于在本地运行：
```bash
python cdss_api.py
```
但在生产环境中，gunicorn提供了更好的性能和稳定性。

---

## 高级配置（可选）

### 使用 gunicorn 配置文件

如果您想使用 `gunicorn_config.py`，可以修改 Start Command：

```yaml
startCommand: gunicorn cdss_api:app -c gunicorn_config.py
```

### 添加更多 gunicorn 参数

```yaml
startCommand: gunicorn cdss_api:app --workers 4 --timeout 120 --bind 0.0.0.0:$PORT
```

**参数说明**:
- `--workers 4` - 工作进程数（通常设为 CPU核心数 * 2 + 1）
- `--timeout 120` - 请求超时时间（秒）
- `--bind 0.0.0.0:$PORT` - 绑定地址（$PORT是Render自动设置的环境变量）

---

## 当前配置总结

### render.yaml 中的配置

```yaml
buildCommand: |
  pip install -r requirements.txt
  python3 download_data.py || echo "数据文件下载失败，部分功能将不可用"
startCommand: gunicorn cdss_api:app
```

### 在 Render Dashboard 中的配置

如果您在Dashboard中手动配置，应该填写：

**Build Command**:
```
pip install -r requirements.txt && python3 download_data.py || echo "数据文件下载失败，部分功能将不可用"
```

**Start Command**:
```
gunicorn cdss_api:app
```

---

## 常见问题

### Q: 为什么使用 gunicorn 而不是直接运行 Python？

A: 
- **性能**: gunicorn是多进程服务器，性能更好
- **稳定性**: 生产环境推荐使用WSGI服务器
- **可扩展性**: 支持多worker进程
- **标准做法**: Flask在生产环境的标准部署方式

### Q: Build Command 可以做什么？

A: Build Command 可以执行任何构建步骤：
- 安装依赖
- 下载文件
- 运行数据库迁移
- 编译代码
- 等等

### Q: 如果数据文件下载失败怎么办？

A: 当前配置使用了 `|| echo`，这意味着：
- 如果下载成功：继续部署
- 如果下载失败：显示警告，但继续部署
- 服务可以启动，但部分功能（药物组合分析）不可用

### Q: 如何调试构建/启动问题？

A: 在 Render Dashboard 中：
1. 进入您的服务
2. 点击 **Logs** 标签
3. 查看构建日志（Build logs）和运行日志（Runtime logs）

---

## 验证配置

您可以通过以下方式验证配置是否正确：

1. **检查文件是否存在**:
   - `cdss_api.py` - Flask应用文件
   - `requirements.txt` - 依赖列表
   - `download_data.py` - 下载脚本

2. **检查 Flask app 实例名称**:
   在 `cdss_api.py` 中应该有：`app = Flask(__name__)`

3. **测试本地运行**:
   ```bash
   # 安装依赖
   pip install -r requirements.txt
   
   # 使用 gunicorn 测试
   gunicorn cdss_api:app --bind 0.0.0.0:5003
   ```

---

## 相关文件

- `render.yaml` - Render配置文件
- `cdss_api.py` - Flask应用主文件
- `requirements.txt` - Python依赖
- `gunicorn_config.py` - Gunicorn配置文件（可选）
- `download_data.py` - 数据下载脚本

