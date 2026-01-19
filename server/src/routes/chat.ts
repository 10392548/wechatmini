import { Router } from 'express';
import { AppDataSource } from '../index';
import { ChatMessage } from '../entities/ChatMessage';
import { Pet } from '../entities/Pet';
import { authMiddleware, AuthRequest } from '../middleware/auth';
import { chatWithDeepSeek } from '../utils/deepseek';

const router = Router();

// 发送消息
router.post('/send', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { pet_id, content } = req.body;

    if (!pet_id || !content) {
      return res.status(400).json({ code: 400, message: 'pet_id and content required', data: null });
    }

    const petRepo = AppDataSource.getRepository(Pet);
    const messageRepo = AppDataSource.getRepository(ChatMessage);

    const pet = await petRepo.findOne({ where: { id: pet_id, user_id: req.userId } });
    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    // 保存用户消息
    const userMessage = messageRepo.create({
      pet_id,
      role: 'user',
      content
    });
    await messageRepo.save(userMessage);

    // 获取最近的对话历史（最多10条）
    const history = await messageRepo.find({
      where: { pet_id },
      order: { created_at: 'DESC' },
      take: 10
    });

    // 构建对话上下文
    const messages = history.reverse().map(msg => ({
      role: msg.role as 'user' | 'assistant',
      content: msg.content
    }));

    // 调用 DeepSeek API
    const aiResponse = await chatWithDeepSeek(messages);

    // 保存 AI 回复
    const assistantMessage = messageRepo.create({
      pet_id,
      role: 'assistant',
      content: aiResponse
    });
    await messageRepo.save(assistantMessage);

    res.json({ code: 0, message: 'Success', data: { userMessage, assistantMessage } });
  } catch (error) {
    console.error('Chat error:', error);
    res.status(500).json({ code: 500, message: 'Failed to send message', data: null });
  }
});

// 获取聊天历史
router.get('/history/:petId', authMiddleware, async (req: AuthRequest, res) => {
  try {
    const { petId } = req.params;
    const { limit = 50 } = req.query;

    const petRepo = AppDataSource.getRepository(Pet);
    const messageRepo = AppDataSource.getRepository(ChatMessage);

    const pet = await petRepo.findOne({ where: { id: parseInt(petId), user_id: req.userId } });
    if (!pet) {
      return res.status(404).json({ code: 404, message: 'Pet not found', data: null });
    }

    const messages = await messageRepo.find({
      where: { pet_id: parseInt(petId) },
      order: { created_at: 'ASC' },
      take: Number(limit)
    });

    res.json({ code: 0, message: 'Success', data: messages });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Failed to get chat history', data: null });
  }
});

export default router;
