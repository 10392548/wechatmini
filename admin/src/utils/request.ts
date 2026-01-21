import axios, { type AxiosError, type InternalAxiosRequestConfig } from 'axios'
import { message } from 'antd'

const request = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:3003/api',
  timeout: 30000,
})

// 从 zustand persist 存储中获取 token
const getToken = () => {
  const stored = localStorage.getItem('admin-auth')
  if (stored) {
    try {
      const parsed = JSON.parse(stored)
      return parsed.state?.token || null
    } catch {
      return null
    }
  }
  return null
}

// 请求拦截器
request.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = getToken()
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error)
)

// 响应拦截器
request.interceptors.response.use(
  (response) => {
    const { code, data, message: msg } = response.data
    if (code === 0) {
      return data
    }
    message.error(msg || '请求失败')
    return Promise.reject(new Error(msg))
  },
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('admin-auth')
      window.location.href = '/login'
    }
    message.error(error.message || '网络错误')
    return Promise.reject(error)
  }
)

export default request
