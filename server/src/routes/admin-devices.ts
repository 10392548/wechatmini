import { Router } from 'express';
import { AppDataSource } from '../index';
import { Device } from '../entities/Device';
import { Pet } from '../entities/Pet';
import { adminAuthMiddleware, AdminAuthRequest } from '../middleware/admin-auth';
import { getMQTTService } from '../services/mqtt.service';

const router = Router();

// 获取设备列表
router.get('/', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { page = 1, pageSize = 20, status, keyword = '' } = req.query;
    const pageNum = Number(page);
    const sizeNum = Number(pageSize);

    const deviceRepo = AppDataSource.getRepository(Device);

    const queryBuilder = deviceRepo.createQueryBuilder('device')
      .leftJoinAndSelect('device.pet', 'pet');

    if (keyword) {
      queryBuilder.andWhere('device.deviceSn LIKE :keyword', { keyword: `%${keyword}%` });
    }

    if (status === 'online') {
      queryBuilder.andWhere('device.isOnline = :online', { online: true });
    } else if (status === 'offline') {
      queryBuilder.andWhere('device.isOnline = :online', { online: false });
    }

    const [devices, total] = await queryBuilder
      .orderBy('device.createdAt', 'DESC')
      .skip((pageNum - 1) * sizeNum)
      .take(sizeNum)
      .getManyAndCount();

    res.json({
      code: 0,
      message: 'Success',
      data: {
        list: devices,
        total,
        page: pageNum,
        pageSize: sizeNum,
      },
    });
  } catch (error) {
    console.error('Get devices error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get devices', data: null });
  }
});

// 获取设备详情
router.get('/:id', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { id } = req.params;
    const deviceRepo = AppDataSource.getRepository(Device);

    const device = await deviceRepo.findOne({
      where: { id: Number(id) },
      relations: ['pet'],
    });

    if (!device) {
      return res.status(404).json({ code: 404, message: 'Device not found', data: null });
    }

    res.json({ code: 0, message: 'Success', data: device });
  } catch (error) {
    console.error('Get device detail error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get device', data: null });
  }
});

// 获取在线状态统计
router.get('/online-status', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const deviceRepo = AppDataSource.getRepository(Device);

    const [online, offline, total] = await Promise.all([
      deviceRepo.count({ where: { isOnline: true } }),
      deviceRepo.count({ where: { isOnline: false } }),
      deviceRepo.count(),
    ]);

    res.json({
      code: 0,
      message: 'Success',
      data: { online, offline, total },
    });
  } catch (error) {
    console.error('Get online status error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get status', data: null });
  }
});

// 蜂鸣器控制
router.post('/:id/buzzer', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { id } = req.params;
    const { enabled } = req.body;

    const deviceRepo = AppDataSource.getRepository(Device);
    const device = await deviceRepo.findOne({ where: { id: Number(id) } });

    if (!device) {
      return res.status(404).json({ code: 404, message: 'Device not found', data: null });
    }

    device.buzzerEnabled = enabled;
    await deviceRepo.save(device);

    // 通过 MQTT 发送控制命令
    const mqttService = getMQTTService();
    const mqttSent = mqttService?.isConnected() ?? false;
    if (mqttSent && mqttService) {
      await mqttService.buzzerControl(device.deviceSn, enabled);
    }

    res.json({
      code: 0,
      message: 'Success',
      data: { success: true, mqttSent },
    });
  } catch (error) {
    console.error('Buzzer control error:', error);
    res.status(500).json({ code: 500, message: 'Control failed', data: null });
  }
});

// LED 控制
router.post('/:id/led', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { id } = req.params;
    const { enabled } = req.body;

    const deviceRepo = AppDataSource.getRepository(Device);
    const device = await deviceRepo.findOne({ where: { id: Number(id) } });

    if (!device) {
      return res.status(404).json({ code: 404, message: 'Device not found', data: null });
    }

    device.ledEnabled = enabled;
    await deviceRepo.save(device);

    const mqttService = getMQTTService();
    const mqttSent = mqttService?.isConnected() ?? false;
    if (mqttSent && mqttService) {
      await mqttService.ledControl(device.deviceSn, enabled);
    }

    res.json({
      code: 0,
      message: 'Success',
      data: { success: true, mqttSent },
    });
  } catch (error) {
    console.error('LED control error:', error);
    res.status(500).json({ code: 500, message: 'Control failed', data: null });
  }
});

// 休眠模式控制
router.post('/:id/sleep', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { id } = req.params;
    const { enabled } = req.body;

    const deviceRepo = AppDataSource.getRepository(Device);
    const device = await deviceRepo.findOne({ where: { id: Number(id) } });

    if (!device) {
      return res.status(404).json({ code: 404, message: 'Device not found', data: null });
    }

    device.sleepModeEnabled = enabled;
    await deviceRepo.save(device);

    const mqttService = getMQTTService();
    const mqttSent = mqttService?.isConnected() ?? false;
    if (mqttSent && mqttService) {
      await mqttService.sleepControl(device.deviceSn, enabled);
    }

    res.json({
      code: 0,
      message: 'Success',
      data: { success: true, mqttSent },
    });
  } catch (error) {
    console.error('Sleep control error:', error);
    res.status(500).json({ code: 500, message: 'Control failed', data: null });
  }
});

export default router;
