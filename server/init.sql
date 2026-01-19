-- 创建数据库
CREATE DATABASE IF NOT EXISTS pet_app DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE pet_app;

-- 用户表
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  openid VARCHAR(100) UNIQUE NOT NULL,
  nickname VARCHAR(100),
  avatar VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 宠物表
CREATE TABLE pets (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  name VARCHAR(50) NOT NULL,
  avatar VARCHAR(255),
  breed VARCHAR(50),
  birthday DATE,
  gender ENUM('male', 'female') DEFAULT 'male',
  weight DECIMAL(5,2),
  device_id INT UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id)
);

-- 设备表
CREATE TABLE devices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  device_sn VARCHAR(50) UNIQUE NOT NULL,
  pet_id INT UNIQUE,
  battery_level INT DEFAULT 100,
  is_online BOOLEAN DEFAULT FALSE,
  last_online_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE SET NULL,
  INDEX idx_device_sn (device_sn)
);

-- 朋友圈表
CREATE TABLE moments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  pet_id INT,
  content TEXT,
  images JSON,
  is_public BOOLEAN DEFAULT TRUE,
  like_count INT DEFAULT 0,
  comment_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE SET NULL,
  INDEX idx_user_id (user_id),
  INDEX idx_created_at (created_at)
);

-- 朋友圈点赞表
CREATE TABLE moment_likes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  moment_id INT NOT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (moment_id) REFERENCES moments(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_like (moment_id, user_id),
  INDEX idx_moment_id (moment_id)
);

-- 朋友圈评论表
CREATE TABLE moment_comments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  moment_id INT NOT NULL,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (moment_id) REFERENCES moments(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_moment_id (moment_id)
);

-- AI 聊天记录表
CREATE TABLE chat_messages (
  id INT PRIMARY KEY AUTO_INCREMENT,
  pet_id INT NOT NULL,
  role ENUM('user', 'assistant') NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE,
  INDEX idx_pet_id_created (pet_id, created_at)
);

-- 运动数据表
CREATE TABLE activity_data (
  id INT PRIMARY KEY AUTO_INCREMENT,
  device_id INT NOT NULL,
  pet_id INT NOT NULL,
  steps INT DEFAULT 0,
  distance DECIMAL(10,2) DEFAULT 0,
  calories DECIMAL(10,2) DEFAULT 0,
  active_minutes INT DEFAULT 0,
  recorded_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE,
  FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE,
  INDEX idx_pet_recorded (pet_id, recorded_at)
);

-- 成长日志表
CREATE TABLE growth_logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  pet_id INT NOT NULL,
  log_type ENUM('activity', 'sleep', 'milestone') NOT NULL,
  title VARCHAR(100) NOT NULL,
  content TEXT,
  data JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE,
  INDEX idx_pet_created (pet_id, created_at)
);
