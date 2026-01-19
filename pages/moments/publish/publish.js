const api = require('../../../api/index')

Page({
  data: {
    content: '',
    images: [],
    uploading: false,
    maxImages: 9
  },

  onContentInput(e) {
    this.setData({ content: e.detail.value })
  },

  async chooseImages() {
    const remainingCount = this.data.maxImages - this.data.images.length
    if (remainingCount <= 0) {
      wx.showToast({ title: '最多只能选择9张图片', icon: 'none' })
      return
    }

    try {
      const res = await wx.chooseMedia({
        count: remainingCount,
        mediaType: ['image'],
        sourceType: ['album', 'camera'],
        sizeType: ['compressed']
      })

      this.setData({
        images: [...this.data.images, ...res.tempFiles.map(f => f.tempFilePath)]
      })
    } catch (error) {
      if (error.errMsg && !error.errMsg.includes('cancel')) {
        wx.showToast({ title: '选择图片失败', icon: 'none' })
      }
    }
  },

  deleteImage(e) {
    const index = e.currentTarget.dataset.index
    const images = this.data.images.filter((_, i) => i !== index)
    this.setData({ images })
  },

  previewImage(e) {
    const current = e.currentTarget.dataset.url
    wx.previewImage({
      urls: this.data.images,
      current
    })
  },

  async publish() {
    if (!this.data.content.trim() && this.data.images.length === 0) {
      wx.showToast({ title: '请输入内容或选择图片', icon: 'none' })
      return
    }

    if (this.data.uploading) return

    this.setData({ uploading: true })

    try {
      let imageUrls = []
      if (this.data.images.length > 0) {
        wx.showLoading({ title: '上传图片中...', mask: true })
        imageUrls = await api.upload.uploadImages(this.data.images)
        wx.hideLoading()
      }

      wx.showLoading({ title: '发布中...', mask: true })

      const app = getApp()
      const currentPet = app.globalData.currentPet

      await api.moment.createMoment(
        this.data.content.trim(),
        currentPet ? currentPet.id : null,
        true,
        imageUrls
      )

      wx.hideLoading()
      wx.showToast({ title: '发布成功', icon: 'success' })

      setTimeout(() => {
        wx.navigateBack()
      }, 1500)
    } catch (error) {
      wx.hideLoading()
      wx.showToast({ title: '发布失败: ' + (error.message || '未知错误'), icon: 'none' })
      this.setData({ uploading: false })
    }
  },

  goBack() {
    if (this.data.content || this.data.images.length > 0) {
      wx.showModal({
        title: '提示',
        content: '确定要放弃编辑吗？',
        success: (res) => {
          if (res.confirm) {
            wx.navigateBack()
          }
        }
      })
    } else {
      wx.navigateBack()
    }
  }
})
