import { Router } from 'express';
import { AppDataSource } from '../index';
import { Moment, AuditStatus } from '../entities/Moment';
import { adminAuthMiddleware, AdminAuthRequest } from '../middleware/admin-auth';

const router = Router();

// 获取朋友圈列表（支持状态筛选）
router.get('/', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { page = 1, pageSize = 20, status } = req.query;
    const pageNum = Number(page);
    const sizeNum = Number(pageSize);

    const momentRepo = AppDataSource.getRepository(Moment);

    const queryBuilder = momentRepo
      .createQueryBuilder('moment')
      .leftJoinAndSelect('moment.user', 'user')
      .leftJoinAndSelect('moment.pet', 'pet')
      .leftJoinAndSelect('moment.reviewed_by', 'reviewedBy')
      .orderBy('moment.created_at', 'DESC')
      .skip((pageNum - 1) * sizeNum)
      .take(sizeNum);

    // 支持按状态筛选
    if (status && typeof status === 'string') {
      queryBuilder.andWhere('moment.status = :status', { status });
    }

    const [moments, total] = await queryBuilder.getManyAndCount();

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

// 审核通过
router.put('/:id/approve', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { id } = req.params;
    const momentRepo = AppDataSource.getRepository(Moment);

    const moment = await momentRepo.findOne({ where: { id: Number(id) } });
    if (!moment) {
      return res.status(404).json({ code: 404, message: 'Moment not found', data: null });
    }

    // 验证状态
    if (moment.status === AuditStatus.APPROVED) {
      return res.status(400).json({ code: 400, message: 'Moment already approved', data: null });
    }

    // 更新状态
    moment.status = AuditStatus.APPROVED;
    moment.reviewed_by_id = req.adminId ?? null;
    moment.reviewed_at = new Date();
    moment.rejection_reason = null;

    await momentRepo.save(moment);

    res.json({ code: 0, message: 'Moment approved successfully', data: moment });
  } catch (error) {
    console.error('Approve moment error:', error);
    res.status(500).json({ code: 500, message: 'Failed to approve moment', data: null });
  }
});

// 审核驳回
router.put('/:id/reject', adminAuthMiddleware, async (req: AdminAuthRequest, res) => {
  try {
    const { id } = req.params;
    const { reason } = req.body;
    const momentRepo = AppDataSource.getRepository(Moment);

    const moment = await momentRepo.findOne({ where: { id: Number(id) } });
    if (!moment) {
      return res.status(404).json({ code: 404, message: 'Moment not found', data: null });
    }

    // 验证状态
    if (moment.status === AuditStatus.REJECTED) {
      return res.status(400).json({ code: 400, message: 'Moment already rejected', data: null });
    }

    // 更新状态
    moment.status = AuditStatus.REJECTED;
    moment.reviewed_by_id = req.adminId ?? null;
    moment.reviewed_at = new Date();
    moment.rejection_reason = reason || null;

    await momentRepo.save(moment);

    res.json({ code: 0, message: 'Moment rejected successfully', data: moment });
  } catch (error) {
    console.error('Reject moment error:', error);
    res.status(500).json({ code: 500, message: 'Failed to reject moment', data: null });
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
