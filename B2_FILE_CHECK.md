# B2 文件检查和上传指南

## 当前问题

下载失败的可能原因：
1. ❌ 文件尚未上传到B2
2. ❌ b2sdk API使用错误（已修复）
3. ❌ Bucket名称或文件路径不正确

## 第一步：检查文件是否已上传

### 方法1：使用Python脚本检查

```bash
python3 -c "
from b2sdk.v1 import InMemoryAccountInfo, B2Api
import os

B2_KEY_ID = '005f3bca11c7bdf0000000001'
B2_APPLICATION_KEY = 'K005Inrhhjnd7znhJ1fyFVKGQZSFoRw'
B2_BUCKET_NAME = 'cdss-data'

info = InMemoryAccountInfo()
b2_api = B2Api(info)
b2_api.authorize_account('production', B2_KEY_ID, B2_APPLICATION_KEY)

try:
    bucket = b2_api.get_bucket_by_name(B2_BUCKET_NAME)
    files = list(bucket.ls_file_names('', '', 100))
    print('Files in bucket:', files)
    if 'eicu_mimic_lab_time.csv' in files:
        print('✅ 文件已存在')
    else:
        print('❌ 文件不存在，需要上传')
except Exception as e:
    print(f'Error: {e}')
"
```

### 方法2：使用Backblaze B2控制台

1. 登录 https://secure.backblaze.com/
2. 进入 B2 Cloud Storage
3. 点击 Buckets
4. 选择 `cdss-data` bucket
5. 查看文件列表
6. 确认 `eicu_mimic_lab_time.csv` 是否存在

## 第二步：如果文件不存在，上传文件

运行上传脚本：

```bash
python3 b2_upload_python.py
```

或者使用命令行工具：

```bash
pip install b2sdk
python3 b2_upload_python.py
```

## 第三步：验证上传成功

上传后，再次检查文件列表，确认文件存在。

## 当前状态

- ✅ b2sdk下载代码已修复
- ⏳ 需要确认文件是否已上传到B2
- ⏳ 如果未上传，需要先上传文件

## 重要提示

1. **文件必须先上传才能下载**
2. **确保使用正确的bucket名称** (`cdss-data`)
3. **确保环境变量正确设置**（在Render Dashboard中）

