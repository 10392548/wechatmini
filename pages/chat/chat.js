const api = require('../../api/index')

Page({
  data: {
    messages: [],
    inputText: '',
    scrollId: 'bottom',
    sending: false
  },

  async onLoad() {
    await this.loadHistory()
  },

  async loadHistory() {
    try {
      const app = getApp()
      const currentPet = app.globalData.currentPet

      if (!currentPet) {
        wx.showToast({ title: '请先创建宠物', icon: 'none' })
        return
      }

      const history = await api.chat.getChatHistory(currentPet.id, 50)
      this.setData({
        messages: history.map(msg => ({
          type: msg.role === 'user' ? 'user' : 'pet',
          sender: msg.role === 'user' ? '主人' : currentPet.name,
          content: msg.content,
          time: new Date(msg.created_at).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
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

    // 添加用户消息到界面
    const userMessage = {
      type: 'user',
      sender: '主人',
      content,
      time: new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
    }

    this.setData({
      messages: [...this.data.messages, userMessage],
      scrollId: 'bottom'
    })

    try {
      // 调用 API 发送消息
      const { assistantMessage } = await api.chat.sendMessage(currentPet.id, content)

      // 添加 AI 回复到界面
      const petReply = {
        type: 'pet',
        sender: currentPet.name,
        content: assistantMessage.content,
        time: new Date(assistantMessage.created_at).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
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
