# 隐私设置页面 (privacy)

## 页面路径
`pages/privacy/privacy`

## 页面功能
隐私设置页面，管理数据收集、隐私保护和账号安全设置。

## 文件结构
- `privacy.wxml` - 页面结构
- `privacy.wxss` - 页面样式
- `privacy.js` - 页面逻辑
- `privacy.json` - 页面配置

## 主要功能

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：隐私设置
- 带返回按钮
- 白色背景

### 2. 数据收集设置
- 位置信息开关（用于追踪宠物位置）
- 运动数据开关（用于分析宠物运动情况）

### 3. 隐私保护设置
- 朋友圈可见开关（允许其他用户查看我的动态）

### 4. 账号安全
- 修改密码
- 清除缓存

### 5. 隐私政策
- 查看隐私政策链接
- 点击后弹出模态框显示隐私政策内容
- 模态框支持滚动查看完整内容

## 关键代码

### WXML 结构
```xml
<navigation-bar title="隐私设置" back="{{true}}" color="black" background="#FFF"></navigation-bar>
<view class="page-content">
  <!-- 数据收集 -->
  <view class="section-card">
    <view class="section-title">数据收集</view>
    <view class="setting-list">
      <view class="setting-item">
        <view class="setting-info">
          <text class="setting-name">位置信息</text>
          <text class="setting-desc">用于追踪宠物位置</text>
        </view>
        <switch checked="{{settings.location}}" bindchange="onLocationChange" color="#FF8C00"/>
      </view>
    </view>
  </view>

  <!-- 隐私政策链接 -->
  <view class="privacy-link" bindtap="viewPrivacyPolicy">
    <text>查看隐私政策</text>
  </view>
</view>

<!-- 隐私政策模态框 -->
<view class="modal" wx:if="{{showModal}}" bindtap="closeModal">
  <view class="modal-content" catchtap="stopPropagation">
    <view class="modal-header">
      <text class="modal-title">隐私政策</text>
      <text class="modal-close" bindtap="closeModal">×</text>
    </view>
    <scroll-view class="modal-body" scroll-y>
      <text class="policy-text">隐私政策内容...</text>
    </scroll-view>
  </view>
</view>
```

### JS 逻辑
```javascript
Page({
  data: {
    settings: {
      location: true,
      activity: true,
      momentsVisible: true
    },
    showModal: false
  },

  onLocationChange(e) {
    this.setData({
      'settings.location': e.detail.value
    })
  },

  viewPrivacyPolicy() {
    this.setData({
      showModal: true
    })
  },

  closeModal() {
    this.setData({
      showModal: false
    })
  },

  clearCache() {
    wx.showModal({
      title: '提示',
      content: '确定要清除缓存吗？',
      success: (res) => {
        if (res.confirm) {
          wx.showToast({
            title: '缓存已清除',
            icon: 'success'
          })
        }
      }
    })
  }
})
```

## 样式特点
- 白色卡片式布局
- Switch 开关组件（橙色主题）
- 设置项带说明文字
- 菜单项右箭头
- 全屏模态框，半透明黑色遮罩
- 模态框内容可滚动

## 最近更新
- 删除了"位置共享"功能
- 添加了隐私政策模态框功能
