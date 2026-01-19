// app.js
const tokenManager = require('./utils/token')

App({
  globalData: {
    userInfo: null,
    currentPet: null
  },

  onLaunch() {
    // 检查登录状态
    const token = tokenManager.getToken()
    if (!token) {
      // 未登录，跳转到登录页
      wx.reLaunch({ url: '/pages/login/login' })
    }
  }
})

