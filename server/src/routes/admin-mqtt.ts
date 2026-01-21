import { Router } from 'express';
import { AppDataSource } from '../index';
import { DeviceDataLog } from '../entities/DeviceDataLog';
import { DeviceCommand } from '../entities/DeviceCommand';
import { Device } from '../entities/Device';
import { adminAuthMiddleware, AdminAuthRequest } from '../middleware/admin-auth';

const router = Router();

// MQTT 统计
router.get('/stats', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const deviceDataLogRepo = AppDataSource.getRepository(DeviceDataLog);
    const deviceCommandRepo = AppDataSource.getRepository(DeviceCommand);
    const deviceRepo = AppDataSource.getRepository(Device);

    const [messagesReceived, messagesSent, activeDevices] = await Promise.all([
      deviceDataLogRepo.count(),
      deviceCommandRepo.count(),
      deviceRepo.count({ where: { isOnline: true } }),
    ]);

    res.json({
      code: 0,
      message: 'Success',
      data: {
        messagesReceived,
        messagesSent,
        activeDevices,
      },
    });
  } catch (error) {
    console.error('Get MQTT stats error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get stats', data: null });
  }
});

// 设备数据日志（显示接收到的 MQTT 消息）
router.get('/logs', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { page = 1, pageSize = 20, deviceSn } = req.query;
    const pageNum = Number(page);
    const sizeNum = Number(pageSize);

    const deviceDataLogRepo = AppDataSource.getRepository(DeviceDataLog);

    const queryBuilder = deviceDataLogRepo.createQueryBuilder('log');

    if (deviceSn && typeof deviceSn === 'string') {
      queryBuilder.andWhere('log.deviceSn = :deviceSn', { deviceSn });
    }

    const [logs, total] = await queryBuilder
      .orderBy('log.receivedAt', 'DESC')
      .skip((pageNum - 1) * sizeNum)
      .take(sizeNum)
      .getManyAndCount();

    // 映射为前端期望的数据格式
    const formattedLogs = logs.map((log) => ({
      timestamp: log.receivedAt,
      deviceId: log.deviceId,
      deviceSn: log.deviceSn,
      type: 'data',
      message: JSON.stringify(log.rawData),
      status: 'success',
    }));

    res.json({
      code: 0,
      message: 'Success',
      data: {
        list: formattedLogs,
        total,
        page: pageNum,
        pageSize: sizeNum,
      },
    });
  } catch (error) {
    console.error('Get device logs error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get logs', data: null });
  }
});

export default router;
