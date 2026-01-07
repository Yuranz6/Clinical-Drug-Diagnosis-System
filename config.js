// API配置
// Render后端部署地址
// 注意：如果你使用URL参数 ?api=xxx，URL参数会优先使用
// 本地开发时，可以通过URL参数覆盖：?api=http://localhost:5003

// 如果 window.API_BASE_URL 还未定义，则设置默认值
if (typeof window.API_BASE_URL === 'undefined') {
    // ⬇️ Render后端地址 ⬇️
    // 部署后端到 Render 后，请将下面的 URL 替换为您的 Render 服务地址
    // 例如: https://cdss-api-xxxx.onrender.com
    window.API_BASE_URL = 'https://cdss-kd6u.onrender.com';
    // ⬆️ 生产环境API地址 ⬆️
    // 
    // 如何获取您的 Render URL:
    // 1. 登录 Render Dashboard: https://dashboard.render.com
    // 2. 找到您的服务
    // 3. 复制服务 URL（例如: https://cdss-api-xxxx.onrender.com）
    // 4. 替换上面的 URL
    // 5. 提交并推送到 GitHub，GitHub Pages 会自动更新
}

