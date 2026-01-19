const config = require('../config/index')
const tokenManager = require('./token')

let isRefreshing = false
let refreshSubscribers = []

function subscribeTokenRefresh(callback) {
  refreshSubscribers.push(callback)
}

function onTokenRefreshed(token) {
  refreshSubscribers.forEach(callback => callback(token))
  refreshSubscribers = []
}

function refreshToken() {
  return new Promise((resolve, reject) => {
    const refreshTokenValue = tokenManager.getRefreshToken()
    console.log('[Token] 开始刷新 token，refreshToken 存在:', !!refreshTokenValue)

    if (!refreshTokenValue) {
      console.error('[Token] RefreshToken 不存在')
      reject(new Error('No refresh token'))
      return
    }

    wx.request({
      url: `${config.baseURL}/api/auth/refresh`,
      method: 'POST',
      data: { refreshToken: refreshTokenValue },
      success: (res) => {
        console.log('[Token] 刷新请求响应:', res.data)
        if (res.data.code === 0) {
          tokenManager.setToken(res.data.data.accessToken)
          if (res.data.data.refreshToken) {
            tokenManager.setRefreshToken(res.data.data.refreshToken)
          }
          resolve(res.data.data.accessToken)
        } else {
          console.error('[Token] 刷新失败，响应码:', res.data.code)
          reject(new Error('Refresh failed'))
        }
      },
      fail: (error) => {
        console.error('[Token] 刷新请求失败:', error)
        reject(error)
      }
    })
  })
}

function handleTokenExpired() {
  if (isRefreshing) {
    return new Promise(resolve => {
      subscribeTokenRefresh(token => resolve(token))
    })
  }

  console.log('[Token] Token 过期，尝试刷新')
  isRefreshing = true
  return refreshToken()
    .then(token => {
      console.log('[Token] Token 刷新成功')
      onTokenRefreshed(token)
      return token
    })
    .catch((error) => {
      console.error('[Token] Token 刷新失败:', error)
      tokenManager.clearTokens()
      // 暂时禁用自动跳转，避免循环重启
      wx.showToast({
        title: '登录已过期',
        icon: 'none',
        duration: 3000
      })
      // TODO: 等待用户手动操作
      throw new Error('Token refresh failed')
    })
    .finally(() => {
      isRefreshing = false
    })
}

function shouldRetry(error, retryCount) {
  if (retryCount >= config.retryCount) return false

  const noRetryErrors = [400, 401, 403, 404]
  if (error.statusCode && noRetryErrors.includes(error.statusCode)) return false
  if (error.code && noRetryErrors.includes(error.code)) return false

  return true
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

function request(options) {
  const {
    url,
    method = 'GET',
    data = {},
    header = {},
    retryCount = 0
  } = options

  const token = tokenManager.getToken()
  if (token) {
    header.Authorization = `Bearer ${token}`
  }

  // 设置 JSON 内容类型
  if (method === 'POST' || method === 'PUT') {
    header['Content-Type'] = 'application/json'
  }

  return new Promise((resolve, reject) => {
    wx.request({
      url: `${config.baseURL}${url}`,
      method,
      data,
      header,
      timeout: config.timeout,
      success: (res) => {
        if (res.statusCode === 401 || res.data.code === 401) {
          handleTokenExpired()
            .then(() => request({
              ...options,
              retryCount: 0
            }))
            .then(resolve)
            .catch(reject)
          return
        }

        if (res.data.code === 0) {
          resolve(res.data.data)
        } else {
          wx.showToast({ title: res.data.message || '请求失败', icon: 'none' })
          reject(res.data)
        }
      },
      fail: (error) => {
        if (shouldRetry(error, retryCount)) {
          const delay = config.retryDelay * Math.pow(2, retryCount)
          sleep(delay)
            .then(() => request({
              ...options,
              retryCount: retryCount + 1
            }))
            .then(resolve)
            .catch(reject)
        } else {
          wx.showToast({ title: '网络请求失败', icon: 'none' })
          reject(error)
        }
      }
    })
  })
}

module.exports = {
  get(url, data, options = {}) {
    return request({ url, method: 'GET', data, ...options })
  },

  post(url, data, options = {}) {
    return request({ url, method: 'POST', data, ...options })
  },

  put(url, data, options = {}) {
    return request({ url, method: 'PUT', data, ...options })
  },

  delete(url, data, options = {}) {
    return request({ url, method: 'DELETE', data, ...options })
  },

  request
}
