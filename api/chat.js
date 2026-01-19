const request = require('../utils/request')

module.exports = {
  // 发送消息
  sendMessage(pet_id, content) {
    return request.post('/api/chat/send', { pet_id, content })
  },

  // 获取聊天历史
  getChatHistory(petId, limit = 50) {
    return request.get(`/api/chat/history/${petId}`, { limit })
  }
}
