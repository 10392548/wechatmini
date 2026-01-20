import { Request, Response, NextFunction } from 'express';

/**
 * 设备认证中间件
 * 验证设备端调用请求（通过简单的API Key或设备凭证）
 * 生产环境应该使用更安全的设备证书机制
 */
export function deviceAuthMiddleware(req: Request, res: Response, next: NextFunction) {
  // 从请求头获取设备凭证
  const deviceKey = req.headers['x-device-key'] as string;
  const deviceSn = req.headers['x-device-sn'] as string;

  // 验证必需的头部信息
  if (!deviceKey || !deviceSn) {
    return res.status(401).json({ code: 401, message: 'Device credentials required', data: null });
  }

  // 验证设备凭证（生产环境应该使用数据库或缓存验证）
  // 这里使用环境变量配置的设备密钥进行简单验证
  const validDeviceKey = process.env.DEVICE_API_KEY;

  if (!validDeviceKey) {
    console.warn('[DeviceAuth] DEVICE_API_KEY not configured');
    return res.status(500).json({ code: 500, message: 'Server configuration error', data: null });
  }

  if (deviceKey !== validDeviceKey) {
    return res.status(403).json({ code: 403, message: 'Invalid device credentials', data: null });
  }

  // 将设备序列号附加到请求对象
  (req as any).deviceSn = deviceSn;

  next();
}
