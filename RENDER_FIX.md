# Render Build Command 修复

## 问题

错误信息：
```
ERROR: Could not find a version that satisfies the requirement python3 (from versions: none)
ERROR: No matching distribution found for python3
```

## 原因

在 Render 的 Python 环境中，应该使用 `python` 而不是 `python3`。

## 修复

已将 `render.yaml` 中的 Build Command 从：
```yaml
python3 download_data.py
```

改为：
```yaml
python download_data.py
```

## 更新后的配置

```yaml
buildCommand: |
  pip install -r requirements.txt
  python download_data.py || echo "数据文件下载失败，部分功能将不可用"
```

## 说明

- ✅ Render 环境中 `python` 命令就是 Python 3
- ✅ 不需要使用 `python3`
- ✅ 这样更符合 Render 的标准做法

## 验证

修复后，重新部署应该可以正常工作。Build Command 会：
1. 安装所有依赖
2. 运行下载脚本（使用 `python` 命令）

