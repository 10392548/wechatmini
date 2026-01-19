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
    const { limit = 50, log_type } = req.query;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    // 验证 log_type
    const validTypes = ['activity', 'sleep', 'milestone'];
    if (log_type && !validTypes.includes(log_type as string)) {
      return res.status(400).json({ code: 400, message: 'Invalid log_type', data: null });
    }

    const logRepo = AppDataSource.getRepository(GrowthLog);
    const where: any = { pet_id: parseInt(id) };
    if (log_type) {
      where.log_type = log_type;
    }

    // 限制最大返回数量
    const take = Math.min(Number(limit), 100);

    const logs = await logRepo.find({
      where,
      order: { created_at: 'DESC' },
      take
    });

    res.json({ code: 0, message: 'Success', data: logs });
  } catch (error) {
    console.error('Failed to get growth logs:', error);
    res.status(500).json({ code: 500, message: 'Failed to get growth logs', data: null });
  }
});

// 创建成长日志
router.post('/:id/growth-logs', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;
    const { log_type, title, content, data } = req.body;

    if (!log_type || !title) {
      return res.status(400).json({ code: 400, message: 'log_type and title are required', data: null });
    }

    if (title.length > 100) {
      return res.status(400).json({ code: 400, message: 'Title is too long (max 100 characters)', data: null });
    }

    const validTypes = ['activity', 'sleep', 'milestone'];
    if (!validTypes.includes(log_type)) {
      return res.status(400).json({ code: 400, message: 'Invalid log_type', data: null });
    }

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const logRepo = AppDataSource.getRepository(GrowthLog);
    const log = logRepo.create({
      pet_id: parseInt(id),
      log_type,
      title,
      content,
      data
    });

    await logRepo.save(log);
    res.json({ code: 0, message: 'Success', data: log });
  } catch (error) {
    console.error('Failed to create growth log:', error);
    res.status(500).json({ code: 500, message: 'Failed to create growth log', data: null });
  }
});

// 更新成长日志
router.put('/:id/growth-logs/:logId', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id, logId } = req.params;
    const { title, content, data } = req.body;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const logRepo = AppDataSource.getRepository(GrowthLog);
    const log = await logRepo.findOne({
      where: { id: parseInt(logId), pet_id: parseInt(id) }
    });

    if (!log) {
      return res.status(404).json({ code: 404, message: 'Growth log not found', data: null });
    }

    if (title !== undefined) log.title = title;
    if (content !== undefined) log.content = content;
    if (data !== undefined) log.data = data;

    await logRepo.save(log);
    res.json({ code: 0, message: 'Success', data: log });
  } catch (error) {
    console.error('Failed to update growth log:', error);
    res.status(500).json({ code: 500, message: 'Failed to update growth log', data: null });
  }
});

// 删除成长日志
router.delete('/:id/growth-logs/:logId', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id, logId } = req.params;

    const petRepo = AppDataSource.getRepository(Pet);
    const pet = await petRepo.findOne({ where: { id: parseInt(id), user_id: req.userId } });

    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const logRepo = AppDataSource.getRepository(GrowthLog);
    const log = await logRepo.findOne({
      where: { id: parseInt(logId), pet_id: parseInt(id) }
    });

    if (!log) {
      return res.status(404).json({ code: 404, message: 'Growth log not found', data: null });
    }

    await logRepo.remove(log);
    res.json({ code: 0, message: 'Success', data: { deleted: true } });
  } catch (error) {
    console.error('Failed to delete growth log:', error);
    res.status(500).json({ code: 500, message: 'Failed to delete growth log', data: null });
  }
});

export default router;
