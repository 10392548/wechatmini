import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { User } from './User';
import { Pet } from './Pet';
import { MomentLike } from './MomentLike';
import { MomentComment } from './MomentComment';
import { Admin } from './Admin';

export enum AuditStatus {
  PENDING = 'pending',
  APPROVED = 'approved',
  REJECTED = 'rejected'
}

@Entity('moments')
export class Moment {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  user_id: number;

  @Column({ type: 'int', nullable: true })
  pet_id: number | null;

  @Column({ type: 'text', nullable: true })
  content: string;

  @Column({ type: 'json', nullable: true })
  images: string[];

  @Column({ default: true })
  is_public: boolean;

  @Column({ default: 0 })
  like_count: number;

  @Column({ default: 0 })
  comment_count: number;

  @Column({
    type: 'enum',
    enum: AuditStatus,
    default: AuditStatus.PENDING
  })
  status: AuditStatus;

  @Column({ type: 'int', nullable: true })
  reviewed_by_id: number | null;

  @Column({ type: 'timestamp', nullable: true })
  reviewed_at: Date | null;

  @Column({ type: 'text', nullable: true })
  rejection_reason: string | null;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @ManyToOne(() => User, user => user.moments)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Pet)
  @JoinColumn({ name: 'pet_id' })
  pet: Pet;

  @OneToMany(() => MomentLike, like => like.moment)
  likes: MomentLike[];

  @OneToMany(() => MomentComment, comment => comment.moment)
  comments: MomentComment[];

  @ManyToOne(() => Admin, { nullable: true })
  @JoinColumn({ name: 'reviewed_by_id' })
  reviewed_by: Admin | null;
}
