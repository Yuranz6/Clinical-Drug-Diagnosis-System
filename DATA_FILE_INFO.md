# 数据文件说明

## eicu_mimic_lab_time.csv 文件

**文件大小**: 约 305MB  
**状态**: 已添加到 `.gitignore`，不会上传到 GitHub

## 影响分析

### ✅ 不受影响的核心功能（仍然可用）

这些功能**不依赖** `eicu_mimic_lab_time.csv` 文件：

1. **肝肾功能异常预测** (`/predict`)
   - 使用已训练好的模型文件 (`models/organ_function_predictor.pkl`)
   - 只需要模型文件，不需要原始数据

2. **药物组合风险预警** (`/warn`)
   - 基于规则和临床知识
   - 不需要数据文件

3. **综合分析** (`/analyze`)
   - 结合预测和预警功能
   - 核心功能仍然可用

4. **健康检查** (`/health`)
   - 服务状态检查
   - 不受影响

### ⚠️ 受影响的功能（需要数据文件）

以下功能**需要** `eicu_mimic_lab_time.csv` 文件，如果文件缺失会返回错误：

1. **药物组合分析** (`/drug_combinations`)
   - 分析患者药物组合的风险和疗效

2. **常见药物组合** (`/drug_combinations/common`)
   - 获取数据库中常见的药物组合

3. **高风险药物组合** (`/drug_combinations/risky`)
   - 基于数据分析找出高风险组合

4. **有效药物组合** (`/drug_combinations/effective`)
   - 基于数据分析找出有效组合

5. **药物列表** (`/drugs/list`)
   - 从数据文件中提取药物列名
   - ⚠️ **这个功能前端需要！**

6. **药物推荐** (`/drugs/recommend`)
   - 部分功能需要数据文件

7. **药物保护性效果分析** (`/drugs/protective-effects`)
   - 基于数据分析

## 解决方案

### 方案1：不部署数据文件（推荐用于最小化部署）

**优点**:
- 部署速度快
- 不占用存储空间
- 核心功能可用

**缺点**:
- 药物组合分析功能不可用
- 前端无法加载药物列表（需要手动修复）

**适用场景**:
- 只使用预测和预警功能
- 部署环境存储空间有限

### 方案2：使用Git LFS（Large File Storage）

如果需要在GitHub上存储大文件：

```bash
# 安装Git LFS
git lfs install

# 跟踪CSV文件
git lfs track "eicu_mimic_lab_time.csv"

# 添加.gitattributes文件
git add .gitattributes

# 添加文件（使用LFS）
git add eicu_mimic_lab_time.csv
git commit -m "Add data file using Git LFS"
```

**注意**: GitHub免费版Git LFS有1GB存储限制

### 方案3：使用云存储（推荐用于生产环境）

1. **上传到云存储**（如AWS S3, Google Cloud Storage, 阿里云OSS等）
2. **在部署时下载**:
   - Render支持环境变量
   - 可以在构建脚本中下载文件

示例脚本 (`download_data.sh`):
```bash
#!/bin/bash
# 从云存储下载数据文件
wget -O eicu_mimic_lab_time.csv "https://your-storage-url/eicu_mimic_lab_time.csv"
```

在 `render.yaml` 中添加构建命令：
```yaml
buildCommand: |
  pip install -r requirements.txt
  bash download_data.sh
```

### 方案4：使用Render的持久存储（付费计划）

Render的付费计划提供持久存储，可以：
1. 手动上传文件到Render
2. 在代码中从持久存储读取

## 前端功能影响

⚠️ **重要**: 前端 `drug_combination_analyzer.html` 使用 `/drugs/list` 接口来加载药物列表。如果数据文件不存在，前端将无法显示药物搜索功能。

### 临时解决方案

如果无法上传数据文件，可以：

1. **修改前端使用硬编码的药物列表**（不推荐，维护困难）

2. **使用环境变量或配置文件提供药物列表**（推荐）

3. **使用其他数据源**（如外部API）

## 推荐方案

对于部署到Render，推荐：

1. **短期方案**: 不部署数据文件，仅使用核心预测功能
2. **长期方案**: 使用Git LFS或云存储存储数据文件

## 检查数据文件是否存在

代码已经包含检查逻辑，如果文件不存在会：
- 打印警告信息
- 服务仍然启动
- 相关API端点返回错误信息

您可以在日志中看到：
```
警告：数据文件不存在，药物组合分析功能将不可用
```

