# 我的页面 (my)

## 页面路径
`pages/my/my`

## 页面功能
个人中心页面，展示用户信息、快捷功能入口、已绑定设备和设置选项。

## 文件结构
- `my.wxml` - 页面结构
- `my.wxss` - 页面样式
- `my.js` - 页面逻辑
- `my.json` - 页面配置

## 主要功能

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：我的
- 无返回按钮（作为 TabBar 页面）
- 白色背景

### 2. 个人信息卡片
- 橙色渐变背景
- 头像显示（使用 `/images/pet.png`）
- 用户昵称和 ID
- 编辑资料按钮（点击跳转到编辑资料页面）

### 3. 快捷功能
- 5个功能入口
- 绑定设备、AI聊天、运动轨迹、成长日志、电池状态
- 点击跳转到对应页面
- AI聊天使用 switchTab 跳转（TabBar 页面）

### 4. 已绑定设备列表
- 显示所有已绑定的设备
- 每个设备显示：设备编号、IMEI号、绑定时间
- 从本地存储读取设备列表
- 页面显示时自动刷新

### 5. 设置选项
- 隐私设置（跳转到隐私设置页面）
- 关于我们（跳转到关于我们页面）

### 6. 退出登录
- 红色文字按钮
- 点击弹出确认对话框
- 确认后显示退出成功提示

## 关键代码

### JS 数据结构
```javascript
data: {
  userInfo: {
    name: '豆包主人',
    id: '10086'
  },
  features: [
    { id: 'bind', name: '绑定设备', icon: '/images/bind.png', color: '#FFF3E0', url: '/pages/bind/bind' },
    { id: 'chat', name: 'AI聊天', icon: '/images/chat-active.png', color: '#FFE4E1', url: '/pages/chat/chat' },
    { id: 'activity', name: '运动轨迹', icon: '/images/petc.png', color: '#E8F5E9', url: '/pages/activity/activity' },
    { id: 'diary', name: '成长日志', icon: '/images/diary.png', color: '#F3E5F5', url: '/pages/diary/diary' },
    { id: 'battery', name: '电池状态', icon: '/images/battery.png', color: '#E3F2FD', url: '/pages/battery/battery' }
  ],
  devices: []
}
```

### 设备列表加载
```javascript
onShow() {
  this.loadDevices()
},

loadDevices() {
  const devices = wx.getStorageSync('boundDevices') || []
  this.setData({ devices })
}
```

## TabBar 配置
- 已添加到底部 TabBar
- 图标：`/images/my.png`
- 位置：第4个标签

## 样式特点
- 橙色渐变个人信息卡片
- 白色菜单列表
- 统一浅橙色背景(#FFF3E0)的图标
- 图标 + 文字 + 箭头的菜单项布局
- 红色退出登录按钮
- 设备列表卡片式布局

## 最近更新
- 设置选项图标改为图片图标,统一浅橙色背景
  - 隐私设置: /images/privacy.png
  - 关于我们: /images/about.png
- 快捷功能图标统一使用浅橙色背景(#FFF3E0)
- 快捷功能图标从 emoji 改为图片图标
  - 绑定设备: /images/bind.png
  - AI聊天: /images/chat-active.png
  - 运动轨迹: /images/petc.png
  - 成长日志: /images/diary.png
  - 电池状态: /images/battery.png
- 添加了绑定设备入口到快捷功能（第1个位置）
- 添加了已绑定设备列表显示
- 页面显示时自动加载设备列表
- AI聊天改为 TabBar 页面，使用 switchTab 跳转
