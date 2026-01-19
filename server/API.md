# 宠物项圈系统 API 文档

## 目录

- [通用说明](#通用说明)
- [认证接口](#认证接口)
- [用户接口](#用户接口)
- [宠物接口](#宠物接口)
- [设备接口](#设备接口)
- [朋友圈接口](#朋友圈接口)
- [AI 聊天接口](#ai-聊天接口)
- [图片上传接口](#图片上传接口)
- [错误码说明](#错误码说明)

---

## 通用说明

### 基础信息

- **Base URL**: `http://localhost:3003`
- **协议**: HTTP/HTTPS
- **数据格式**: JSON
- **字符编码**: UTF-8

### 认证机制

大部分接口需要在请求头中携带 JWT Token：

```
Authorization: Bearer <access_token>
```

Token 有效期：
- Access Token: 2 小时
- Refresh Token: 7 天

### 统一响应格式

所有接口返回统一的 JSON 格式：

```json
{
  "code": 0,
  "message": "Success",
  "data": {}
}
```

- `code`: 状态码，0 表示成功，非 0 表示失败
- `message`: 响应消息
- `data`: 响应数据，失败时为 null

---

## 认证接口

### 1. 微信登录

**接口**: `POST /api/auth/login`

**功能**: 使用微信授权码登录，获取访问令牌

**请求头**: 无需认证

**请求参数**:

```json
{
  "code": "string",      // 微信授权码
  "nickname": "string",  // 用户昵称
  "avatar": "string"     // 用户头像 URL
}
```

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "openid": "mock_openid_1234567890",
      "nickname": "测试用户",
      "avatar": "https://example.com/avatar.jpg",
      "created_at": "2026-01-18T23:12:37.000Z",
      "updated_at": "2026-01-18T23:12:37.000Z"
    }
  }
}
```

**错误响应**:

```json
{
  "code": 500,
  "message": "Login failed",
  "data": null
}
```

---

### 2. 刷新令牌

**接口**: `POST /api/auth/refresh`

**功能**: 使用 Refresh Token 获取新的 Access Token

**请求头**: 无需认证

**请求参数**:

```json
{
  "refreshToken": "string"  // Refresh Token
}
```

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**错误响应**:

```json
{
  "code": 401,
  "message": "Invalid refresh token",
  "data": null
}
```

---

## 用户接口

### 1. 获取用户资料

**接口**: `GET /api/user/profile`

**功能**: 获取当前登录用户的详细信息

**请求头**: 需要认证

```
Authorization: Bearer <access_token>
```

**请求参数**: 无

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "id": 1,
    "openid": "mock_openid_1234567890",
    "nickname": "测试用户",
    "avatar": "https://example.com/avatar.jpg",
    "phone": "13800138000",
    "created_at": "2026-01-18T23:12:37.000Z",
    "updated_at": "2026-01-18T23:13:26.000Z",
    "pets": []
  }
}
```

**错误响应**:

```json
{
  "code": 404,
  "message": "User not found",
  "data": null
}
```

---

### 2. 更新用户资料

**接口**: `PUT /api/user/profile`

**功能**: 更新当前登录用户的信息

**请求头**: 需要认证

```
Authorization: Bearer <access_token>
```

**请求参数**:

```json
{
  "nickname": "string",   // 可选，用户昵称
  "avatar": "string",     // 可选，用户头像 URL
  "phone": "string"       // 可选，手机号码
}
```

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "id": 1,
    "openid": "mock_openid_1234567890",
    "nickname": "更新后的用户",
    "avatar": "https://example.com/avatar.jpg",
    "phone": "13800138000",
    "created_at": "2026-01-18T23:12:37.000Z",
    "updated_at": "2026-01-18T23:13:26.000Z"
  }
}
```

---

## 宠物接口

### 1. 获取宠物列表

**接口**: `GET /api/pet`

**功能**: 获取当前用户的所有宠物

**请求头**: 需要认证

**请求参数**: 无

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "name": "豆包",
      "avatar": null,
      "breed": "哈士奇",
      "birthday": null,
      "gender": "male",
      "weight": null,
      "device_id": null,
      "created_at": "2026-01-18T23:13:54.000Z",
      "updated_at": "2026-01-18T23:13:54.000Z",
      "device": null
    }
  ]
}
```

---

### 2. 创建宠物

**接口**: `POST /api/pet`

**功能**: 为当前用户创建新宠物

**请求头**: 需要认证

**请求参数**:

```json
{
  "name": "string",       // 必填，宠物名称
  "breed": "string",      // 可选，品种
  "gender": "string",     // 可选，性别 (male/female)
  "birthday": "string",   // 可选，生日 (YYYY-MM-DD)
  "weight": "number",     // 可选，体重 (kg)
  "avatar": "string"      // 可选，头像 URL
}
```

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "user_id": 1,
    "name": "豆包",
    "breed": "哈士奇",
    "gender": "male",
    "avatar": null,
    "birthday": null,
    "weight": null,
    "device_id": null,
    "id": 1,
    "created_at": "2026-01-18T23:13:54.000Z",
    "updated_at": "2026-01-18T23:13:54.000Z"
  }
}
```

---

### 3. 更新宠物信息

**接口**: `PUT /api/pet/:id`

**功能**: 更新指定宠物的信息

**请求头**: 需要认证

**路径参数**:
- `id`: 宠物 ID

**请求参数**:

```json
{
  "name": "string",       // 可选，宠物名称
  "breed": "string",      // 可选，品种
  "gender": "string",     // 可选，性别
  "birthday": "string",   // 可选，生日
  "weight": "number",     // 可选，体重
  "avatar": "string"      // 可选，头像 URL
}
```

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "id": 1,
    "user_id": 1,
    "name": "豆包",
    "breed": "哈士奇",
    "gender": "male",
    "created_at": "2026-01-18T23:13:54.000Z",
    "updated_at": "2026-01-18T23:20:00.000Z"
  }
}
```

---

### 4. 删除宠物

**接口**: `DELETE /api/pet/:id`

**功能**: 删除指定的宠物

**请求头**: 需要认证

**路径参数**:
- `id`: 宠物 ID

**请求参数**: 无

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "deleted": true
  }
}
```

---

### 5. 获取今日统计

**接口**: `GET /api/pet/:id/stats/today`

**功能**: 获取指定宠物今日的运动统计数据

**请求头**: 需要认证

**路径参数**:
- `id`: 宠物 ID

**请求参数**: 无

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "steps": 1000,
    "distance": 500,
    "calories": 50,
    "active_minutes": 30
  }
}
```

