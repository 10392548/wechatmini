const request = require('../utils/request')

module.exports = {
  // 绑定设备
  bindDevice(device_sn, pet_id) {
    return request.post('/api/device/bind', { device_sn, pet_id })
  },

  // 解绑设备
  unbindDevice(petId) {
    return request.post(`/api/device/unbind/${petId}`)
  },

  // 更新设备状态
  updateDeviceStatus(device_sn, battery_level, is_online) {
    return request.post('/api/device/status', { device_sn, battery_level, is_online })
  },

  // 获取今日轨迹
  getTodayTrack(deviceId) {
    return request.get(`/api/device/${deviceId}/locations/today`)
  },

  // 获取历史轨迹
  getHistoryTrack(deviceId, startTime, endTime, limit = 100) {
    return request.get(`/api/device/${deviceId}/locations/history`, {
      startTime,
      endTime,
      limit
    })
  },

  // 获取最新位置
  getLatestLocation(deviceId) {
    return request.get(`/api/device/${deviceId}/location/latest`)
  }
}
