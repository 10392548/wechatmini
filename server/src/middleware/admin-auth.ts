import { Request, Response, NextFunction } from 'express';
import { verifyAdminToken } from '../utils/jwt';

export interface AdminAuthRequest extends Request {
  adminId?: number;
  adminRole?: string;
}

export function adminAuthMiddleware(req: AdminAuthRequest, res: Response, next: NextFunction) {
  const token = req.headers.authorization?.replace('Bearer ', '');

  if (!token) {
    return res.status(401).json({ code: 401, message: 'No token provided', data: null });
  }

  try {
    const { userId, role } = verifyAdminToken(token);
    if (role !== 'admin' && role !== 'super_admin') {
      return res.status(403).json({ code: 403, message: 'Admin access required', data: null });
    }
    req.adminId = userId;
    req.adminRole = role;
    next();
  } catch (error) {
    return res.status(401).json({ code: 401, message: 'Invalid token', data: null });
  }
}
