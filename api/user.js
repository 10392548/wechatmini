const request = require('../utils/request')

module.exports = {
  // 获取用户信息
  getProfile() {
    return request.get('/api/user/profile')
  },

  // 更新用户信息
  updateProfile(data) {
    return request.put('/api/user/profile', data)
  }
}
