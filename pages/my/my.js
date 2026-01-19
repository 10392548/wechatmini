// pages/my/my.js
const api = require('../../api/index')
const tokenManager = require('../../utils/token')

Page({
  data: {
    userInfo: {
      name: '加载中...',
      id: ''
    },
    features: [
      { id: 'bind', name: '绑定设备', icon: '/images/bind.png', color: '#FFF3E0', url: '/pages/bind/bind' },
      { id: 'chat', name: 'AI聊天', icon: '/images/chat-active.png', color: '#FFF3E0', url: '/pages/chat/chat' },
      { id: 'activity', name: '运动轨迹', icon: '/images/petc.png', color: '#FFF3E0', url: '/pages/activity/activity' },
      { id: 'diary', name: '成长日志', icon: '/images/diary.png', color: '#FFF3E0', url: '/pages/diary/diary' },
      { id: 'battery', name: '电池状态', icon: '/images/battery.png', color: '#FFF3E0', url: '/pages/battery/battery' }
    ],
    devices: []
  },

  async onShow() {
    await this.loadUserInfo()
    await this.loadDevices()
  },

  async loadUserInfo() {
    try {
      const app = getApp()
      if (app.globalData.userInfo) {
        this.setData({
          userInfo: {
            name: app.globalData.userInfo.nickname,
            id: app.globalData.userInfo.id.toString()
          }
        })
      } else {
        const user = await api.user.getProfile()
        app.globalData.userInfo = user
        this.setData({
          userInfo: {
            name: user.nickname,
            id: user.id.toString()
          }
        })
      }
    } catch (error) {
      console.error('加载用户信息失败', error)
    }
  },

  async loadDevices() {
    try {
      const pets = await api.pet.getPetList()
      const devices = pets
        .filter(pet => pet.device)
        .map(pet => ({
          id: pet.device.id,
          imei: pet.device.imei,
          petName: pet.name,
          battery: pet.device.battery_level || 0
        }))
      this.setData({ devices })
    } catch (error) {
      console.error('加载设备列表失败', error)
    }
  },

  editProfile() {
    wx.navigateTo({
      url: '/pages/profile/profile'
    })
  },

  onFeatureTap(e) {
    const url = e.currentTarget.dataset.url
    if (url === '/pages/chat/chat') {
      wx.switchTab({ url })
    } else {
      wx.navigateTo({ url })
    }
  },

  goToPrivacy() {
    wx.navigateTo({
      url: '/pages/privacy/privacy'
    })
  },

  goToAbout() {
    wx.navigateTo({
      url: '/pages/about/about'
    })
  },

  logout() {
    wx.showModal({
      title: '提示',
      content: '确定要退出登录吗？',
      success: (res) => {
        if (res.confirm) {
          tokenManager.clearToken()
          tokenManager.clearRefreshToken()
          const app = getApp()
          app.globalData.userInfo = null
          app.globalData.currentPet = null
          wx.reLaunch({ url: '/pages/login/login' })
        }
      }
    })
  }
})
