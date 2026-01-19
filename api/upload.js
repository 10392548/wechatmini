const config = require('../config/index')
const tokenManager = require('../utils/token')
const fileLogger = require('../utils/fileLogger')

module.exports = {
  // 上传单张图片
  uploadImage(filePath) {
    return new Promise((resolve, reject) => {
      const token = tokenManager.getToken()

      fileLogger.log('[API上传] 开始上传图片，token 存在: ' + !!token)
      console.log('[上传] 开始上传图片，token 存在:', !!token)

      wx.uploadFile({
        url: `${config.baseURL}/api/upload/image`,
        filePath,
        name: 'file',
        header: {
          'Authorization': `Bearer ${token}`
        },
        success: (res) => {
          fileLogger.log('[API上传] 上传响应，statusCode: ' + res.statusCode)
          console.log('[上传] 上传响应，statusCode:', res.statusCode)

          // 检查 HTTP 状态码
          if (res.statusCode === 401) {
            fileLogger.log('[API上传] 401 未授权，token 可能已过期')
            console.error('[上传] 401 未授权，token 可能已过期')
            wx.showToast({
              title: '登录已过期，请重新登录',
              icon: 'none',
              duration: 2000
            })
            reject(new Error('Unauthorized'))
            return
          }

          if (res.statusCode !== 200) {
            fileLogger.log('[API上传] 上传失败，statusCode: ' + res.statusCode)
            console.error('[上传] 上传失败，statusCode:', res.statusCode)
            wx.showToast({
              title: '上传失败',
              icon: 'none'
            })
            reject(new Error(`HTTP ${res.statusCode}`))
            return
          }

          try {
            fileLogger.log('[API上传] 原始响应数据: ' + res.data)
            console.log('[上传] 原始响应数据:', res.data)
            console.log('[上传] 响应数据类型:', typeof res.data)

            const data = JSON.parse(res.data)
            fileLogger.log('[API上传] 解析后的数据: ' + JSON.stringify(data))
            console.log('[上传] 解析后的数据:', JSON.stringify(data))

            if (data.code === 0) {
              // 如果返回的是相对路径，拼接完整 URL
              let url = data.data.url
              fileLogger.log('[API上传] 返回 URL: ' + url)
              console.log('[上传] 返回 URL:', url)
              console.log('[上传] URL 是否以 /uploads 开头:', url && url.startsWith('/uploads'))

              if (url && url.startsWith('/uploads')) {
                url = config.baseURL + url
                fileLogger.log('[API上传] 拼接后 URL: ' + url)
                console.log('[上传] 拼接后 URL:', url)
              }

              fileLogger.log('[API上传] 准备 resolve，最终 URL: ' + url)
              console.log('[上传] 准备 resolve，最终 URL:', url)
              resolve(url)
              fileLogger.log('[API上传] resolve 执行完成')
              console.log('[上传] resolve 执行完成')
            } else {
              fileLogger.log('[API上传] 上传失败: ' + data.message)
              console.error('[上传] 上传失败:', data.message)
              wx.showToast({
                title: data.message || '上传失败',
                icon: 'none'
              })
              reject(new Error(data.message))
            }
          } catch (parseError) {
            fileLogger.log('[API上传] 解析响应失败: ' + parseError.message)
            fileLogger.log('[API上传] 原始响应: ' + res.data)
            console.error('[上传] 解析响应失败:', parseError)
            console.error('[上传] 原始响应:', res.data)
            wx.showToast({
              title: '上传失败',
              icon: 'none'
            })
            reject(parseError)
          }
        },
        fail: (error) => {
          fileLogger.log('[API上传] 上传请求失败: ' + JSON.stringify(error))
          console.error('[上传] 上传请求失败:', error)
          wx.showToast({
            title: '网络错误',
            icon: 'none'
          })
          reject(error)
        }
      })
    })
  },

  // 上传多张图片
  async uploadImages(filePaths) {
    const urls = []
    for (const filePath of filePaths) {
      const url = await this.uploadImage(filePath)
      urls.push(url)
    }
    return urls
  }
}
