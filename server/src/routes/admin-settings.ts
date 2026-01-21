import { Router } from 'express';
import { adminAuthMiddleware, AdminAuthRequest } from '../middleware/admin-auth';
import { config } from '../config';

const router = Router();

// 简单的系统配置（内存存储，实际项目应使用数据库）
const systemConfigs: Record<string, any> = {
  maxUsers: 10000,
  deviceTimeout: 120,
  lowBatteryThreshold: 20,
  mqttBroker: config.iot.broker || '',
  contentModerationEnabled: false,
  autoRegisterEnabled: true,
};

// 获取配置
router.get('/', adminAuthMiddleware, (req: AdminAuthRequest, res) => {
  const configs = Object.entries(systemConfigs).map(([key, value]) => ({
    key,
    value,
    description: getConfigDescription(key),
  }));

  res.json({
    code: 0,
    message: 'Success',
    data: configs,
  });
});

// 更新配置
router.put('/', adminAuthMiddleware, (req: AdminAuthRequest, res) => {
  try {
    const updates = req.body;

    for (const [key, value] of Object.entries(updates)) {
      if (key in systemConfigs) {
        systemConfigs[key] = value;
      }
    }

    res.json({ code: 0, message: 'Settings updated successfully', data: systemConfigs });
  } catch (error) {
    console.error('Update settings error:', error);
    res.status(500).json({ code: 500, message: 'Failed to update settings', data: null });
  }
});

function getConfigDescription(key: string): string {
  const descriptions: Record<string, string> = {
    maxUsers: '系统支持的最大用户数量',
    deviceTimeout: '设备离线超时时间（秒）',
    lowBatteryThreshold: '低电量警告阈值（%）',
    mqttBroker: 'MQTT 消息服务器地址',
    contentModerationEnabled: '是否启用内容审核',
    autoRegisterEnabled: '是否启用设备自动注册',
  };
  return descriptions[key] || '';
}

export default router;
