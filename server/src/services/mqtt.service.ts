import * as mqtt from 'mqtt';
import * as crypto from 'crypto';
import { AppDataSource } from '../index';
import { Device } from '../entities/Device';
import { DeviceLocation } from '../entities/DeviceLocation';
import { DeviceDataLog } from '../entities/DeviceDataLog';
import { LocationUtils } from '../utils/location';

/**
 * MQTT设备数据接口
 * 对应阿里云IoT平台设备上报的数据格式
 */
interface DeviceDataParams {
  timeinterval?: number;
  Latitude?: number;
  Longitude?: number;
  latitude?: number;
  longitude?: number;
  activity?: number;
  temperature?: number;
  motionstate?: number;
  battery?: number;
}

interface DeviceMqttMessage {
  method: string;
  id?: string;
  params: DeviceDataParams;
  ID?: string;
  deviceId?: string;
}

/**
 * 阿里云IoT MQTT配置
 */
interface MqttConfig {
  broker: string;
  port: number;
  clientId: string;
  username: string;
  password: string;
  subscribeTopic: string;
  publishTopic: string;
}

/**
 * MQTT服务类
 * 负责与阿里云IoT平台通信，接收设备数据并下发控制命令
 */
export class MQTTService {
  private client: mqtt.MqttClient | null = null;
  private config: MqttConfig;
  private isConnecting: boolean = false;
  private reconnectTimer: NodeJS.Timeout | null = null;

  constructor(config: MqttConfig) {
    this.config = config;
  }

  /**
   * 连接MQTT服务器
   */
  async connect(): Promise<void> {
    if (this.client?.connected || this.isConnecting) {
      console.log('MQTT已连接或正在连接中');
      return;
    }

    this.isConnecting = true;

    const connectUrl = `mqtt://${this.config.broker}:${this.config.port}`;

    this.client = mqtt.connect(connectUrl, {
      clientId: this.config.clientId,
      username: this.config.username,
      password: this.config.password,
      clean: false,  // 与Android端保持一致
      connectTimeout: 10 * 1000,  // 10秒
      keepalive: 60,  // 与Android端保持一致
      reconnectPeriod: 5000
    });

    this.client.on('connect', () => {
      console.log('[MQTT] 连接成功');
      this.isConnecting = false;

      // 订阅设备上报主题
      this.client!.subscribe(this.config.subscribeTopic, { qos: 1 }, (err) => {
        if (err) {
          console.error('[MQTT] 订阅失败:', err);
        } else {
          console.log(`[MQTT] 已订阅主题: ${this.config.subscribeTopic}`);
        }
      });
    });

    this.client.on('message', async (topic, message) => {
      await this.handleMessage(topic, message.toString());
    });

    this.client.on('error', (err) => {
      console.error('[MQTT] 连接错误:', err.message);
      this.isConnecting = false;
    });

    this.client.on('close', () => {
      console.log('[MQTT] 连接关闭');
      this.isConnecting = false;
    });

    this.client.on('reconnect', () => {
      console.log('[MQTT] 正在重连...');
    });
  }

  /**
   * 处理接收到的MQTT消息
   */
  private async handleMessage(topic: string, payload: string): Promise<void> {
    try {
      const data: DeviceMqttMessage = JSON.parse(payload);
      const deviceSn = data.ID || data.deviceId;
      console.log(`[MQTT] 收到消息: method=${data.method}, device=${deviceSn}`);

      // 只处理设备属性上报
      if (data.method === 'thing.event.property.post') {
        await this.handleDeviceData(data);
      }
    } catch (error) {
      // 详细记录错误信息，便于排查
      const payloadPreview = payload.length > 200 ? payload.substring(0, 200) + '...' : payload;
      console.error('[MQTT] 消息解析错误:', {
        topic,
        payload: payloadPreview,
        error: error instanceof Error ? error.message : String(error),
        stack: error instanceof Error ? error.stack : undefined
      });
    }
  }

