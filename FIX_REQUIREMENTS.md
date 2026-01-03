# 修复 requirements.txt 问题

## 问题

部署时出现两个错误：

1. **ModuleNotFoundError: No module named 'requests'**
   - `download_data.py` 需要 requests 模块
   - 但 requirements.txt 中可能没有包含

2. **gunicorn: command not found**
   - gunicorn 没有安装
   - requirements.txt 中可能没有包含

## 原因

`requirements.txt` 文件已被修改但**未提交到Git**，所以Render使用的是旧版本的requirements.txt，缺少新添加的依赖。

## 解决方案

需要提交更新后的 `requirements.txt` 文件。

## 步骤

### 1. 检查 requirements.txt 内容

确保文件包含所有必需的依赖：

```txt
pandas>=1.3.0
numpy>=1.21.0
scikit-learn>=1.0.0
flask>=2.0.0
flask-cors>=3.0.0
joblib>=1.0.0
gunicorn>=20.1.0
requests>=2.28.0
b2sdk>=1.20.0
```

### 2. 提交更新的 requirements.txt

```bash
git add requirements.txt
git commit -m "Update requirements.txt: add gunicorn, requests, b2sdk"
git push
```

### 3. 等待Render重新部署

文件推送后，Render会自动检测更改并重新部署。

## 验证

部署成功后，构建日志应该显示：
- ✅ 所有依赖安装成功（包括 requests, gunicorn, b2sdk）
- ✅ download_data.py 运行成功
- ✅ gunicorn 启动服务成功

## 完整的依赖列表

当前 requirements.txt 应该包含：

```
pandas>=1.3.0
numpy>=1.21.0
scikit-learn>=1.0.0
flask>=2.0.0
flask-cors>=3.0.0
joblib>=1.0.0
gunicorn>=20.1.0
requests>=2.28.0
b2sdk>=1.20.0
```

## 一键修复命令

```bash
git add requirements.txt && \
git commit -m "Update requirements.txt: add gunicorn, requests, b2sdk for deployment" && \
git push
```

