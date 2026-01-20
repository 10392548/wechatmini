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
  },
  // 阿里云IoT配置
  iot: {
    broker: process.env.IOT_BROKER || 'iot-06z00fvzf0b0r8c.mqtt.iothub.aliyuncs.com',
    port: parseInt(process.env.IOT_PORT || '1883'),
    clientId: process.env.IOT_CLIENT_ID || 'k1v4u1lBCWc.Server',
    username: process.env.IOT_USERNAME || 'APP2&k1v4u1lBCWc',
    password: process.env.IOT_PASSWORD || '', // 必须通过环境变量配置
    subscribeTopic: process.env.IOT_SUBSCRIBE_TOPIC || '/k1v4u1lBCWc/APP2/user/set',
    publishTopic: process.env.IOT_PUBLISH_TOPIC || '/k1v4u1lBCWc/APP2/user/post2'
  },
  // 腾讯地图配置
  tencentMap: {
    key: process.env.TENCENT_MAP_KEY || '',
    coordinateSystem: 'gcj02'
  },
  // 坐标校准偏移量
  location: {
    offsetLat: parseFloat(process.env.LOCATION_OFFSET_LAT || '-0.002684'),
    offsetLng: parseFloat(process.env.LOCATION_OFFSET_LNG || '0.003912')
  },
  // 设备离线超时时间（毫秒）
  device: {
    offlineTimeout: parseInt(process.env.DEVICE_OFFLINE_TIMEOUT || '120000') // 2分钟
  }
};
