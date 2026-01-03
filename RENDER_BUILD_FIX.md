# Render Build Command 修复（多行命令问题）

## 问题

错误信息显示pip试图安装"python"作为包：
```
ERROR: Could not find a version that satisfies the requirement python
ERROR: No matching distribution found for python
```

## 原因

在Render的YAML配置中，多行命令格式（使用`|`）可能导致命令被错误解析。Render可能将每一行当作独立的命令执行，而不是作为shell脚本的一部分。

## 解决方案

将多行命令改为单行命令，使用`&&`连接：

**之前（有问题）**:
```yaml
buildCommand: |
  pip install -r requirements.txt
  python download_data.py || echo "数据文件下载失败，部分功能将不可用"
```

**修复后**:
```yaml
buildCommand: pip install -r requirements.txt && python download_data.py || echo "数据文件下载失败，部分功能将不可用"
```

## 命令说明

- `pip install -r requirements.txt` - 安装依赖
- `&&` - 如果第一个命令成功，执行第二个命令
- `python download_data.py` - 运行下载脚本
- `|| echo "..."` - 如果下载失败，显示警告但继续

## 为什么使用单行？

在Render的YAML配置中：
- ✅ 单行命令更可靠
- ✅ 使用`&&`确保命令顺序执行
- ✅ 避免YAML多行格式的解析问题

## 更新后的完整配置

```yaml
services:
  - type: web
    name: cdss-api
    env: python
    buildCommand: pip install -r requirements.txt && python download_data.py || echo "数据文件下载失败，部分功能将不可用"
    startCommand: gunicorn cdss_api:app
```

## 验证

修复后，重新部署应该可以正常工作。构建过程会：
1. ✅ 安装所有依赖
2. ✅ 运行下载脚本
3. ✅ 如果下载失败，显示警告但继续部署

