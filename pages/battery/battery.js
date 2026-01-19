// pages/battery/battery.js
const api = require('../../api/index')

Page({
  data: {
    // 电池数据
    battery: 85,
    batteryClass: '',
    batteryColor: '#fff',
    batteryText: '电量充足',
    estimateTime: '约2天',
    isCharging: false,

    // 设备状态
    isOnline: false,
    lastOnlineTime: '--',

    // 设置
    powerSaveMode: false,
    frequencyIndex: 0,
    frequencyOptions: ['高频模式 (10分钟)', '标准模式 (30分钟)', '省电模式 (1小时)'],

    // 电池健康
    healthPercent: 95
  },

  onLoad() {
    this.loadDeviceData()
  },

  async loadDeviceData() {
    try {
      // 获取宠物列表，从中获取设备信息
      const pets = await api.pet.getPetList()
      const app = getApp()

      // 找到当前宠物的设备
      const currentPet = app.globalData.currentPet || pets[0]

      if (currentPet && currentPet.device) {
        const device = currentPet.device

        // 计算电量相关状态
        this.calculateBatteryStatus(device.battery_level || 0)

        // 设置在线状态
        this.setData({
          isOnline: device.is_online || false,
          lastOnlineTime: this.formatLastOnline(device.last_online_at)
        })
      } else {
        // 没有设备时显示默认值
        this.calculateBatteryStatus(0)
        this.setData({
          isOnline: false,
          lastOnlineTime: '未绑定设备'
        })
      }
    } catch (error) {
      console.error('加载设备数据失败:', error)
      // 出错时使用默认值
      this.calculateBatteryStatus(50)
      this.setData({
        isOnline: false,
        lastOnlineTime: '加载失败'
      })
    }
  },

  calculateBatteryStatus(battery) {
    let batteryClass = ''
    let batteryText = ''
    let estimateTime = ''

    if (battery > 80) {
      batteryClass = ''
      batteryText = '电量充足'
      estimateTime = '约2-3天'
    } else if (battery > 50) {
      batteryClass = ''
      batteryText = '电量良好'
      estimateTime = '约1-2天'
    } else if (battery > 20) {
      batteryClass = 'medium'
      batteryText = '电量偏低'
      estimateTime = '约12小时'
    } else if (battery > 10) {
      batteryClass = 'low'
      batteryText = '电量不足'
      estimateTime = '约6小时'
    } else {
      batteryClass = 'low'
      batteryText = '请充电'
      estimateTime = '请尽快充电'
    }

    this.setData({
      battery,
      batteryClass,
      batteryText,
      estimateTime: battery > 0 ? estimateTime : ''
    })
  },

  formatLastOnline(lastOnlineAt) {
    if (!lastOnlineAt) return '未知'

    const now = new Date()
    const lastOnline = new Date(lastOnlineAt)
    const diff = now - lastOnline

    const minutes = Math.floor(diff / 60000)
    const hours = Math.floor(diff / 3600000)
    const days = Math.floor(diff / 86400000)

    if (minutes < 1) return '刚刚'
    if (minutes < 60) return `${minutes}分钟前`
    if (hours < 24) return `${hours}小时前`
    if (days < 7) return `${days}天前`

    // 超过一周显示具体日期
    const year = lastOnline.getFullYear()
    const month = String(lastOnline.getMonth() + 1).padStart(2, '0')
    const day = String(lastOnline.getDate()).padStart(2, '0')
    const hour = String(lastOnline.getHours()).padStart(2, '0')
    const minute = String(lastOnline.getMinutes()).padStart(2, '0')

    return `${year}-${month}-${day} ${hour}:${minute}`
  },

  togglePowerMode(e) {
    const powerSaveMode = e.detail.value
    this.setData({ powerSaveMode })

    const tips = powerSaveMode ? '已开启超级省电模式' : '已关闭超级省电模式'
    wx.showToast({ title: tips, icon: 'none' })

    // TODO: 调用API设置省电模式
  }
})
