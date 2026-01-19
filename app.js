// app.js
const tokenManager = require('./utils/token')
const api = require('./api/index')

App({
  globalData: {
    userInfo: null,
    currentPet: null
  },

  async onLaunch() {
    const token = tokenManager.getToken()
    if (!token) {
      wx.reLaunch({ url: '/pages/login/login' })
      return
    }

    await this.loadPets()
  },

  async loadPets() {
    try {
      const pets = await api.pet.getPetList()
      if (pets && pets.length > 0) {
        this.globalData.currentPet = pets[0]
      }
    } catch (error) {
      console.error('加载宠物列表失败', error)
    }
  }
})
