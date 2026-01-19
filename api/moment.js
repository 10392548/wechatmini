const request = require('../utils/request')

module.exports = {
  // 获取朋友圈列表
  getMomentList(page = 1, limit = 20) {
    return request.get('/api/moment', { page, limit })
  },

  // 创建朋友圈（需要使用 wx.uploadFile）
  createMoment(content, pet_id, is_public, images) {
    // 注意：图片上传需要特殊处理
    return request.post('/api/moment', { content, pet_id, is_public, images })
  },

  // 点赞
  likeMoment(momentId) {
    return request.post(`/api/moment/${momentId}/like`)
  },

  // 取消点赞
  unlikeMoment(momentId) {
    return request.delete(`/api/moment/${momentId}/like`)
  },

  // 评论
  commentMoment(momentId, content) {
    return request.post(`/api/moment/${momentId}/comment`, { content })
  },

  // 获取评论列表
  getComments(momentId) {
    return request.get(`/api/moment/${momentId}/comments`)
  }
}
