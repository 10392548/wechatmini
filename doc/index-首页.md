# 首页 (index)

## 页面路径
`pages/index/index`

## 页面功能
首页是小程序的主入口,聚合展示宠物信息、今日数据、电池状态、快捷功能、最新动态和今日日志。

## 文件结构
- `index.wxml` - 页面结构
- `index.wxss` - 页面样式
- `index.js` - 页面逻辑
- `index.json` - 页面配置

## 主要功能

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：宠物项圈
- 无返回按钮（作为 TabBar 页面）
- 白色背景

### 2. 宠物信息卡片
- 橙色渐变背景
- 显示宠物头像、名称、状态
- 显示电池电量百分比

### 3. 今日数据
- 消耗热量（kcal）
- 活跃时间（小时）
- 行走步数（步）
- 点击跳转到运动轨迹页面

### 4. 电池状态
- 显示当前电量百分比
- 电量进度条
- 预计续航天数
- 耗电详情（GPS定位、传感器）
- 点击跳转到电池状态页面

### 5. 快捷功能
- 4个功能入口
- AI聊天、运动轨迹、成长日志、电池状态
- 统一浅橙色背景(#FFF3E0)
- 使用图片图标
- AI聊天使用 switchTab 跳转（TabBar 页面）

### 6. 最新动态
- 显示朋友圈最新一条动态
- 显示用户昵称、发布时间、内容
- 显示点赞数和评论数
- 点击跳转到朋友圈页面

### 7. 今日日志
- 显示今天的3条日志记录
- 每条日志显示时间、标题、描述
- 点击跳转到成长日志页面

## 关键代码

### JS 数据结构
```javascript
data: {
  pet: {
    name: '豆包',
    status: '在家开心',
    battery: 85
  },
  batteryEstimate: 3,
  todayStats: {
    calories: '1,280',
    activeTime: '4.5',
    steps: '12,482'
  },
  features: [
    { id: 'chat', name: 'AI聊天', icon: '/images/chat-active.png', color: '#FFF3E0', url: '/pages/chat/chat' },
    { id: 'activity', name: '运动轨迹', icon: '/images/petc.png', color: '#FFF3E0', url: '/pages/activity/activity' },
    { id: 'diary', name: '成长日志', icon: '/images/diary.png', color: '#FFF3E0', url: '/pages/diary/diary' },
    { id: 'battery', name: '电池状态', icon: '/images/battery.png', color: '#FFF3E0', url: '/pages/battery/battery' }
  ]
}
```

### 快捷功能点击处理
```javascript
onFeatureTap(e) {
  const url = e.currentTarget.dataset.url
  if (url === '/pages/chat/chat') {
    wx.switchTab({ url })
  } else {
    wx.navigateTo({ url })
  }
}
```

## TabBar 配置
- 已添加到底部 TabBar
- 图标：`/images/home.png`
- 位置：第1个标签

## 样式特点
- 橙色渐变宠物信息卡片
- 白色内容卡片
- 统一浅橙色背景(#FFF3E0)的快捷功能图标
- 网格布局的快捷功能
- 卡片式布局

## 最近更新
- 快捷功能图标统一使用浅橙色背景(#FFF3E0)
- 快捷功能图标从 emoji 改为图片图标
  - AI聊天: /images/chat-active.png
  - 运动轨迹: /images/petc.png
  - 成长日志: /images/diary.png
  - 电池状态: /images/battery.png
- AI聊天改为 TabBar 页面，使用 switchTab 跳转
- 聚合展示各功能模块的数据
