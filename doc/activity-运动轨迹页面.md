# 运动轨迹页面 (activity)

## 页面路径
`pages/activity/activity`

## 页面功能
宠物运动数据展示页面，显示卡路里消耗、活跃时间、步数等运动数据。

## 文件结构
- `activity.wxml` - 页面结构
- `activity.wxss` - 页面样式
- `activity.js` - 页面逻辑
- `activity.json` - 页面配置

## 主要修改内容

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：运动轨迹
- 带返回按钮
- 白色背景

### 2. 卡路里卡片
- 今日消耗数值展示
- 单位：kcal
- 同比昨天对比数据

### 3. 图表区域
- Canvas 绑定 `calorieChart`
- 时间轴标签（06:00 - 21:00）

### 4. 统计卡片
- 活跃时间（蓝色卡片）
- 行走步数（紫色卡片）

### 5. 状态详情
- 奔跑记录（时间段、消耗卡路里）
- 深度睡眠记录（时间段、评分）

## 关键代码

### WXML 结构
```xml
<navigation-bar title="运动轨迹" back="{{true}}" color="black" background="#FFF"></navigation-bar>
<view class="page-content">
  <view class="calorie-card">
    <text class="label">今日消耗</text>
    <view class="value-row">
      <text class="value">1,280</text>
      <text class="unit">kcal</text>
    </view>
    <text class="compare">+12% 同比昨天</text>
  </view>

  <view class="chart-container">
    <canvas canvas-id="calorieChart" class="chart-canvas"></canvas>
    <view class="time-labels">
      <text>06:00</text>
      <text>09:00</text>
      <text>12:00</text>
      <text>15:00</text>
      <text>18:00</text>
      <text>21:00</text>
    </view>
  </view>

  <view class="stats-row">
    <view class="stat-card blue">
      <text class="stat-icon">⏱</text>
      <text class="stat-label">活跃时间</text>
      <text class="stat-value">4.5 小时</text>
    </view>
    <view class="stat-card purple">
      <text class="stat-icon">👣</text>
      <text class="stat-label">行走步数</text>
      <text class="stat-value">12,482 步</text>
    </view>
  </view>

  <view class="detail-section">
    <text class="section-title">状态详情</text>
    <view class="detail-list">
      <view class="detail-item">
        <view class="detail-icon green">🏃</view>
        <view class="detail-info">
          <text class="detail-name">奔跑</text>
          <text class="detail-time">12:30 - 13:10</text>
        </view>
        <text class="detail-value">420 kcal</text>
      </view>
      <view class="detail-item">
        <view class="detail-icon yellow">🌙</view>
        <view class="detail-info">
          <text class="detail-name">深度睡眠</text>
          <text class="detail-time">01:00 - 07:00</text>
        </view>
        <text class="detail-value">76% 评分</text>
      </view>
    </view>
  </view>
</view>
```

## 样式特点
- 卡片式布局
- 多彩统计卡片（蓝色、紫色）
- 详情列表带图标
- Canvas 图表展示