---

### 6. 获取成长日志

**接口**: `GET /api/pet/:id/growth-logs`

**功能**: 获取指定宠物的成长日志

**请求头**: 需要认证

**路径参数**:
- `id`: 宠物 ID

**查询参数**:
- `limit`: 可选，返回数量，默认 20

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "pet_id": 1,
      "log_type": "activity",
      "title": "今日运动",
      "content": "今天跑了 1000 步",
      "created_at": "2026-01-18T23:15:00.000Z"
    }
  ]
}
```

---

## 设备接口

### 1. 绑定设备

**接口**: `POST /api/device/bind`

**功能**: 将设备绑定到指定宠物

**请求头**: 需要认证

**请求参数**:

```json
{
  "device_sn": "string",  // 必填，设备序列号
  "pet_id": "number"      // 必填，宠物 ID
}
```

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "device": {
      "id": 1,
      "device_sn": "TEST123456789",
      "pet_id": 1,
      "battery_level": 100,
      "is_online": false,
      "last_online_at": null,
      "created_at": "2026-01-18T23:15:19.000Z",
      "updated_at": "2026-01-18T23:15:19.000Z"
    },
    "pet": {
      "id": 1,
      "name": "豆包",
      "device_id": 1
    }
  }
}
```

**错误响应**:

```json
{
  "code": 400,
  "message": "device_sn and pet_id required",
  "data": null
}
```

---

### 2. 解绑设备

**接口**: `POST /api/device/unbind/:petId`

**功能**: 解除宠物与设备的绑定关系

**请求头**: 需要认证

**路径参数**:
- `petId`: 宠物 ID

**请求参数**: 无

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "unbound": true
  }
}
```

---

### 3. 更新设备状态

**接口**: `POST /api/device/status`

**功能**: 更新设备的状态信息（设备端调用）

**请求头**: 无需认证

**请求参数**:

```json
{
  "device_sn": "string",    // 必填，设备序列号
  "battery_level": "number", // 可选，电池电量 (0-100)
  "is_online": "boolean"     // 可选，是否在线
}
```

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "id": 1,
    "device_sn": "TEST123456789",
    "pet_id": 1,
    "battery_level": 85,
    "is_online": true,
    "last_online_at": "2026-01-18T23:15:49.267Z",
    "created_at": "2026-01-18T23:15:19.000Z",
    "updated_at": "2026-01-18T23:15:49.000Z"
  }
}
```

