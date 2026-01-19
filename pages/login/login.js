// 登录页面
const api = require('../../api/index')
const tokenManager = require('../../utils/token')

Page({
  data: {
    userInfo: null
  },

  async onLogin() {
    try {
      // 1. 先获取用户信息（必须在点击事件中同步调用）
      const { userInfo } = await wx.getUserProfile({
        desc: '用于完善用户资料'
      })

      console.log('[登录] 获取用户信息成功:', userInfo)

      // 2. 获取微信登录 code
      const { code } = await wx.login()

      console.log('[登录] 获取 code 成功:', {
        hasCode: !!code,
        codeLength: code?.length,
        codePreview: code?.substring(0, 15) + '...'
      })

      // 3. 调用后端登录接口（request.js 会自动显示 loading）
      const result = await api.auth.login(
        code,
        userInfo.nickName,
        userInfo.avatarUrl
      )

      console.log('[登录] 后端返回成功:', result)

      const { accessToken, refreshToken, user } = result

      // 4. 保存 token
      tokenManager.setToken(accessToken)
      tokenManager.setRefreshToken(refreshToken)

      // 5. 保存用户信息到全局
      const app = getApp()
      app.globalData.userInfo = user

      wx.showToast({ title: '登录成功', icon: 'success' })

      // 6. 跳转到首页
      setTimeout(() => {
        wx.switchTab({ url: '/pages/index/index' })
      }, 1500)
    } catch (error) {
      console.error('[登录] 登录失败:', error)
      wx.showToast({ title: '登录失败: ' + (error.message || '未知错误'), icon: 'none' })
    }
  }
})
