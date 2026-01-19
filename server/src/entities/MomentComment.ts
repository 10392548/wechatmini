import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Moment } from './Moment';
import { User } from './User';

@Entity('moment_comments')
export class MomentComment {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  moment_id: number;

  @Column()
  user_id: number;

  @Column({ type: 'text' })
  content: string;

  @CreateDateColumn()
  created_at: Date;

  @ManyToOne(() => Moment, moment => moment.comments)
  @JoinColumn({ name: 'moment_id' })
  moment: Moment;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'user_id' })
  user: User;
}
