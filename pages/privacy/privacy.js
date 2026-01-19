// pages/privacy/privacy.js
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

  onActivityChange(e) {
    this.setData({
      'settings.activity': e.detail.value
    })
  },

  onMomentsVisibleChange(e) {
    this.setData({
      'settings.momentsVisible': e.detail.value
    })
  },

  changePassword() {
    wx.showToast({
      title: '功能开发中',
      icon: 'none'
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

  stopPropagation() {
    // 阻止事件冒泡
  }
})
