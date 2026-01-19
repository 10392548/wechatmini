# 宠物项圈微信小程序 - 开发文档

## 项目概述
宠物智能项圈管理小程序，提供设备绑定、宠物社交、运动追踪等功能。

## 页面列表

| 页面 | 路径 | 功能 | TabBar |
|------|------|------|--------|
| 首页 | pages/index/index | 主页面（聚合各功能数据） | ✓ |
| 绑定 | pages/bind/bind | IMEI设备绑定 + AI聊天入口 | ✓ |
| 朋友圈 | pages/moments/moments | 宠物社交动态 | ✓ |
| 我的 | pages/my/my | 个人中心 | ✓ |
| 编辑资料 | pages/profile/profile | 资料编辑 | - |
| 关于我们 | pages/about/about | 应用介绍 | - |
| 隐私设置 | pages/privacy/privacy | 隐私和安全设置 | - |
| AI聊天 | pages/chat/chat | 宠物AI对话 | - |
| 运动轨迹 | pages/activity/activity | 运动数据展示 | - |
| 成长日志 | pages/diary/diary | 每日记录 | - |
| 电池状态 | pages/battery/battery | 电量管理 | - |

## 技术要点

### 1. Skyline 渲染器兼容
- 不支持 `scroll-view` 的 flex 布局，使用普通 `view` 替代
- 不支持 CSS `gap` 属性，使用 `margin` 替代

### 2. 统一布局模式
所有页面采用统一的布局结构：
```xml
<navigation-bar title="标题" back="{{true/false}}" color="black" background="#FFF"></navigation-bar>
<view class="page-content">
  <!-- 页面内容 -->
</view>
```

### 3. 样式规范
```css
page {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #fff;
}

.page-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
}
```

### 4. 图片资源
- 头像：`/images/pet.png`
- 点赞图标：`/images/Like.png`
- 评论图标：`/images/Comment.png`

**注意：文件名区分大小写**

## 文档目录

- [index-首页.md](./index-首页.md) - 主页面（聚合各功能数据）
- [bind-绑定页面.md](./bind-绑定页面.md) - IMEI设备绑定 + AI聊天入口
- [moments-朋友圈页面.md](./moments-朋友圈页面.md) - 宠物社交动态
- [my-我的页面.md](./my-我的页面.md) - 个人中心
- [profile-编辑资料页面.md](./profile-编辑资料页面.md) - 资料编辑
- [about-关于我们页面.md](./about-关于我们页面.md) - 应用介绍
- [privacy-隐私设置页面.md](./privacy-隐私设置页面.md) - 隐私和安全设置
- [chat-AI聊天页面.md](./chat-AI聊天页面.md) - AI对话功能
- [activity-运动轨迹页面.md](./activity-运动轨迹页面.md) - 运动数据
- [diary-成长日志页面.md](./diary-成长日志页面.md) - 每日记录
- [battery-电池状态页面.md](./battery-电池状态页面.md) - 电量管理

## 主题色
- 主色：`#FF8C00`（橙色）
- 选中色：`#FF8C00`
- 文字色：`#333`
- 次要文字：`#999`
- 链接色：`#576b95`（蓝色）
- 点赞高亮：`#FF6B6B`（红色）
