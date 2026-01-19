import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn, Unique } from 'typeorm';
import { Moment } from './Moment';
import { User } from './User';

@Entity('moment_likes')
@Unique(['moment_id', 'user_id'])
export class MomentLike {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  moment_id: number;

  @Column()
  user_id: number;

  @CreateDateColumn()
  created_at: Date;

  @ManyToOne(() => Moment, moment => moment.likes)
  @JoinColumn({ name: 'moment_id' })
  moment: Moment;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'user_id' })
  user: User;
}
