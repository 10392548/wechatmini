// bind.js
const api = require('../../api/index')
const fileLogger = require('../../utils/fileLogger')

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
    fileLogger.clear() // 清空之前的日志
    fileLogger.log('[生命周期] ========== onLoad 执行 ==========')
    console.log('[生命周期] ========== onLoad 执行 ==========')
    console.log('[生命周期] 调用栈:', new Error().stack)
    this.loadExistingPets()
  },

  onShow() {
    fileLogger.log('[生命周期] onShow 执行')
    console.log('[生命周期] onShow 执行')
    console.log('[生命周期] 当前时间:', new Date().toISOString())
  },

  onReady() {
    fileLogger.log('[生命周期] onReady 执行')
    console.log('[生命周期] onReady 执行')
  },

  onHide() {
    fileLogger.log('[生命周期] ========== onHide 执行 - 页面隐藏 ==========')
    console.log('[生命周期] ========== onHide 执行 - 页面隐藏 ==========')
    console.log('[生命周期] 调用栈:', new Error().stack)
  },

  onUnload() {
    fileLogger.log('[生命周期] ========== onUnload 执行 - 页面卸载 ==========')
    fileLogger.log('[生命周期] 当前 petInfo: ' + JSON.stringify(this.data.petInfo))
    console.log('[生命周期] ========== onUnload 执行 - 页面卸载 ==========')
    console.log('[生命周期] 调用栈:', new Error().stack)
    console.log('[生命周期] 当前 petInfo:', this.data.petInfo)
  },

  async loadExistingPets() {
    console.log('[页面] 开始加载宠物列表')
    try {
      const pets = await api.pet.getPetList()
      console.log('[页面] 宠物列表加载成功:', pets)
      this.setData({
        existingPets: pets,
        bindMode: pets.length > 0 ? 'existing' : 'new'
      })

      if (pets.length > 0) {
        this.setData({ selectedPetId: pets[0].id })
      }
    } catch (error) {
      console.error('[页面] 加载宠物列表失败:', error)
      this.setData({ bindMode: 'new' })
    }
  },

  // 切换绑定模式
  switchMode(e) {
    const mode = e.currentTarget.dataset.mode
    console.log('[操作] 切换模式到:', mode)
    this.setData({ bindMode: mode })
  },

  // 选择已有宠物
  selectPet(e) {
    const petId = e.currentTarget.dataset.petId
    console.log('[操作] 选择宠物 ID:', petId)
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
    console.log('[操作] 选择性别:', gender)
    this.setData({
      'petInfo.gender': gender
    })
  },

  // 选择头像
  chooseAvatar() {
    fileLogger.log('[头像] ========== 开始选择图片 ==========')
    console.log('[头像] ========== 开始选择图片 ==========')
    wx.chooseMedia({
      count: 1,
      mediaType: ['image'],
      sourceType: ['album'],
      sizeType: ['compressed'],
      success: (res) => {
        fileLogger.log('[头像] 选择图片成功')
        console.log('[头像] 选择图片成功')
        const tempFilePath = res.tempFiles[0].tempFilePath
        const fileSize = res.tempFiles[0].size
        fileLogger.log('[头像] 文件大小: ' + (fileSize / 1024).toFixed(2) + 'KB')
        console.log('[头像] 文件大小:', (fileSize / 1024).toFixed(2) + 'KB')

        if (fileSize > 5 * 1024 * 1024) {
          wx.showToast({ title: '图片不能超过5MB', icon: 'none' })
          return
        }

        fileLogger.log('[头像] 准备上传...')
        console.log('[头像] 准备上传...')
        this.uploadAvatar(tempFilePath)
      },
      fail: (error) => {
        fileLogger.log('[头像] 选择图片失败: ' + JSON.stringify(error))
        console.error('[头像] 选择图片失败:', error)
        wx.showToast({ title: '选择图片失败', icon: 'none' })
      }
    })
  },


  async uploadAvatar(filePath) {
    try {
      fileLogger.log('[上传] ========== 开始上传 ==========')
      fileLogger.log('[上传] 文件路径: ' + filePath)
      console.log('[上传] ========== 开始上传 ==========')
      console.log('[上传] 文件路径:', filePath)
      console.log('[上传] 上传前 petInfo:', this.data.petInfo)

      const url = await api.upload.uploadImage(filePath)
      fileLogger.log('[上传] 上传成功，URL: ' + url)
      fileLogger.log('[上传] URL 类型: ' + typeof url)
      fileLogger.log('[上传] URL 长度: ' + (url ? url.length : 0))
      console.log('[上传] 上传成功，URL:', url)
      console.log('[上传] URL 类型:', typeof url)
      console.log('[上传] URL 长度:', url ? url.length : 0)

      fileLogger.log('[上传] 准备更新数据...')
      console.log('[上传] 准备更新数据...')
      this.setData({
        petInfo: {
          ...this.data.petInfo,
          avatar: url
        }
      })

      fileLogger.log('[上传] setData 执行完成')
      fileLogger.log('[上传] 更新后 petInfo: ' + JSON.stringify(this.data.petInfo))
      console.log('[上传] setData 执行完成')
      console.log('[上传] 更新后 petInfo:', this.data.petInfo)

      // 延迟显示提示，观察是否在此之前页面重新加载
      setTimeout(() => {
        fileLogger.log('[上传] 延迟 100ms 后执行')
        console.log('[上传] 延迟 100ms 后执行')
        wx.showToast({ title: '上传成功', icon: 'success' })
      }, 100)

      fileLogger.log('[上传] ========== uploadAvatar 方法执行完毕 ==========')
      console.log('[上传] ========== uploadAvatar 方法执行完毕 ==========')
    } catch (error) {
      fileLogger.log('[上传] ========== 上传失败 ==========')
      fileLogger.log('[上传] 错误信息: ' + (error.message || JSON.stringify(error)))
      console.error('[上传] ========== 上传失败 ==========')
      console.error('[上传] 错误信息:', error)
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
        app.globalData.currentPet = {
          id: petId,
          ...petInfo
        }
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
      console.error('绑定失败:', error)
      wx.showToast({ title: error.message || '绑定失败', icon: 'none' })
    } finally {
      this.setData({ binding: false })
    }
  }
})
