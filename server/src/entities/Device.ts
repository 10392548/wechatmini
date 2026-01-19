import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToOne } from 'typeorm';
import { Pet } from './Pet';

@Entity('devices')
export class Device {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  device_sn: string;

  @Column({ type: 'int', nullable: true })
  pet_id: number | null;

  @Column({ default: 100 })
  battery_level: number;

  @Column({ default: false })
  is_online: boolean;

  @Column({ type: 'timestamp', nullable: true })
  last_online_at: Date;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @OneToOne(() => Pet, pet => pet.device)
  pet: Pet;
}
