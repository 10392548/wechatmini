import { Router } from 'express';
import { Response } from 'express';
import { AppDataSource } from '../index';
import { Device } from '../entities/Device';
import { Pet } from '../entities/Pet';
import { authMiddleware, AuthRequest } from '../middleware/auth';
import { deviceAuthMiddleware } from '../middleware/device-auth';
import { getMQTTService } from '../services/mqtt.service';
import { DeviceLocation } from '../entities/DeviceLocation';

const router = Router();

// =====================================================
// 设备控制类型定义
// =====================================================
type DeviceControlType = 'buzzer' | 'sleep' | 'led';

const CONTROL_FIELD_MAP: Record<DeviceControlType, keyof Device> = {
  buzzer: 'buzzerEnabled',
  sleep: 'sleepModeEnabled',
  led: 'ledEnabled'
};

const CONTROL_RESPONSE_KEY_MAP: Record<DeviceControlType, string> = {
  buzzer: 'buzzer',
  sleep: 'sleep',
  led: 'led'
};

// =====================================================
// 通用设备控制函数
// =====================================================
/**
 * 处理设备控制请求
 * @param req 请求对象
 * @param res 响应对象
 * @param controlType 控制类型（buzzer/sleep/led）
 */
async function handleDeviceControl(
  req: AuthRequest,
  res: Response,
  controlType: DeviceControlType
): Promise<void> {
  try {
    const deviceId = parseInt(req.params.id);
    const { enabled } = req.body;

    // 验证输入
    if (typeof enabled !== 'boolean') {
      res.status(400).json({ code: 400, message: 'enabled (boolean) required', data: null });
      return;
    }

    const deviceRepo = AppDataSource.getRepository(Device);
    const device = await deviceRepo.findOne({
      where: { id: deviceId },
      relations: ['pet']
    });

    if (!device) {
      res.status(404).json({ code: 404, message: 'Device not found', data: null });
      return;
    }

    // 验证设备属于当前用户
    if (device.pet?.user_id !== req.userId) {
      res.status(403).json({ code: 403, message: 'Access denied', data: null });
      return;
    }

    // 更新本地状态
    const field = CONTROL_FIELD_MAP[controlType] as keyof Device;
    (device as any)[field] = enabled;
    await deviceRepo.save(device);

    // 通过MQTT发送命令
    const mqttService = getMQTTService();
    const commandSuccess = mqttService?.isConnected() ?? false;

    if (commandSuccess && mqttService) {
      const commandMap = {
        buzzer: () => mqttService.buzzerControl(device.deviceSn, enabled),
        sleep: () => mqttService.sleepControl(device.deviceSn, enabled),
        led: () => mqttService.ledControl(device.deviceSn, enabled)
      };
      await commandMap[controlType]();
    } else {
      console.warn(`[DeviceControl] MQTT未连接，${controlType}命令仅保存本地状态`);
    }

    const responseKey = CONTROL_RESPONSE_KEY_MAP[controlType];
    res.json({
      code: 0,
      message: 'Success',
      data: { [responseKey]: enabled, deviceSn: device.deviceSn, mqttSent: commandSuccess }
    });
  } catch (error) {
    console.error(`[DeviceControl] ${controlType} control error:`, error);
    res.status(500).json({ code: 500, message: 'Internal server error', data: null });
  }
}

// =====================================================
// 原有接口
// =====================================================

// 绑定设备到宠物
router.post('/bind', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { device_sn, pet_id } = req.body;

    if (!device_sn || !pet_id) {
      return res.status(400).json({ code: 400, message: 'device_sn and pet_id required', data: null });
    }

    const petRepo = AppDataSource.getRepository(Pet);
    const deviceRepo = AppDataSource.getRepository(Device);

    const pet = await petRepo.findOne({ where: { id: pet_id, user_id: req.userId } });
    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    let device = await deviceRepo.findOne({ where: { deviceSn: device_sn } });
    if (!device) {
      device = new Device();
      device.deviceSn = device_sn;
    }

    if (device.petId && device.petId !== pet_id) {
      return res.status(400).json({ code: 400, message: 'Device already bound to another pet', data: null });
    }

    device.petId = pet_id;
    await deviceRepo.save(device);

    pet.device_id = device.id;
    await petRepo.save(pet);

    res.json({ code: 0, message: 'Success', data: { device, pet } });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to bind device', data: null });
  }
});

// 解绑设备
router.post('/unbind/:petId', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { petId } = req.params;

    const petRepo = AppDataSource.getRepository(Pet);
    const deviceRepo = AppDataSource.getRepository(Device);

    const pet = await petRepo.findOne({ where: { id: parseInt(petId), user_id: req.userId } });
    if (!pet || !pet.device_id) {
      return res.status(404).json({ code: 404, message: 'Pet or device not found', data: null });
    }

    const device = await deviceRepo.findOne({ where: { id: pet.device_id } });
    if (device) {
      device.petId = null;
      await deviceRepo.save(device);
    }

    pet.device_id = null;
    await petRepo.save(pet);

    res.json({ code: 0, message: 'Success', data: { unbound: true } });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to unbind device', data: null });
  }
});

