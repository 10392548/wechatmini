# 电池状态页面 (battery)

## 页面路径
`pages/battery/battery`

## 页面功能
宠物项圈电池状态页面，显示电量、省电模式和耗电排行。

## 文件结构
- `battery.wxml` - 页面结构
- `battery.wxss` - 页面样式
- `battery.js` - 页面逻辑
- `battery.json` - 页面配置

## 主要修改内容

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：电池状态
- 带返回按钮
- 白色背景

### 2. 电池圆环
- Canvas 绘制电量圆环
- 中心显示电量百分比
- 电池状态文字

### 3. 省电模式
- 超级省电模式开关
- Switch 组件控制
- 橙色主题色（#FF8C00）

### 4. 耗电排行
- GPS定位耗电占比
- 传感器耗电占比
- 进度条可视化展示

## 关键代码

### WXML 结构
```xml
<navigation-bar title="电池状态" back="{{true}}" color="black" background="#FFF"></navigation-bar>
<view class="page-content">
  <view class="battery-section">
    <view class="battery-circle">
      <canvas canvas-id="batteryCanvas" class="canvas"></canvas>
      <view class="battery-info">
        <text class="battery-percent">{{battery}}%</text>
        <text class="battery-status">{{status}}</text>
      </view>
    </view>
  </view>

  <view class="content">
    <view class="power-mode">
      <view class="mode-icon">🔋</view>
      <view class="mode-info">
        <text class="mode-title">超级省电模式</text>
        <text class="mode-desc">保证重要基本功能</text>
      </view>
      <switch checked="{{powerSaveMode}}" bindchange="togglePowerMode" color="#FF8C00"/>
    </view>

    <view class="usage-section">
      <text class="section-title">耗电排行</text>
      <view class="usage-item">
        <view class="usage-info">
          <text class="usage-name">GPS定位</text>
          <text class="usage-percent">65%</text>
        </view>
        <view class="progress-bar">
          <view class="progress-fill blue" style="width: 65%"></view>
        </view>
      </view>
      <view class="usage-item">
        <view class="usage-info">
          <text class="usage-name">传感器</text>
          <text class="usage-percent">20%</text>
        </view>
        <view class="progress-bar">
          <view class="progress-fill orange" style="width: 20%"></view>
        </view>
      </view>
    </view>
  </view>
</view>
```

### JS 数据和方法
```javascript
Page({
  data: {
    battery: 85,
    status: '电量充足',
    powerSaveMode: false
  },
  onLoad() {
    this.drawBatteryCircle()
  },
  drawBatteryCircle() {
    // Canvas 绘制电量圆环
  },
  togglePowerMode(e) {
    this.setData({
      powerSaveMode: e.detail.value
    })
  }
})
```

## 样式特点
- 圆环电量展示（Canvas）
- Switch 开关组件
- 进度条可视化
- 多彩进度条（蓝色、橙色）
