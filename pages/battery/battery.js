// pages/battery/battery.js
const api = require('../../api/index')

Page({
  data: {
    // 调试模式（上线前设为false）
    isDebug: true,

    // 电池数据
    battery: 0,
    batteryClass: '',
    batteryColor: '#fff',
    batteryText: '',
    estimateTime: '',
    isCharging: false,

    // 设备状态
    isOnline: false,
    lastOnlineTime: '--',

    // 电量消耗数据（仿真）
    usageData: {
      gps: 0,
      sensor: 0,
      network: 0
    },

    // 电池健康（仿真，本地存储）
    healthPercent: 98,
    healthStatus: {
      text: '优秀',
      tip: '电池状态良好，继续保持'
    }
  },

  onLoad() {
    this.loadDeviceData()
    this.initBatteryHealth()
  },

  // 切换在线/离线状态（调试用）
  toggleOnline(e) {
    const isOnline = e.detail.value
    this.setData({ isOnline })

    if (isOnline) {
      // 切换到在线，生成电量数据
      this.generateBatteryData()
      this.generateUsageData()
      this.setData({
        lastOnlineTime: '刚刚'
      })
    } else {
      // 切换到离线
      this.setData({
        lastOnlineTime: '刚刚'
      })
    }

    wx.showToast({
      title: isOnline ? '已切换到在线' : '已切换到离线',
      icon: 'none'
    })
  },

  async loadDeviceData() {
    // 调试模式：默认显示在线状态，方便调试
    if (this.data.isDebug) {
      this.setData({ isOnline: true })
      this.generateBatteryData()
      this.generateUsageData()
      this.setData({
        lastOnlineTime: '刚刚'
      })
      return
    }

    try {
      // 获取宠物列表，从中获取设备信息
      const pets = await api.pet.getPetList()
      const app = getApp()

      // 找到当前宠物的设备
      const currentPet = app.globalData.currentPet || pets[0]

      if (currentPet && currentPet.device) {
        const device = currentPet.device

        // 设置在线状态
        const isOnline = device.is_online || false
        this.setData({
          isOnline: isOnline,
          lastOnlineTime: this.formatLastOnline(device.last_online_at)
        })

        // 只有在线时才生成电量数据
        if (isOnline) {
          this.generateBatteryData()
          this.generateUsageData()
        }
      } else {
        this.setData({
          isOnline: false,
          lastOnlineTime: '未绑定设备'
        })
      }
    } catch (error) {
      console.error('加载设备数据失败:', error)
      // 出错时默认离线
      this.setData({
        isOnline: false,
        lastOnlineTime: '加载失败'
      })
    }
  },

  // 生成仿真电量数据（基于时间，看起来真实）
  generateBatteryData() {
    const hour = new Date().getHours()
    const minute = new Date().getMinutes()

    // 根据时间生成"合理"的基准电量
    let baseBattery

    if (hour >= 6 && hour < 9) {
      // 早上 6-9点：90% → 80%
      baseBattery = 90 - (hour - 6) * 3 - (minute / 60) * 3
    } else if (hour >= 9 && hour < 12) {
      // 上午 9-12点：80% → 70%
      baseBattery = 80 - (hour - 9) * 3.5 - (minute / 60) * 3.5
    } else if (hour >= 12 && hour < 18) {
      // 下午 12-18点：70% → 40%
      baseBattery = 70 - (hour - 12) * 5 - (minute / 60) * 5
    } else if (hour >= 18 && hour < 22) {
      // 晚上 18-22点：40% → 20%
      baseBattery = 40 - (hour - 18) * 5 - (minute / 60) * 5
    } else {
      // 深夜 22-6点：假设充过电
      baseBattery = 95 + Math.random() * 5
    }

    // 添加随机波动，保留一位小数
    const battery = Math.max(10, Math.min(98, baseBattery + (Math.random() * 6 - 3)))
    const batteryFixed = battery.toFixed(1)

    // 计算电量状态
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
    } else if (battery > 30) {
      batteryClass = 'medium'
      batteryText = '电量中等'
      estimateTime = '约12小时'
    } else if (battery > 15) {
      batteryClass = 'low'
      batteryText = '电量偏低'
      estimateTime = '约6小时'
    } else {
      batteryClass = 'low'
      batteryText = '电量不足'
      estimateTime = '请充电'
    }

    this.setData({
      battery: batteryFixed,
      batteryClass,
      batteryText,
      estimateTime
    })
  },

  // 生成仿真电量消耗数据
  generateUsageData() {
    // GPS最耗电，传感器其次，通信最少
    const gpsBase = 55 + Math.random() * 15  // 55-70%
    const sensorBase = 15 + Math.random() * 10  // 15-25%
    const networkBase = 100 - gpsBase - sensorBase - Math.random() * 5

    this.setData({
      usageData: {
        gps: gpsBase.toFixed(1),
        sensor: sensorBase.toFixed(1),
        network: Math.max(5, networkBase).toFixed(1)
      }
    })
  },

  // 初始化电池健康度（本地存储，缓慢下降）
  initBatteryHealth() {
    let health = wx.getStorageSync('battery_health') || 98

    // 偶尔降低健康度（模拟真实使用）
    if (Math.random() < 0.15) {
      health = Math.max(85, health - 0.1)
      wx.setStorageSync('battery_health', health)
    }

    const healthFixed = health.toFixed(1)

    // 根据健康度返回状态
    let healthStatus = {}
    if (health > 95) {
      healthStatus = {
        text: '优秀',
        tip: '电池状态优秀，使用体验极佳'
      }
    } else if (health > 90) {
      healthStatus = {
        text: '良好',
        tip: '电池状态良好，正常运行'
      }
    } else if (health > 85) {
      healthStatus = {
        text: '正常',
        tip: '电池状态正常，建议关注'
      }
    } else {
      healthStatus = {
        text: '需关注',
        tip: '建议联系售后检查电池'
      }
    }

    this.setData({
      healthPercent: healthFixed,
      healthStatus
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

    // 添加一些随机感，让"刚刚"更真实
    if (minutes < 2) return '刚刚'
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
  }
})
