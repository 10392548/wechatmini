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

// 设备日志
router.get('/logs', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { page = 1, pageSize = 20, deviceSn } = req.query;
    const pageNum = Number(page);
    const sizeNum = Number(pageSize);

    const deviceCommandRepo = AppDataSource.getRepository(DeviceCommand);

    const queryBuilder = deviceCommandRepo.createQueryBuilder('command')
      .leftJoin('command.device', 'device');

    if (deviceSn) {
      queryBuilder.andWhere('device.deviceSn = :deviceSn', { deviceSn });
    }

    const [commands, total] = await queryBuilder
      .orderBy('command.createdAt', 'DESC')
      .skip((pageNum - 1) * sizeNum)
      .take(sizeNum)
      .getManyAndCount();

    const logs = commands.map((cmd: any) => ({
      timestamp: cmd.createdAt,
      deviceId: cmd.deviceId,
      deviceSn: cmd.device?.deviceSn || 'Unknown',
      type: cmd.commandType,
      message: cmd.payload ? JSON.stringify(cmd.payload) : '',
      status: cmd.status,
    }));

    res.json({
      code: 0,
      message: 'Success',
      data: {
        list: logs,
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
