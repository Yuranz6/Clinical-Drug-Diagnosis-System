# 文件检查清单

## 需要提交到Git的文件

确保以下文件已提交到Git仓库：

### 必需的Python文件
- [ ] `cdss_api.py` - Flask应用主文件
- [ ] `download_data.py` - 数据下载脚本 ⚠️ **必须提交**
- [ ] `prediction_models.py`
- [ ] `data_preprocessing.py`
- [ ] `drug_interaction_warning.py`
- [ ] `drug_combination_analyzer.py`
- [ ] `train_models.py`

### 配置文件
- [ ] `requirements.txt` - Python依赖
- [ ] `render.yaml` - Render配置

### 前端文件
- [ ] `drug_combination_analyzer.html`
- [ ] `config.js`

### 模型文件（如果较小）
- [ ] `models/organ_function_predictor.pkl`
- [ ] `models/preprocessor.pkl`

### 其他
- [ ] `.gitignore`
- [ ] `README.md`

## 检查文件是否已提交

```bash
# 检查文件是否在Git中
git ls-files download_data.py

# 如果没有输出，说明文件未提交，需要添加：
git add download_data.py
git commit -m "Add download_data.py script"
git push
```

## 如果文件未提交

1. 添加文件到Git：
   ```bash
   git add download_data.py
   git commit -m "Add download_data.py for B2 data download"
   git push
   ```

2. 验证文件已提交：
   ```bash
   git ls-files download_data.py
   ```

3. 重新部署到Render