---

## 朋友圈接口

### 1. 获取朋友圈列表

**接口**: `GET /api/moment`

**功能**: 获取朋友圈动态列表

**请求头**: 需要认证

**查询参数**:
- `page`: 可选，页码，默认 1
- `limit`: 可选，每页数量，默认 20

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "moments": [
      {
        "id": 1,
        "user_id": 1,
        "pet_id": null,
        "content": "今天天气真好！",
        "images": [],
        "is_public": true,
        "like_count": 0,
        "comment_count": 0,
        "created_at": "2026-01-18T23:16:25.000Z",
        "updated_at": "2026-01-18T23:16:25.000Z",
        "user": {
          "id": 1,
          "nickname": "测试用户",
          "avatar": "https://example.com/avatar.jpg"
        },
        "pet": null
      }
    ],
    "total": 1,
    "page": 1,
    "limit": 10
  }
}
```

---

### 2. 发布朋友圈

**接口**: `POST /api/moment`

**功能**: 发布新的朋友圈动态

**请求头**: 需要认证

**Content-Type**: `multipart/form-data`

**请求参数**:
- `content`: 可选，文字内容
- `pet_id`: 可选，关联的宠物 ID
- `is_public`: 可选，是否公开，默认 true
- `images`: 可选，图片文件（最多 9 张）

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "id": 1,
    "user_id": 1,
    "pet_id": null,
    "content": "今天天气真好！",
    "images": [],
    "is_public": true,
    "like_count": 0,
    "comment_count": 0,
    "created_at": "2026-01-18T23:16:25.000Z",
    "updated_at": "2026-01-18T23:16:25.000Z"
  }
}
```

---

### 3. 点赞朋友圈

**接口**: `POST /api/moment/:id/like`

**功能**: 给指定朋友圈动态点赞

**请求头**: 需要认证

**路径参数**:
- `id`: 朋友圈 ID

**请求参数**: 无

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "like_count": 1
  }
}
```

---

### 4. 取消点赞

**接口**: `DELETE /api/moment/:id/like`

**功能**: 取消对朋友圈动态的点赞

**请求头**: 需要认证

**路径参数**:
- `id`: 朋友圈 ID

**请求参数**: 无

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "like_count": 0
  }
}
```

---

### 5. 评论朋友圈

**接口**: `POST /api/moment/:id/comment`

**功能**: 给指定朋友圈动态添加评论

**请求头**: 需要认证

**路径参数**:
- `id`: 朋友圈 ID

**请求参数**:

```json
{
  "content": "string"  // 必填，评论内容
}
```

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "id": 1,
    "moment_id": 1,
    "user_id": 1,
    "content": "真不错！",
    "created_at": "2026-01-18T23:17:00.000Z"
  }
}
```

---

### 6. 删除评论

**接口**: `DELETE /api/moment/comment/:commentId`

**功能**: 删除指定的评论

**请求头**: 需要认证

**路径参数**:
- `commentId`: 评论 ID

**请求参数**: 无

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "deleted": true
  }
}
```

---

## AI 聊天接口

### 1. 获取聊天历史

**接口**: `GET /api/chat/history/:petId`

**功能**: 获取与指定宠物的聊天历史记录

**请求头**: 需要认证

**路径参数**:
- `petId`: 宠物 ID

**查询参数**:
- `limit`: 可选，返回数量，默认 50

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": [
    {
      "id": 1,
      "pet_id": 1,
      "role": "user",
      "content": "你好，豆包！",
      "created_at": "2026-01-18T23:17:59.000Z"
    },
    {
      "id": 2,
      "pet_id": 1,
      "role": "assistant",
      "content": "你好！我很高兴能为你提供帮助...",
      "created_at": "2026-01-18T23:18:07.000Z"
    }
  ]
}
```

---

### 2. 发送消息

**接口**: `POST /api/chat/send`

**功能**: 向 AI 宠物发送消息并获取回复

**请求头**: 需要认证

**请求参数**:

```json
{
  "pet_id": "number",  // 必填，宠物 ID
  "content": "string"  // 必填，消息内容
}
```

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "userMessage": {
      "id": 1,
      "pet_id": 1,
      "role": "user",
      "content": "你好，豆包！",
      "created_at": "2026-01-18T23:17:59.000Z"
    },
    "assistantMessage": {
      "id": 2,
      "pet_id": 1,
      "role": "assistant",
      "content": "你好！我很高兴能为你提供帮助...",
      "created_at": "2026-01-18T23:18:07.000Z"
    }
  }
}
```

