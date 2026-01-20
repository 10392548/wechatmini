import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { Device } from './Device';

@Entity('device_locations')
@Index(['deviceId', 'recordedAt']) // 复合索引，用于查询设备最新位置
export class DeviceLocation {
  @PrimaryGeneratedColumn()
  id: number;

  @Index()
  @Column({ name: 'device_id' })
  deviceId: number;

  @Column({ name: 'device_sn', length: 50 })
  deviceSn: string;

  @Column({ type: 'decimal', precision: 10, scale: 7 })
  latitude: number;

  @Column({ type: 'decimal', precision: 11, scale: 7 })
  longitude: number;

  @Column({ name: 'latitude_original', type: 'decimal', precision: 10, scale: 7, nullable: true })
  latitudeOriginal: number;

  @Column({ name: 'longitude_original', type: 'decimal', precision: 11, scale: 7, nullable: true })
  longitudeOriginal: number;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  altitude: number;

  @Column({ type: 'decimal', precision: 8, scale: 2, nullable: true })
  accuracy: number;

  @Column({ default: 0 })
  activity: number;

  @Column({ type: 'decimal', precision: 4, scale: 1, nullable: true })
  temperature: number;

  @Column({ name: 'motion_state', default: 0 })
  motionState: number;

  @Index()
  @Column({ name: 'recorded_at', type: 'timestamp' })
  recordedAt: Date;

  @Index()
  @Column({ name: 'received_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  receivedAt: Date;

  @ManyToOne(() => Device, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'device_id' })
  device: Device;

  /**
   * 判断是否有有效位置
   */
  hasValidLocation(): boolean {
    return this.latitude !== 0 && this.longitude !== 0;
  }

  /**
   * 获取运动状态描述
   */
  getMotionStateDescription(): string {
    const states = ['静止', '行走', '跑步'];
    return states[this.motionState] || '未知';
  }
}
