import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, OneToOne, JoinColumn, OneToMany } from 'typeorm';
import { User } from './User';
import { Device } from './Device';
import { ChatMessage } from './ChatMessage';

@Entity('pets')
export class Pet {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  user_id: number;

  @Column()
  name: string;

  @Column({ nullable: true })
  avatar: string;

  @Column({ nullable: true })
  breed: string;

  @Column({ type: 'date', nullable: true })
  birthday: Date;

  @Column({ type: 'enum', enum: ['male', 'female'], default: 'male' })
  gender: string;

  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  weight: number;

  @Column({ type: 'int', nullable: true })
  device_id: number | null;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @ManyToOne(() => User, user => user.pets)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @OneToOne(() => Device, device => device.pet)
  @JoinColumn({ name: 'device_id' })
  device: Device;

  @OneToMany(() => ChatMessage, message => message.pet)
  chat_messages: ChatMessage[];
}
