# 宠物项圈小程序 API 系统

完整的宠物智能项圈管理系统，包含后端 API 服务和小程序端请求封装。

## 项目结构

```
wechatmini/
├── server/                 # 后端服务
│   ├── src/
│   │   ├── entities/      # 数据库实体
│   │   ├── routes/        # API 路由
│   │   ├── middleware/    # 中间件
│   │   ├── utils/         # 工具函数
│   │   ├── config.ts      # 配置文件
│   │   └── index.ts       # 入口文件
│   ├── uploads/           # 图片存储
│   ├── init.sql           # 数据库初始化脚本
│   ├── package.json
│   └── tsconfig.json
├── config/                # 小程序配置
├── utils/                 # 小程序工具函数
├── api/                   # 小程序 API 模块
└── pages/                 # 小程序页面
```

## 快速开始

### 1. 初始化数据库

```bash
# 连接到 MySQL
mysql -h 127.0.0.1 -P 3307 -u root -p12345

# 执行初始化脚本
source server/init.sql
```

### 2. 安装后端依赖

```bash
cd server
npm install
```

### 3. 启动后端服务

```bash
# 开发模式（自动重启）
npm run dev

# 生产模式
npm run build
npm start
```

服务将运行在 http://localhost:3003

### 4. 配置小程序

修改 `config/index.js` 中的 `baseURL`（如果需要）：

```javascript
module.exports = {
  baseURL: 'http://localhost:3003',  // 开发环境
  // baseURL: 'https://your-domain.com',  // 生产环境
  timeout: 10000,
  retryCount: 2,
  retryDelay: 1000
}
```

## API 文档

### 认证相关

#### 登录
- **POST** `/api/auth/login`
- Body: `{ code, nickname, avatar }`
- Response: `{ accessToken, refreshToken, user }`

#### 刷新 Token
- **POST** `/api/auth/refresh`
- Body: `{ refreshToken }`
- Response: `{ accessToken, refreshToken }`

### 宠物管理

#### 获取宠物列表
- **GET** `/api/pet`
- Headers: `Authorization: Bearer {token}`
- Response: `[{ id, name, avatar, breed, ... }]`

#### 创建宠物
- **POST** `/api/pet`
- Headers: `Authorization: Bearer {token}`
- Body: `{ name, avatar, breed, birthday, gender, weight }`

#### 更新宠物
- **PUT** `/api/pet/:id`
- Headers: `Authorization: Bearer {token}`
- Body: `{ name, avatar, breed, birthday, gender, weight }`

#### 删除宠物
- **DELETE** `/api/pet/:id`
- Headers: `Authorization: Bearer {token}`

### 设备管理

#### 绑定设备
- **POST** `/api/device/bind`
- Headers: `Authorization: Bearer {token}`
- Body: `{ device_sn, pet_id }`

#### 解绑设备
- **POST** `/api/device/unbind/:petId`
- Headers: `Authorization: Bearer {token}`

#### 更新设备状态
- **POST** `/api/device/status`
- Body: `{ device_sn, battery_level, is_online }`

### 朋友圈

#### 获取朋友圈列表
- **GET** `/api/moment?page=1&limit=20`
- Headers: `Authorization: Bearer {token}`

#### 创建朋友圈
- **POST** `/api/moment`
- Headers: `Authorization: Bearer {token}`
- Content-Type: `multipart/form-data`
- Body: `{ content, pet_id, is_public, images[] }`

#### 点赞
- **POST** `/api/moment/:id/like`
- Headers: `Authorization: Bearer {token}`

#### 取消点赞
- **DELETE** `/api/moment/:id/like`
- Headers: `Authorization: Bearer {token}`

#### 评论
- **POST** `/api/moment/:id/comment`
- Headers: `Authorization: Bearer {token}`
- Body: `{ content }`

#### 获取评论列表
- **GET** `/api/moment/:id/comments`
- Headers: `Authorization: Bearer {token}`

### AI 聊天

#### 发送消息
- **POST** `/api/chat/send`
- Headers: `Authorization: Bearer {token}`
- Body: `{ pet_id, content }`
- Response: `{ userMessage, assistantMessage }`

#### 获取聊天历史
- **GET** `/api/chat/history/:petId?limit=50`
- Headers: `Authorization: Bearer {token}`

## 小程序端使用示例

### 1. 登录

