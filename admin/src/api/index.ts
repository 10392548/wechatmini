import request from '@/utils/request'
import type {
  LoginRequest,
  LoginResponse,
  PaginatedResponse,
  User,
  Device,
  Moment,
  OverviewStats,
  TrendData,
  MqttStats,
  DeviceLog,
  SystemConfig,
} from '@/types/api'

// ========== 认证 API ==========
export const authApi = {
  // 管理员登录
  login: (data: LoginRequest) =>
    request.post<LoginResponse>('/admin/auth/login', data),

  // 验证 token
  verify: () =>
    request.get<LoginResponse>('/admin/auth/verify'),
}

// ========== 用户管理 API ==========
export const userApi = {
  // 获取用户列表
  getList: (params: { page: number; pageSize: number; keyword?: string }) =>
    request.get<PaginatedResponse<User>>('/admin/users', { params }),

  // 获取用户详情
  getDetail: (id: number) =>
    request.get<User>(`/admin/users/${id}`),

  // 封禁用户
  ban: (id: number, reason: string) =>
    request.put(`/admin/users/${id}/ban`, { reason }),

  // 解封用户
  unban: (id: number) =>
    request.put(`/admin/users/${id}/unban`),
}

// ========== 设备管理 API ==========
export const deviceApi = {
  // 获取设备列表
  getList: (params: { page: number; pageSize: number; status?: string; keyword?: string }) =>
    request.get<PaginatedResponse<Device>>('/admin/devices', { params }),

  // 获取设备详情
  getDetail: (id: number) =>
    request.get<Device>(`/admin/devices/${id}`),

  // 获取在线状态统计
  getOnlineStatus: () =>
    request.get<{ online: number; offline: number; total: number }>('/admin/devices/online-status'),

  // 蜂鸣器控制
  buzzerControl: (id: number, enabled: boolean) =>
    request.post(`/admin/devices/${id}/buzzer`, { enabled }),

  // LED 控制
  ledControl: (id: number, enabled: boolean) =>
    request.post(`/admin/devices/${id}/led`, { enabled }),

  // 休眠模式控制
  sleepControl: (id: number, enabled: boolean) =>
    request.post(`/admin/devices/${id}/sleep`, { enabled }),
}

// ========== 内容审核 API ==========
export const momentApi = {
  // 获取朋友圈列表
  getList: (params: { page: number; pageSize: number; status?: string }) =>
    request.get<PaginatedResponse<Moment>>('/admin/moments', { params }),

  // 删除朋友圈
  delete: (id: number) =>
    request.delete(`/admin/moments/${id}`),
}

// ========== 数据统计 API ==========
export const statsApi = {
  // 总体统计
  overview: () =>
    request.get<OverviewStats>('/admin/stats/overview'),

  // 用户增长趋势
  userGrowth: (days: number = 30) =>
    request.get<TrendData[]>('/admin/stats/user-growth', { params: { days } }),

  // 活跃度统计
  activity: (days: number = 7) =>
    request.get<{ labels: string[]; values: number[] }>('/admin/stats/activity', { params: { days } }),

  // 设备状态分布
  deviceStatus: () =>
    request.get<{ online: number; offline: number; lowBattery: number }>('/admin/stats/device-status'),
}

// ========== MQTT 监控 API ==========
export const mqttApi = {
  // 获取 MQTT 统计
  stats: () =>
    request.get<MqttStats>('/admin/mqtt/stats'),

  // 获取设备日志
  logs: (params: { page: number; pageSize: number; deviceSn?: string }) =>
    request.get<PaginatedResponse<DeviceLog>>('/admin/mqtt/logs', { params }),
}

// ========== 系统配置 API ==========
export const systemApi = {
  // 获取配置
  getSettings: () =>
    request.get<SystemConfig[]>('/admin/settings'),

  // 更新配置
  updateSettings: (data: Record<string, any>) =>
    request.put('/admin/settings', data),
}
