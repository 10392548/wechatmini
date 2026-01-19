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
    const { nickname, avatar, phone, avatar_url } = req.body;

    const userRepo = AppDataSource.getRepository(User);
    const user = await userRepo.findOne({ where: { id: req.userId } });

    if (!user) {
      return res.status(404).json({ code: 404, message: 'User not found', data: null });
    }

    // 检查是否修改了头像或昵称
    const hasCustomProfile =
      (nickname && nickname !== user.nickname) ||
      ((avatar || avatar_url) && (avatar || avatar_url) !== user.avatar);

    // 更新字段
    if (nickname) user.nickname = nickname;
    if (avatar || avatar_url) user.avatar = avatar || avatar_url;
    if (phone !== undefined) user.phone = phone;

    // 如果修改了头像或昵称，标记为已自定义
    if (hasCustomProfile) {
      user.has_custom_profile = 1;
    }

    await userRepo.save(user);

    // 返回更新后的用户信息（不包含敏感信息）
    const { openid, ...safeUser } = user;
    res.json({ code: 0, message: 'Success', data: safeUser });
  } catch (error) {
    console.error('更新用户资料失败:', error);
    res.status(500).json({ code: 500, message: 'Failed to update user profile', data: null });
  }
});

export default router;
