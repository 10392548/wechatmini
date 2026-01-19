import { Router } from 'express';
import { authMiddleware } from '../middleware/auth';
import { upload } from '../middleware/upload';

const router = Router();

// 上传单张图片
router.post('/image', authMiddleware, upload.single('file'), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ code: 400, message: 'No file uploaded', data: null });
    }

    const imageUrl = `/uploads/${req.file.filename}`;
    res.json({ code: 0, message: 'Success', data: { url: imageUrl } });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Upload failed', data: null });
  }
});

// 上传多张图片
router.post('/images', authMiddleware, upload.array('files', 9), (req, res) => {
  try {
    const files = req.files as Express.Multer.File[];

    if (!files || files.length === 0) {
      return res.status(400).json({ code: 400, message: 'No files uploaded', data: null });
    }

    const imageUrls = files.map(file => `/uploads/${file.filename}`);
    res.json({ code: 0, message: 'Success', data: { urls: imageUrls } });
  } catch (error) {
    res.status(500).json({ code: 500, message: 'Upload failed', data: null });
  }
});

export default router;
