import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Pet } from './Pet';

@Entity('chat_messages')
export class ChatMessage {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  pet_id: number;

  @Column({ type: 'enum', enum: ['user', 'assistant'] })
  role: string;

  @Column({ type: 'text' })
  content: string;

  @CreateDateColumn()
  created_at: Date;

  @ManyToOne(() => Pet, pet => pet.chat_messages)
  @JoinColumn({ name: 'pet_id' })
  pet: Pet;
}
