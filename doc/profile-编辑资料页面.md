# 编辑资料页面 (profile)

## 页面路径
`pages/profile/profile`

## 页面功能
用户资料编辑页面，支持修改个人信息和宠物信息。

## 文件结构
- `profile.wxml` - 页面结构
- `profile.wxss` - 页面样式
- `profile.js` - 页面逻辑
- `profile.json` - 页面配置

## 主要功能

### 1. 页面布局
- 使用 `navigation-bar` 组件作为顶部导航栏
- 标题：编辑资料
- 带返回按钮
- 白色背景

### 2. 头像编辑
- 显示当前头像
- 点击可选择新头像
- 使用 `wx.chooseImage` 选择图片

### 3. 基本信息编辑
- 昵称（可编辑）
- ID（只读显示）
- 手机号（可编辑）

### 4. 宠物信息编辑
- 宠物名称（可编辑）
- 品种（可编辑）
- 年龄（可编辑）

### 5. 保存功能
- 保存按钮（橙色渐变）
- 保存成功后返回上一页

## 关键代码

### WXML 结构
```xml
<navigation-bar title="编辑资料" back="{{true}}" color="black" background="#FFF"></navigation-bar>
<view class="page-content">
  <!-- 头像 -->
  <view class="section">
    <view class="avatar-section" bindtap="chooseAvatar">
      <image class="avatar-preview" src="{{userInfo.avatar}}"></image>
      <text class="avatar-tip">点击更换头像</text>
    </view>
  </view>

  <!-- 基本信息 -->
  <view class="section">
    <view class="form-list">
      <view class="form-item">
        <text class="form-label">昵称</text>
        <input class="form-input" value="{{userInfo.name}}" bindinput="onNameInput"/>
      </view>
      <view class="form-item">
        <text class="form-label">ID</text>
        <text class="form-value">{{userInfo.id}}</text>
      </view>
    </view>
  </view>

  <!-- 宠物信息 -->
  <view class="section">
    <view class="form-list">
      <view class="form-item">
        <text class="form-label">宠物名称</text>
        <input class="form-input" value="{{petInfo.name}}" bindinput="onPetNameInput"/>
      </view>
    </view>
  </view>

  <!-- 保存按钮 -->
  <view class="save-btn" bindtap="saveProfile">
    <text>保存</text>
  </view>
</view>
```

### JS 逻辑
```javascript
Page({
  data: {
    userInfo: {
      avatar: '/images/pet.png',
      name: '豆包主人',
      id: '10086',
      phone: '138****8888'
    },
    petInfo: {
      name: '豆包',
      breed: '哈士奇',
      age: '2岁'
    }
  },

  chooseAvatar() {
    wx.chooseImage({
      count: 1,
      sizeType: ['compressed'],
      sourceType: ['album', 'camera'],
      success: (res) => {
        this.setData({
          'userInfo.avatar': res.tempFilePaths[0]
        })
      }
    })
  },

  onNameInput(e) {
    this.setData({
      'userInfo.name': e.detail.value
    })
  },

  saveProfile() {
    wx.showToast({
      title: '保存成功',
      icon: 'success'
    })
    setTimeout(() => {
      wx.navigateBack()
    }, 1500)
  }
})
```

## 样式特点
- 白色卡片式表单
- 头像居中显示
- 表单项左右布局（标签 + 输入框）
- 橙色渐变保存按钮

## 交互流程
1. 从"我的"页面点击"编辑资料"进入
2. 修改各项信息
3. 点击保存按钮
4. 显示保存成功提示
5. 自动返回上一页
