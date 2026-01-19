// bind.js
const api = require('../../api/index')

Page({
  data: {
    imei: '',
    bindMode: 'new',
    existingPets: [],
    selectedPetId: null,
    binding: false,
    petInfo: {
      name: '',
      breed: '',
      gender: 'male',
      avatar: ''
    }
  },

  onLoad() {
    this.loadExistingPets()
  },

  onShow() {},

  onReady() {},

  onHide() {},

  onUnload() {},

  async loadExistingPets() {
    try {
      const pets = await api.pet.getPetList()
      this.setData({
        existingPets: pets,
        bindMode: pets.length > 0 ? 'existing' : 'new'
      })

      if (pets.length > 0) {
        this.setData({ selectedPetId: pets[0].id })
      }
    } catch (error) {
      this.setData({ bindMode: 'new' })
    }
  },

  // 切换绑定模式
  switchMode(e) {
    const mode = e.currentTarget.dataset.mode
    this.setData({ bindMode: mode })
  },

  // 选择已有宠物
  selectPet(e) {
    const petId = e.currentTarget.dataset.petid
    this.setData({ selectedPetId: petId })
  },

  // 宠物信息输入
  onNameInput(e) {
    this.setData({
      'petInfo.name': e.detail.value.trim()
    })
  },

  onBreedInput(e) {
    this.setData({
      'petInfo.breed': e.detail.value.trim()
    })
  },

  selectGender(e) {
    const gender = e.currentTarget.dataset.gender
    this.setData({
      'petInfo.gender': gender
    })
  },

  // 选择头像
  chooseAvatar() {
    wx.chooseMedia({
      count: 1,
      mediaType: ['image'],
      sourceType: ['album'],
      sizeType: ['compressed'],
      success: (res) => {
        const tempFilePath = res.tempFiles[0].tempFilePath
        const fileSize = res.tempFiles[0].size

        if (fileSize > 5 * 1024 * 1024) {
          wx.showToast({ title: '图片不能超过5MB', icon: 'none' })
          return
        }

        this.uploadAvatar(tempFilePath)
      },
      fail: (error) => {
        wx.showToast({ title: '选择图片失败', icon: 'none' })
      }
    })
  },


  async uploadAvatar(filePath) {
    try {
      const url = await api.upload.uploadImage(filePath)

      this.setData({
        petInfo: {
          ...this.data.petInfo,
          avatar: url
        }
      })

      wx.showToast({ title: '上传成功', icon: 'success' })
    } catch (error) {
      wx.showToast({ title: '上传失败: ' + (error.message || '未知错误'), icon: 'none' })
    }
  },

  onImeiInput(e) {
    this.setData({ imei: e.detail.value.trim() })
  },

  async onBind() {
    const { imei, bindMode, petInfo, selectedPetId, binding } = this.data

    if (binding) return

    if (!imei) {
      wx.showToast({ title: '请输入IMEI号码', icon: 'none' })
      return
    }

    if (!/^\d{15}$/.test(imei)) {
      wx.showToast({ title: 'IMEI应为15位数字', icon: 'none' })
      return
    }

    let petId = selectedPetId

    if (bindMode === 'new') {
      if (!petInfo.name) {
        wx.showToast({ title: '请输入宠物名称', icon: 'none' })
        return
      }

      try {
        this.setData({ binding: true })

        const newPet = await api.pet.createPet({
          name: petInfo.name,
          breed: petInfo.breed || '未知品种',
          gender: petInfo.gender,
          avatar: petInfo.avatar
        })

        petId = newPet.id
      } catch (error) {
        wx.showToast({ title: error.message || '创建宠物失败', icon: 'none' })
        return
      } finally {
        this.setData({ binding: false })
      }
    } else if (!petId) {
      wx.showToast({ title: '请选择宠物', icon: 'none' })
      return
    }

    try {
      this.setData({ binding: true })
      await api.device.bindDevice(imei, petId)

      wx.showToast({ title: '绑定成功', icon: 'success', duration: 2000 })

      const app = getApp()
      if (bindMode === 'new') {
        app.globalData.currentPet = newPet
      } else {
        const pet = this.data.existingPets.find(p => p.id === petId)
        if (pet) {
          app.globalData.currentPet = pet
        }
      }

      setTimeout(() => {
        wx.switchTab({ url: '/pages/index/index' })
      }, 2000)

    } catch (error) {
      wx.showToast({ title: error.message || '绑定失败', icon: 'none' })
    } finally {
      this.setData({ binding: false })
    }
  }
})
