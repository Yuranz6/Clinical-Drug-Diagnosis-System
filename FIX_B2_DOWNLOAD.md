# 修复 B2 下载问题

## 问题

下载脚本遇到多个问题：

1. **b2sdk API错误**: `download_file_by_name()` 参数使用不正确
2. **b2命令行工具失败**: 可能因为环境或权限问题
3. **公开URL 404错误**: 文件可能不存在或bucket不是公开的

## 解决方案

### 1. 修复 b2sdk 代码

已修复 `download_data.py` 中的 b2sdk 下载代码，使用正确的API。

### 2. 检查文件是否已上传到B2

首先确认文件是否已上传到Backblaze B2：

```bash
# 使用Python脚本检查
python3 b2_upload_python.py
# 或者
python3 -c "
from b2sdk.v1 import InMemoryAccountInfo, B2Api
import os
B2_KEY_ID = '005f3bca11c7bdf0000000001'
B2_APPLICATION_KEY = 'K005Inrhhjnd7znhJ1fyFVKGQZSFoRw'
B2_BUCKET_NAME = 'cdss-data'

info = InMemoryAccountInfo()
b2_api = B2Api(info)
b2_api.authorize_account('production', B2_KEY_ID, B2_APPLICATION_KEY)
bucket = b2_api.get_bucket_by_name(B2_BUCKET_NAME)
files = list(bucket.ls_file_names('', '', 100))
print('Files in bucket:', files)
"
```

### 3. 如果文件未上传，先上传

运行上传脚本：

```bash
python3 b2_upload_python.py
```

### 4. 检查环境变量

确保Render Dashboard中设置了正确的环境变量：

- `B2_KEY_ID = 005f3bca11c7bdf0000000001`
- `B2_APPLICATION_KEY = K005Inrhhjnd7znhJ1fyFVKGQZSFoRw`
- `B2_BUCKET_NAME = cdss-data`

### 5. 提交修复后的代码

```bash
git add download_data.py
git commit -m "Fix b2sdk download API usage"
git push
```

## 临时解决方案（如果B2下载持续失败）

如果B2下载持续失败，可以暂时跳过下载，让服务先启动：

当前的buildCommand已经包含错误处理：
```yaml
buildCommand: pip install -r requirements.txt && python download_data.py || echo "数据文件下载失败，部分功能将不可用"
```

这意味着即使下载失败，服务仍可启动，只是部分功能不可用。

## 调试步骤

1. **检查文件是否在B2中**：
   - 登录Backblaze B2控制台
   - 查看bucket中是否有 `eicu_mimic_lab_time.csv`

2. **检查环境变量**：
   - 在Render Dashboard中确认环境变量已设置

3. **查看详细错误**：
   - 查看Render构建日志
   - 检查是否有更详细的错误信息

4. **测试本地下载**：
   ```bash
   export B2_KEY_ID="005f3bca11c7bdf0000000001"
   export B2_APPLICATION_KEY="K005Inrhhjnd7znhJ1fyFVKGQZSFoRw"
   export B2_BUCKET_NAME="cdss-data"
   python download_data.py
   ```

## 成功下载的标志

下载成功后应该看到：
```
✅ 下载完成（使用 b2sdk）
```

文件应该被保存到 `eicu_mimic_lab_time.csv`。

