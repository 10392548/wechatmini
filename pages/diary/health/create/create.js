// pages/diary/health/create/create.js
const api = require('../../../../api/index')

Page({
  data: {
    recordType: 'vaccination',
    title: '',
    description: '',
    recordDate: '',
    endDate: '',
    vaccineName: '',
    nextVaccinationDate: '',
    symptoms: '',
    diagnosis: '',
    hospital: '',
    medicineName: '',
    dosage: '',
    frequency: '',
    durationDays: '',
    weight: '',
    temperature: '',
    heartRate: '',
    checkupResult: '',
    notes: '',
    cost: '',
    submitting: false
  },

  onLoad() {
    // 设置默认日期为今天
    const today = this.formatDate(new Date())
    this.setData({ recordDate: today })
  },

  formatDate(date) {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  },

  onTypeChange(e) {
    this.setData({ recordType: e.currentTarget.dataset.value })
    wx.vibrateShort({ type: 'light' })
  },

  onTitleInput(e) {
    this.setData({ title: e.detail.value })
  },

  onShowDatePicker() {
    const that = this
    wx.showActionSheet({
      itemList: ['选择日期'],
      success() {
        that.showDatePicker('recordDate')
      }
    })
  },

  onShowNextDatePicker() {
    this.showDatePicker('nextVaccinationDate')
  },

  onShowEndDatePicker() {
    this.showDatePicker('endDate')
  },

  showDatePicker(field) {
    const currentDate = new Date()
    const that = this
    wx.showModal({
      title: '选择日期',
      editable: true,
      placeholderText: 'YYYY-MM-DD',
      success(res) {
        if (res.confirm && res.content) {
          const dateStr = res.content.trim()
          // 简单验证日期格式
          if (/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) {
            that.setData({ [field]: dateStr })
          } else {
            wx.showToast({ title: '日期格式错误', icon: 'none' })
          }
        }
      }
    })
  },

  onVaccineNameInput(e) {
    this.setData({ vaccineName: e.detail.value })
  },

  onSymptomsInput(e) {
    this.setData({ symptoms: e.detail.value })
  },

  onDiagnosisInput(e) {
    this.setData({ diagnosis: e.detail.value })
  },

  onHospitalInput(e) {
    this.setData({ hospital: e.detail.value })
  },

  onMedicineNameInput(e) {
    this.setData({ medicineName: e.detail.value })
  },

  onDosageInput(e) {
    this.setData({ dosage: e.detail.value })
  },

  onFrequencyInput(e) {
    this.setData({ frequency: e.detail.value })
  },

  onDurationDaysInput(e) {
    this.setData({ durationDays: e.detail.value })
  },

  onWeightInput(e) {
    this.setData({ weight: e.detail.value })
  },

  onTemperatureInput(e) {
    this.setData({ temperature: e.detail.value })
  },

  onHeartRateInput(e) {
    this.setData({ heartRate: e.detail.value })
  },

  onCheckupResultInput(e) {
    this.setData({ checkupResult: e.detail.value })
  },

  onNotesInput(e) {
    this.setData({ notes: e.detail.value })
  },

  onCostInput(e) {
    this.setData({ cost: e.detail.value })
  },

  async onSubmit() {
    const { recordType, title, submitting } = this.data

    if (submitting) return

    if (!title.trim()) {
      wx.showToast({ title: '请输入标题', icon: 'none' })
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

      // 构建请求数据
      const data = {
        record_type: recordType,
        title: title.trim(),
        description: this.data.description.trim() || null,
        record_date: this.data.recordDate || null,
        end_date: this.data.endDate || null,
        vaccine_name: this.data.vaccineName || null,
        next_vaccination_date: this.data.nextVaccinationDate || null,
        symptoms: this.data.symptoms || null,
        diagnosis: this.data.diagnosis || null,
        hospital: this.data.hospital || null,
        medicine_name: this.data.medicineName || null,
        dosage: this.data.dosage || null,
        frequency: this.data.frequency || null,
        duration_days: this.data.durationDays ? parseInt(this.data.durationDays) : null,
        weight: this.data.weight ? parseFloat(this.data.weight) : null,
        temperature: this.data.temperature ? parseFloat(this.data.temperature) : null,
        heart_rate: this.data.heartRate ? parseInt(this.data.heartRate) : null,
        checkup_result: this.data.checkupResult || null,
        notes: this.data.notes || null,
        cost: this.data.cost ? parseFloat(this.data.cost) : null
      }

      await api.pet.createHealthRecord(currentPet.id, data)

      wx.showToast({ title: '创建成功', icon: 'success' })

      setTimeout(() => {
        wx.navigateBack()
      }, 1500)
    } catch (error) {
      console.error('创建健康记录失败', error)
      wx.showToast({ title: '创建失败，请重试', icon: 'none' })
    } finally {
      this.setData({ submitting: false })
    }
  }
})
