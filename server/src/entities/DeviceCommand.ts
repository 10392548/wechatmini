import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Device } from './Device';

export enum CommandStatus {
  PENDING = 'pending',
  SENT = 'sent',
  CONFIRMED = 'confirmed',
  FAILED = 'failed'
}

export enum CommandType {
  BUZZER = 'buzzer',
  SLEEP = 'sleep',
  LED = 'led'
}

@Entity('device_commands')
export class DeviceCommand {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'device_id' })
  deviceId: number;

  @Column({ name: 'command_type', length: 50 })
  commandType: CommandType;

  @Column({ type: 'json', nullable: true })
  payload: Record<string, any>;

  @Column({
    type: 'varchar',
    length: 20,
    default: CommandStatus.PENDING
  })
  status: CommandStatus;

  @Column({ name: 'sent_at', type: 'timestamp', nullable: true })
  sentAt: Date;

  @Column({ name: 'confirmed_at', type: 'timestamp', nullable: true })
  confirmedAt: Date;

  @Column({ name: 'created_at', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  createdAt: Date;

  @ManyToOne(() => Device, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'device_id' })
  device: Device;
}
