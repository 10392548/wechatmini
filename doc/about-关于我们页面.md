# 关于我们页面 (about)

## 页面路径
`pages/about/about`

## 页面功能
应用介绍页面，展示应用信息、功能特点和联系方式。

## 文件结构
- `about.wxml` - 页面结构
- `about.wxss` - 页面样式
- `about.js` - 页面逻辑
- `about.json` - 页面配置

## 主要内容

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：关于我们
- 带返回按钮
- 白色背景
- 使用 `scroll-view` 支持内容滚动

### 2. Logo 区域
- 应用 Logo 展示
- 应用名称：宠物项圈
- 版本号：1.0.0

### 3. 应用介绍
- 应用简介文字
- 介绍智能项圈的核心功能

### 4. 功能特点
- 设备绑定管理 📱
- 运动轨迹追踪 🏃
- 电池状态监控 🔋
- 成长日志记录 📔

### 5. 联系我们
- 客服电话：400-888-8888
- 客服邮箱：support@petcollar.com

### 6. 版权信息
- © 2026 宠物项圈 All Rights Reserved

## 关键代码

### WXML 结构
```xml
<navigation-bar title="关于我们" back="{{true}}" color="black" background="#FFF"></navigation-bar>
<scroll-view class="page-content" scroll-y>
  <!-- Logo -->
  <view class="logo-section">
    <image class="app-logo" src="/images/pet.png"></image>
    <view class="app-name">宠物项圈</view>
    <view class="app-version">版本 1.0.0</view>
  </view>

  <!-- 应用介绍 -->
  <view class="section-card">
    <view class="section-title">应用介绍</view>
    <text class="intro-text">宠物项圈是一款专为宠物主人打造的智能管理应用...</text>
  </view>

  <!-- 功能特点 -->
  <view class="section-card">
    <view class="feature-list">
      <view class="feature-item">
        <text class="feature-icon">📱</text>
        <text class="feature-text">设备绑定管理</text>
      </view>
    </view>
  </view>
</scroll-view>
```

## 样式特点
- 白色卡片式布局
- Logo 居中展示
- 功能列表带图标
- 联系方式左右布局

## 最近更新
- 修复了页面滚动问题，将 `view` 改为 `scroll-view` 以支持内容滚动