  /**
   * 处理设备数据
   */
  private async handleDeviceData(data: DeviceMqttMessage): Promise<void> {
    const deviceSn = data.ID || data.deviceId;
    if (!deviceSn) {
      console.warn('[MQTT] 消息缺少设备ID');
      return;
    }

    const params = data.params || {};

    // 获取或创建设备
    const deviceRepo = AppDataSource.getRepository(Device);
    let device = await deviceRepo.findOne({ where: { deviceSn } });

    if (!device) {
      console.log(`[MQTT] 新设备注册: ${deviceSn}`);
      device = deviceRepo.create({ deviceSn });
    }

    // 更新设备状态
    if (params.battery !== undefined) {
      device.batteryLevel = params.battery;
    }
    device.isOnline = true;
    device.lastOnlineAt = new Date();
    await deviceRepo.save(device);

    // 如果有位置数据，保存位置记录
    const lat = params.Latitude || params.latitude;
    const lng = params.Longitude || params.longitude;

    if (lat && lng && lat !== 0 && lng !== 0) {
      await this.saveDeviceLocation(device.id, deviceSn, params);
    }

    // 保存数据日志
    await this.saveDeviceDataLog(device.id, deviceSn, data, params);
  }

  /**
   * 保存设备位置
   */
  private async saveDeviceLocation(
    deviceId: number,
    deviceSn: string,
    params: DeviceDataParams
  ): Promise<void> {
    try {
      const locationRepo = AppDataSource.getRepository(DeviceLocation);

      const originalLat = params.Latitude || params.latitude;
      const originalLng = params.Longitude || params.longitude;

      // 验证坐标有效性
      if (!originalLat || !originalLng) {
        console.warn(`[MQTT] 坐标数据缺失: ${deviceSn}`);
        return;
      }

      if (!LocationUtils.isValidCoordinate(originalLat, originalLng)) {
        console.warn(`[MQTT] 无效坐标: ${deviceSn}`, { lat: originalLat, lng: originalLng });
        return;
      }

      // 应用坐标校准
      const calibrated = LocationUtils.calibrate(originalLat, originalLng);

      const location = locationRepo.create({
        deviceId,
        deviceSn,
        latitude: calibrated.latitude,
        longitude: calibrated.longitude,
        latitudeOriginal: originalLat,
        longitudeOriginal: originalLng,
        activity: params.activity || 0,
        temperature: params.temperature,
        motionState: params.motionstate || 0,
        recordedAt: new Date()
      });

      await locationRepo.save(location);
      console.log(`[MQTT] 位置已保存: ${deviceSn}`, {
        original: { lat: originalLat, lng: originalLng },
        calibrated
      });
    } catch (error) {
      console.error('[MQTT] 位置保存失败:', deviceSn, error);
    }
  }

  /**
   * 保存设备数据日志
   */
  private async saveDeviceDataLog(
    deviceId: number,
    deviceSn: string,
    rawData: DeviceMqttMessage,
    params: DeviceDataParams
  ): Promise<void> {
    try {
      const logRepo = AppDataSource.getRepository(DeviceDataLog);

      const log = logRepo.create({
        deviceId,
        deviceSn,
        rawData,
        activity: params.activity,
        temperature: params.temperature,
        batteryLevel: params.battery,
        motionState: params.motionstate,
        latitude: params.Latitude || params.latitude,
        longitude: params.Longitude || params.longitude
      });

      await logRepo.save(log);
    } catch (error) {
      console.error('[MQTT] 日志保存失败:', error);
    }
  }

  /**
   * 发布控制命令到设备
   * @param deviceId 设备序列号
   * @param params 命令参数 { beep: 0/1, led: 0/1, sleep: 0/1 }
   */
  async publishCommand(deviceId: string, params: Record<string, any>): Promise<boolean> {
    return new Promise((resolve) => {
      if (!this.client?.connected) {
        console.error('[MQTT] 未连接，无法发送命令');
        resolve(false);
        return;
      }

      const payload = JSON.stringify({
        method: 'thing.service.property.set',
        id: `cmd_${Date.now()}`,
        params
      });

      this.client.publish(this.config.publishTopic, payload, { qos: 1 }, (err) => {
        if (err) {
          console.error('[MQTT] 命令发送失败:', err);
          resolve(false);
        } else {
          console.log(`[MQTT] 命令已发送: ${deviceId}`, params);
          resolve(true);
        }
      });
    });
  }