```javascript
const api = require('../../api/index')
const tokenManager = require('../../utils/token')

// 微信登录
wx.login({
  success: async (res) => {
    const { code } = res
    const { accessToken, refreshToken, user } = await api.auth.login(code, '用户昵称', '头像URL')

    tokenManager.setToken(accessToken)
    tokenManager.setRefreshToken(refreshToken)

    wx.switchTab({ url: '/pages/index/index' })
  }
})
```

### 2. 获取宠物列表

```javascript
const api = require('../../api/index')

Page({
  async onLoad() {
    try {
      const pets = await api.pet.getPetList()
      this.setData({ pets })
    } catch (error) {
      console.error('获取宠物列表失败', error)
    }
  }
})
```

### 3. 绑定设备

```javascript
const api = require('../../api/index')

Page({
  async bindDevice() {
    try {
      const result = await api.device.bindDevice('860678079254720', 1)
      wx.showToast({ title: '绑定成功', icon: 'success' })
    } catch (error) {
      wx.showToast({ title: '绑定失败', icon: 'none' })
    }
  }
})
```

### 4. AI 聊天

```javascript
const api = require('../../api/index')

Page({
  data: {
    messages: [],
    petId: 1
  },

  async sendMessage() {
    const content = this.data.inputText

    try {
      const { userMessage, assistantMessage } = await api.chat.sendMessage(this.data.petId, content)

      this.setData({
        messages: [...this.data.messages, userMessage, assistantMessage],
        inputText: ''
      })
    } catch (error) {
      wx.showToast({ title: '发送失败', icon: 'none' })
    }
  }
})
```

## 核心特性

### 后端

- ✅ TypeScript + Express + TypeORM
- ✅ MySQL 数据库
- ✅ JWT 认证（access + refresh token）
- ✅ 图片上传（本地存储）
- ✅ DeepSeek AI 集成（上下文记忆）
- ✅ RESTful API 设计
- ✅ 统一响应格式

### 小程序端

- ✅ 统一请求封装
- ✅ Token 自动刷新
- ✅ 请求重试机制（指数退避）
- ✅ 全局 loading
- ✅ 统一错误处理
- ✅ 模块化 API 设计

## 数据库表结构

- `users` - 用户表
- `pets` - 宠物表
- `devices` - 设备表
- `moments` - 朋友圈表
- `moment_likes` - 点赞表
- `moment_comments` - 评论表
- `chat_messages` - AI 聊天记录表
- `activity_data` - 运动数据表
- `growth_logs` - 成长日志表

## 配置说明

### 后端配置 (server/src/config.ts)

```typescript
export const config = {
  port: 3003,
  database: {
    host: '127.0.0.1',
    port: 3307,
    username: 'root',
    password: '12345',
    database: 'pet_app'
  },
  jwt: {
    accessSecret: 'your-secret-key',
    refreshSecret: 'your-refresh-secret-key',
    accessExpire: '2h',
    refreshExpire: '7d'
  },
  deepseek: {
    apiKey: 'your-deepseek-api-key',
    apiUrl: 'https://api.deepseek.com/v1/chat/completions',
    model: 'deepseek-chat'
  }
}
```

### 小程序配置 (config/index.js)

```javascript
module.exports = {
  baseURL: 'http://localhost:3003',
  timeout: 10000,
  retryCount: 2,
  retryDelay: 1000
}
```

## 注意事项

1. **数据库密码**：请修改 `server/src/config.ts` 中的数据库密码
2. **JWT 密钥**：生产环境请使用强密钥
3. **DeepSeek API Key**：已配置在 config.ts 中
4. **图片上传**：图片存储在 `server/uploads/` 目录
5. **CORS**：后端已配置 CORS，允许跨域请求

## 开发建议

1. 使用 Postman 或类似工具测试 API
2. 查看浏览器控制台的网络请求
3. 检查后端日志输出
4. 使用微信开发者工具的调试功能

## 故障排查

### 数据库连接失败
- 检查 MySQL 是否运行在 3307 端口
- 验证数据库用户名和密码
- 确认数据库 `pet_app` 已创建

### Token 过期
- Token 会自动刷新，无需手动处理
- 如果刷新失败，会自动跳转到登录页

### 图片上传失败
- 确保 `server/uploads/` 目录存在且有写权限
- 检查图片大小是否超过 5MB

## License

MIT
