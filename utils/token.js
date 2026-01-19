const TOKEN_KEY = 'access_token'
const REFRESH_TOKEN_KEY = 'refresh_token'

module.exports = {
  getToken() {
    return wx.getStorageSync(TOKEN_KEY)
  },

  setToken(token) {
    wx.setStorageSync(TOKEN_KEY, token)
  },

  getRefreshToken() {
    return wx.getStorageSync(REFRESH_TOKEN_KEY)
  },

  setRefreshToken(token) {
    wx.setStorageSync(REFRESH_TOKEN_KEY, token)
  },

  clearTokens() {
    wx.removeStorageSync(TOKEN_KEY)
    wx.removeStorageSync(REFRESH_TOKEN_KEY)
  }
}