  /**
   * 发送蜂鸣器控制命令
   */
  async buzzerControl(deviceId: string, enabled: boolean): Promise<boolean> {
    return this.publishCommand(deviceId, { beep: enabled ? 1 : 0 });
  }

  /**
   * 发送休眠模式控制命令
   */
  async sleepControl(deviceId: string, enabled: boolean): Promise<boolean> {
    return this.publishCommand(deviceId, { sleep: enabled ? 1 : 0 });
  }

  /**
   * 发送LED控制命令
   */
  async ledControl(deviceId: string, enabled: boolean): Promise<boolean> {
    return this.publishCommand(deviceId, { led: enabled ? 1 : 0 });
  }

  /**
   * 断开连接
   */
  disconnect(): void {
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }

    if (this.client) {
      this.client.end();
      this.client = null;
    }
  }

  /**
   * 获取连接状态
   */
  isConnected(): boolean {
    return this.client?.connected ?? false;
  }
}

// =====================================================
// 阿里云IoT MQTT签名工具
// =====================================================

/**
 * 生成阿里云IoT MQTT签名的ClientId（设备端方式）
 * 参考Android端实现，使用HMAC-SHA256签名
 */
function generateDeviceClientId(
  productKey: string,
  deviceKey: string,
  deviceSecret: string
): { clientId: string; password: string } {
  const timestamp = Date.now().toString();
  const clientId = `${productKey}.${deviceKey}|securemode=2,signmethod=hmacsha256,timestamp=${timestamp}|`;

  // 尝试1: 生成签名: hmacsha256(deviceSecret, clientId)
  const signSha256 = crypto.createHmac('sha256', deviceSecret).update(clientId).digest('hex');

  // 尝试2: 使用MD5签名（阿里云IoT某些版本使用MD5）
  const clientIdMd5 = `${productKey}.${deviceKey}|securemode=2,signmethod=hmacmd5,timestamp=${timestamp}|`;
  const signMd5 = crypto.createHmac('md5', deviceSecret).update(clientIdMd5).digest('hex');

  // 调试日志
  console.log('[MQTT] 签名调试:', {
    timestamp,
    clientIdSha256: clientId,
    signSha256: signSha256.substring(0, 20) + '...',
    clientIdMd5: clientIdMd5,
    signMd5: signMd5
  });

  // 先尝试MD5
  return { clientId: clientIdMd5, password: signMd5 };
}

/**
 * 生成服务端签名（使用AccessKey认证）
 * 服务端认证不与设备冲突，可同时连接
 */
function generateServerSignature(
  accessKeyId: string,
  accessKeySecret: string,
  productKey: string
): { clientId: string; username: string; password: string } {
  const timestamp = Date.now().toString();
  const clientId = `Server_${accessKeyId}_${timestamp}`;

  // 阿里云IoT服务端签名： hmacmd5(secret, clientId)
  const sign = crypto.createHmac('md5', accessKeySecret).update(clientId).digest('hex');

  // Username格式: |timestamp=${timestamp}|，或者使用AccessKey ID
  const username = `|timestamp=${timestamp}|`;
  const password = sign;

  return { clientId, username, password };
}

// 导出单例
let mqttServiceInstance: MQTTService | null = null;

