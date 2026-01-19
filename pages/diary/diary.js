// pages/diary/diary.js
const api = require('../../api/index')

Page({
  data: {
    activeTab: 0,
    diaryList: [],
    healthReports: [],
    healthRecords: [],
    refreshing: false,
    loading: false
  },

  onLoad() {
    this.loadGrowthLogs()
  },

  onShow() {
    // 每次显示时刷新数据
    this.loadData()
  },

  onPullDownRefresh() {
    this.loadData().then(() => {
      wx.stopPullDownRefresh()
    })
  },

  // 下拉刷新
  onRefresh() {
    this.setData({ refreshing: true })
    this.loadData()
  },

  async loadData() {
    await Promise.all([this.loadGrowthLogs(), this.loadHealthRecords()])
  },

  async loadGrowthLogs() {
    try {
      const app = getApp()
      const currentPet = app.globalData.currentPet

      if (!currentPet) {
        this.setData({
          diaryList: [],
          healthReports: [],
          loading: false
        })
        return
      }

      const logs = await api.pet.getGrowthLogs(currentPet.id, 50)

      // 分类处理日志 - 健康报告不再显示睡眠日志，只显示活动和里程碑
      const diaryList = []

      if (Array.isArray(logs)) {
        logs.forEach(log => {
          const formatted = this.formatLogItem(log)
          if (log.log_type !== 'sleep') {
            diaryList.push(formatted)
          }
        })
      }

      this.setData({
        diaryList,
        loading: false
      })
    } catch (error) {
      console.error('加载成长日志失败', error)
    }
  },

  async loadHealthRecords() {
    try {
      const app = getApp()
      const currentPet = app.globalData.currentPet

      if (!currentPet) {
        this.setData({
          healthRecords: [],
          loading: false
        })
        return
      }

      const records = await api.pet.getHealthRecords(currentPet.id)
      const formattedRecords = records.map(record => this.formatHealthRecord(record))

      this.setData({
        healthRecords: formattedRecords,
        loading: false
      })
    } catch (error) {
      console.error('加载健康记录失败', error)
    }
  },

  formatLogItem(log) {
    const config = api.pet.getLogTypeConfig(log.log_type)

    return {
      id: log.id,
      image: config.image,
      time: this.formatTime(log.created_at),
      title: log.title,
      description: log.content || '无详细内容'
    }
  },

  formatHealthRecord(record) {
    const typeConfig = {
      'vaccination': { icon: '💉', name: '疫苗接种', color: '#FF6B6B' },
      'illness': { icon: '🤒', name: '生病记录', color: '#4ECDC4' },
      'medication': { icon: '💊', name: '用药记录', color: '#95E1D3' },
      'checkup': { icon: '🏥', name: '体检记录', color: '#6C5CE7' }
    }

    const config = typeConfig[record.record_type] || { icon: '📋', name: '健康记录', color: '#999' }

    // 构建详情数组
    const details = []
    if (record.vaccine_name) details.push(`疫苗: ${record.vaccine_name}`)
    if (record.next_vaccination_date) details.push(`下次: ${record.next_vaccination_date}`)
    if (record.symptoms) details.push(`症状: ${record.symptoms}`)
    if (record.diagnosis) details.push(`诊断: ${record.diagnosis}`)
    if (record.medicine_name) details.push(`药品: ${record.medicine_name}`)
    if (record.dosage) details.push(`剂量: ${record.dosage}`)
    if (record.frequency) details.push(`频次: ${record.frequency}`)
    if (record.duration_days) details.push(`疗程: ${record.duration_days}天`)
    if (record.weight) details.push(`体重: ${record.weight}kg`)
    if (record.temperature) details.push(`体温: ${record.temperature}°C`)
    if (record.heart_rate) details.push(`心率: ${record.heart_rate}次/分`)
    if (record.hospital) details.push(`医院: ${record.hospital}`)
    if (record.cost) details.push(`费用: ¥${record.cost}`)

    return {
      id: record.id,
      title: record.title,
      typeIcon: config.icon,
      typeName: config.name,
      typeColor: config.color,
      recordDate: this.formatDate(record.record_date),
      details: details.length > 0 ? details : null
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

  formatDate(dateStr) {
    if (!dateStr) return ''
    const date = new Date(dateStr)
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  },

  onTabChange(e) {
    const index = parseInt(e.currentTarget.dataset.index)
    this.setData({ activeTab: index })

    // 切换到健康报告时加载数据
    if (index === 1 && this.data.healthRecords.length === 0) {
      this.loadHealthRecords()
    }
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
  },

  onAddHealthRecord() {
    const app = getApp()
    const currentPet = app.globalData.currentPet

    if (!currentPet) {
      wx.showToast({ title: '请先创建宠物', icon: 'none' })
      return
    }

    wx.navigateTo({
      url: '/pages/diary/health/create/create'
    })
  }
})
