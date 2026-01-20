/*
 Navicat Premium Data Transfer

 Source Server         : MySql5.7（3307）
 Source Server Type    : MySQL
 Source Server Version : 50721 (5.7.21-log)
 Source Host           : localhost:3307
 Source Schema         : pet_app

 Target Server Type    : MySQL
 Target Server Version : 50721 (5.7.21-log)
 File Encoding         : 65001

 Date: 21/01/2026 06:06:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity_data
-- ----------------------------
DROP TABLE IF EXISTS `activity_data`;
CREATE TABLE `activity_data`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `steps` int(11) NULL DEFAULT 0,
  `distance` decimal(10, 2) NULL DEFAULT 0.00,
  `calories` decimal(10, 2) NULL DEFAULT 0.00,
  `active_minutes` int(11) NULL DEFAULT 0,
  `recorded_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `device_id`(`device_id`) USING BTREE,
  INDEX `idx_pet_recorded`(`pet_id`, `recorded_at`) USING BTREE,
  CONSTRAINT `activity_data_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `activity_data_ibfk_2` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of activity_data
-- ----------------------------

-- ----------------------------
-- Table structure for chat_messages
-- ----------------------------
DROP TABLE IF EXISTS `chat_messages`;
CREATE TABLE `chat_messages`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pet_id` int(11) NOT NULL,
  `role` enum('user','assistant') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pet_id_created`(`pet_id`, `created_at`) USING BTREE,
  CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_messages
-- ----------------------------

-- ----------------------------
-- Table structure for device_commands
-- ----------------------------
DROP TABLE IF EXISTS `device_commands`;
CREATE TABLE `device_commands`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) NOT NULL COMMENT '设备ID',
  `command_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '命令类型：buzzer/sleep/led',
  `payload` json NULL COMMENT '命令载荷',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending' COMMENT '状态：pending/sent/confirmed/failed',
  `sent_at` timestamp NULL DEFAULT NULL COMMENT '发送时间',
  `confirmed_at` timestamp NULL DEFAULT NULL COMMENT '确认时间',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_device_id`(`device_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE,
  CONSTRAINT `device_commands_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备命令记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of device_commands
-- ----------------------------

-- ----------------------------
-- Table structure for device_data_logs
-- ----------------------------
DROP TABLE IF EXISTS `device_data_logs`;
CREATE TABLE `device_data_logs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) NOT NULL COMMENT '设备ID',
  `device_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备序列号',
  `raw_data` json NOT NULL COMMENT '原始MQTT数据',
  `activity` int(11) NULL DEFAULT NULL COMMENT '活动量',
  `temperature` decimal(4, 1) NULL DEFAULT NULL COMMENT '温度',
  `battery_level` int(11) NULL DEFAULT NULL COMMENT '电量',
  `motion_state` int(11) NULL DEFAULT NULL COMMENT '运动状态',
  `latitude` decimal(10, 7) NULL DEFAULT NULL COMMENT '纬度',
  `longitude` decimal(11, 7) NULL DEFAULT NULL COMMENT '经度',
  `received_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '接收时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_device_id`(`device_id`) USING BTREE,
  INDEX `idx_device_sn`(`device_sn`) USING BTREE,
  INDEX `idx_received_at`(`received_at`) USING BTREE,
  CONSTRAINT `device_data_logs_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备数据日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of device_data_logs
-- ----------------------------

-- ----------------------------
-- Table structure for device_locations
-- ----------------------------
DROP TABLE IF EXISTS `device_locations`;
CREATE TABLE `device_locations`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) NOT NULL COMMENT '设备ID',
  `device_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备序列号',
  `latitude` decimal(10, 7) NOT NULL COMMENT '纬度（校准后）',
  `longitude` decimal(11, 7) NOT NULL COMMENT '经度（校准后）',
  `latitude_original` decimal(10, 7) NULL DEFAULT NULL COMMENT '原始纬度',
  `longitude_original` decimal(11, 7) NULL DEFAULT NULL COMMENT '原始经度',
  `altitude` decimal(8, 2) NULL DEFAULT NULL COMMENT '海拔（米）',
  `accuracy` decimal(8, 2) NULL DEFAULT NULL COMMENT '定位精度（米）',
  `activity` int(11) NULL DEFAULT 0 COMMENT '活动量',
  `temperature` decimal(4, 1) NULL DEFAULT NULL COMMENT '温度（℃）',
  `motion_state` int(11) NULL DEFAULT 0 COMMENT '运动状态：0=静止 1=行走 2=跑步',
  `recorded_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '设备记录时间',
  `received_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '服务器接收时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_device_id`(`device_id`) USING BTREE,
  INDEX `idx_device_sn`(`device_sn`) USING BTREE,
  INDEX `idx_recorded_at`(`recorded_at`) USING BTREE,
  INDEX `idx_received_at`(`received_at`) USING BTREE,
  CONSTRAINT `device_locations_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备位置记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of device_locations
-- ----------------------------

-- ----------------------------
-- Table structure for devices
-- ----------------------------
DROP TABLE IF EXISTS `devices`;
CREATE TABLE `devices`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pet_id` int(11) NULL DEFAULT NULL,
  `battery_level` int(11) NULL DEFAULT 100,
  `is_online` tinyint(1) NULL DEFAULT 0,
  `last_online_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `buzzer_enabled` tinyint(1) NULL DEFAULT 0 COMMENT '蜂鸣器开关状态',
  `sleep_mode_enabled` tinyint(1) NULL DEFAULT 0 COMMENT '休眠模式开关状态',
  `led_enabled` tinyint(1) NULL DEFAULT 0 COMMENT 'LED灯开关状态',
  `firmware_version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '固件版本',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `device_sn`(`device_sn`) USING BTREE,
  UNIQUE INDEX `pet_id`(`pet_id`) USING BTREE,
  INDEX `idx_device_sn`(`device_sn`) USING BTREE,
  CONSTRAINT `devices_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of devices
-- ----------------------------
INSERT INTO `devices` VALUES (8, '860678079254725', NULL, 100, 0, '2026-01-19 19:08:35', '2026-01-19 19:08:35', '2026-01-19 19:08:35', 0, 0, 0, NULL);
INSERT INTO `devices` VALUES (9, '860678079254720', 9, 100, 0, '2026-01-21 06:03:37', '2026-01-21 06:03:37', '2026-01-21 06:03:37', 0, 0, 0, NULL);

-- ----------------------------
-- Table structure for growth_logs
-- ----------------------------
DROP TABLE IF EXISTS `growth_logs`;
CREATE TABLE `growth_logs`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pet_id` int(11) NOT NULL,
  `log_type` enum('activity','sleep','milestone') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `data` json NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pet_created`(`pet_id`, `created_at`) USING BTREE,
  CONSTRAINT `growth_logs_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of growth_logs
-- ----------------------------

-- ----------------------------
-- Table structure for health_records
-- ----------------------------
DROP TABLE IF EXISTS `health_records`;
CREATE TABLE `health_records`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pet_id` int(11) NOT NULL,
  `record_type` enum('vaccination','illness','medication','checkup') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `record_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `vaccine_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `next_vaccination_date` date NULL DEFAULT NULL,
  `symptoms` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `diagnosis` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `vet_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `hospital` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `medicine_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `dosage` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `frequency` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `duration_days` int(11) NULL DEFAULT NULL,
  `weight` decimal(5, 2) NULL DEFAULT NULL,
  `temperature` decimal(5, 2) NULL DEFAULT NULL,
  `heart_rate` int(11) NULL DEFAULT NULL,
  `checkup_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `cost` decimal(10, 2) NULL DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pet_id`(`pet_id`) USING BTREE,
  INDEX `idx_record_type`(`record_type`) USING BTREE,
  INDEX `idx_record_date`(`record_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of health_records
-- ----------------------------
INSERT INTO `health_records` VALUES (1, 8, 'medication', '狂犬疫苗', NULL, '2026-01-20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '屁屁', '1片', '每日2次', 30, NULL, NULL, NULL, NULL, 380.00, '生冷少吃', '2026-01-20 06:15:11', '2026-01-20 06:15:11');

-- ----------------------------
-- Table structure for moment_comments
-- ----------------------------
DROP TABLE IF EXISTS `moment_comments`;
CREATE TABLE `moment_comments`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `moment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `idx_moment_id`(`moment_id`) USING BTREE,
  CONSTRAINT `moment_comments_ibfk_1` FOREIGN KEY (`moment_id`) REFERENCES `moments` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `moment_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of moment_comments
-- ----------------------------

-- ----------------------------
-- Table structure for moment_likes
-- ----------------------------
DROP TABLE IF EXISTS `moment_likes`;
CREATE TABLE `moment_likes`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `moment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_like`(`moment_id`, `user_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `idx_moment_id`(`moment_id`) USING BTREE,
  CONSTRAINT `moment_likes_ibfk_1` FOREIGN KEY (`moment_id`) REFERENCES `moments` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `moment_likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of moment_likes
-- ----------------------------
INSERT INTO `moment_likes` VALUES (2, 3, 18, '2026-01-19 19:14:15');

-- ----------------------------
-- Table structure for moments
-- ----------------------------
DROP TABLE IF EXISTS `moments`;
CREATE TABLE `moments`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `images` json NULL,
  `is_public` tinyint(1) NULL DEFAULT 1,
  `like_count` int(11) NULL DEFAULT 0,
  `comment_count` int(11) NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `pet_id`(`pet_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE,
  CONSTRAINT `moments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `moments_ibfk_2` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of moments
-- ----------------------------
INSERT INTO `moments` VALUES (3, 18, NULL, '11111', '[\"http://localhost:3003/uploads/1768821242646-157863045.png\"]', 1, 1, 0, '2026-01-19 19:14:02', '2026-01-19 19:14:15');

-- ----------------------------
-- Table structure for pets
-- ----------------------------
DROP TABLE IF EXISTS `pets`;
CREATE TABLE `pets`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `breed` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `birthday` date NULL DEFAULT NULL,
  `gender` enum('male','female') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'male',
  `weight` decimal(5, 2) NULL DEFAULT NULL,
  `device_id` int(11) NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `device_id`(`device_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `pets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pets
-- ----------------------------
INSERT INTO `pets` VALUES (9, 18, '张飞', 'http://localhost:3003/uploads/1768946526179-278136894.jpg', '金毛', NULL, 'male', NULL, 9, '2026-01-21 06:03:37', '2026-01-21 06:03:37');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `has_custom_profile` tinyint(1) NULL DEFAULT 0 COMMENT '是否自定义过资料（头像或昵称）：0-否，1-是',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `openid`(`openid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (18, 'o-I5h14M5RacW9YQHRlvPqloFKH8', '微信用1户', 'http://localhost:3003/uploads/1768820420218-944785976.jpg', '', 1, '2026-01-19 19:00:05', '2026-01-19 19:00:22');
INSERT INTO `users` VALUES (19, 'mock_openid_1768853966437', '微信用户', '', NULL, 0, '2026-01-20 04:19:26', '2026-01-20 04:19:26');

SET FOREIGN_KEY_CHECKS = 1;
