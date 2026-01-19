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
  }
}
