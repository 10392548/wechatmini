import { Router } from 'express';
import { AppDataSource } from '../index';
import { Device } from '../entities/Device';
import { Pet } from '../entities/Pet';
import { authMiddleware, AuthRequest } from '../middleware/auth';

const router = Router();

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

    let device = await deviceRepo.findOne({ where: { device_sn } });
    if (!device) {
      device = deviceRepo.create({ device_sn });
    }

    if (device.pet_id && device.pet_id !== pet_id) {
      return res.status(400).json({ code: 400, message: 'Device already bound to another pet', data: null });
    }

    device.pet_id = pet_id;
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
      device.pet_id = null;
      await deviceRepo.save(device);
    }

    pet.device_id = null;
    await petRepo.save(pet);

    res.json({ code: 0, message: 'Success', data: { unbound: true } });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to unbind device', data: null });
  }
});

// 更新设备状态（设备端调用）
router.post('/status', async (req, res) => {
  try {
    const { device_sn, battery_level, is_online } = req.body;

    const deviceRepo = AppDataSource.getRepository(Device);
    const device = await deviceRepo.findOne({ where: { device_sn } });

    if (!device) {
      return res.status(404).json({ code: 404, message: 'Device not found', data: null });
    }

    if (battery_level !== undefined) device.battery_level = battery_level;
    if (is_online !== undefined) device.is_online = is_online;
    device.last_online_at = new Date();
    await deviceRepo.save(device);

    res.json({ code: 0, message: 'Success', data: device });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to update device status', data: null });
  }
});

export default router;
