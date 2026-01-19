const request = require('../utils/request')

// 成长日志类型配置（统一管理图标和颜色）
const GROWTH_LOG_TYPE_CONFIG = {
  'activity': { image: '/images/Activity.png', color: '#2196F3', bgColor: '#FFF3E0' },
  'sleep': { image: '/images/sleep.png', color: '#3F51B5', bgColor: '#FFF3E0' },
  'milestone': { image: '/images/Milestone.png', color: '#FF9800', bgColor: '#FFF3E0' }
}

// 获取日志类型配置
const getLogTypeConfig = (type) => {
  return GROWTH_LOG_TYPE_CONFIG[type] || { image: '/images/diary.png', color: '#2196F3', bgColor: '#F5F5F5' }
}

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
  getGrowthLogs(petId, limit = 50, logType) {
    const params = { limit }
    if (logType) params.log_type = logType
    return request.get(`/api/pet/${petId}/growth-logs`, params)
  },

  // 创建成长日志
  createGrowthLog(petId, data) {
    return request.post(`/api/pet/${petId}/growth-logs`, data)
  },

  // 更新成长日志
  updateGrowthLog(petId, logId, data) {
    return request.put(`/api/pet/${petId}/growth-logs/${logId}`, data)
  },

  // 删除成长日志
  deleteGrowthLog(petId, logId) {
    return request.delete(`/api/pet/${petId}/growth-logs/${logId}`)
  },

  // 获取健康记录列表
  getHealthRecords(petId, recordType, limit = 50) {
    const params = { limit }
    if (recordType) params.record_type = recordType
    return request.get(`/api/pet/${petId}/health-records`, params)
  },

  // 获取单条健康记录
  getHealthRecord(petId, recordId) {
    return request.get(`/api/pet/${petId}/health-records/${recordId}`)
  },

  // 创建健康记录
  createHealthRecord(petId, data) {
    return request.post(`/api/pet/${petId}/health-records`, data)
  },

  // 更新健康记录
  updateHealthRecord(petId, recordId, data) {
    return request.put(`/api/pet/${petId}/health-records/${recordId}`, data)
  },

  // 删除健康记录
  deleteHealthRecord(petId, recordId) {
    return request.delete(`/api/pet/${petId}/health-records/${recordId}`)
  },

  // 获取日志类型配置
  getLogTypeConfig
}
