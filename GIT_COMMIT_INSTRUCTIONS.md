# 提交 download_data.py 文件到 Git

## 问题

Render 报错：
```
python: can't open file '/opt/render/project/src/download_data.py': [Errno 2] No such file or directory
```

**原因**: `download_data.py` 文件没有被提交到Git仓库，所以Render无法获取这个文件。

## 解决方案

需要将 `download_data.py` 文件提交到Git仓库。

## 步骤

### 1. 检查文件状态

```bash
git status download_data.py
```

如果文件显示为未跟踪（untracked）或已修改（modified），需要提交。

### 2. 添加文件到Git

```bash
git add download_data.py
```

### 3. 提交文件

```bash
git commit -m "Add download_data.py script for B2 data download"
```

### 4. 推送到GitHub

```bash
git push
```

### 5. 验证文件已提交

```bash
# 检查文件是否在Git中
git ls-files download_data.py
```

如果有输出，说明文件已提交。

## 一键命令

如果文件未提交，运行：

```bash
git add download_data.py && \
git commit -m "Add download_data.py for B2 data download" && \
git push
```

## 其他需要提交的文件

确保以下文件也已提交：

- `cdss_api.py`
- `render.yaml`
- `requirements.txt`
- `b2_upload_python.py` (可选，用于本地上传)
- `config.js` (前端配置)
- `drug_combination_analyzer.html` (前端)

检查所有Python文件：
```bash
git status *.py
```

## 重新部署

文件提交并推送后，Render会自动检测更改并重新部署。

1. 提交文件到Git
2. 推送到GitHub
3. Render会自动触发新的部署
4. 部署应该可以成功找到 `download_data.py` 文件

