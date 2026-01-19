import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Pet } from './Pet';

@Entity('growth_logs')
export class GrowthLog {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  pet_id: number;

  @Column({ type: 'enum', enum: ['activity', 'sleep', 'milestone'] })
  log_type: string;

  @Column()
  title: string;

  @Column({ type: 'text', nullable: true })
  content: string;

  @Column({ type: 'json', nullable: true })
  data: any;

  @CreateDateColumn()
  created_at: Date;

  @ManyToOne(() => Pet)
  @JoinColumn({ name: 'pet_id' })
  pet: Pet;
}
