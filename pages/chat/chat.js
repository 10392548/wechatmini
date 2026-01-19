const api = require('../../api/index')

Page({
  data: {
    messages: [],
    inputText: '',
    scrollId: 'bottom',
    sending: false,
    petName: '',
    petAvatar: ''
  },

  async onLoad() {
    await this.ensurePetLoaded()
    await this.loadHistory()
  },

  async onShow() {
    await this.ensurePetLoaded()
  },

  async ensurePetLoaded() {
    const app = getApp()

    if (!app.globalData.currentPet) {
      try {
        await app.loadPets()
      } catch (error) {
        console.error('加载宠物失败', error)
      }
    }

    const currentPet = app.globalData.currentPet
    if (!currentPet) {
      wx.showModal({
        title: '提示',
        content: '请先创建宠物',
        confirmText: '去创建',
        success: (res) => {
          if (res.confirm) {
            wx.navigateTo({ url: '/pages/bind/bind' })
          }
        }
      })
      return false
    }

    this.setData({
      petName: currentPet.name,
      petAvatar: currentPet.avatar || '/images/pet.png'
    })
    return true
  },

  async loadHistory() {
    try {
      const app = getApp()
      const currentPet = app.globalData.currentPet

      if (!currentPet) return

      const history = await api.chat.getChatHistory(currentPet.id, 50)
      this.setData({
        messages: history.map(msg => ({
          type: msg.role === 'user' ? 'user' : 'pet',
          sender: msg.role === 'user' ? '主人' : currentPet.name,
          content: msg.content,
          time: new Date(msg.created_at).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }),
          avatar: msg.role === 'user' ? '' : (currentPet.avatar || '/images/pet.png')
        })),
        scrollId: 'bottom'
      })
    } catch (error) {
      console.error('加载聊天历史失败', error)
    }
  },

  onInput(e) {
    this.setData({ inputText: e.detail.value })
  },

  async sendMessage() {
    if (!this.data.inputText.trim() || this.data.sending) return

    const app = getApp()
    const currentPet = app.globalData.currentPet

    if (!currentPet) {
      wx.showToast({ title: '请先创建宠物', icon: 'none' })
      return
    }

    const content = this.data.inputText.trim()
    this.setData({ inputText: '', sending: true })

    const userMessage = {
      type: 'user',
      sender: '主人',
      content,
      time: new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }),
      avatar: ''
    }

    this.setData({
      messages: [...this.data.messages, userMessage],
      scrollId: 'bottom'
    })

    try {
      const { assistantMessage } = await api.chat.sendMessage(currentPet.id, content)

      const petReply = {
        type: 'pet',
        sender: currentPet.name,
        content: assistantMessage.content,
        time: new Date(assistantMessage.created_at).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }),
        avatar: currentPet.avatar || '/images/pet.png'
      }

      this.setData({
        messages: [...this.data.messages, petReply],
        scrollId: 'bottom',
        sending: false
      })
    } catch (error) {
      wx.showToast({ title: '发送失败', icon: 'none' })
      this.setData({ sending: false })
    }
  }
})