**注意**: 此接口调用外部 AI API，响应时间可能较长（约 5-10 秒）

---

## 图片上传接口

### 1. 上传单张图片

**接口**: `POST /api/upload/image`

**功能**: 上传单张图片文件

**请求头**: 需要认证

**Content-Type**: `multipart/form-data`

**请求参数**:
- `file`: 图片文件（支持 jpg, jpeg, png, gif）

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "url": "/uploads/1234567890-image.jpg"
  }
}
```

**错误响应**:

```json
{
  "code": 400,
  "message": "Only image files are allowed",
  "data": null
}
```

---

### 2. 上传多张图片

**接口**: `POST /api/upload/images`

**功能**: 批量上传图片文件

**请求头**: 需要认证

**Content-Type**: `multipart/form-data`

**请求参数**:
- `files`: 图片文件数组（最多 9 张）

**响应示例**:

```json
{
  "code": 0,
  "message": "Success",
  "data": {
    "urls": [
      "/uploads/1234567890-image1.jpg",
      "/uploads/1234567891-image2.jpg"
    ]
  }
}
```

---

## 错误码说明

| 错误码 | 说明 | 常见原因 |
|--------|------|----------|
| 0 | 成功 | 请求成功 |
| 400 | 请求参数错误 | 缺少必填参数或参数格式错误 |
| 401 | 未授权 | Token 无效或已过期 |
| 403 | 禁止访问 | 没有权限访问该资源 |
| 404 | 资源不存在 | 请求的资源不存在 |
| 500 | 服务器错误 | 服务器内部错误 |

### 常见错误处理

#### 1. Token 过期

当收到 401 错误时，应使用 Refresh Token 刷新 Access Token：

```javascript
// 伪代码
if (response.code === 401) {
  const newTokens = await refreshToken(refreshToken);
  // 使用新 token 重试请求
  return retryRequest(newTokens.accessToken);
}
```

#### 2. 参数验证失败

确保所有必填参数都已提供，且格式正确：

```json
{
  "code": 400,
  "message": "device_sn and pet_id required",
  "data": null
}
```

#### 3. 资源不存在

检查请求的资源 ID 是否正确：

```json
{
  "code": 404,
  "message": "Pet not found",
  "data": null
}
```

---

## 附录

### 数据模型

#### User（用户）
```typescript
{
  id: number;
  openid: string;
  nickname: string;
  avatar: string;
  phone?: string;
  created_at: Date;
  updated_at: Date;
}
```

#### Pet（宠物）
```typescript
{
  id: number;
  user_id: number;
  name: string;
  avatar?: string;
  breed?: string;
  birthday?: Date;
  gender: 'male' | 'female';
  weight?: number;
  device_id?: number;
  created_at: Date;
  updated_at: Date;
}
```

#### Device（设备）
```typescript
{
  id: number;
  device_sn: string;
  pet_id?: number;
  battery_level: number;
  is_online: boolean;
  last_online_at?: Date;
  created_at: Date;
  updated_at: Date;
}
```

#### Moment（朋友圈）
```typescript
{
  id: number;
  user_id: number;
  pet_id?: number;
  content?: string;
  images: string[];
  is_public: boolean;
  like_count: number;
  comment_count: number;
  created_at: Date;
  updated_at: Date;
}
```

#### ChatMessage（聊天消息）
```typescript
{
  id: number;
  pet_id: number;
  role: 'user' | 'assistant';
  content: string;
  created_at: Date;
}
```

---

## 更新日志

### v1.0.0 (2026-01-18)
- 初始版本
- 实现所有核心 API 接口
- 完成接口测试和文档编写

---

**文档维护**: 请在修改 API 时同步更新此文档

**技术支持**: 如有问题，请联系开发团队
