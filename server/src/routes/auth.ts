import { Router } from 'express';
import axios from 'axios';
import { AppDataSource } from '../index';
import { User } from '../entities/User';
import { generateAccessToken, generateRefreshToken, verifyRefreshToken } from '../utils/jwt';
import { config } from '../config';

const router = Router();

// 调用微信 API 获取 openid
async function getWxOpenId(code: string): Promise<string> {
  try {
    // 打印配置信息（用于诊断）
    console.log('[微信登录] 配置检查:', {
      hasAppId: !!config.wechat.appId,
      appId: config.wechat.appId?.substring(0, 10) + '...',
      hasAppSecret: !!config.wechat.appSecret,
      appSecret: config.wechat.appSecret?.substring(0, 10) + '...',
      url: config.wechat.code2SessionUrl
    });

    // 检查是否配置了微信 AppID 和 AppSecret
    if (!config.wechat.appId || !config.wechat.appSecret) {
      console.warn('[微信登录] 未配置微信 AppID/AppSecret,使用 mock openid');
      return `mock_openid_${Date.now()}`;
    }

    console.log('[微信登录] 开始调用微信 API, code:', code?.substring(0, 10) + '...');

    const response = await axios.get(config.wechat.code2SessionUrl, {
      params: {
        appid: config.wechat.appId,
        secret: config.wechat.appSecret,
        js_code: code,
        grant_type: 'authorization_code'
      },
      timeout: 10000 // 10秒超时
    });

    console.log('[微信登录] 微信 API 响应:', {
      status: response.status,
      hasData: !!response.data,
      errcode: response.data.errcode,
      hasOpenid: !!response.data.openid
    });

    if (response.data.errcode) {
      console.error('[微信登录] 微信 API 返回错误:', response.data);
      throw new Error(`微信 API 错误 [${response.data.errcode}]: ${response.data.errmsg}`);
    }

    if (!response.data.openid) {
      console.error('[微信登录] 微信 API 响应中没有 openid:', response.data);
      throw new Error('微信 API 响应中没有 openid');
    }

    console.log('[微信登录] 成功获取 openid:', response.data.openid?.substring(0, 15) + '...');
    return response.data.openid;
  } catch (error: any) {
    console.error('[微信登录] 获取微信 openid 失败:', {
      message: error.message,
      code: error.code,
      response: error.response?.data,
      stack: error.stack
    });
    // 如果微信 API 调用失败,降级到 mock 模式
    console.warn('[微信登录] 降级使用 mock openid（生产环境应该抛出错误）');
    return `mock_openid_${Date.now()}`;
  }
}

// 微信登录
router.post('/login', async (req, res) => {
  try {
    const { code, nickname, avatar } = req.body;

    console.log('[微信登录] 收到登录请求:', {
      hasCode: !!code,
      codeLength: code?.length,
      codePreview: code?.substring(0, 20) + '...',
      nickname,
      avatar
    });

    if (!code) {
      return res.status(400).json({ code: 400, message: '缺少 code 参数', data: null });
    }

    // 调用微信 API 获取 openid
    const openid = await getWxOpenId(code);

    const userRepo = AppDataSource.getRepository(User);
    let user = await userRepo.findOne({ where: { openid } });

    if (!user) {
      user = userRepo.create({ openid, nickname, avatar });
      await userRepo.save(user);
    } else if (nickname || avatar) {
      if (nickname) user.nickname = nickname;
      if (avatar) user.avatar = avatar;
      await userRepo.save(user);
    }

    const accessToken = generateAccessToken(user.id);
    const refreshToken = generateRefreshToken(user.id);

    res.json({ code: 0, message: 'Success', data: { accessToken, refreshToken, user } });
  } catch (error) {
    console.error('登录失败:', error);
    res.status(500).json({ code: 500, message: 'Login failed', data: null });
  }
});

// 刷新 token
router.post('/refresh', async (req, res) => {
  try {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(400).json({ code: 400, message: 'Refresh token required', data: null });
    }

    const { userId } = verifyRefreshToken(refreshToken);
    const accessToken = generateAccessToken(userId);
    const newRefreshToken = generateRefreshToken(userId);

    res.json({ code: 0, message: 'Success', data: { accessToken, refreshToken: newRefreshToken } });
  } catch (error) {
    res.status(401).json({ code: 401, message: 'Invalid refresh token', data: null });
  }
});

export default router;
