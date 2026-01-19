import { Router } from 'express';
import { AppDataSource } from '../index';
import { Pet } from '../entities/Pet';
import { ActivityData } from '../entities/ActivityData';
import { GrowthLog } from '../entities/GrowthLog';
import { authMiddleware, AuthRequest } from '../middleware/auth';

const router = Router();

// 获取我的宠物列表
router.get('/', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const petRepo = AppDataSource.getRepository(Pet);
    const pets = await petRepo.find({
      where: { user_id: req.userId },
      relations: ['device']
    });
    res.json({ code: 0, message: 'Success', data: pets });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to get pets', data: null });
  }
});

// 创建宠物
router.post('/', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { name, avatar, breed, birthday, gender, weight } = req.body;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = petRepo.create({
      user_id: req.userId!,
      name,
      avatar,
      breed,
      birthday,
      gender,
      weight
    });

    await petRepo.save(pet);
    res.json({ code: 0, message: 'Success', data: pet });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to create pet', data: null });
  }
});

// 更新宠物信息
router.put('/:id', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;
    const { name, avatar, breed, birthday, gender, weight } = req.body;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    Object.assign(pet, { name, avatar, breed, birthday, gender, weight });
    await petRepo.save(pet);
    res.json({ code: 0, message: 'Success', data: pet });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to update pet', data: null });
  }
});

// 删除宠物
router.delete('/:id', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;

    const petRepo = AppDataSource.getRepository(Pet);
    const result = await petRepo.delete({ id: parseInt(id), user_id: req.userId });

    if (result.affected === 0) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    res.json({ code: 0, message: 'Success', data: { deleted: true } });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to delete pet', data: null });
  }
});

// 获取宠物今日统计数据
router.get('/:id/stats/today', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const activityRepo = AppDataSource.getRepository(ActivityData);
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const stats = await activityRepo
      .createQueryBuilder('activity')
      .select('SUM(activity.steps)', 'steps')
      .addSelect('SUM(activity.distance)', 'distance')
      .addSelect('SUM(activity.calories)', 'calories')
      .addSelect('SUM(activity.active_minutes)', 'active_minutes')
      .where('activity.pet_id = :petId', { petId: parseInt(id) })
      .andWhere('activity.recorded_at >= :today', { today })
      .getRawOne();

    res.json({
      code: 0,
      message: 'Success',
      data: {
        steps: parseInt(stats.steps) || 0,
        distance: parseFloat(stats.distance) || 0,
        calories: parseFloat(stats.calories) || 0,
        active_minutes: parseInt(stats.active_minutes) || 0
      }
    });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to get stats', data: null });
  }
});

// 获取宠物成长日志
router.get('/:id/growth-logs', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;
    const { limit = 20 } = req.query;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const logRepo = AppDataSource.getRepository(GrowthLog);
    const logs = await logRepo.find({
      where: { pet_id: parseInt(id) },
      order: { created_at: 'DESC' },
      take: Number(limit)
    });

    res.json({ code: 0, message: 'Success', data: logs });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to get growth logs', data: null });
  }
});

export default router;
