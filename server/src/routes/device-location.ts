import { Router } from 'express';
import { AppDataSource } from '../index';
import { DeviceLocation } from '../entities/DeviceLocation';
import { Device } from '../entities/Device';
import { Pet } from '../entities/Pet';
import { authMiddleware, AuthRequest } from '../middleware/auth';

const router = Router();

/**
 * 获取设备最新位置
 * GET /api/device/:id/location/latest
 */
router.get('/device/:id/location/latest', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const deviceId = parseInt(req.params.id);

    const deviceRepo = AppDataSource.getRepository(Device);
    const petRepo = AppDataSource.getRepository(Pet);
    const device = await deviceRepo.findOne({ where: { id: deviceId } });

    if (!device) {
      return res.status(404).json({ code: 404, message: 'Device not found', data: null });
    }

    // 验证设备属于当前用户
    if (device.petId) {
      const petRepo = AppDataSource.getRepository(Pet);
      const pet = await petRepo.findOne({ where: { id: device.petId } });
      if (pet?.user_id !== req.userId) {
        return res.status(403).json({ code: 403, message: 'Access denied', data: null });
      }
    }

    const locationRepo = AppDataSource.getRepository(DeviceLocation);
    const location = await locationRepo.findOne({
      where: { deviceId },
      order: { recordedAt: 'DESC' }
    });

    if (!location) {
      return res.status(404).json({ code: 404, message: 'No location data', data: null });
    }

    // 添加宠物名称
    const result = {
      ...location,
      petName: device.petId ? (await petRepo.findOneBy({ id: device.petId }))?.name : null
    };

    res.json({ code: 0, message: 'Success', data: result });
  } catch (error) {
    console.error('Get latest location error:', error);
    res.status(500).json({ code: 500, message: 'Internal server error', data: null });
  }
});

/**
 * 获取设备位置历史
 * GET /api/device/:id/locations/history?startTime=&endTime=&limit=
 */
router.get('/device/:id/locations/history', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const deviceId = parseInt(req.params.id);
    const limit = Math.min(parseInt(req.query.limit as string) || 100, 1000);
    const startTime = req.query.startTime as string;
    const endTime = req.query.endTime as string;

    const deviceRepo = AppDataSource.getRepository(Device);
    const device = await deviceRepo.findOne({ where: { id: deviceId } });

    if (!device) {
      return res.status(404).json({ code: 404, message: 'Device not found', data: null });
    }

    // 验证设备属于当前用户
    if (device.petId) {
      const petRepo = AppDataSource.getRepository(Pet);
      const pet = await petRepo.findOne({ where: { id: device.petId } });
      if (pet?.user_id !== req.userId) {
        return res.status(403).json({ code: 403, message: 'Access denied', data: null });
      }
    }

    const locationRepo = AppDataSource.getRepository(DeviceLocation);

    const query = locationRepo.createQueryBuilder('location')
      .where('location.deviceId = :deviceId', { deviceId });

    if (startTime) {
      query.andWhere('location.recordedAt >= :startTime', { startTime: new Date(startTime) });
    }

    if (endTime) {
      query.andWhere('location.recordedAt <= :endTime', { endTime: new Date(endTime) });
    }

    query.orderBy('location.recordedAt', 'DESC')
      .limit(limit);

    const locations = await query.getMany();

    res.json({ code: 0, message: 'Success', data: locations });
  } catch (error) {
    console.error('Get location history error:', error);
    res.status(500).json({ code: 500, message: 'Internal server error', data: null });
  }
});

/**
 * 获取设备今日轨迹
 * GET /api/device/:id/locations/today
 */
router.get('/device/:id/locations/today', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const deviceId = parseInt(req.params.id);

    const deviceRepo = AppDataSource.getRepository(Device);
    const device = await deviceRepo.findOne({ where: { id: deviceId } });

    if (!device) {
      return res.status(404).json({ code: 404, message: 'Device not found', data: null });
    }

    // 验证设备属于当前用户
    if (device.petId) {
      const petRepo = AppDataSource.getRepository(Pet);
      const pet = await petRepo.findOne({ where: { id: device.petId } });
      if (pet?.user_id !== req.userId) {
        return res.status(403).json({ code: 403, message: 'Access denied', data: null });
      }
    }

    // 获取今天开始时间
    const todayStart = new Date();
    todayStart.setHours(0, 0, 0, 0);

    const todayEnd = new Date();
    todayEnd.setHours(23, 59, 59, 999);

    const locationRepo = AppDataSource.getRepository(DeviceLocation);
    const locations = await locationRepo
      .createQueryBuilder('location')
      .where('location.deviceId = :deviceId', { deviceId })
      .andWhere('location.recordedAt BETWEEN :start AND :end', {
        start: todayStart,
        end: todayEnd
      })
      .orderBy('location.recordedAt', 'ASC')
      .getMany();

    res.json({ code: 0, message: 'Success', data: locations });
  } catch (error) {
    console.error('Get today locations error:', error);
    res.status(500).json({ code: 500, message: 'Internal server error', data: null });
  }
});

/**
 * 获取用户所有设备的最新位置
 * GET /api/locations/devices
 */
router.get('/locations/devices', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const petRepo = AppDataSource.getRepository(Pet);
    const deviceRepo = AppDataSource.getRepository(Device);
    const locationRepo = AppDataSource.getRepository(DeviceLocation);

    // 获取用户的所有宠物
    const pets = await petRepo.find({ where: { user_id: req.userId } });
    const petIds = pets.map(p => p.id);

    if (petIds.length === 0) {
      return res.json({ code: 0, message: 'Success', data: [] });
    }

    // 获取这些宠物的设备
    const devices = await deviceRepo
      .createQueryBuilder('device')
      .where('device.petId IN (:...petIds)', { petIds })
      .getMany();

    const deviceIds = devices.map(d => d.id);

    if (deviceIds.length === 0) {
      return res.json({ code: 0, message: 'Success', data: [] });
    }

    // 获取每个设备的最新位置（使用子查询优化）
    const locations = await locationRepo
      .createQueryBuilder('location')
      .where(`location.id IN (
        SELECT MAX(l.id)
        FROM device_locations l
        WHERE l.device_id IN (:...deviceIds)
        GROUP BY l.device_id
      )`, { deviceIds })
      .getMany();

    // 组合结果
    const results = locations.map(loc => {
      const device = devices.find(d => d.id === loc.deviceId);
      const pet = pets.find(p => p.id === device?.petId);
      return {
        ...loc,
        deviceSn: device?.deviceSn,
        petName: pet?.name,
        petAvatar: pet?.avatar
      };
    });

    res.json({ code: 0, message: 'Success', data: results });
  } catch (error) {
    console.error('Get all devices locations error:', error);
    res.status(500).json({ code: 500, message: 'Internal server error', data: null });
  }
});

export default router;
