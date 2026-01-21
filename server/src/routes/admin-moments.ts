import { Router } from 'express';
import { AppDataSource } from '../index';
import { Moment } from '../entities/Moment';
import { adminAuthMiddleware, AdminAuthRequest } from '../middleware/admin-auth';

const router = Router();

// 获取朋友圈列表
router.get('/', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { page = 1, pageSize = 20 } = req.query;
    const pageNum = Number(page);
    const sizeNum = Number(pageSize);

    const momentRepo = AppDataSource.getRepository(Moment);

    const [moments, total] = await momentRepo
      .createQueryBuilder('moment')
      .leftJoinAndSelect('moment.user', 'user')
      .leftJoinAndSelect('moment.pet', 'pet')
      .orderBy('moment.created_at', 'DESC')
      .skip((pageNum - 1) * sizeNum)
      .take(sizeNum)
      .getManyAndCount();

    res.json({
      code: 0,
      message: 'Success',
      data: {
        list: moments,
        total,
        page: pageNum,
        pageSize: sizeNum,
      },
    });
  } catch (error) {
    console.error('Get moments error:', error);
    res.status(500).json({ code: 500, message: 'Failed to get moments', data: null });
  }
});

// 删除朋友圈
router.delete('/:id', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { id } = req.params;
    const momentRepo = AppDataSource.getRepository(Moment);

    const moment = await momentRepo.findOne({ where: { id: Number(id) } });
    if (!moment) {
      return res.status(404).json({ code: 404, message: 'Moment not found', data: null });
    }

    await momentRepo.remove(moment);

    res.json({ code: 0, message: 'Moment deleted successfully', data: { deleted: true } });
  } catch (error) {
    console.error('Delete moment error:', error);
    res.status(500).json({ code: 500, message: 'Failed to delete moment', data: null });
  }
});

export default router;