// 更新设备状态（设备端调用，需要设备认证）
router.post('/status', deviceAuthMiddleware, async (req, res) => {
  try {
    const { battery_level, is_online } = req.body;
    const deviceSn = (req as any).deviceSn; // 从中间件获取

    const deviceRepo = AppDataSource.getRepository(Device);
    const device = await deviceRepo.findOne({ where: { deviceSn } });

    if (!device) {
      return res.status(404).json({ code: 404, message: 'Device not found', data: null });
    }

    if (battery_level !== undefined) device.batteryLevel = battery_level;
    if (is_online !== undefined) device.isOnline = is_online;
    device.lastOnlineAt = new Date();
    await deviceRepo.save(device);

    res.json({ code: 0, message: 'Success', data: device });
  } catch (error) {
    console.error('[DeviceStatus] Update error:', error);
    res.status(500).json({ code: 500, message: 'Failed to update device status', data: null });
  }
});

// =====================================================
// 新增IoT功能接口
// =====================================================

/**
 * 获取用户所有设备的最新状态（轮询接口）
 * GET /api/devices/status
 */
router.get('/devices/status', authMiddleware, async (req: AuthRequest, res) => {
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
      .leftJoinAndSelect('device.pet', 'pet')
      .where('device.petId IN (:...petIds)', { petIds })
      .getMany();

    if (devices.length === 0) {
      return res.json({ code: 0, message: 'Success', data: [] });
    }

    // 获取设备最新位置（使用子查询优化）
    const deviceIds = devices.map(d => d.id);
    const locations = await locationRepo
      .createQueryBuilder('location')
      .where(`location.id IN (
        SELECT MAX(l.id)
        FROM device_locations l
        WHERE l.device_id IN (:...deviceIds)
        GROUP BY l.device_id
      )`, { deviceIds })
      .getMany();

    // 按设备ID映射位置
    const locationMap = new Map(locations.map(loc => [loc.deviceId, loc]));

    // 组合结果
    const results = devices.map(device => {
      const location = locationMap.get(device.id);
      return {
        id: device.id,
        deviceSn: device.deviceSn,
        petId: device.petId,
        petName: device.pet?.name,
        petAvatar: device.pet?.avatar,
        batteryLevel: device.batteryLevel,
        isOnline: device.isOnline,
        lastOnlineAt: device.lastOnlineAt,
        buzzerEnabled: device.buzzerEnabled || false,
        sleepModeEnabled: device.sleepModeEnabled || false,
        ledEnabled: device.ledEnabled || false,
        latestLocation: location ? {
          latitude: location.latitude,
          longitude: location.longitude,
          activity: location.activity,
          temperature: location.temperature,
          motionState: location.motionState,
          recordedAt: location.recordedAt
        } : null
      };
    });

    res.json({ code: 0, message: 'Success', data: results });
  } catch (error) {
    console.error('[DeviceStatus] Get error:', error);
    res.status(500).json({ code: 500, message: 'Internal server error', data: null });
  }
});

/**
 * 获取单个设备详情
 * GET /api/device/:id
 */
router.get('/:id', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const deviceId = parseInt(req.params.id);

    const deviceRepo = AppDataSource.getRepository(Device);
    const device = await deviceRepo.findOne({
      where: { id: deviceId },
      relations: ['pet']
    });

    if (!device) {
      return res.status(404).json({ code: 404, message: 'Device not found', data: null });
    }

    // 验证设备属于当前用户
    if (device.pet?.user_id !== req.userId) {
      return res.status(403).json({ code: 403, message: 'Access denied', data: null });
    }

    // 获取最新位置
    const locationRepo = AppDataSource.getRepository(DeviceLocation);
    const latestLocation = await locationRepo.findOne({
      where: { deviceId },
      order: { recordedAt: 'DESC' }
    });

    const result = {
      ...device,
      latestLocation
    };

    res.json({ code: 0, message: 'Success', data: result });
  } catch (error) {
    console.error('[Device] Get error:', error);
    res.status(500).json({ code: 500, message: 'Internal server error', data: null });
  }
});

// =====================================================
// 设备控制接口（重构后）
// =====================================================

/**
 * 蜂鸣器控制
 * POST /api/device/:id/buzzer
 * Body: { enabled: true/false }
 */
router.post('/:id/buzzer', authMiddleware, (req: AuthRequest, res) => {
  handleDeviceControl(req, res, 'buzzer');
});

/**
 * 休眠模式控制
 * POST /api/device/:id/sleep
 * Body: { enabled: true/false }
 */
router.post('/:id/sleep', authMiddleware, (req: AuthRequest, res) => {
  handleDeviceControl(req, res, 'sleep');
});

/**
 * LED灯控制
 * POST /api/device/:id/led
 * Body: { enabled: true/false }
 */
router.post('/:id/led', authMiddleware, (req: AuthRequest, res) => {
  handleDeviceControl(req, res, 'led');
});

export default router;
