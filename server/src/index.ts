import 'reflect-metadata';
import express from 'express';
import cors from 'cors';
import { DataSource } from 'typeorm';
import { config } from './config';
import authRoutes from './routes/auth';
import petRoutes from './routes/pet';
import deviceRoutes from './routes/device';
import deviceLocationRoutes from './routes/device-location';
import momentRoutes from './routes/moment';
import chatRoutes from './routes/chat';
import userRoutes from './routes/user';
import uploadRoutes from './routes/upload';
import healthRoutes from './routes/health';
import adminAuthRoutes from './routes/admin-auth';
import adminUserRoutes from './routes/admin-users';
import adminDeviceRoutes from './routes/admin-devices';
import adminMomentRoutes from './routes/admin-moments';
import adminStatsRoutes from './routes/admin-stats';
import adminMqttRoutes from './routes/admin-mqtt';
import adminSettingsRoutes from './routes/admin-settings';

// 实体导入
import { User } from './entities/User';
import { Pet } from './entities/Pet';
import { Device } from './entities/Device';
import { Moment } from './entities/Moment';
import { MomentLike } from './entities/MomentLike';
import { MomentComment } from './entities/MomentComment';
import { ChatMessage } from './entities/ChatMessage';
import { ActivityData } from './entities/ActivityData';
import { GrowthLog } from './entities/GrowthLog';
import { HealthRecord } from './entities/HealthRecord';
import { DeviceLocation } from './entities/DeviceLocation';
import { DeviceDataLog } from './entities/DeviceDataLog';
import { DeviceCommand } from './entities/DeviceCommand';
import { Admin } from './entities/Admin';

// 服务导入
import { initMQTTService } from './services/mqtt.service';

// 初始化数据库连接
export const AppDataSource = new DataSource({
  type: 'mysql',
  host: config.database.host,
  port: config.database.port,
  username: config.database.username,
  password: config.database.password,
  database: config.database.database,
  entities: [
    User, Pet, Device, Admin,
    Moment, MomentLike, MomentComment,
    ChatMessage, ActivityData,
    GrowthLog, HealthRecord,
    DeviceLocation, DeviceDataLog, DeviceCommand
  ],
  synchronize: false, // 生产环境设为 false
  logging: false
});

// 初始化 Express 应用
const app = express();

// 中间件
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 静态文件服务（图片访问）
app.use('/uploads', express.static('uploads'));

// 路由
app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/pet', petRoutes);
app.use('/api/device', deviceRoutes);
app.use('/api', deviceLocationRoutes);
app.use('/api/moment', momentRoutes);
app.use('/api/chat', chatRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/pet', healthRoutes);

// 管理员路由
app.use('/api/admin/auth', adminAuthRoutes);
app.use('/api/admin/users', adminUserRoutes);
app.use('/api/admin/devices', adminDeviceRoutes);
app.use('/api/admin/moments', adminMomentRoutes);
app.use('/api/admin/stats', adminStatsRoutes);
app.use('/api/admin/mqtt', adminMqttRoutes);
app.use('/api/admin/settings', adminSettingsRoutes);

// 健康检查
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// 启动服务器
AppDataSource.initialize()
  .then(() => {
    console.log('Database connected successfully');

    app.listen(config.port, () => {
      console.log(`Server is running on http://localhost:${config.port}`);
    });

    // 启动MQTT服务
    const mqttService = initMQTTService();
    mqttService.connect().catch((err) => {
      console.error('MQTT connection failed:', err);
      // MQTT连接失败不影响主服务运行
    });
  })
  .catch((error) => {
    console.error('Database connection failed:', error);
    process.exit(1);
  });
