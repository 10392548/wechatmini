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

      // 加载今日运动统计数据
      await this.loadTodayStats()

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

  // 加载今日运动统计（真实数据）
  async loadTodayStats() {
    // 从 globalData 获取设备信息（不是从 this.data.pet）
    const app = getApp()
    const currentPet = app.globalData?.currentPet

    // 检查 device_id 或 device.id
    const deviceId = currentPet?.device?.id || currentPet?.device_id

    if (!deviceId) {
      // 没有设备，显示全0
      this.setData({
        todayStats: {
          runningTime: '0',
          walkingTime: '0',
          staticTime: '0'
        }
      })
      return
    }

    try {
      // 获取今日轨迹数据
      const trackData = await api.device.getTodayTrack(deviceId)

      if (trackData && trackData.length > 0) {
        // 计算各运动状态时长
        let runningTime = 0
        let walkingTime = 0
        let staticTime = 0

        for (let i = 0; i < trackData.length - 1; i++) {
          const timeDiff = (new Date(trackData[i + 1].recordedAt) - new Date(trackData[i].recordedAt)) / 60000

          switch (trackData[i].motionState || 0) {
            case 0:
              staticTime += timeDiff
              break
            case 1:
              walkingTime += timeDiff
              break
            case 2:
              runningTime += timeDiff
              break
          }
        }

        this.setData({
          todayStats: {
            runningTime: Math.round(runningTime).toString(),
            walkingTime: Math.round(walkingTime).toString(),
            staticTime: Math.round(staticTime).toString()
          }
        })

        // 更新当前状态
        const lastPoint = trackData[trackData.length - 1]
        const statusMap = {
          0: { icon: 'Still', text: '静止' },
          1: { icon: 'Walking', text: '行走' },
          2: { icon: 'Running', text: '奔跑' }
        }
        this.setData({
          currentStatus: statusMap[lastPoint.motionState || 0]
        })

        // 更新温度
        if (lastPoint.temperature) {
          this.setData({
            temperature: parseFloat(lastPoint.temperature).toFixed(1)
          })
        }
      } else {
        // 无数据时显示全0
        this.setData({
          todayStats: {
            runningTime: '0',
            walkingTime: '0',
            staticTime: '0'
          }
        })
      }
    } catch (error) {
      console.error('加载今日统计失败:', error)
      // 失败时显示全0
      this.setData({
        todayStats: {
          runningTime: '0',
          walkingTime: '0',
          staticTime: '0'
        }
      })
    }
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
