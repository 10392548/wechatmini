import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Pet } from './Pet';

@Entity('health_records')
export class HealthRecord {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  pet_id: number;

  @Column({ type: 'enum', enum: ['vaccination', 'illness', 'medication', 'checkup'] })
  record_type: string;

  @Column({ length: 200 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'date', nullable: true })
  record_date: Date;

  @Column({ type: 'date', nullable: true })
  end_date: Date;

  // 疫苗接种专用字段
  @Column({ length: 100, nullable: true })
  vaccine_name: string;

  @Column({ type: 'date', nullable: true })
  next_vaccination_date: Date;

  // 生病记录专用字段
  @Column({ length: 500, nullable: true })
  symptoms: string;

  @Column({ length: 200, nullable: true })
  diagnosis: string;

  @Column({ length: 100, nullable: true })
  vet_name: string;

  @Column({ length: 200, nullable: true })
  hospital: string;

  // 用药记录专用字段
  @Column({ length: 100, nullable: true })
  medicine_name: string;

  @Column({ length: 100, nullable: true })
  dosage: string;

  @Column({ length: 100, nullable: true })
  frequency: string;

  @Column({ type: 'int', nullable: true })
  duration_days: number;

  // 体检记录专用字段
  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  weight: number;

  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  temperature: number;

  @Column({ type: 'int', nullable: true })
  heart_rate: number;

  @Column({ type: 'text', nullable: true })
  checkup_result: string;

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  cost: number;

  @Column({ type: 'text', nullable: true })
  notes: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @ManyToOne(() => Pet)
  @JoinColumn({ name: 'pet_id' })
  pet: Pet;
}
