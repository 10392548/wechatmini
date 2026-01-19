# 绑定页面 (bind)

## 页面路径
`pages/bind/bind`

## 页面功能
IMEI设备绑定页面，用户输入设备背面的IMEI号码进行设备绑定。

## 文件结构
- `bind.wxml` - 页面结构
- `bind.wxss` - 页面样式
- `bind.js` - 页面逻辑
- `bind.json` - 页面配置

## 主要修改内容

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：添加新设备
- 带返回按钮
- 白色背景

### 2. 动画效果
- 橙色脉冲圆圈动画
- 芯片图标居中显示
- 使用 CSS `@keyframes` 实现脉冲扩散效果

### 3. 输入卡片
- WiFi信号图标
- IMEI输入框（最大15位）
- 绑定按钮（输入为空时禁用）

### 4. 样式特点
- 使用 `page-content` + `content-wrapper` 布局模式
- 内容居中聚拢显示
- 适配 Skyline 渲染器

## 关键代码

### WXML 结构
```xml
<navigation-bar title="添加新设备" back="{{true}}" color="black" background="#FFF"></navigation-bar>
<view class="page-content">
  <view class="content-wrapper">
    <!-- 动画圆圈区域 -->
    <view class="circle-wrapper">
      <view class="pulse-ring"></view>
      <view class="pulse-ring delay"></view>
      <view class="icon-circle">...</view>
    </view>
    <!-- 输入卡片 -->
    <view class="input-card">
      <input class="imei-input" placeholder="请输入IMEI号码"/>
      <button class="bind-btn">绑定</button>
    </view>
  </view>
</view>
```

### CSS 布局模式
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
  align-items: center;
  justify-content: center;
}
```

## 注意事项
- Skyline 渲染器不支持 `scroll-view` 的 flex 布局，使用普通 `view` 替代
- 使用 `margin` 替代 `gap` 属性（Skyline 不支持 gap）

## AI聊天入口
在绑定页面底部添加了AI聊天入口：
- 使用图标 `/images/chat-active.png`
- 点击跳转到AI聊天页面
- 样式：灰色背景卡片，居中布局

### AI聊天入口代码
```xml
<view class="chat-entry" bindtap="goToChat">
  <image class="chat-icon" src="/images/chat-active.png"></image>
  <text class="chat-text">与宠物AI聊天</text>
</view>
```

```javascript
goToChat() {
  wx.navigateTo({
    url: '/pages/chat/chat'
  })
}
```