export function initMQTTService(): MQTTService {
  if (!mqttServiceInstance) {
    // 阿里云IoT参数
    const productKey = process.env.IOT_PRODUCT_KEY || 'k1v4u1lBCWc';
    const deviceKey = process.env.IOT_DEVICE_KEY || 'APP2';

    let config: MqttConfig;

    // 优先使用服务端AccessKey认证（推荐，不与设备冲突）
    if (process.env.IOT_ACCESS_KEY_ID && process.env.IOT_ACCESS_KEY_SECRET) {
      const { clientId, username, password } = generateServerSignature(
        process.env.IOT_ACCESS_KEY_ID,
        process.env.IOT_ACCESS_KEY_SECRET,
        productKey
      );

      config = {
        broker: process.env.IOT_BROKER || 'iot-06z00fvzf0b0r8c.mqtt.iothub.aliyuncs.com',
        port: parseInt(process.env.IOT_PORT || '1883'),
        clientId,
        username,
        password,
        subscribeTopic: process.env.IOT_SUBSCRIBE_TOPIC || `/${productKey}/${deviceKey}/user/set`,
        publishTopic: process.env.IOT_PUBLISH_TOPIC || `/${productKey}/${deviceKey}/user/post2`
      };

      console.log('[MQTT] 使用服务端AccessKey认证');
    } else if (process.env.IOT_USE_RAW_PASSWORD === 'true') {
      // 原始密码模式：与Android端保持一致的认证方式
      const deviceSecret = process.env.IOT_DEVICE_SECRET || process.env.IOT_PASSWORD;
      if (!deviceSecret) {
        throw new Error('缺少认证配置，需要配置 IOT_ACCESS_KEY_ID/IOT_ACCESS_KEY_SECRET 或 IOT_DEVICE_SECRET');
      }

      // 使用与Android端完全相同的ClientId和timestamp
      const clientId = `${productKey}.${deviceKey}|securemode=2,signmethod=hmacsha256,timestamp=1757835869920|`;

      config = {
        broker: process.env.IOT_BROKER || 'iot-06z00fvzf0b0r8c.mqtt.iothub.aliyuncs.com',
        port: parseInt(process.env.IOT_PORT || '1883'),
        clientId,
        username: process.env.IOT_USERNAME || `${deviceKey}&${productKey}`,
        password: deviceSecret,  // 直接使用DeviceSecret作为密码，不计算签名
        subscribeTopic: process.env.IOT_SUBSCRIBE_TOPIC || `/${productKey}/${deviceKey}/user/set`,
        publishTopic: process.env.IOT_PUBLISH_TOPIC || `/${productKey}/${deviceKey}/user/post2`
      };

      console.log('[MQTT] 使用原始密码认证（与Android端完全一致）');
    } else {
      // 备用：使用设备认证（需要确保设备不在线）
      const deviceSecret = process.env.IOT_DEVICE_SECRET || process.env.IOT_PASSWORD;
      if (!deviceSecret) {
        throw new Error('缺少认证配置，需要配置 IOT_ACCESS_KEY_ID/IOT_ACCESS_KEY_SECRET 或 IOT_DEVICE_SECRET');
      }

      const { clientId, password } = generateDeviceClientId(productKey, deviceKey, deviceSecret);

      config = {
        broker: process.env.IOT_BROKER || 'iot-06z00fvzf0b0r8c.mqtt.iothub.aliyuncs.com',
        port: parseInt(process.env.IOT_PORT || '1883'),
        clientId,
        username: process.env.IOT_USERNAME || `${deviceKey}&${productKey}`,
        password,
        subscribeTopic: process.env.IOT_SUBSCRIBE_TOPIC || `/${productKey}/${deviceKey}/user/set`,
        publishTopic: process.env.IOT_PUBLISH_TOPIC || `/${productKey}/${deviceKey}/user/post2`
      };

      console.log('[MQTT] 使用设备认证（确保设备APP2不在线）');
    }

    console.log('[MQTT] 配置参数:', {
      broker: config.broker,
      port: config.port,
      clientId: config.clientId,  // 完整打印，便于调试
      username: config.username,
      password: config.password.substring(0, 20) + '...' + config.password.substring(config.password.length - 20),  // 打印部分密码
      subscribeTopic: config.subscribeTopic,
      publishTopic: config.publishTopic
    });

    mqttServiceInstance = new MQTTService(config);
  }

  return mqttServiceInstance;
}

export function getMQTTService(): MQTTService | null {
  return mqttServiceInstance;
}
