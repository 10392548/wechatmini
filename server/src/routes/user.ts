import { Router } from 'express';
import { AppDataSource } from '../index';
import { User } from '../entities/User';
import { authMiddleware, AuthRequest } from '../middleware/auth';

const router = Router();

// 获取用户信息
router.get('/profile', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const userRepo = AppDataSource.getRepository(User);
    const user = await userRepo.findOne({
      where: { id: req.userId },
      relations: ['pets']
    });

    if (!user) {
      return res.status(404).json({ code: 404, message: 'User not found', data: null });
    }

    res.json({ code: 0, message: 'Success', data: user });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to get user profile', data: null });
  }
});

// 更新用户信息
router.put('/profile', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { nickname, avatar } = req.body;

    const userRepo = AppDataSource.getRepository(User);
    const user = await userRepo.findOne({ where: { id: req.userId } });

    if (!user) {
      return res.status(404).json({ code: 404, message: 'User not found', data: null });
    }

    if (nickname) user.nickname = nickname;
    if (avatar) user.avatar = avatar;

    await userRepo.save(user);
    res.json({ code: 0, message: 'Success', data: user });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to update user profile', data: null });
  }
});

export default router;
