// pages/diary/create/create.js
const api = require('../../../api/index')

Page({
  data: {
    petName: '',
    title: '',
    content: '',
    logType: 'milestone',
    submitting: false
  },

  onLoad() {
    const app = getApp()
    const currentPet = app.globalData.currentPet

    if (currentPet) {
      this.setData({ petName: currentPet.name })
    }

    // 获取参数（如果有）
    if (this.options.logType) {
      this.setData({ logType: this.options.logType })
    }
  },

  onTitleInput(e) {
    this.setData({ title: e.detail.value })
  },

  onContentInput(e) {
    this.setData({ content: e.detail.value })
  },

  onTypeChange(e) {
    const value = e.currentTarget.dataset.value
    this.setData({ logType: value })

    // 添加震动反馈
    wx.vibrateShort({ type: 'light' })
  },

  async onSubmit() {
    const { title, content, logType, submitting } = this.data

    if (submitting) {
      return
    }

    if (!title.trim()) {
      wx.showToast({ title: '请输入标题', icon: 'none' })
      return
    }

    if (title.length > 50) {
      wx.showToast({ title: '标题不能超过50字', icon: 'none' })
      return
    }

    this.setData({ submitting: true })

    try {
      const app = getApp()
      const currentPet = app.globalData.currentPet

      if (!currentPet) {
        wx.showToast({ title: '请先创建宠物', icon: 'none' })
        this.setData({ submitting: false })
        return
      }

      await api.pet.createGrowthLog(currentPet.id, {
        log_type: logType,
        title: title.trim(),
        content: content.trim()
      })

      wx.showToast({ title: '创建成功', icon: 'success' })

      setTimeout(() => {
        wx.navigateBack()
      }, 1500)
    } catch (error) {
      console.error('创建成长日志失败', error)
      wx.showToast({ title: '创建失败，请重试', icon: 'none' })
    } finally {
      this.setData({ submitting: false })
    }
  }
})
