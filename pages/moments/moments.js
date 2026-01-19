// moments.js
const api = require('../../api/index')

Page({
  data: {
    moments: [],
    page: 1,
    hasMore: true,
    loading: false
  },

  async onLoad() {
    await this.loadMoments()
  },

  async loadMoments() {
    if (this.data.loading || !this.data.hasMore) return

    this.setData({ loading: true })

    try {
      const { moments, total } = await api.moment.getMomentList(this.data.page, 20)

      const formattedMoments = moments.map(m => ({
        id: m.id,
        nickname: m.user.nickname,
        avatar: m.user.avatar || '/images/pet.png',
        time: this.formatTime(m.created_at),
        location: '',
        content: m.content,
        images: m.images || [],
        likes: m.like_count,
        liked: m.is_liked || false,
        comments: [],
        showComments: false
      }))

      this.setData({
        moments: [...this.data.moments, ...formattedMoments],
        page: this.data.page + 1,
        hasMore: this.data.moments.length + formattedMoments.length < total,
        loading: false
      })
    } catch (error) {
      console.error('加载朋友圈失败', error)
      this.setData({ loading: false })
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

  async onLike(e) {
    const id = e.currentTarget.dataset.id
    const moment = this.data.moments.find(m => m.id === id)

    if (!moment) return

    try {
      if (moment.liked) {
        await api.moment.unlikeMoment(id)
      } else {
        await api.moment.likeMoment(id)
      }

      const moments = this.data.moments.map(item => {
        if (item.id === id) {
          return {
            ...item,
            liked: !item.liked,
            likes: item.liked ? item.likes - 1 : item.likes + 1
          }
        }
        return item
      })

      this.setData({ moments })
    } catch (error) {
      wx.showToast({ title: '操作失败', icon: 'none' })
    }
  },

  toggleComments(e) {
    const id = e.currentTarget.dataset.id
    const moments = this.data.moments.map(item => {
      if (item.id === id) {
        return { ...item, showComments: !item.showComments }
      }
      return item
    })
    this.setData({ moments })
  },

  onReachBottom() {
    this.loadMoments()
  },

  goToPublish() {
    wx.navigateTo({ url: '/pages/moments/publish/publish' })
  },

  previewImage(e) {
    const { url, urls } = e.currentTarget.dataset
    wx.previewImage({ current: url, urls })
  }
})
