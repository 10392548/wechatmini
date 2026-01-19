import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Device } from './Device';
import { Pet } from './Pet';

@Entity('activity_data')
export class ActivityData {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  device_id: number;

  @Column()
  pet_id: number;

  @Column({ default: 0 })
  steps: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  distance: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  calories: number;

  @Column({ default: 0 })
  active_minutes: number;

  @Column({ type: 'timestamp' })
  recorded_at: Date;

  @CreateDateColumn()
  created_at: Date;

  @ManyToOne(() => Device)
  @JoinColumn({ name: 'device_id' })
  device: Device;

  @ManyToOne(() => Pet)
  @JoinColumn({ name: 'pet_id' })
  pet: Pet;
}
