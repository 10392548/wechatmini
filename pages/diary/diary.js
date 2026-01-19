// pages/diary/diary.js
const api = require('../../api/index')

Page({
  data: {
    activeTab: 0,
    diaryList: [],
    healthReports: [],
    loading: false,
    refreshing: false,
    empty: false
  },

  onLoad() {
    this.loadGrowthLogs()
  },

  onShow() {
    // 每次显示页面时刷新数据
    this.loadGrowthLogs()
  },

  onPullDownRefresh() {
    this.loadGrowthLogs().then(() => {
      wx.stopPullDownRefresh()
    })
  },

  // 下拉刷新（scroll-view 自带刷新）
  onRefresh() {
    this.setData({ refreshing: true })
    this.loadGrowthLogs()
  },

  async loadGrowthLogs() {
    try {
      this.setData({ loading: true })
      const app = getApp()
      const currentPet = app.globalData.currentPet

      if (!currentPet) {
        this.setData({
          diaryList: [],
          healthReports: [],
          loading: false,
          refreshing: false,
          empty: true
        })
        return
      }

      const logs = await api.pet.getGrowthLogs(currentPet.id, 50)

      // 分类处理日志
      const diaryList = []
      const healthReports = []

      if (Array.isArray(logs)) {
        logs.forEach(log => {
        const formatted = this.formatLogItem(log)
        if (log.log_type === 'sleep') {
          healthReports.push(formatted)
        } else {
          diaryList.push(formatted)
        }
      })
      }

      this.setData({
        diaryList,
        healthReports,
        loading: false,
        refreshing: false,
        empty: logs.length === 0
      })
    } catch (error) {
      console.error('加载成长日志失败', error)
      wx.showToast({ title: '加载失败，请重试', icon: 'none' })
      this.setData({
        loading: false,
        refreshing: false,
        empty: true
      })
    }
  },

  formatLogItem(log) {
    // 日志类型映射 - 统一蓝色主题
    const typeMap = {
      'activity': { image: '/images/Activity.png', color: '#2196F3' },
      'sleep': { image: '/images/sleep.png', color: '#2196F3' },
      'milestone': { image: '/images/Milestone.png', color: '#2196F3' }
    }

    const config = typeMap[log.log_type] || { image: '/images/diary.png', color: '#2196F3' }
    const bgColor = this.hexToRgba(config.color, 0.1)

    return {
      id: log.id,
      image: config.image,
      iconColor: config.color,
      bgColor: bgColor,
      time: this.formatTime(log.created_at),
      title: log.title,
      description: log.content || '无详细内容'
    }
  },

  formatTime(dateStr) {
    const now = new Date()
    const date = new Date(dateStr)
    const diffMs = now - date
    const diffDays = Math.floor(diffMs / 1000 / 60 / 60 / 24)

    const hour = date.getHours().toString().padStart(2, '0')
    const minute = date.getMinutes().toString().padStart(2, '0')
    const timeStr = `${hour}:${minute}`

    if (diffDays === 0) {
      return timeStr
    } else if (diffDays === 1) {
      return `昨天 ${timeStr}`
    } else if (diffDays < 7) {
      const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
      return weekDays[date.getDay()]
    } else {
      const month = (date.getMonth() + 1).toString().padStart(2, '0')
      const day = date.getDate().toString().padStart(2, '0')
      return `${month}/${day}`
    }
  },

  hexToRgba(hex, alpha) {
    const r = parseInt(hex.slice(1, 3), 16)
    const g = parseInt(hex.slice(3, 5), 16)
    const b = parseInt(hex.slice(5, 7), 16)
    return `rgba(${r}, ${g}, ${b}, ${alpha})`
  },

  onTabChange(e) {
    this.setData({ activeTab: e.currentTarget.dataset.index })
  },

  onCreateLog() {
    const app = getApp()
    const currentPet = app.globalData.currentPet

    if (!currentPet) {
      wx.showToast({ title: '请先创建宠物', icon: 'none' })
      return
    }

    wx.navigateTo({
      url: '/pages/diary/create/create'
    })
  }
})
