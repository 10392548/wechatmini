import dotenv from 'dotenv';

// 加载环境变量
dotenv.config();

export const config = {
  port: parseInt(process.env.PORT || '3003'),
  database: {
    host: process.env.DB_HOST || '127.0.0.1',
    port: parseInt(process.env.DB_PORT || '3307'),
    username: process.env.DB_USERNAME || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_DATABASE || 'pet_app'
  },
  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET || 'pet-collar-access-secret-key-2026',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'pet-collar-refresh-secret-key-2026',
    accessExpire: process.env.JWT_ACCESS_EXPIRE || '2h',
    refreshExpire: process.env.JWT_REFRESH_EXPIRE || '7d'
  },
  wechat: {
    appId: process.env.WECHAT_APP_ID || '',
    appSecret: process.env.WECHAT_APP_SECRET || '',
    code2SessionUrl: 'https://api.weixin.qq.com/sns/jscode2session'
  },
  deepseek: {
    apiKey: process.env.DEEPSEEK_API_KEY || '',
    apiUrl: process.env.DEEPSEEK_API_URL || 'https://api.deepseek.com/v1/chat/completions',
    model: process.env.DEEPSEEK_MODEL || 'deepseek-chat'
  },
  upload: {
    path: process.env.UPLOAD_PATH || './uploads',
    maxSize: parseInt(process.env.UPLOAD_MAX_SIZE || '5242880')
  }
};
