import jwt, { SignOptions } from 'jsonwebtoken';
import { config } from '../config';

export function generateAccessToken(userId: number): string {
  return jwt.sign({ userId }, config.jwt.accessSecret, { expiresIn: config.jwt.accessExpire } as SignOptions);
}

export function generateRefreshToken(userId: number): string {
  return jwt.sign({ userId }, config.jwt.refreshSecret, { expiresIn: config.jwt.refreshExpire } as SignOptions);
}

export function generateAdminToken(adminId: number, role: string = 'admin'): string {
  return jwt.sign({ userId: adminId, role }, config.jwt.accessSecret, { expiresIn: '7d' } as SignOptions);
}

export function verifyAccessToken(token: string): { userId: number } {
  return jwt.verify(token, config.jwt.accessSecret) as { userId: number };
}

export function verifyRefreshToken(token: string): { userId: number } {
  return jwt.verify(token, config.jwt.refreshSecret) as { userId: number };
}

export function verifyAdminToken(token: string): { userId: number; role: string } {
  return jwt.verify(token, config.jwt.accessSecret) as { userId: number; role: string };
}
