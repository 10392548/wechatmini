import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Device } from './Device';

@Entity('device_data_logs')
export class DeviceDataLog {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'device_id' })
  deviceId: number;

  @Column({ name: 'device_sn', length: 50 })
  deviceSn: string;

  @Column({ name: 'raw_data', type: 'json' })
  rawData: Record<string, any>;

  @Column({ nullable: true })
  activity: number;

  @Column({ type: 'decimal', precision: 4, scale: 1, nullable: true })
  temperature: number;

  @Column({ name: 'battery_level', nullable: true })
  batteryLevel: number;

  @Column({ name: 'motion_state', nullable: true })
  motionState: number;

  @Column({ type: 'decimal', precision: 10, scale: 7, nullable: true })
  latitude: number;

  @Column({ type: 'decimal', precision: 11, scale: 7, nullable: true })
  longitude: number;

  @Column({ name: 'received_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  receivedAt: Date;

  @ManyToOne(() => Device, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'device_id' })
  device: Device;
}
