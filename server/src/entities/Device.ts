import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToOne } from 'typeorm';
import { Pet } from './Pet';

@Entity('devices')
export class Device {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'device_sn', unique: true })
  deviceSn: string;

  @Column({ name: 'pet_id', type: 'int', nullable: true })
  petId: number | null;

  @Column({ name: 'battery_level', default: 100 })
  batteryLevel: number;

  @Column({ name: 'is_online', default: false })
  isOnline: boolean;

  @Column({ name: 'last_online_at', type: 'timestamp', nullable: true })
  lastOnlineAt: Date;

  // IoT控制字段
  @Column({ name: 'buzzer_enabled', type: 'tinyint', default: 0 })
  buzzerEnabled: boolean;

  @Column({ name: 'sleep_mode_enabled', type: 'tinyint', default: 0 })
  sleepModeEnabled: boolean;

  @Column({ name: 'led_enabled', type: 'tinyint', default: 0 })
  ledEnabled: boolean;

  @Column({ name: 'firmware_version', length: 20, nullable: true })
  firmwareVersion: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @OneToOne(() => Pet, pet => pet.device)
  pet: Pet;
}
