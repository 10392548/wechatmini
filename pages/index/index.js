// index.js
const api = require('../../api/index')

Page({
  data: {
    pet: {
      name: '加载中...',
      status: '加载中...',
      battery: 0
    },
    // 设备状态
    isOnline: false,
    lastOnlineTime: '--',
    currentStatus: {
      icon: 'Still',
      text: '静止'
    },
    temperature: '--',
    // 今日运动数据（暂时用虚拟数据，后续从服务器获取）
    todayStats: {
      runningTime: '0',
      walkingTime: '0',
      staticTime: '0'
    },
    features: [
      { id: 'chat', name: 'AI聊天', icon: '/images/chat-active.png', color: '#FFF3E0', url: '/pages/chat/chat' },
      { id: 'activity', name: '运动轨迹', icon: '/images/petc.png', color: '#FFF3E0', url: '/pages/activity/activity' },
      { id: 'diary', name: '成长日志', icon: '/images/diary.png', color: '#FFF3E0', url: '/pages/diary/diary' },
      { id: 'battery', name: '电池状态', icon: '/images/battery.png', color: '#FFF3E0', url: '/pages/battery/battery' }
    ],
    latestMoment: null,
    todayDiary: []
  },

  async onLoad() {
    await this.loadData()
  },

  async loadData() {
    try {
      const app = getApp()
      const currentPet = app.globalData.currentPet

      if (!currentPet) {
        // 没有宠物，跳转到绑定页面
        wx.showToast({ title: '请先创建宠物', icon: 'none' })
        setTimeout(() => {
          wx.navigateTo({ url: '/pages/bind/bind' })
        }, 1500)
        return
      }

      // 加载宠物信息
      this.setData({
        pet: {
          name: currentPet.name,
          avatar: currentPet.avatar || '/images/pet.png',
          status: '在家开心',
          battery: currentPet.device?.batteryLevel || 0
        }
      })

      // 获取设备状态
      const device = currentPet.device
      if (device) {
        this.setData({
          isOnline: device.isOnline || false,
          lastOnlineTime: this.formatLastOnline(device.lastOnlineAt),
          temperature: device.lastTemperature || '--'
        })

        // 设置当前状态（根据motionState，暂时用默认值）
        const statusMap = {
          0: { icon: 'Still', text: '静止' },
          1: { icon: 'Walking', text: '行走' },
          2: { icon: 'Running', text: '奔跑' }
        }
        // TODO: 从服务器获取motionState
        this.setData({
          currentStatus: statusMap[device.motionState || 0]
        })
      }

      // 加载今日运动统计数据（暂时用虚拟数据）
      // TODO: 从服务器获取真实的运动时长统计
      this.generateTodayStats()

      // 加载成长日志
      const logs = await api.pet.getGrowthLogs(currentPet.id, 3)
      console.log('成长日志数据:', logs)
      this.setData({
        todayDiary: logs.map(log => {
          const config = api.pet.getLogTypeConfig(log.logType)
          return {
            id: log.id,
            image: config.image,
            bgColor: config.bgColor,
            time: new Date(log.createdAt).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }),
            title: log.title,
            description: log.content
          }
        })
      })

      // 加载最新朋友圈
      const moments = await api.moment.getMomentList(1, 1)
      if (moments.moments && moments.moments.length > 0) {
        const moment = moments.moments[0]
        this.setData({
          latestMoment: {
            nickname: moment.user.nickname,
            avatar: moment.user.avatar || '/images/pet.png',
            time: this.formatTime(moment.createdAt),
            content: moment.content,
            likes: moment.likeCount,
            comments: moment.commentCount
          }
        })
      }
    } catch (error) {
      console.error('加载数据失败', error)
      wx.showToast({ title: '加载失败', icon: 'none' })
    }
  },

  // 生成今日运动统计（虚拟数据，等待服务器接口）
  generateTodayStats() {
    // 根据时间生成合理的运动时长
    const hour = new Date().getHours()

    let runningTime = 0
    let walkingTime = 0
    let staticTime = 0

    if (hour >= 6 && hour < 12) {
      // 上午：活动较多
      runningTime = 30 + Math.floor(Math.random() * 20)
      walkingTime = 40 + Math.floor(Math.random() * 30)
      staticTime = (12 - hour) * 30
    } else if (hour >= 12 && hour < 18) {
      // 下午：午休后活动
      runningTime = 20 + Math.floor(Math.random() * 15)
      walkingTime = 30 + Math.floor(Math.random() * 20)
      staticTime = (18 - hour) * 20
    } else if (hour >= 18 && hour < 22) {
      // 晚上：活动减少
      runningTime = 10 + Math.floor(Math.random() * 10)
      walkingTime = 20 + Math.floor(Math.random() * 15)
      staticTime = (22 - hour) * 30
    } else {
      // 深夜/凌晨：基本静止
      runningTime = 0
      walkingTime = 0
      staticTime = 60
    }

    this.setData({
      todayStats: {
        runningTime: runningTime.toString(),
        walkingTime: walkingTime.toString(),
        staticTime: staticTime.toString()
      }
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
  },

  formatTime(dateStr) {
    const now = new Date()
    const date = new Date(dateStr)
    const diff = Math.floor((now - date) / 1000 / 60)

    if (diff < 1) return '刚刚'
    if (diff < 60) return `${diff}分钟前`
    if (diff < 1440) return `${Math.floor(diff / 60)}小时前`
    return `${Math.floor(diff / 1440)}天前`
  },

  onFeatureTap(e) {
    const url = e.currentTarget.dataset.url
    if (url === '/pages/chat/chat') {
      wx.switchTab({ url })
    } else {
      wx.navigateTo({ url })
    }
  },

  goToActivity() {
    wx.navigateTo({ url: '/pages/activity/activity' })
  },

  goToBattery() {
    wx.navigateTo({ url: '/pages/battery/battery' })
  },

  goToMoments() {
    wx.switchTab({ url: '/pages/moments/moments' })
  },

  goToDiary() {
    wx.navigateTo({ url: '/pages/diary/diary' })
  }
})
