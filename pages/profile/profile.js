// pages/profile/profile.js
const api = require('../../api/index')

Page({
  data: {
    userInfo: {
      avatar: '/images/pet.png',
      name: '加载中...',
      id: '',
      phone: ''
    },
    petInfo: {
      id: null,
      name: '',
      breed: '',
      age: ''
    }
  },

  async onLoad() {
    await this.loadProfile()
  },

  async loadProfile() {
    try {
      const app = getApp()
      const user = await api.user.getProfile()
      const currentPet = app.globalData.currentPet

      console.log('用户数据:', user)
      console.log('头像URL:', user.avatar_url || user.avatar)

      this.setData({
        userInfo: {
          avatar: user.avatar_url || user.avatar || '/images/pet.png',
          name: user.nickname,
          id: user.id.toString(),
          phone: user.phone || ''
        },
        petInfo: currentPet ? {
          id: currentPet.id,
          name: currentPet.name,
          breed: currentPet.breed || '',
          age: currentPet.age ? `${currentPet.age}岁` : ''
        } : {
          id: null,
          name: '',
          breed: '',
          age: ''
        }
      })
    } catch (error) {
      console.error('加载资料失败', error)
      wx.showToast({ title: '加载失败', icon: 'none' })
    }
  },

  async chooseAvatar() {
    wx.chooseImage({
      count: 1,
      sizeType: ['compressed'],
      sourceType: ['album', 'camera'],
      success: async (res) => {
        try {
          const imageUrl = await api.upload.uploadImage(res.tempFilePaths[0])
          this.setData({
            'userInfo.avatar': imageUrl
          })
        } catch (error) {
          wx.showToast({ title: '上传失败', icon: 'none' })
        }
      }
    })
  },

  onNameInput(e) {
    this.setData({
      'userInfo.name': e.detail.value
    })
  },

  onPetNameInput(e) {
    this.setData({
      'petInfo.name': e.detail.value
    })
  },

  onBreedInput(e) {
    this.setData({
      'petInfo.breed': e.detail.value
    })
  },

  async saveProfile() {
    try {
      const { userInfo, petInfo } = this.data
      const app = getApp()

      console.log('保存的头像URL:', userInfo.avatar)

      // 更新用户信息
      await api.user.updateProfile({
        nickname: userInfo.name,
        avatar_url: userInfo.avatar,
        phone: userInfo.phone
      })

      // 更新宠物信息
      if (petInfo.id) {
        const age = parseInt(petInfo.age.replace('岁', ''))
        await api.pet.updatePet(petInfo.id, {
          name: petInfo.name,
          breed: petInfo.breed,
          age: isNaN(age) ? null : age
        })

        // 更新全局宠物信息
        if (app.globalData.currentPet && app.globalData.currentPet.id === petInfo.id) {
          app.globalData.currentPet = {
            ...app.globalData.currentPet,
            name: petInfo.name,
            breed: petInfo.breed,
            age: isNaN(age) ? null : age
          }
        }
      }

      // 更新全局用户信息
      if (app.globalData.userInfo) {
        app.globalData.userInfo = {
          ...app.globalData.userInfo,
          nickname: userInfo.name,
          avatar_url: userInfo.avatar,
          phone: userInfo.phone
        }
      }

      wx.showToast({ title: '保存成功', icon: 'success' })
      setTimeout(() => {
        wx.navigateBack()
      }, 1500)
    } catch (error) {
      console.error('保存失败', error)
      wx.showToast({ title: '保存失败', icon: 'none' })
    }
  }
})
