-- =====================================================
-- 宠物项圈 IoT 功能扩展
-- 版本: 1.0
-- 日期: 2026-01-20
-- =====================================================

USE pet_app;

-- -----------------------------------------------------
-- 1. 扩展设备表 - 添加控制字段
-- -----------------------------------------------------
ALTER TABLE devices
ADD COLUMN buzzer_enabled TINYINT(1) DEFAULT 0 COMMENT '蜂鸣器开关状态',
ADD COLUMN sleep_mode_enabled TINYINT(1) DEFAULT 0 COMMENT '休眠模式开关状态',
ADD COLUMN led_enabled TINYINT(1) DEFAULT 0 COMMENT 'LED灯开关状态',
ADD COLUMN firmware_version VARCHAR(20) COMMENT '固件版本';

-- -----------------------------------------------------
-- 2. 设备位置表 - 存储GPS位置历史
-- -----------------------------------------------------
CREATE TABLE device_locations (
  id INT PRIMARY KEY AUTO_INCREMENT,
  device_id INT NOT NULL COMMENT '设备ID',
  device_sn VARCHAR(50) NOT NULL COMMENT '设备序列号',
  latitude DECIMAL(10, 7) NOT NULL COMMENT '纬度（校准后）',
  longitude DECIMAL(11, 7) NOT NULL COMMENT '经度（校准后）',
  latitude_original DECIMAL(10, 7) COMMENT '原始纬度',
  longitude_original DECIMAL(11, 7) COMMENT '原始经度',
  altitude DECIMAL(8, 2) COMMENT '海拔（米）',
  accuracy DECIMAL(8, 2) COMMENT '定位精度（米）',
  activity INT DEFAULT 0 COMMENT '活动量',
  temperature DECIMAL(4, 1) COMMENT '温度（℃）',
  motion_state INT DEFAULT 0 COMMENT '运动状态：0=静止 1=行走 2=跑步',
  recorded_at TIMESTAMP NOT NULL COMMENT '设备记录时间',
  received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '服务器接收时间',
  INDEX idx_device_id (device_id),
  INDEX idx_device_sn (device_sn),
  INDEX idx_recorded_at (recorded_at),
  INDEX idx_received_at (received_at),
  FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备位置记录表';

-- -----------------------------------------------------
-- 3. 设备数据日志表 - 存储原始MQTT数据
-- -----------------------------------------------------
CREATE TABLE device_data_logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  device_id INT NOT NULL COMMENT '设备ID',
  device_sn VARCHAR(50) NOT NULL COMMENT '设备序列号',
  raw_data JSON NOT NULL COMMENT '原始MQTT数据',
  activity INT COMMENT '活动量',
  temperature DECIMAL(4, 1) COMMENT '温度',
  battery_level INT COMMENT '电量',
  motion_state INT COMMENT '运动状态',
  latitude DECIMAL(10, 7) COMMENT '纬度',
  longitude DECIMAL(11, 7) COMMENT '经度',
  received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '接收时间',
  INDEX idx_device_id (device_id),
  INDEX idx_device_sn (device_sn),
  INDEX idx_received_at (received_at),
  FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备数据日志表';

-- -----------------------------------------------------
-- 4. 设备命令表 - 记录下发的控制命令
-- -----------------------------------------------------
CREATE TABLE device_commands (
  id INT PRIMARY KEY AUTO_INCREMENT,
  device_id INT NOT NULL COMMENT '设备ID',
  command_type VARCHAR(50) NOT NULL COMMENT '命令类型：buzzer/sleep/led',
  payload JSON COMMENT '命令载荷',
  status VARCHAR(20) DEFAULT 'pending' COMMENT '状态：pending/sent/confirmed/failed',
  sent_at TIMESTAMP NULL COMMENT '发送时间',
  confirmed_at TIMESTAMP NULL COMMENT '确认时间',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  INDEX idx_device_id (device_id),
  INDEX idx_status (status),
  INDEX idx_created_at (created_at),
  FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备命令记录表';

-- -----------------------------------------------------
-- 执行完成
-- -----------------------------------------------------
