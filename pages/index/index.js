// index.js
const api = require('../../api/index')

Page({
  data: {
    pet: {
      name: '加载中...',
      status: '加载中...',
      battery: 0
    },
    batteryEstimate: 0,
    todayStats: {
      calories: '0',
      activeTime: '0',
      steps: '0'
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
          battery: currentPet.device?.battery_level || 0
        },
        batteryEstimate: Math.floor((currentPet.device?.battery_level || 0) / 30)
      })

      // 加载今日统计数据
      const stats = await api.pet.getTodayStats(currentPet.id)
      this.setData({
        todayStats: {
          calories: stats.calories.toLocaleString(),
          activeTime: (stats.active_minutes / 60).toFixed(1),
          steps: stats.steps.toLocaleString()
        }
      })

      // 加载成长日志
      const logs = await api.pet.getGrowthLogs(currentPet.id, 3)
      this.setData({
        todayDiary: logs.map(log => {
          const config = api.pet.getLogTypeConfig(log.log_type)
          return {
            id: log.id,
            image: config.image,
            bgColor: config.bgColor,
            time: new Date(log.created_at).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }),
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
            time: this.formatTime(moment.created_at),
            content: moment.content,
            likes: moment.like_count,
            comments: moment.comment_count
          }
        })
      }
    } catch (error) {
      console.error('加载数据失败', error)
      wx.showToast({ title: '加载失败', icon: 'none' })
    }
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
