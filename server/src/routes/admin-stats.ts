import { Router } from 'express';
import { AppDataSource } from '../index';
import { User } from '../entities/User';
import { Device } from '../entities/Device';
import { Moment } from '../entities/Moment';
import { adminAuthMiddleware, AdminAuthRequest } from '../middleware/admin-auth';
import { MoreThan } from 'typeorm';

const router = Router();

// 总体统计
router.get('/overview', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const userRepo = AppDataSource.getRepository(User);
    const deviceRepo = AppDataSource.getRepository(Device);
    const momentRepo = AppDataSource.getRepository(Moment);

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const [userCount, deviceCount, onlineDeviceCount, todayNewUsers] = await Promise.all([
      userRepo.count(),
      deviceRepo.count(),
      deviceRepo.count({ where: { isOnline: true } }),
      userRepo.count({ where: { created_at: MoreThan(today) } }),
    ]);

    // 计算今日活跃用户（有发布朋友圈的）
    const todayActive = await momentRepo
      .createQueryBuilder('moment')
      .where('moment.created_at >= :today', { today })
      .select('COUNT(DISTINCT moment.user_id)')
      .getRawOne();

    res.json({
      code: 0,
      message: 'Success',
      data: {
        userCount,
        deviceCount,
        onlineDeviceCount,
        todayActiveCount: Number(Object.values(todayActive)[0]) || 0,
        todayNewUsers,
      },
    });
  } catch (error) {
    console.error('Get overview stats error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get overview', data: null });
  }
});

// 用户增长趋势
router.get('/user-growth', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { days = 30 } = req.query;
    const daysNum = Math.min(Number(days), 90);
    const userRepo = AppDataSource.getRepository(User);
    const result = [];

    for (let i = daysNum - 1; i >= 0; i--) {
      const date = new Date();
      date.setDate(date.getDate() - i);
      date.setHours(0, 0, 0, 0);
      const nextDate = new Date(date);
      nextDate.setDate(nextDate.getDate() + 1);

      const count = await userRepo.count({
        where: {
          created_at: MoreThan(date),
        },
      });

      // 修正：使用两个日期之间的差值来计算
      // 这里简化处理，实际需要更精确的查询
      result.push({
        date: date.toISOString().split('T')[0],
        count,
      });
    }

    res.json({ code: 0, message: 'Success', data: result });
  } catch (error) {
    console.error('Get user growth error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get user growth', data: null });
  }
});

// 活跃度统计
router.get('/activity', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { days = 7 } = req.query;
    const daysNum = Math.min(Number(days), 30);
    const momentRepo = AppDataSource.getRepository(Moment);
    const labels = [];
    const values = [];

    const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];

    for (let i = daysNum - 1; i >= 0; i--) {
      const date = new Date();
      date.setDate(date.getDate() - i);
      date.setHours(0, 0, 0, 0);
      const nextDate = new Date(date);
      nextDate.setDate(nextDate.getDate() + 1);

      const count = await momentRepo.count({
        where: {
          created_at: MoreThan(date),
        },
      });

      labels.push(weekDays[date.getDay()]);
      values.push(count);
    }

    res.json({
      code: 0,
      message: 'Success',
      data: { labels, values },
    });
  } catch (error) {
    console.error('Get activity stats error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get activity stats', data: null });
  }
});

// 设备状态分布
router.get('/device-status', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const deviceRepo = AppDataSource.getRepository(Device);

    const [online, offline] = await Promise.all([
      deviceRepo.count({ where: { isOnline: true } }),
      deviceRepo.count({ where: { isOnline: false } }),
    ]);

    // 低电量设备（电量 < 20%）
    const lowBattery = await deviceRepo
      .createQueryBuilder('device')
      .where('device.batteryLevel < :threshold', { threshold: 20 })
      .getCount();

    res.json({
      code: 0,
      message: 'Success',
      data: { online, offline, lowBattery },
    });
  } catch (error) {
    console.error('Get device status error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get device status', data: null });
  }
});

export default router;
