const request = require('../utils/request')

module.exports = {
  // 获取宠物列表
  getPetList() {
    return request.get('/api/pet')
  },

  // 创建宠物
  createPet(data) {
    return request.post('/api/pet', data)
  },

  // 更新宠物信息
  updatePet(id, data) {
    return request.put(`/api/pet/${id}`, data)
  },

  // 删除宠物
  deletePet(id) {
    return request.delete(`/api/pet/${id}`)
  },

  // 获取今日统计数据
  getTodayStats(petId) {
    return request.get(`/api/pet/${petId}/stats/today`)
  },

  // 获取成长日志
  getGrowthLogs(petId, limit = 20) {
    return request.get(`/api/pet/${petId}/growth-logs`, { limit })
  }
}
