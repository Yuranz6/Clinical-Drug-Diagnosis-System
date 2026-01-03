# 数据文件影响总结

## 简短回答

**`eicu_mimic_lab_time.csv` 文件（305MB）无法上传GitHub会影响部分功能，但核心功能仍然可用。**

## 详细说明

### ✅ 核心功能可用（不依赖数据文件）

1. **肝肾功能异常预测** (`/predict`) ✅
2. **药物组合风险预警** (`/warn`) ✅  
3. **综合分析** (`/analyze`) ✅

### ⚠️ 受影响的功能（需要数据文件）

以下功能需要数据文件，如果文件缺失会**无法使用**：

1. ❌ **药物列表** (`/drugs/list`) - **前端需要这个接口！**
2. ❌ 药物组合分析 (`/drug_combinations`)
3. ❌ 常见/高风险/有效药物组合查询
4. ❌ 药物推荐 (`/drugs/recommend`)
5. ❌ 药物保护性效果分析

## 影响评估

### 对后端的影响
- ✅ 服务可以正常启动
- ✅ 核心API（预测、预警）可以正常工作
- ❌ 药物组合相关API会返回错误

### 对前端的影响
- ❌ **药物搜索功能无法使用**（依赖 `/drugs/list` 接口）
- ❌ 药物组合分析功能无法使用
- ✅ 其他功能（如果有独立实现）可以正常使用

## 解决方案

### 方案1：不部署数据文件（最小化部署）⭐ 推荐用于快速部署

**适用场景**：只需要预测和预警功能

**操作**：
- 保持 `.gitignore` 中的 `*.csv` 设置
- 直接部署，不包含数据文件
- 服务会正常启动，但相关功能不可用

**优点**：
- 部署快速
- 占用空间小
- 核心功能可用

**缺点**：
- 前端药物搜索功能不可用
- 药物组合分析功能不可用

### 方案2：使用Git LFS（如果必须存储在GitHub）

**适用场景**：需要在GitHub存储大文件

```bash
# 1. 安装Git LFS
git lfs install

# 2. 跟踪CSV文件
git lfs track "eicu_mimic_lab_time.csv"

# 3. 添加到Git
git add .gitattributes
git add eicu_mimic_lab_time.csv
git commit -m "Add data file using Git LFS"
git push
```

**注意**：GitHub免费版Git LFS有1GB存储限制

### 方案3：使用云存储（推荐用于生产环境）⭐ 最佳方案

**步骤**：
1. 上传文件到云存储（AWS S3, Google Cloud, 阿里云OSS等）
2. 在Render构建时下载文件

**示例**（使用AWS S3）：
```yaml
# render.yaml
services:
  - type: web
    name: cdss-api
    buildCommand: |
      pip install -r requirements.txt
      aws s3 cp s3://your-bucket/eicu_mimic_lab_time.csv . || echo "数据文件下载失败，部分功能将不可用"
```

### 方案4：提取药物列表到配置文件（临时解决方案）

如果只需要药物搜索功能，可以：
1. 从数据文件提取237种药物名称
2. 保存到JSON文件
3. 修改代码使用JSON文件而不是CSV文件

## 推荐做法

对于**部署到Render**：

1. **短期/测试部署**：不部署数据文件
   - 快速验证核心功能
   - 前端需要手动修改或使用备用方案

2. **生产部署**：使用云存储方案
   - 稳定可靠
   - 支持所有功能
   - 灵活管理

## 检查清单

部署时检查：
- [ ] 数据文件是否已上传/可用
- [ ] 服务启动日志中是否有相关警告
- [ ] `/drugs/list` 接口是否正常工作
- [ ] 前端药物搜索功能是否正常

## 相关文档

- [DATA_FILE_INFO.md](DATA_FILE_INFO.md) - 详细说明
- [DEPLOY.md](DEPLOY.md) - 部署指南

