// API 响应类型
export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
}

// 分页响应
export interface PaginatedResponse<T> {
  list: T[]
  total: number
  page: number
  pageSize: number
}

// 认证类型
export interface LoginRequest {
  username: string
  password: string
}

export interface LoginResponse {
  token: string
  admin: AdminInfo
}

export interface AdminInfo {
  id: number
  username: string
  role: string
}

// 用户类型
export interface User {
  id: number
  openid: string
  nickname: string
  avatar?: string
  phone?: string
  has_custom_profile: boolean
  is_banned?: boolean
  ban_reason?: string
  created_at: string
  updated_at: string
  pets?: Pet[]
}

// 宠物类型
export interface Pet {
  id: number
  user_id: number
  name: string
  avatar?: string
  breed?: string
  birthday?: string
  gender: 'male' | 'female'
  weight?: number
  device_id?: number
  created_at: string
  updated_at: string
  device?: Device
}

// 设备类型
export interface Device {
  id: number
  deviceSn: string
  petId?: number
  batteryLevel: number
  isOnline: boolean
  lastOnlineAt?: string
  buzzerEnabled: boolean
  sleepModeEnabled: boolean
  ledEnabled: boolean
  firmwareVersion?: string
  createdAt: string
  updatedAt: string
  pet?: Pet
}

// 审核状态类型
export type AuditStatus = 'pending' | 'approved' | 'rejected'

// 朋友圈类型
export interface Moment {
  id: number
  user_id: number
  pet_id?: number
  content: string
  images: string[]
  is_public: boolean
  likeCount: number
  commentCount: number
  status?: AuditStatus
  reviewed_by_id?: number
  reviewed_at?: string
  rejection_reason?: string
  created_at: string
  updated_at: string
  user?: User
  pet?: Pet
  reviewed_by?: AdminInfo
}

// 统计数据类型
export interface OverviewStats {
  userCount: number
  deviceCount: number
  onlineDeviceCount: number
  todayActiveCount: number
  todayNewUsers: number
}

export interface TrendData {
  date: string
  count: number
}

// MQTT 监控类型
export interface MqttStats {
  messagesReceived: number
  messagesSent: number
  activeDevices: number
}

export interface DeviceLog {
  timestamp: string
  deviceId: number
  deviceSn: string
  type: string
  message: string
  status: string
}

// 系统配置类型
export interface SystemConfig {
  key: string
  value: any
  description?: string
}
