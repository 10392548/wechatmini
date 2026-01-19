# 成长日志页面 (diary)

## 页面路径
`pages/diary/diary`

## 页面功能
宠物成长日志页面，记录宠物每日活动和健康报告。

## 文件结构
- `diary.wxml` - 页面结构
- `diary.wxss` - 页面样式
- `diary.js` - 页面逻辑
- `diary.json` - 页面配置

## 主要修改内容

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：成长日志
- 带返回按钮
- 白色背景

### 2. 标签切换
- 每日回顾
- 健康报告
- 点击切换不同内容

### 3. 时间线列表
- 日志卡片展示
- 左侧图标（emoji + 背景色）
- 右侧内容（时间、标题、描述）
- 不同类型卡片有不同背景色

## 关键代码

### WXML 结构
```xml
<navigation-bar title="成长日志" back="{{true}}" color="black" background="#FFF"></navigation-bar>
<view class="page-content">
  <!-- 标签切换 -->
  <view class="tabs-container">
    <view class="tab-item {{activeTab === 0 ? 'active' : ''}}" data-index="0" bindtap="onTabChange">每日回顾</view>
    <view class="tab-item {{activeTab === 1 ? 'active' : ''}}" data-index="1" bindtap="onTabChange">健康报告</view>
  </view>

  <!-- 时间线列表 -->
  <view class="diary-list">
    <block wx:if="{{activeTab === 0}}">
      <view class="diary-item" wx:for="{{diaryList}}" wx:key="id" style="background: {{item.bgColor}};">
        <view class="item-left">
          <view class="icon-wrapper" style="background: {{item.iconColor}};">{{item.emoji}}</view>
        </view>
        <view class="item-content">
          <view class="item-time">{{item.time}}</view>
          <view class="item-title">{{item.title}}</view>
          <view class="item-desc">{{item.description}}</view>
        </view>
      </view>
    </block>
    <block wx:if="{{activeTab === 1}}">
      <view class="diary-item" wx:for="{{healthReports}}" wx:key="id" style="background: {{item.bgColor}};">
        <view class="item-left">
          <view class="icon-wrapper" style="background: {{item.iconColor}};">{{item.emoji}}</view>
        </view>
        <view class="item-content">
          <view class="item-time">{{item.time}}</view>
          <view class="item-title">{{item.title}}</view>
          <view class="item-desc">{{item.description}}</view>
        </view>
      </view>
    </block>
  </view>
</view>
```

### JS 数据结构
```javascript
Page({
  data: {
    activeTab: 0,
    diaryList: [
      {
        id: 1,
        emoji: '🐕',
        iconColor: '#FFE4B5',
        bgColor: '#FFF8E7',
        time: '08:30',
        title: '早起散步',
        description: '在小区公园散步30分钟'
      }
      // ...
    ],
    healthReports: [
      // 健康报告数据
    ]
  },
  onTabChange(e) {
    const index = e.currentTarget.dataset.index
    this.setData({ activeTab: parseInt(index) })
  }
})
```

## 样式特点
- 标签切换高亮效果
- 时间线卡片布局
- 动态背景色（通过 style 绑定）
- 图标圆形背景
