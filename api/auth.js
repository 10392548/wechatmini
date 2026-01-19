const request = require('../utils/request')

module.exports = {
  // 登录
  login(code, nickname, avatar) {
    return request.post('/api/auth/login', { code, nickname, avatar })
  },

  // 刷新 token
  refreshToken(refreshToken) {
    return request.post('/api/auth/refresh', { refreshToken })
  }
}
