import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { User } from './User';
import { Pet } from './Pet';
import { MomentLike } from './MomentLike';
import { MomentComment } from './MomentComment';

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
}
