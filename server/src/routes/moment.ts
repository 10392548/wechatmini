import { Router } from 'express';
import { AppDataSource } from '../index';
import { Moment } from '../entities/Moment';
import { MomentLike } from '../entities/MomentLike';
import { MomentComment } from '../entities/MomentComment';
import { authMiddleware, AuthRequest } from '../middleware/auth';
import { upload } from '../middleware/upload';

const router = Router();

// 获取朋友圈列表
router.get('/', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;

    const momentRepo = AppDataSource.getRepository(Moment);
    const [moments, total] = await momentRepo.findAndCount({
      where: { is_public: true },
      relations: ['user', 'pet'],
      order: { created_at: 'DESC' },
      skip: (Number(page) - 1) * Number(limit),
      take: Number(limit)
    });

    res.json({ code: 0, message: 'Success', data: { moments, total, page: Number(page), limit: Number(limit) } });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to get moments', data: null });
  }
});

// 创建朋友圈
router.post('/', authMiddleware, upload.array('images', 9), async (req: AuthRequest, res) => {
  try {
    const { content, pet_id, is_public = 'true' } = req.body;
    const files = req.files as Express.Multer.File[];

    const images = files ? files.map(file => `/uploads/${file.filename}`) : [];

    const momentRepo = AppDataSource.getRepository(Moment);
    const moment = momentRepo.create({
      user_id: req.userId!,
      pet_id: pet_id ? parseInt(pet_id) : undefined,
      content,
      images,
      is_public: is_public === 'true'
    });

    await momentRepo.save(moment);
    res.json({ code: 0, message: 'Success', data: moment });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to create moment', data: null });
  }
});

// 点赞
router.post('/:id/like', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;

    const momentRepo = AppDataSource.getRepository(Moment);
    const likeRepo = AppDataSource.getRepository(MomentLike);

    const moment = await momentRepo.findOne({ where: { id: parseInt(id) } });
    if (!moment) {
      return res.status(404).json({ code: 404, message: 'Moment not found', data: null });
    }

    const existingLike = await likeRepo.findOne({
      where: { moment_id: parseInt(id), user_id: req.userId }
    });

    if (existingLike) {
      return res.status(400).json({ code: 400, message: 'Already liked', data: null });
    }

    const like = likeRepo.create({ moment_id: parseInt(id), user_id: req.userId! });
    await likeRepo.save(like);

    moment.like_count += 1;
    await momentRepo.save(moment);

    res.json({ code: 0, message: 'Success', data: { like_count: moment.like_count } });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to like moment', data: null });
  }
});

// 取消点赞
router.delete('/:id/like', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;

    const momentRepo = AppDataSource.getRepository(Moment);
    const likeRepo = AppDataSource.getRepository(MomentLike);

    const like = await likeRepo.findOne({
      where: { moment_id: parseInt(id), user_id: req.userId }
    });

    if (!like) {
      return res.status(404).json({ code: 404, message: 'Like not found', data: null });
    }

    await likeRepo.remove(like);

    const moment = await momentRepo.findOne({ where: { id: parseInt(id) } });
    if (moment) {
      moment.like_count = Math.max(0, moment.like_count - 1);
      await momentRepo.save(moment);
    }

    res.json({ code: 0, message: 'Success', data: { like_count: moment?.like_count || 0 } });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to unlike moment', data: null });
  }
});

// 评论
router.post('/:id/comment', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;
    const { content } = req.body;

    if (!content) {
      return res.status(400).json({ code: 400, message: 'Content required', data: null });
    }

    const momentRepo = AppDataSource.getRepository(Moment);
    const commentRepo = AppDataSource.getRepository(MomentComment);

    const moment = await momentRepo.findOne({ where: { id: parseInt(id) } });
    if (!moment) {
      return res.status(404).json({ code: 404, message: 'Moment not found', data: null });
    }

    const comment = commentRepo.create({
      moment_id: parseInt(id),
      user_id: req.userId!,
      content
    });
    await commentRepo.save(comment);

    moment.comment_count += 1;
    await momentRepo.save(moment);

    res.json({ code: 0, message: 'Success', data: comment });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to comment', data: null });
  }
});

// 获取评论列表
router.get('/:id/comments', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { id } = req.params;

    const commentRepo = AppDataSource.getRepository(MomentComment);
    const comments = await commentRepo.find({
      where: { moment_id: parseInt(id) },
      relations: ['user'],
      order: { created_at: 'ASC' }
    });

    res.json({ code: 0, message: 'Success', data: comments });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to get comments', data: null });
  }
});

export default router;
