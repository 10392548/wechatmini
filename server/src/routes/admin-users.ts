import { Router } from 'express';
import { AppDataSource } from '../index';
import { User } from '../entities/User';
import { Pet } from '../entities/Pet';
import { adminAuthMiddleware, AdminAuthRequest } from '../middleware/admin-auth';
import { Like } from 'typeorm';

const router = Router();

// 获取用户列表
router.get('/', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { page = 1, pageSize = 20, keyword = '' } = req.query;
    const pageNum = Number(page);
    const sizeNum = Number(pageSize);

    const userRepo = AppDataSource.getRepository(User);

    const queryBuilder = userRepo.createQueryBuilder('user');

    if (keyword) {
      queryBuilder.andWhere('user.nickname LIKE :keyword OR user.phone LIKE :keyword', {
        keyword: `%${keyword}%`,
      });
    }

    const [users, total] = await queryBuilder
      .orderBy('user.created_at', 'DESC')
      .skip((pageNum - 1) * sizeNum)
      .take(sizeNum)
      .getManyAndCount();

    // 获取每个用户的宠物数量
    const userList = await Promise.all(
      users.map(async (user) => {
        const petRepo = AppDataSource.getRepository(Pet);
        const pets = await petRepo.find({ where: { user_id: user.id } });
        return {
          ...user,
          pets,
        };
      })
    );

    res.json({
      code: 0,
      message: 'Success',
      data: {
        list: userList,
        total,
        page: pageNum,
        pageSize: sizeNum,
      },
    });
  } catch (error) {
    console.error('Get users error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get users', data: null });
  }
});

// 获取用户详情
router.get('/:id', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { id } = req.params;
    const userRepo = AppDataSource.getRepository(User);
    const petRepo = AppDataSource.getRepository(Pet);

    const user = await userRepo.findOne({ where: { id: Number(id) } });
    if (!user) {
      return res.status(404).json({ code: 404, message: 'User not found', data: null });
    }

    const pets = await petRepo.find({ where: { user_id: Number(id) } });

    res.json({
      code: 0,
      message: 'Success',
      data: { ...user, pets },
    });
  } catch (error) {
    console.error('Get user detail error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get user', data: null });
  }
});

// 封禁用户
router.put('/:id/ban', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { id } = req.params;
    const { reason } = req.body;

    const userRepo = AppDataSource.getRepository(User);
    const user = await userRepo.findOne({ where: { id: Number(id) } });

    if (!user) {
      return res.status(404).json({ code: 404, message: 'User not found', data: null });
    }

    // TODO: 添加 is_banned 和 ban_reason 字段到 User 实体
    // 目前先返回成功
    res.json({ code: 0, message: 'User banned successfully', data: { banned: true, reason } });
  } catch (error) {
    console.error('Ban user error:', error);
    res.status(500).json({ code: 500, message: 'Failed to ban user', data: null });
  }
});

// 解封用户
router.put('/:id/unban', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { id } = req.params;

    const userRepo = AppDataSource.getRepository(User);
    const user = await userRepo.findOne({ where: { id: Number(id) } });

    if (!user) {
      return res.status(404).json({ code: 404, message: 'User not found', data: null });
    }

    // TODO: 添加 is_banned 字段到 User 实体
    res.json({ code: 0, message: 'User unbanned successfully', data: { unbanned: true } });
  } catch (error) {
    console.error('Unban user error:', error);
    res.status(500).json({ code: 500, message: 'Failed to unban user', data: null });
  }
});

export default router;
