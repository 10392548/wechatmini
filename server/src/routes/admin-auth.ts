import { Router } from 'express';
import { AppDataSource } from '../index';
import { Admin } from '../entities/Admin';
import { adminAuthMiddleware, AdminAuthRequest } from '../middleware/admin-auth';
import { generateAdminToken } from '../utils/jwt';
import bcrypt from 'bcrypt';

const router = Router();

// 管理员登录
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ code: 400, message: 'Username and password required', data: null });
    }

    const adminRepo = AppDataSource.getRepository(Admin);
    const admin = await adminRepo.findOne({ where: { username } });

    if (!admin) {
      return res.status(401).json({ code: 401, message: 'Invalid credentials', data: null });
    }

    const isValid = await bcrypt.compare(password, admin.password_hash);
    if (!isValid) {
      return res.status(401).json({ code: 401, message: 'Invalid credentials', data: null });
    }

    const token = generateAdminToken(admin.id, admin.role);

    res.json({
      code: 0,
      message: 'Success',
      data: {
        token,
        admin: {
          id: admin.id,
          username: admin.username,
          role: admin.role,
        },
      },
    });
  } catch (error) {
    console.error('Admin login error:', error);
    res.status(500).json({ code: 500, message: 'Login failed', data: null });
  }
});

// 验证 token
router.get('/verify', adminAuthMiddleware, (req: AdminAuthRequest, res) => {
  const adminRepo = AppDataSource.getRepository(Admin);

  adminRepo.findOne({ where: { id: req.adminId } }).then(admin => {
    if (!admin) {
      return res.status(404).json({ code: 404, message: 'Admin not found', data: null });
    }
    res.json({
      code: 0,
      message: 'Success',
      data: {
        admin: {
          id: admin.id,
          username: admin.username,
          role: admin.role,
        },
      },
    });
  }).catch(() => {
    res.status(500).json({ code: 500, message: 'Server error', data: null });
  });
});

export default router;
