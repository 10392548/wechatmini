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

 Date: 22/01/2026 05:42:33
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
-- Table structure for admins
-- ----------------------------
DROP TABLE IF EXISTS `admins`;
CREATE TABLE `admins`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'admin',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admins
-- ----------------------------
INSERT INTO `admins` VALUES (3, 'admin', '$2b$10$ig4bO3n73K27.LsC6PsXEubmi.x9E3VEcDzH6zgqkn8Z7YTZPFB0q', 'admin', '2026-01-21 08:48:41', '2026-01-21 08:48:41');

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
) ENGINE = InnoDB AUTO_INCREMENT = 527 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备数据日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of device_data_logs
-- ----------------------------
INSERT INTO `device_data_logs` VALUES (1, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251674, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516740, 113.1872500, '2026-01-22 05:13:10');
INSERT INTO `device_data_logs` VALUES (2, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251674, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 8.23, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516740, 113.1872500, '2026-01-22 05:13:13');
INSERT INTO `device_data_logs` VALUES (3, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251674, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 8.77, \"timeinterval\": 10}}', 1348, 8.8, NULL, 0, 23.2516740, 113.1872500, '2026-01-22 05:13:16');
INSERT INTO `device_data_logs` VALUES (4, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251668, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516680, 113.1872500, '2026-01-22 05:13:20');
INSERT INTO `device_data_logs` VALUES (5, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251668, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516680, 113.1872500, '2026-01-22 05:13:23');
INSERT INTO `device_data_logs` VALUES (6, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251668, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 8.41, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516680, 113.1872500, '2026-01-22 05:13:26');
INSERT INTO `device_data_logs` VALUES (7, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251668, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516680, 113.1872500, '2026-01-22 05:13:30');
INSERT INTO `device_data_logs` VALUES (8, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251668, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516680, 113.1872500, '2026-01-22 05:13:33');
INSERT INTO `device_data_logs` VALUES (9, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251715, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2517150, 113.1872500, '2026-01-22 05:13:36');
INSERT INTO `device_data_logs` VALUES (10, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251715, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2517150, 113.1872500, '2026-01-22 05:13:40');
INSERT INTO `device_data_logs` VALUES (11, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251715, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2517150, 113.1872500, '2026-01-22 05:13:43');
INSERT INTO `device_data_logs` VALUES (12, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251715, \"activity\": 1348, \"Longitude\": 113.18725, \"motionstate\": 0, \"temperature\": 6.89, \"timeinterval\": 10}}', 1348, 6.9, NULL, 0, 23.2517150, 113.1872500, '2026-01-22 05:13:46');
INSERT INTO `device_data_logs` VALUES (13, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516930, 113.1872380, '2026-01-22 05:13:50');
INSERT INTO `device_data_logs` VALUES (14, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516930, 113.1872380, '2026-01-22 05:13:53');
INSERT INTO `device_data_logs` VALUES (15, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516930, 113.1872380, '2026-01-22 05:13:56');
INSERT INTO `device_data_logs` VALUES (16, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516930, 113.1872380, '2026-01-22 05:14:00');
INSERT INTO `device_data_logs` VALUES (17, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 6.37, \"timeinterval\": 10}}', 1348, 6.4, NULL, 0, 23.2516930, 113.1872380, '2026-01-22 05:14:03');
INSERT INTO `device_data_logs` VALUES (18, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251684, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516840, 113.1871870, '2026-01-22 05:14:06');
INSERT INTO `device_data_logs` VALUES (19, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251684, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516840, 113.1871870, '2026-01-22 05:14:10');
INSERT INTO `device_data_logs` VALUES (20, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251684, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516840, 113.1871870, '2026-01-22 05:14:13');
INSERT INTO `device_data_logs` VALUES (21, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251684, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516840, 113.1871870, '2026-01-22 05:14:16');
INSERT INTO `device_data_logs` VALUES (22, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 6.71, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516390, 113.1872380, '2026-01-22 05:14:20');
INSERT INTO `device_data_logs` VALUES (23, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516390, 113.1872380, '2026-01-22 05:14:23');
INSERT INTO `device_data_logs` VALUES (24, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516390, 113.1872380, '2026-01-22 05:14:26');
INSERT INTO `device_data_logs` VALUES (25, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 6.71, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516390, 113.1872380, '2026-01-22 05:14:30');
INSERT INTO `device_data_logs` VALUES (26, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516390, 113.1872380, '2026-01-22 05:14:33');
INSERT INTO `device_data_logs` VALUES (27, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187288, \"motionstate\": 0, \"temperature\": 6.37, \"timeinterval\": 10}}', 1348, 6.4, NULL, 0, 23.2516710, 113.1872880, '2026-01-22 05:14:36');
INSERT INTO `device_data_logs` VALUES (28, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187288, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516710, 113.1872880, '2026-01-22 05:14:40');
INSERT INTO `device_data_logs` VALUES (29, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187288, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516710, 113.1872880, '2026-01-22 05:14:43');
INSERT INTO `device_data_logs` VALUES (30, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187288, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516710, 113.1872880, '2026-01-22 05:14:47');
INSERT INTO `device_data_logs` VALUES (31, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516420, 113.1872120, '2026-01-22 05:14:50');
INSERT INTO `device_data_logs` VALUES (32, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516420, 113.1872120, '2026-01-22 05:14:53');
INSERT INTO `device_data_logs` VALUES (33, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516420, 113.1872120, '2026-01-22 05:14:57');
INSERT INTO `device_data_logs` VALUES (34, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516420, 113.1872120, '2026-01-22 05:15:00');
INSERT INTO `device_data_logs` VALUES (35, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 8.55, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2516420, 113.1872120, '2026-01-22 05:15:03');
INSERT INTO `device_data_logs` VALUES (36, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251588, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2515880, 113.1871990, '2026-01-22 05:15:07');
INSERT INTO `device_data_logs` VALUES (37, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251588, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2515880, 113.1871990, '2026-01-22 05:15:10');
INSERT INTO `device_data_logs` VALUES (38, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251588, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2515880, 113.1871990, '2026-01-22 05:15:13');
INSERT INTO `device_data_logs` VALUES (39, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251588, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2515880, 113.1871990, '2026-01-22 05:15:17');
INSERT INTO `device_data_logs` VALUES (40, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516010, 113.1871740, '2026-01-22 05:15:20');
INSERT INTO `device_data_logs` VALUES (41, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516010, 113.1871740, '2026-01-22 05:15:23');
INSERT INTO `device_data_logs` VALUES (42, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516010, 113.1871740, '2026-01-22 05:15:27');
INSERT INTO `device_data_logs` VALUES (43, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 6.65, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516010, 113.1871740, '2026-01-22 05:15:30');
INSERT INTO `device_data_logs` VALUES (44, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516010, 113.1871740, '2026-01-22 05:15:33');
INSERT INTO `device_data_logs` VALUES (45, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2515980, 113.1871870, '2026-01-22 05:15:37');
INSERT INTO `device_data_logs` VALUES (46, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2515980, 113.1871870, '2026-01-22 05:15:40');
INSERT INTO `device_data_logs` VALUES (47, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2515980, 113.1871870, '2026-01-22 05:15:43');
INSERT INTO `device_data_logs` VALUES (48, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2515980, 113.1871870, '2026-01-22 05:15:47');
INSERT INTO `device_data_logs` VALUES (49, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516010, 113.1871740, '2026-01-22 05:15:50');
INSERT INTO `device_data_logs` VALUES (50, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516010, 113.1871740, '2026-01-22 05:15:53');
INSERT INTO `device_data_logs` VALUES (51, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516010, 113.1871740, '2026-01-22 05:15:57');
INSERT INTO `device_data_logs` VALUES (52, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 6.65, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516010, 113.1871740, '2026-01-22 05:16:00');
INSERT INTO `device_data_logs` VALUES (53, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516010, 113.1871740, '2026-01-22 05:16:03');
INSERT INTO `device_data_logs` VALUES (54, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516010, 113.1871230, '2026-01-22 05:16:07');
INSERT INTO `device_data_logs` VALUES (55, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516010, 113.1871230, '2026-01-22 05:16:10');
INSERT INTO `device_data_logs` VALUES (56, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 8.67, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2516010, 113.1871230, '2026-01-22 05:16:13');
INSERT INTO `device_data_logs` VALUES (57, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2516010, 113.1871230, '2026-01-22 05:16:17');
INSERT INTO `device_data_logs` VALUES (58, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251557, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2515570, 113.1871360, '2026-01-22 05:16:20');
INSERT INTO `device_data_logs` VALUES (59, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251557, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2515570, 113.1871360, '2026-01-22 05:16:23');
INSERT INTO `device_data_logs` VALUES (60, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251557, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2515570, 113.1871360, '2026-01-22 05:16:27');
INSERT INTO `device_data_logs` VALUES (61, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251557, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.67, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2515570, 113.1871360, '2026-01-22 05:16:30');
INSERT INTO `device_data_logs` VALUES (62, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251557, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.41, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2515570, 113.1871360, '2026-01-22 05:16:34');
INSERT INTO `device_data_logs` VALUES (63, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2515850, 113.1871610, '2026-01-22 05:16:37');
INSERT INTO `device_data_logs` VALUES (64, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2515850, 113.1871610, '2026-01-22 05:16:40');
INSERT INTO `device_data_logs` VALUES (65, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2515850, 113.1871610, '2026-01-22 05:16:44');
INSERT INTO `device_data_logs` VALUES (66, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.23, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2515850, 113.1871610, '2026-01-22 05:16:47');
INSERT INTO `device_data_logs` VALUES (67, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516110, 113.1871490, '2026-01-22 05:16:50');
INSERT INTO `device_data_logs` VALUES (68, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.67, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2516110, 113.1871490, '2026-01-22 05:16:54');
INSERT INTO `device_data_logs` VALUES (69, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516110, 113.1871490, '2026-01-22 05:16:57');
INSERT INTO `device_data_logs` VALUES (70, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516110, 113.1871490, '2026-01-22 05:17:00');
INSERT INTO `device_data_logs` VALUES (71, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516110, 113.1871490, '2026-01-22 05:17:04');
INSERT INTO `device_data_logs` VALUES (72, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251652, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516520, 113.1870980, '2026-01-22 05:17:07');
INSERT INTO `device_data_logs` VALUES (73, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251652, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516520, 113.1870980, '2026-01-22 05:17:10');
INSERT INTO `device_data_logs` VALUES (74, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251652, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516520, 113.1870980, '2026-01-22 05:17:14');
INSERT INTO `device_data_logs` VALUES (75, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251652, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516520, 113.1870980, '2026-01-22 05:17:17');
INSERT INTO `device_data_logs` VALUES (76, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516330, 113.1871100, '2026-01-22 05:17:20');
INSERT INTO `device_data_logs` VALUES (77, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516330, 113.1871100, '2026-01-22 05:17:24');
INSERT INTO `device_data_logs` VALUES (78, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516330, 113.1871100, '2026-01-22 05:17:27');
INSERT INTO `device_data_logs` VALUES (79, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516330, 113.1871100, '2026-01-22 05:17:30');
INSERT INTO `device_data_logs` VALUES (80, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251626, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516260, 113.1871610, '2026-01-22 05:17:34');
INSERT INTO `device_data_logs` VALUES (81, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251626, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.17, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516260, 113.1871610, '2026-01-22 05:17:37');
INSERT INTO `device_data_logs` VALUES (82, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251626, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516260, 113.1871610, '2026-01-22 05:17:40');
INSERT INTO `device_data_logs` VALUES (83, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251626, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516260, 113.1871610, '2026-01-22 05:17:44');
INSERT INTO `device_data_logs` VALUES (84, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251626, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516260, 113.1871610, '2026-01-22 05:17:47');
INSERT INTO `device_data_logs` VALUES (85, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.29, \"timeinterval\": 10}}', 1348, 8.3, NULL, 0, 23.2516230, 113.1871870, '2026-01-22 05:17:50');
INSERT INTO `device_data_logs` VALUES (86, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.95, \"timeinterval\": 10}}', 1348, 9.0, NULL, 0, 23.2516230, 113.1871870, '2026-01-22 05:17:54');
INSERT INTO `device_data_logs` VALUES (87, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516230, 113.1871870, '2026-01-22 05:17:57');
INSERT INTO `device_data_logs` VALUES (88, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516230, 113.1871870, '2026-01-22 05:18:00');
INSERT INTO `device_data_logs` VALUES (89, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.67, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2516010, 113.1871990, '2026-01-22 05:18:04');
INSERT INTO `device_data_logs` VALUES (90, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.23, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516010, 113.1871990, '2026-01-22 05:18:07');
INSERT INTO `device_data_logs` VALUES (91, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.17, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516010, 113.1871990, '2026-01-22 05:18:10');
INSERT INTO `device_data_logs` VALUES (92, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516010, 113.1871990, '2026-01-22 05:18:14');
INSERT INTO `device_data_logs` VALUES (93, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.23, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516010, 113.1871990, '2026-01-22 05:18:17');
INSERT INTO `device_data_logs` VALUES (94, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251617, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516170, 113.1872120, '2026-01-22 05:18:21');
INSERT INTO `device_data_logs` VALUES (95, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251617, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 8.23, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516170, 113.1872120, '2026-01-22 05:18:24');
INSERT INTO `device_data_logs` VALUES (96, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251617, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 8.17, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516170, 113.1872120, '2026-01-22 05:18:27');
INSERT INTO `device_data_logs` VALUES (97, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251617, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 8.73, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2516170, 113.1872120, '2026-01-22 05:18:31');
INSERT INTO `device_data_logs` VALUES (98, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.49, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2516390, 113.1871990, '2026-01-22 05:18:34');
INSERT INTO `device_data_logs` VALUES (99, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516390, 113.1871990, '2026-01-22 05:18:37');
INSERT INTO `device_data_logs` VALUES (100, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516390, 113.1871990, '2026-01-22 05:18:41');
INSERT INTO `device_data_logs` VALUES (101, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516390, 113.1871990, '2026-01-22 05:18:44');
INSERT INTO `device_data_logs` VALUES (102, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516390, 113.1871990, '2026-01-22 05:18:47');
INSERT INTO `device_data_logs` VALUES (103, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:18:51');
INSERT INTO `device_data_logs` VALUES (104, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:18:54');
INSERT INTO `device_data_logs` VALUES (105, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 6.99, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:18:57');
INSERT INTO `device_data_logs` VALUES (106, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:19:01');
INSERT INTO `device_data_logs` VALUES (107, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516300, 113.1871490, '2026-01-22 05:19:04');
INSERT INTO `device_data_logs` VALUES (108, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516300, 113.1871490, '2026-01-22 05:19:07');
INSERT INTO `device_data_logs` VALUES (109, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516300, 113.1871490, '2026-01-22 05:19:11');
INSERT INTO `device_data_logs` VALUES (110, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516300, 113.1871490, '2026-01-22 05:19:14');
INSERT INTO `device_data_logs` VALUES (111, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516300, 113.1871490, '2026-01-22 05:19:17');
INSERT INTO `device_data_logs` VALUES (112, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516110, 113.1872120, '2026-01-22 05:19:21');
INSERT INTO `device_data_logs` VALUES (113, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 6.43, \"timeinterval\": 10}}', 1348, 6.4, NULL, 0, 23.2516110, 113.1872120, '2026-01-22 05:19:24');
INSERT INTO `device_data_logs` VALUES (114, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516110, 113.1872120, '2026-01-22 05:19:27');
INSERT INTO `device_data_logs` VALUES (115, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516110, 113.1872120, '2026-01-22 05:19:31');
INSERT INTO `device_data_logs` VALUES (116, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 6.77, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516110, 113.1872120, '2026-01-22 05:19:34');
INSERT INTO `device_data_logs` VALUES (117, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516110, 113.1872120, '2026-01-22 05:19:37');
INSERT INTO `device_data_logs` VALUES (118, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516110, 113.1872120, '2026-01-22 05:19:41');
INSERT INTO `device_data_logs` VALUES (119, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516110, 113.1872120, '2026-01-22 05:19:44');
INSERT INTO `device_data_logs` VALUES (120, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251611, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516110, 113.1872120, '2026-01-22 05:19:47');
INSERT INTO `device_data_logs` VALUES (121, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 6.61, \"timeinterval\": 10}}', 1348, 6.6, NULL, 0, 23.2515980, 113.1871990, '2026-01-22 05:19:51');
INSERT INTO `device_data_logs` VALUES (122, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 6.65, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2515980, 113.1871990, '2026-01-22 05:19:54');
INSERT INTO `device_data_logs` VALUES (123, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2515980, 113.1871990, '2026-01-22 05:19:57');
INSERT INTO `device_data_logs` VALUES (124, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 6.99, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2515980, 113.1871990, '2026-01-22 05:20:01');
INSERT INTO `device_data_logs` VALUES (125, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251607, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516070, 113.1871870, '2026-01-22 05:20:04');
INSERT INTO `device_data_logs` VALUES (126, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251607, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516070, 113.1871870, '2026-01-22 05:20:07');
INSERT INTO `device_data_logs` VALUES (127, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251607, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516070, 113.1871870, '2026-01-22 05:20:11');
INSERT INTO `device_data_logs` VALUES (128, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251607, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516070, 113.1871870, '2026-01-22 05:20:14');
INSERT INTO `device_data_logs` VALUES (129, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251607, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516070, 113.1871870, '2026-01-22 05:20:18');
INSERT INTO `device_data_logs` VALUES (130, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516040, 113.1871610, '2026-01-22 05:20:21');
INSERT INTO `device_data_logs` VALUES (131, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516040, 113.1871610, '2026-01-22 05:20:24');
INSERT INTO `device_data_logs` VALUES (132, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516040, 113.1871610, '2026-01-22 05:20:28');
INSERT INTO `device_data_logs` VALUES (133, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516040, 113.1871610, '2026-01-22 05:20:31');
INSERT INTO `device_data_logs` VALUES (134, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2515950, 113.1871610, '2026-01-22 05:20:34');
INSERT INTO `device_data_logs` VALUES (135, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2515950, 113.1871610, '2026-01-22 05:20:38');
INSERT INTO `device_data_logs` VALUES (136, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.29, \"timeinterval\": 10}}', 1348, 8.3, NULL, 0, 23.2515950, 113.1871610, '2026-01-22 05:20:41');
INSERT INTO `device_data_logs` VALUES (137, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2515950, 113.1871610, '2026-01-22 05:20:44');
INSERT INTO `device_data_logs` VALUES (138, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2515950, 113.1871610, '2026-01-22 05:20:48');
INSERT INTO `device_data_logs` VALUES (139, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2515950, 113.1871610, '2026-01-22 05:20:51');
INSERT INTO `device_data_logs` VALUES (140, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2515950, 113.1871610, '2026-01-22 05:20:54');
INSERT INTO `device_data_logs` VALUES (141, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2515950, 113.1871610, '2026-01-22 05:20:58');
INSERT INTO `device_data_logs` VALUES (142, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.41, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2515950, 113.1871610, '2026-01-22 05:21:01');
INSERT INTO `device_data_logs` VALUES (143, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516200, 113.1871610, '2026-01-22 05:21:04');
INSERT INTO `device_data_logs` VALUES (144, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516200, 113.1871610, '2026-01-22 05:21:08');
INSERT INTO `device_data_logs` VALUES (145, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.21, \"timeinterval\": 10}}', 1348, 6.2, NULL, 0, 23.2516200, 113.1871610, '2026-01-22 05:21:11');
INSERT INTO `device_data_logs` VALUES (146, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516200, 113.1871610, '2026-01-22 05:21:14');
INSERT INTO `device_data_logs` VALUES (147, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516200, 113.1871610, '2026-01-22 05:21:18');
INSERT INTO `device_data_logs` VALUES (148, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516200, 113.1871610, '2026-01-22 05:21:21');
INSERT INTO `device_data_logs` VALUES (149, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516200, 113.1871610, '2026-01-22 05:21:24');
INSERT INTO `device_data_logs` VALUES (150, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516200, 113.1871610, '2026-01-22 05:21:28');
INSERT INTO `device_data_logs` VALUES (151, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.29, \"timeinterval\": 10}}', 1348, 8.3, NULL, 0, 23.2516200, 113.1871610, '2026-01-22 05:21:31');
INSERT INTO `device_data_logs` VALUES (152, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516550, 113.1871990, '2026-01-22 05:21:34');
INSERT INTO `device_data_logs` VALUES (153, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516550, 113.1871990, '2026-01-22 05:21:38');
INSERT INTO `device_data_logs` VALUES (154, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516550, 113.1871990, '2026-01-22 05:21:41');
INSERT INTO `device_data_logs` VALUES (155, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.45, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2516550, 113.1871990, '2026-01-22 05:21:44');
INSERT INTO `device_data_logs` VALUES (156, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516550, 113.1871990, '2026-01-22 05:21:48');
INSERT INTO `device_data_logs` VALUES (157, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516550, 113.1871990, '2026-01-22 05:21:51');
INSERT INTO `device_data_logs` VALUES (158, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.77, \"timeinterval\": 10}}', 1348, 8.8, NULL, 0, 23.2516550, 113.1871990, '2026-01-22 05:21:55');
INSERT INTO `device_data_logs` VALUES (159, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516550, 113.1871990, '2026-01-22 05:21:58');
INSERT INTO `device_data_logs` VALUES (160, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516550, 113.1871990, '2026-01-22 05:22:01');
INSERT INTO `device_data_logs` VALUES (161, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:22:05');
INSERT INTO `device_data_logs` VALUES (162, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 6.77, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:22:08');
INSERT INTO `device_data_logs` VALUES (163, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 6.65, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:22:11');
INSERT INTO `device_data_logs` VALUES (164, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:22:15');
INSERT INTO `device_data_logs` VALUES (165, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:22:18');
INSERT INTO `device_data_logs` VALUES (166, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:22:21');
INSERT INTO `device_data_logs` VALUES (167, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 6.89, \"timeinterval\": 10}}', 1348, 6.9, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:22:25');
INSERT INTO `device_data_logs` VALUES (168, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:22:28');
INSERT INTO `device_data_logs` VALUES (169, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.23, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516360, 113.1871870, '2026-01-22 05:22:31');
INSERT INTO `device_data_logs` VALUES (170, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251576, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2515760, 113.1871610, '2026-01-22 05:22:35');
INSERT INTO `device_data_logs` VALUES (171, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251576, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2515760, 113.1871610, '2026-01-22 05:22:38');
INSERT INTO `device_data_logs` VALUES (172, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251576, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2515760, 113.1871610, '2026-01-22 05:22:41');
INSERT INTO `device_data_logs` VALUES (173, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251576, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.45, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2515760, 113.1871610, '2026-01-22 05:22:45');
INSERT INTO `device_data_logs` VALUES (174, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251576, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.41, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2515760, 113.1871610, '2026-01-22 05:22:48');
INSERT INTO `device_data_logs` VALUES (175, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2515690, 113.1871360, '2026-01-22 05:22:51');
INSERT INTO `device_data_logs` VALUES (176, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2515690, 113.1871360, '2026-01-22 05:22:55');
INSERT INTO `device_data_logs` VALUES (177, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2515690, 113.1871360, '2026-01-22 05:22:58');
INSERT INTO `device_data_logs` VALUES (178, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2515690, 113.1871360, '2026-01-22 05:23:01');
INSERT INTO `device_data_logs` VALUES (179, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2515790, 113.1871360, '2026-01-22 05:23:05');
INSERT INTO `device_data_logs` VALUES (180, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.95, \"timeinterval\": 10}}', 1348, 9.0, NULL, 0, 23.2515790, 113.1871360, '2026-01-22 05:23:08');
INSERT INTO `device_data_logs` VALUES (181, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2515790, 113.1871360, '2026-01-22 05:23:11');
INSERT INTO `device_data_logs` VALUES (182, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2515790, 113.1871360, '2026-01-22 05:23:15');
INSERT INTO `device_data_logs` VALUES (183, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.67, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2515790, 113.1871360, '2026-01-22 05:23:18');
INSERT INTO `device_data_logs` VALUES (184, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251582, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 8.89, \"timeinterval\": 10}}', 1348, 8.9, NULL, 0, 23.2515820, 113.1871100, '2026-01-22 05:23:21');
INSERT INTO `device_data_logs` VALUES (185, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251582, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2515820, 113.1871100, '2026-01-22 05:23:25');
INSERT INTO `device_data_logs` VALUES (186, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251582, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 9.11, \"timeinterval\": 10}}', 1348, 9.1, NULL, 0, 23.2515820, 113.1871100, '2026-01-22 05:23:28');
INSERT INTO `device_data_logs` VALUES (187, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251582, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2515820, 113.1871100, '2026-01-22 05:23:31');
INSERT INTO `device_data_logs` VALUES (188, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251566, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2515660, 113.1871490, '2026-01-22 05:23:35');
INSERT INTO `device_data_logs` VALUES (189, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251566, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2515660, 113.1871490, '2026-01-22 05:23:38');
INSERT INTO `device_data_logs` VALUES (190, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251566, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2515660, 113.1871490, '2026-01-22 05:23:42');
INSERT INTO `device_data_logs` VALUES (191, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251566, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2515660, 113.1871490, '2026-01-22 05:23:45');
INSERT INTO `device_data_logs` VALUES (192, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251566, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2515660, 113.1871490, '2026-01-22 05:23:48');
INSERT INTO `device_data_logs` VALUES (193, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251553, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.23, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2515530, 113.1871490, '2026-01-22 05:23:52');
INSERT INTO `device_data_logs` VALUES (194, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251553, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2515530, 113.1871490, '2026-01-22 05:23:55');
INSERT INTO `device_data_logs` VALUES (195, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251553, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2515530, 113.1871490, '2026-01-22 05:23:58');
INSERT INTO `device_data_logs` VALUES (196, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251553, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.41, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2515530, 113.1871490, '2026-01-22 05:24:02');
INSERT INTO `device_data_logs` VALUES (197, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251566, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2515660, 113.1871360, '2026-01-22 05:24:05');
INSERT INTO `device_data_logs` VALUES (198, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251566, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2515660, 113.1871360, '2026-01-22 05:24:08');
INSERT INTO `device_data_logs` VALUES (199, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251566, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2515660, 113.1871360, '2026-01-22 05:24:12');
INSERT INTO `device_data_logs` VALUES (200, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251566, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2515660, 113.1871360, '2026-01-22 05:24:15');
INSERT INTO `device_data_logs` VALUES (201, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251566, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2515660, 113.1871360, '2026-01-22 05:24:18');
INSERT INTO `device_data_logs` VALUES (202, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2515790, 113.1871610, '2026-01-22 05:24:22');
INSERT INTO `device_data_logs` VALUES (203, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2515790, 113.1871610, '2026-01-22 05:24:25');
INSERT INTO `device_data_logs` VALUES (204, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2515790, 113.1871610, '2026-01-22 05:24:28');
INSERT INTO `device_data_logs` VALUES (205, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2515790, 113.1871610, '2026-01-22 05:24:32');
INSERT INTO `device_data_logs` VALUES (206, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251553, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2515530, 113.1871490, '2026-01-22 05:24:35');
INSERT INTO `device_data_logs` VALUES (207, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251553, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2515530, 113.1871490, '2026-01-22 05:24:38');
INSERT INTO `device_data_logs` VALUES (208, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251553, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.45, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2515530, 113.1871490, '2026-01-22 05:24:42');
INSERT INTO `device_data_logs` VALUES (209, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251553, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2515530, 113.1871490, '2026-01-22 05:24:45');
INSERT INTO `device_data_logs` VALUES (210, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251553, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.45, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2515530, 113.1871490, '2026-01-22 05:24:48');
INSERT INTO `device_data_logs` VALUES (211, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.73, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2515720, 113.1871990, '2026-01-22 05:24:52');
INSERT INTO `device_data_logs` VALUES (212, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2515720, 113.1871990, '2026-01-22 05:24:55');
INSERT INTO `device_data_logs` VALUES (213, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2515720, 113.1871990, '2026-01-22 05:24:58');
INSERT INTO `device_data_logs` VALUES (214, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.49, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2515720, 113.1871990, '2026-01-22 05:25:02');
INSERT INTO `device_data_logs` VALUES (215, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 8.55, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2515850, 113.1872120, '2026-01-22 05:25:05');
INSERT INTO `device_data_logs` VALUES (216, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2515850, 113.1872120, '2026-01-22 05:25:08');
INSERT INTO `device_data_logs` VALUES (217, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 9.05, \"timeinterval\": 10}}', 1348, 9.1, NULL, 0, 23.2515850, 113.1872120, '2026-01-22 05:25:12');
INSERT INTO `device_data_logs` VALUES (218, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 9.01, \"timeinterval\": 10}}', 1348, 9.0, NULL, 0, 23.2515850, 113.1872120, '2026-01-22 05:25:15');
INSERT INTO `device_data_logs` VALUES (219, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 8.77, \"timeinterval\": 10}}', 1348, 8.8, NULL, 0, 23.2515850, 113.1872120, '2026-01-22 05:25:19');
INSERT INTO `device_data_logs` VALUES (220, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.95, \"timeinterval\": 10}}', 1348, 9.0, NULL, 0, 23.2515850, 113.1871870, '2026-01-22 05:25:22');
INSERT INTO `device_data_logs` VALUES (221, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.89, \"timeinterval\": 10}}', 1348, 8.9, NULL, 0, 23.2515850, 113.1871870, '2026-01-22 05:25:25');
INSERT INTO `device_data_logs` VALUES (222, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.73, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2515850, 113.1871870, '2026-01-22 05:25:29');
INSERT INTO `device_data_logs` VALUES (223, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2515850, 113.1871870, '2026-01-22 05:25:32');
INSERT INTO `device_data_logs` VALUES (224, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.73, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2515690, 113.1871990, '2026-01-22 05:25:35');
INSERT INTO `device_data_logs` VALUES (225, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2515690, 113.1871990, '2026-01-22 05:25:39');
INSERT INTO `device_data_logs` VALUES (226, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 6.77, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2515690, 113.1871990, '2026-01-22 05:25:42');
INSERT INTO `device_data_logs` VALUES (227, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2515690, 113.1871990, '2026-01-22 05:25:45');
INSERT INTO `device_data_logs` VALUES (228, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2515690, 113.1871990, '2026-01-22 05:25:49');
INSERT INTO `device_data_logs` VALUES (229, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 6.71, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2515980, 113.1871990, '2026-01-22 05:25:52');
INSERT INTO `device_data_logs` VALUES (230, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2515980, 113.1871990, '2026-01-22 05:25:55');
INSERT INTO `device_data_logs` VALUES (231, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.77, \"timeinterval\": 10}}', 1348, 8.8, NULL, 0, 23.2515980, 113.1871990, '2026-01-22 05:25:59');
INSERT INTO `device_data_logs` VALUES (232, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251598, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.45, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2515980, 113.1871990, '2026-01-22 05:26:02');
INSERT INTO `device_data_logs` VALUES (233, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.67, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2516040, 113.1871870, '2026-01-22 05:26:05');
INSERT INTO `device_data_logs` VALUES (234, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.17, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516040, 113.1871870, '2026-01-22 05:26:09');
INSERT INTO `device_data_logs` VALUES (235, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516040, 113.1871870, '2026-01-22 05:26:12');
INSERT INTO `device_data_logs` VALUES (236, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516040, 113.1871870, '2026-01-22 05:26:15');
INSERT INTO `device_data_logs` VALUES (237, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516040, 113.1871870, '2026-01-22 05:26:19');
INSERT INTO `device_data_logs` VALUES (238, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516010, 113.1871870, '2026-01-22 05:26:22');
INSERT INTO `device_data_logs` VALUES (239, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516010, 113.1871870, '2026-01-22 05:26:25');
INSERT INTO `device_data_logs` VALUES (240, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516010, 113.1871870, '2026-01-22 05:26:29');
INSERT INTO `device_data_logs` VALUES (241, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251601, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516010, 113.1871870, '2026-01-22 05:26:32');
INSERT INTO `device_data_logs` VALUES (242, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.45, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2515850, 113.1871610, '2026-01-22 05:26:35');
INSERT INTO `device_data_logs` VALUES (243, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2515850, 113.1871610, '2026-01-22 05:26:39');
INSERT INTO `device_data_logs` VALUES (244, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2515850, 113.1871610, '2026-01-22 05:26:42');
INSERT INTO `device_data_logs` VALUES (245, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251585, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.77, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2515850, 113.1871610, '2026-01-22 05:26:45');
INSERT INTO `device_data_logs` VALUES (246, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251582, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2515820, 113.1871490, '2026-01-22 05:26:49');
INSERT INTO `device_data_logs` VALUES (247, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251582, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2515820, 113.1871490, '2026-01-22 05:26:52');
INSERT INTO `device_data_logs` VALUES (248, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251582, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 5.99, \"timeinterval\": 10}}', 1348, 6.0, NULL, 0, 23.2515820, 113.1871490, '2026-01-22 05:26:55');
INSERT INTO `device_data_logs` VALUES (249, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251582, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 6.27, \"timeinterval\": 10}}', 1348, 6.3, NULL, 0, 23.2515820, 113.1871490, '2026-01-22 05:26:59');
INSERT INTO `device_data_logs` VALUES (250, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251582, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2515820, 113.1871490, '2026-01-22 05:27:02');
INSERT INTO `device_data_logs` VALUES (251, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2515690, 113.1871610, '2026-01-22 05:27:05');
INSERT INTO `device_data_logs` VALUES (252, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2515690, 113.1871610, '2026-01-22 05:27:09');
INSERT INTO `device_data_logs` VALUES (253, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2515690, 113.1871610, '2026-01-22 05:27:12');
INSERT INTO `device_data_logs` VALUES (254, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251569, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2515690, 113.1871610, '2026-01-22 05:27:16');
INSERT INTO `device_data_logs` VALUES (255, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.41, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2515720, 113.1871490, '2026-01-22 05:27:19');
INSERT INTO `device_data_logs` VALUES (256, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 6.99, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2515720, 113.1871490, '2026-01-22 05:27:22');
INSERT INTO `device_data_logs` VALUES (257, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2515720, 113.1871490, '2026-01-22 05:27:26');
INSERT INTO `device_data_logs` VALUES (258, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2515720, 113.1871490, '2026-01-22 05:27:29');
INSERT INTO `device_data_logs` VALUES (259, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.17, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2515720, 113.1871490, '2026-01-22 05:27:32');
INSERT INTO `device_data_logs` VALUES (260, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2515790, 113.1871490, '2026-01-22 05:27:36');
INSERT INTO `device_data_logs` VALUES (261, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2515790, 113.1871490, '2026-01-22 05:27:39');
INSERT INTO `device_data_logs` VALUES (262, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2515790, 113.1871490, '2026-01-22 05:27:42');
INSERT INTO `device_data_logs` VALUES (263, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2515790, 113.1871490, '2026-01-22 05:27:46');
INSERT INTO `device_data_logs` VALUES (264, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2515720, 113.1871490, '2026-01-22 05:27:49');
INSERT INTO `device_data_logs` VALUES (265, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 6.99, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2515720, 113.1871490, '2026-01-22 05:27:52');
INSERT INTO `device_data_logs` VALUES (266, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2515720, 113.1871490, '2026-01-22 05:27:56');
INSERT INTO `device_data_logs` VALUES (267, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2515720, 113.1871490, '2026-01-22 05:27:59');
INSERT INTO `device_data_logs` VALUES (268, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251572, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2515720, 113.1871490, '2026-01-22 05:28:02');
INSERT INTO `device_data_logs` VALUES (269, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2515790, 113.1871360, '2026-01-22 05:28:06');
INSERT INTO `device_data_logs` VALUES (270, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2515790, 113.1871360, '2026-01-22 05:28:09');
INSERT INTO `device_data_logs` VALUES (271, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2515790, 113.1871360, '2026-01-22 05:28:12');
INSERT INTO `device_data_logs` VALUES (272, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251579, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2515790, 113.1871360, '2026-01-22 05:28:16');
INSERT INTO `device_data_logs` VALUES (273, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 8.29, \"timeinterval\": 10}}', 1348, 8.3, NULL, 0, 23.2516040, 113.1870980, '2026-01-22 05:28:19');
INSERT INTO `device_data_logs` VALUES (274, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516040, 113.1870980, '2026-01-22 05:28:22');
INSERT INTO `device_data_logs` VALUES (275, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516040, 113.1870980, '2026-01-22 05:28:26');
INSERT INTO `device_data_logs` VALUES (276, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 6.49, \"timeinterval\": 10}}', 1348, 6.5, NULL, 0, 23.2516040, 113.1870980, '2026-01-22 05:28:29');
INSERT INTO `device_data_logs` VALUES (277, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 6.21, \"timeinterval\": 10}}', 1348, 6.2, NULL, 0, 23.2516040, 113.1870980, '2026-01-22 05:28:32');
INSERT INTO `device_data_logs` VALUES (278, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 6.61, \"timeinterval\": 10}}', 1348, 6.6, NULL, 0, 23.2516230, 113.1871100, '2026-01-22 05:28:36');
INSERT INTO `device_data_logs` VALUES (279, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 6.71, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516230, 113.1871100, '2026-01-22 05:28:39');
INSERT INTO `device_data_logs` VALUES (280, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516230, 113.1871100, '2026-01-22 05:28:42');
INSERT INTO `device_data_logs` VALUES (281, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516230, 113.1871100, '2026-01-22 05:28:46');
INSERT INTO `device_data_logs` VALUES (282, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516200, 113.1871360, '2026-01-22 05:28:49');
INSERT INTO `device_data_logs` VALUES (283, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516200, 113.1871360, '2026-01-22 05:28:52');
INSERT INTO `device_data_logs` VALUES (284, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516200, 113.1871360, '2026-01-22 05:28:56');
INSERT INTO `device_data_logs` VALUES (285, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516200, 113.1871360, '2026-01-22 05:28:59');
INSERT INTO `device_data_logs` VALUES (286, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516200, 113.1871360, '2026-01-22 05:29:03');
INSERT INTO `device_data_logs` VALUES (287, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 6.33, \"timeinterval\": 10}}', 1348, 6.3, NULL, 0, 23.2516300, 113.1871360, '2026-01-22 05:29:06');
INSERT INTO `device_data_logs` VALUES (288, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 6.61, \"timeinterval\": 10}}', 1348, 6.6, NULL, 0, 23.2516300, 113.1871360, '2026-01-22 05:29:09');
INSERT INTO `device_data_logs` VALUES (289, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516300, 113.1871360, '2026-01-22 05:29:13');
INSERT INTO `device_data_logs` VALUES (290, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516300, 113.1871360, '2026-01-22 05:29:16');
INSERT INTO `device_data_logs` VALUES (291, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516330, 113.1871610, '2026-01-22 05:29:19');
INSERT INTO `device_data_logs` VALUES (292, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2516330, 113.1871610, '2026-01-22 05:29:23');
INSERT INTO `device_data_logs` VALUES (293, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.65, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516330, 113.1871610, '2026-01-22 05:29:26');
INSERT INTO `device_data_logs` VALUES (294, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516330, 113.1871610, '2026-01-22 05:29:29');
INSERT INTO `device_data_logs` VALUES (295, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516330, 113.1871610, '2026-01-22 05:29:33');
INSERT INTO `device_data_logs` VALUES (296, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2515950, 113.1871490, '2026-01-22 05:29:36');
INSERT INTO `device_data_logs` VALUES (297, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2515950, 113.1871490, '2026-01-22 05:29:39');
INSERT INTO `device_data_logs` VALUES (298, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2515950, 113.1871490, '2026-01-22 05:29:43');
INSERT INTO `device_data_logs` VALUES (299, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251595, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2515950, 113.1871490, '2026-01-22 05:29:46');
INSERT INTO `device_data_logs` VALUES (300, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251617, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516170, 113.1871490, '2026-01-22 05:29:49');
INSERT INTO `device_data_logs` VALUES (301, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251617, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516170, 113.1871490, '2026-01-22 05:29:53');
INSERT INTO `device_data_logs` VALUES (302, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251617, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.45, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2516170, 113.1871490, '2026-01-22 05:29:56');
INSERT INTO `device_data_logs` VALUES (303, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251617, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516170, 113.1871490, '2026-01-22 05:29:59');
INSERT INTO `device_data_logs` VALUES (304, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251617, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516170, 113.1871490, '2026-01-22 05:30:03');
INSERT INTO `device_data_logs` VALUES (305, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516040, 113.1871490, '2026-01-22 05:30:06');
INSERT INTO `device_data_logs` VALUES (306, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516040, 113.1871490, '2026-01-22 05:30:09');
INSERT INTO `device_data_logs` VALUES (307, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516040, 113.1871490, '2026-01-22 05:30:13');
INSERT INTO `device_data_logs` VALUES (308, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251604, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516040, 113.1871490, '2026-01-22 05:30:16');
INSERT INTO `device_data_logs` VALUES (309, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516140, 113.1871360, '2026-01-22 05:30:19');
INSERT INTO `device_data_logs` VALUES (310, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.55, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2516140, 113.1871360, '2026-01-22 05:30:23');
INSERT INTO `device_data_logs` VALUES (311, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516140, 113.1871360, '2026-01-22 05:30:27');
INSERT INTO `device_data_logs` VALUES (312, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516140, 113.1871360, '2026-01-22 05:30:29');
INSERT INTO `device_data_logs` VALUES (313, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516140, 113.1871360, '2026-01-22 05:30:33');
INSERT INTO `device_data_logs` VALUES (314, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516140, 113.1871360, '2026-01-22 05:30:36');
INSERT INTO `device_data_logs` VALUES (315, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2516140, 113.1871360, '2026-01-22 05:30:39');
INSERT INTO `device_data_logs` VALUES (316, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516140, 113.1871360, '2026-01-22 05:30:43');
INSERT INTO `device_data_logs` VALUES (317, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516140, 113.1871360, '2026-01-22 05:30:46');
INSERT INTO `device_data_logs` VALUES (318, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516230, 113.1870600, '2026-01-22 05:30:50');
INSERT INTO `device_data_logs` VALUES (319, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516230, 113.1870600, '2026-01-22 05:30:53');
INSERT INTO `device_data_logs` VALUES (320, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516230, 113.1870600, '2026-01-22 05:30:56');
INSERT INTO `device_data_logs` VALUES (321, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 8.29, \"timeinterval\": 10}}', 1348, 8.3, NULL, 0, 23.2516230, 113.1870600, '2026-01-22 05:31:00');
INSERT INTO `device_data_logs` VALUES (322, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 8.45, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2516230, 113.1870600, '2026-01-22 05:31:03');
INSERT INTO `device_data_logs` VALUES (323, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516230, 113.1870600, '2026-01-22 05:31:06');
INSERT INTO `device_data_logs` VALUES (324, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516230, 113.1870600, '2026-01-22 05:31:10');
INSERT INTO `device_data_logs` VALUES (325, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516230, 113.1870600, '2026-01-22 05:31:13');
INSERT INTO `device_data_logs` VALUES (326, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516230, 113.1870600, '2026-01-22 05:31:16');
INSERT INTO `device_data_logs` VALUES (327, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187072, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516390, 113.1870720, '2026-01-22 05:31:20');
INSERT INTO `device_data_logs` VALUES (328, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187072, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516390, 113.1870720, '2026-01-22 05:31:23');
INSERT INTO `device_data_logs` VALUES (329, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187072, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516390, 113.1870720, '2026-01-22 05:31:26');
INSERT INTO `device_data_logs` VALUES (330, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187072, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516390, 113.1870720, '2026-01-22 05:31:30');
INSERT INTO `device_data_logs` VALUES (331, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187072, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516390, 113.1870720, '2026-01-22 05:31:33');
INSERT INTO `device_data_logs` VALUES (332, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187072, \"motionstate\": 0, \"temperature\": 6.99, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516390, 113.1870720, '2026-01-22 05:31:36');
INSERT INTO `device_data_logs` VALUES (333, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187072, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516390, 113.1870720, '2026-01-22 05:31:40');
INSERT INTO `device_data_logs` VALUES (334, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187072, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516390, 113.1870720, '2026-01-22 05:31:43');
INSERT INTO `device_data_logs` VALUES (335, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187072, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516390, 113.1870720, '2026-01-22 05:31:46');
INSERT INTO `device_data_logs` VALUES (336, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516420, 113.1871100, '2026-01-22 05:31:50');
INSERT INTO `device_data_logs` VALUES (337, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516420, 113.1871100, '2026-01-22 05:31:53');
INSERT INTO `device_data_logs` VALUES (338, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516420, 113.1871100, '2026-01-22 05:31:56');
INSERT INTO `device_data_logs` VALUES (339, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516420, 113.1871100, '2026-01-22 05:32:00');
INSERT INTO `device_data_logs` VALUES (340, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516420, 113.1871100, '2026-01-22 05:32:03');
INSERT INTO `device_data_logs` VALUES (341, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516420, 113.1871100, '2026-01-22 05:32:06');
INSERT INTO `device_data_logs` VALUES (342, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 6.65, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516420, 113.1871100, '2026-01-22 05:32:10');
INSERT INTO `device_data_logs` VALUES (343, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516420, 113.1871100, '2026-01-22 05:32:13');
INSERT INTO `device_data_logs` VALUES (344, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251642, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 6.61, \"timeinterval\": 10}}', 1348, 6.6, NULL, 0, 23.2516420, 113.1871100, '2026-01-22 05:32:16');
INSERT INTO `device_data_logs` VALUES (345, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516300, 113.1870980, '2026-01-22 05:32:20');
INSERT INTO `device_data_logs` VALUES (346, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516300, 113.1870980, '2026-01-22 05:32:23');
INSERT INTO `device_data_logs` VALUES (347, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516300, 113.1870980, '2026-01-22 05:32:26');
INSERT INTO `device_data_logs` VALUES (348, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516300, 113.1870980, '2026-01-22 05:32:30');
INSERT INTO `device_data_logs` VALUES (349, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516300, 113.1870980, '2026-01-22 05:32:33');
INSERT INTO `device_data_logs` VALUES (350, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516300, 113.1871100, '2026-01-22 05:32:37');
INSERT INTO `device_data_logs` VALUES (351, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 8.55, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2516300, 113.1871100, '2026-01-22 05:32:40');
INSERT INTO `device_data_logs` VALUES (352, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 6.99, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516300, 113.1871100, '2026-01-22 05:32:43');
INSERT INTO `device_data_logs` VALUES (353, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.18711, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516300, 113.1871100, '2026-01-22 05:32:47');
INSERT INTO `device_data_logs` VALUES (354, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516230, 113.1871360, '2026-01-22 05:32:50');
INSERT INTO `device_data_logs` VALUES (355, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516230, 113.1871360, '2026-01-22 05:32:53');
INSERT INTO `device_data_logs` VALUES (356, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516230, 113.1871360, '2026-01-22 05:32:57');
INSERT INTO `device_data_logs` VALUES (357, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516230, 113.1871360, '2026-01-22 05:33:00');
INSERT INTO `device_data_logs` VALUES (358, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251623, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516230, 113.1871360, '2026-01-22 05:33:03');
INSERT INTO `device_data_logs` VALUES (359, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516140, 113.1871610, '2026-01-22 05:33:07');
INSERT INTO `device_data_logs` VALUES (360, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516140, 113.1871610, '2026-01-22 05:33:10');
INSERT INTO `device_data_logs` VALUES (361, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516140, 113.1871610, '2026-01-22 05:33:13');
INSERT INTO `device_data_logs` VALUES (362, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251614, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516140, 113.1871610, '2026-01-22 05:33:17');
INSERT INTO `device_data_logs` VALUES (363, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516200, 113.1871740, '2026-01-22 05:33:20');
INSERT INTO `device_data_logs` VALUES (364, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516200, 113.1871740, '2026-01-22 05:33:23');
INSERT INTO `device_data_logs` VALUES (365, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516200, 113.1871740, '2026-01-22 05:33:27');
INSERT INTO `device_data_logs` VALUES (366, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516200, 113.1871740, '2026-01-22 05:33:30');
INSERT INTO `device_data_logs` VALUES (367, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25162, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516200, 113.1871740, '2026-01-22 05:33:33');
INSERT INTO `device_data_logs` VALUES (368, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251649, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 8.23, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516490, 113.1871740, '2026-01-22 05:33:37');
INSERT INTO `device_data_logs` VALUES (369, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251649, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516490, 113.1871740, '2026-01-22 05:33:40');
INSERT INTO `device_data_logs` VALUES (370, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251649, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516490, 113.1871740, '2026-01-22 05:33:43');
INSERT INTO `device_data_logs` VALUES (371, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251649, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516490, 113.1871740, '2026-01-22 05:33:47');
INSERT INTO `device_data_logs` VALUES (372, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516300, 113.1871870, '2026-01-22 05:33:50');
INSERT INTO `device_data_logs` VALUES (373, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516300, 113.1871870, '2026-01-22 05:33:53');
INSERT INTO `device_data_logs` VALUES (374, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516300, 113.1871870, '2026-01-22 05:33:57');
INSERT INTO `device_data_logs` VALUES (375, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516300, 113.1871870, '2026-01-22 05:34:00');
INSERT INTO `device_data_logs` VALUES (376, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516300, 113.1871870, '2026-01-22 05:34:03');
INSERT INTO `device_data_logs` VALUES (377, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516330, 113.1872380, '2026-01-22 05:34:07');
INSERT INTO `device_data_logs` VALUES (378, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516330, 113.1872380, '2026-01-22 05:34:10');
INSERT INTO `device_data_logs` VALUES (379, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 6.65, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516330, 113.1872380, '2026-01-22 05:34:13');
INSERT INTO `device_data_logs` VALUES (380, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 6.49, \"timeinterval\": 10}}', 1348, 6.5, NULL, 0, 23.2516330, 113.1872380, '2026-01-22 05:34:17');
INSERT INTO `device_data_logs` VALUES (381, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516360, 113.1871990, '2026-01-22 05:34:20');
INSERT INTO `device_data_logs` VALUES (382, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516360, 113.1871990, '2026-01-22 05:34:24');
INSERT INTO `device_data_logs` VALUES (383, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 6.89, \"timeinterval\": 10}}', 1348, 6.9, NULL, 0, 23.2516360, 113.1871990, '2026-01-22 05:34:27');
INSERT INTO `device_data_logs` VALUES (384, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516360, 113.1871990, '2026-01-22 05:34:30');
INSERT INTO `device_data_logs` VALUES (385, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251636, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516360, 113.1871990, '2026-01-22 05:34:34');
INSERT INTO `device_data_logs` VALUES (386, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251658, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516580, 113.1871870, '2026-01-22 05:34:37');
INSERT INTO `device_data_logs` VALUES (387, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251658, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516580, 113.1871870, '2026-01-22 05:34:40');
INSERT INTO `device_data_logs` VALUES (388, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251658, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516580, 113.1871870, '2026-01-22 05:34:44');
INSERT INTO `device_data_logs` VALUES (389, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251658, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 8.55, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2516580, 113.1871870, '2026-01-22 05:34:47');
INSERT INTO `device_data_logs` VALUES (390, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516710, 113.1871870, '2026-01-22 05:34:50');
INSERT INTO `device_data_logs` VALUES (391, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516710, 113.1871870, '2026-01-22 05:34:54');
INSERT INTO `device_data_logs` VALUES (392, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516710, 113.1871870, '2026-01-22 05:34:57');
INSERT INTO `device_data_logs` VALUES (393, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516710, 113.1871870, '2026-01-22 05:35:00');
INSERT INTO `device_data_logs` VALUES (394, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516710, 113.1871870, '2026-01-22 05:35:04');
INSERT INTO `device_data_logs` VALUES (395, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251674, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516740, 113.1871610, '2026-01-22 05:35:07');
INSERT INTO `device_data_logs` VALUES (396, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251674, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516740, 113.1871610, '2026-01-22 05:35:10');
INSERT INTO `device_data_logs` VALUES (397, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251674, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516740, 113.1871610, '2026-01-22 05:35:14');
INSERT INTO `device_data_logs` VALUES (398, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251674, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516740, 113.1871610, '2026-01-22 05:35:17');
INSERT INTO `device_data_logs` VALUES (399, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251681, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516810, 113.1871490, '2026-01-22 05:35:20');
INSERT INTO `device_data_logs` VALUES (400, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251681, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516810, 113.1871490, '2026-01-22 05:35:24');
INSERT INTO `device_data_logs` VALUES (401, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251681, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516810, 113.1871490, '2026-01-22 05:35:27');
INSERT INTO `device_data_logs` VALUES (402, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251681, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516810, 113.1871490, '2026-01-22 05:35:30');
INSERT INTO `device_data_logs` VALUES (403, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251681, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516810, 113.1871490, '2026-01-22 05:35:34');
INSERT INTO `device_data_logs` VALUES (404, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251684, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516840, 113.1871610, '2026-01-22 05:35:37');
INSERT INTO `device_data_logs` VALUES (405, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251684, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516840, 113.1871610, '2026-01-22 05:35:40');
INSERT INTO `device_data_logs` VALUES (406, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251684, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516840, 113.1871610, '2026-01-22 05:35:44');
INSERT INTO `device_data_logs` VALUES (407, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251684, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516840, 113.1871610, '2026-01-22 05:35:47');
INSERT INTO `device_data_logs` VALUES (408, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516960, 113.1871610, '2026-01-22 05:35:50');
INSERT INTO `device_data_logs` VALUES (409, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516960, 113.1871610, '2026-01-22 05:35:54');
INSERT INTO `device_data_logs` VALUES (410, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516960, 113.1871610, '2026-01-22 05:35:57');
INSERT INTO `device_data_logs` VALUES (411, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516960, 113.1871610, '2026-01-22 05:36:01');
INSERT INTO `device_data_logs` VALUES (412, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.77, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516960, 113.1871610, '2026-01-22 05:36:04');
INSERT INTO `device_data_logs` VALUES (413, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251703, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2517030, 113.1871610, '2026-01-22 05:36:07');
INSERT INTO `device_data_logs` VALUES (414, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251703, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2517030, 113.1871610, '2026-01-22 05:36:11');
INSERT INTO `device_data_logs` VALUES (415, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251703, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.77, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2517030, 113.1871610, '2026-01-22 05:36:14');
INSERT INTO `device_data_logs` VALUES (416, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251703, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2517030, 113.1871610, '2026-01-22 05:36:17');
INSERT INTO `device_data_logs` VALUES (417, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516930, 113.1871610, '2026-01-22 05:36:21');
INSERT INTO `device_data_logs` VALUES (418, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516930, 113.1871610, '2026-01-22 05:36:24');
INSERT INTO `device_data_logs` VALUES (419, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516930, 113.1871610, '2026-01-22 05:36:27');
INSERT INTO `device_data_logs` VALUES (420, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516930, 113.1871610, '2026-01-22 05:36:31');
INSERT INTO `device_data_logs` VALUES (421, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516930, 113.1871870, '2026-01-22 05:36:34');
INSERT INTO `device_data_logs` VALUES (422, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516930, 113.1871870, '2026-01-22 05:36:37');
INSERT INTO `device_data_logs` VALUES (423, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516930, 113.1871870, '2026-01-22 05:36:41');
INSERT INTO `device_data_logs` VALUES (424, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 6.61, \"timeinterval\": 10}}', 1348, 6.6, NULL, 0, 23.2516930, 113.1871870, '2026-01-22 05:36:44');
INSERT INTO `device_data_logs` VALUES (425, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187187, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516930, 113.1871870, '2026-01-22 05:36:47');
INSERT INTO `device_data_logs` VALUES (426, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25169, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516900, 113.1871990, '2026-01-22 05:36:51');
INSERT INTO `device_data_logs` VALUES (427, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25169, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516900, 113.1871990, '2026-01-22 05:36:54');
INSERT INTO `device_data_logs` VALUES (428, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25169, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516900, 113.1871990, '2026-01-22 05:36:57');
INSERT INTO `device_data_logs` VALUES (429, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25169, \"activity\": 1348, \"Longitude\": 113.187199, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516900, 113.1871990, '2026-01-22 05:37:01');
INSERT INTO `device_data_logs` VALUES (430, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187225, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516960, 113.1872250, '2026-01-22 05:37:04');
INSERT INTO `device_data_logs` VALUES (431, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187225, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516960, 113.1872250, '2026-01-22 05:37:07');
INSERT INTO `device_data_logs` VALUES (432, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187225, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516960, 113.1872250, '2026-01-22 05:37:11');
INSERT INTO `device_data_logs` VALUES (433, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187225, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516960, 113.1872250, '2026-01-22 05:37:14');
INSERT INTO `device_data_logs` VALUES (434, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187225, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516960, 113.1872250, '2026-01-22 05:37:17');
INSERT INTO `device_data_logs` VALUES (435, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187225, \"motionstate\": 0, \"temperature\": 6.99, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516870, 113.1872250, '2026-01-22 05:37:21');
INSERT INTO `device_data_logs` VALUES (436, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187225, \"motionstate\": 0, \"temperature\": 6.49, \"timeinterval\": 10}}', 1348, 6.5, NULL, 0, 23.2516870, 113.1872250, '2026-01-22 05:37:24');
INSERT INTO `device_data_logs` VALUES (437, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187225, \"motionstate\": 0, \"temperature\": 6.43, \"timeinterval\": 10}}', 1348, 6.4, NULL, 0, 23.2516870, 113.1872250, '2026-01-22 05:37:27');
INSERT INTO `device_data_logs` VALUES (438, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187225, \"motionstate\": 0, \"temperature\": 6.83, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516870, 113.1872250, '2026-01-22 05:37:31');
INSERT INTO `device_data_logs` VALUES (439, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 6.99, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516930, 113.1872380, '2026-01-22 05:37:34');
INSERT INTO `device_data_logs` VALUES (440, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516930, 113.1872380, '2026-01-22 05:37:38');
INSERT INTO `device_data_logs` VALUES (441, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 6.89, \"timeinterval\": 10}}', 1348, 6.9, NULL, 0, 23.2516930, 113.1872380, '2026-01-22 05:37:41');
INSERT INTO `device_data_logs` VALUES (442, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516930, 113.1872380, '2026-01-22 05:37:44');
INSERT INTO `device_data_logs` VALUES (443, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251693, \"activity\": 1348, \"Longitude\": 113.187238, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516930, 113.1872380, '2026-01-22 05:37:47');
INSERT INTO `device_data_logs` VALUES (444, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 6.99, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516870, 113.1872120, '2026-01-22 05:37:51');
INSERT INTO `device_data_logs` VALUES (445, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 6.65, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516870, 113.1872120, '2026-01-22 05:37:54');
INSERT INTO `device_data_logs` VALUES (446, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516870, 113.1872120, '2026-01-22 05:37:58');
INSERT INTO `device_data_logs` VALUES (447, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187212, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516870, 113.1872120, '2026-01-22 05:38:01');
INSERT INTO `device_data_logs` VALUES (448, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516870, 113.1871740, '2026-01-22 05:38:04');
INSERT INTO `device_data_logs` VALUES (449, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516870, 113.1871740, '2026-01-22 05:38:08');
INSERT INTO `device_data_logs` VALUES (450, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 6.77, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516870, 113.1871740, '2026-01-22 05:38:11');
INSERT INTO `device_data_logs` VALUES (451, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516870, 113.1871740, '2026-01-22 05:38:14');
INSERT INTO `device_data_logs` VALUES (452, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251687, \"activity\": 1348, \"Longitude\": 113.187174, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516870, 113.1871740, '2026-01-22 05:38:18');
INSERT INTO `device_data_logs` VALUES (453, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2516710, 113.1871610, '2026-01-22 05:38:21');
INSERT INTO `device_data_logs` VALUES (454, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516710, 113.1871610, '2026-01-22 05:38:24');
INSERT INTO `device_data_logs` VALUES (455, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516710, 113.1871610, '2026-01-22 05:38:28');
INSERT INTO `device_data_logs` VALUES (456, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251671, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516710, 113.1871610, '2026-01-22 05:38:31');
INSERT INTO `device_data_logs` VALUES (457, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251661, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516610, 113.1870980, '2026-01-22 05:38:34');
INSERT INTO `device_data_logs` VALUES (458, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251661, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 8.17, \"timeinterval\": 10}}', 1348, 8.2, NULL, 0, 23.2516610, 113.1870980, '2026-01-22 05:38:38');
INSERT INTO `device_data_logs` VALUES (459, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251661, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516610, 113.1870980, '2026-01-22 05:38:41');
INSERT INTO `device_data_logs` VALUES (460, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251661, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516610, 113.1870980, '2026-01-22 05:38:44');
INSERT INTO `device_data_logs` VALUES (461, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251661, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 6.99, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516610, 113.1870980, '2026-01-22 05:38:48');
INSERT INTO `device_data_logs` VALUES (462, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251652, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516520, 113.1871230, '2026-01-22 05:38:51');
INSERT INTO `device_data_logs` VALUES (463, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251652, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 8.61, \"timeinterval\": 10}}', 1348, 8.6, NULL, 0, 23.2516520, 113.1871230, '2026-01-22 05:38:54');
INSERT INTO `device_data_logs` VALUES (464, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251652, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.33, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516520, 113.1871230, '2026-01-22 05:38:58');
INSERT INTO `device_data_logs` VALUES (465, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251652, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516520, 113.1871230, '2026-01-22 05:39:01');
INSERT INTO `device_data_logs` VALUES (466, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516330, 113.1871230, '2026-01-22 05:39:04');
INSERT INTO `device_data_logs` VALUES (467, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516330, 113.1871230, '2026-01-22 05:39:08');
INSERT INTO `device_data_logs` VALUES (468, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 8.45, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2516330, 113.1871230, '2026-01-22 05:39:11');
INSERT INTO `device_data_logs` VALUES (469, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.67, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516330, 113.1871230, '2026-01-22 05:39:14');
INSERT INTO `device_data_logs` VALUES (470, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251633, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.05, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2516330, 113.1871230, '2026-01-22 05:39:18');
INSERT INTO `device_data_logs` VALUES (471, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516300, 113.1871230, '2026-01-22 05:39:21');
INSERT INTO `device_data_logs` VALUES (472, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516300, 113.1871230, '2026-01-22 05:39:24');
INSERT INTO `device_data_logs` VALUES (473, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2516300, 113.1871230, '2026-01-22 05:39:28');
INSERT INTO `device_data_logs` VALUES (474, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.25163, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516300, 113.1871230, '2026-01-22 05:39:31');
INSERT INTO `device_data_logs` VALUES (475, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516390, 113.1871360, '2026-01-22 05:39:35');
INSERT INTO `device_data_logs` VALUES (476, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.45, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516390, 113.1871360, '2026-01-22 05:39:38');
INSERT INTO `device_data_logs` VALUES (477, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.49, \"timeinterval\": 10}}', 1348, 8.5, NULL, 0, 23.2516390, 113.1871360, '2026-01-22 05:39:41');
INSERT INTO `device_data_logs` VALUES (478, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516390, 113.1871360, '2026-01-22 05:39:45');
INSERT INTO `device_data_logs` VALUES (479, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.73, \"timeinterval\": 10}}', 1348, 7.7, NULL, 0, 23.2516390, 113.1871360, '2026-01-22 05:39:48');
INSERT INTO `device_data_logs` VALUES (480, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516390, 113.1871360, '2026-01-22 05:39:51');
INSERT INTO `device_data_logs` VALUES (481, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516390, 113.1871360, '2026-01-22 05:39:55');
INSERT INTO `device_data_logs` VALUES (482, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.95, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2516390, 113.1871360, '2026-01-22 05:39:58');
INSERT INTO `device_data_logs` VALUES (483, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251639, \"activity\": 1348, \"Longitude\": 113.187136, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516390, 113.1871360, '2026-01-22 05:40:01');
INSERT INTO `device_data_logs` VALUES (484, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.95, \"timeinterval\": 10}}', 1348, 7.0, NULL, 0, 23.2516550, 113.1871610, '2026-01-22 05:40:05');
INSERT INTO `device_data_logs` VALUES (485, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.77, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516550, 113.1871610, '2026-01-22 05:40:08');
INSERT INTO `device_data_logs` VALUES (486, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.77, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516550, 113.1871610, '2026-01-22 05:40:11');
INSERT INTO `device_data_logs` VALUES (487, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 6.77, \"timeinterval\": 10}}', 1348, 6.8, NULL, 0, 23.2516550, 113.1871610, '2026-01-22 05:40:15');
INSERT INTO `device_data_logs` VALUES (488, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516550, 113.1871610, '2026-01-22 05:40:18');
INSERT INTO `device_data_logs` VALUES (489, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 8.07, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516550, 113.1871610, '2026-01-22 05:40:21');
INSERT INTO `device_data_logs` VALUES (490, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251655, \"activity\": 1348, \"Longitude\": 113.187161, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516550, 113.1871610, '2026-01-22 05:40:31');
INSERT INTO `device_data_logs` VALUES (491, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 6.65, \"timeinterval\": 10}}', 1348, 6.7, NULL, 0, 23.2516960, 113.1870980, '2026-01-22 05:40:35');
INSERT INTO `device_data_logs` VALUES (492, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516960, 113.1870980, '2026-01-22 05:40:38');
INSERT INTO `device_data_logs` VALUES (493, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516960, 113.1870980, '2026-01-22 05:40:41');
INSERT INTO `device_data_logs` VALUES (494, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516960, 113.1870980, '2026-01-22 05:40:45');
INSERT INTO `device_data_logs` VALUES (495, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516960, 113.1870980, '2026-01-22 05:40:48');
INSERT INTO `device_data_logs` VALUES (496, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516960, 113.1870980, '2026-01-22 05:40:51');
INSERT INTO `device_data_logs` VALUES (497, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.23, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516960, 113.1870980, '2026-01-22 05:40:55');
INSERT INTO `device_data_logs` VALUES (498, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516960, 113.1870980, '2026-01-22 05:40:58');
INSERT INTO `device_data_logs` VALUES (499, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2516960, 113.1870980, '2026-01-22 05:41:01');
INSERT INTO `device_data_logs` VALUES (500, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516960, 113.1870600, '2026-01-22 05:41:05');
INSERT INTO `device_data_logs` VALUES (501, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 7.61, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2516960, 113.1870600, '2026-01-22 05:41:08');
INSERT INTO `device_data_logs` VALUES (502, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516960, 113.1870600, '2026-01-22 05:41:11');
INSERT INTO `device_data_logs` VALUES (503, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516960, 113.1870600, '2026-01-22 05:41:15');
INSERT INTO `device_data_logs` VALUES (504, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 8.13, \"timeinterval\": 10}}', 1348, 8.1, NULL, 0, 23.2516960, 113.1870600, '2026-01-22 05:41:18');
INSERT INTO `device_data_logs` VALUES (505, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 8.41, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516960, 113.1870600, '2026-01-22 05:41:22');
INSERT INTO `device_data_logs` VALUES (506, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516960, 113.1870600, '2026-01-22 05:41:25');
INSERT INTO `device_data_logs` VALUES (507, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516960, 113.1870600, '2026-01-22 05:41:28');
INSERT INTO `device_data_logs` VALUES (508, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.18706, \"motionstate\": 0, \"temperature\": 7.17, \"timeinterval\": 10}}', 1348, 7.2, NULL, 0, 23.2516960, 113.1870600, '2026-01-22 05:41:32');
INSERT INTO `device_data_logs` VALUES (509, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251703, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2517030, 113.1870980, '2026-01-22 05:41:35');
INSERT INTO `device_data_logs` VALUES (510, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251703, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2517030, 113.1870980, '2026-01-22 05:41:38');
INSERT INTO `device_data_logs` VALUES (511, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251703, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2517030, 113.1870980, '2026-01-22 05:41:42');
INSERT INTO `device_data_logs` VALUES (512, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251703, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2517030, 113.1870980, '2026-01-22 05:41:45');
INSERT INTO `device_data_logs` VALUES (513, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251703, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.27, \"timeinterval\": 10}}', 1348, 7.3, NULL, 0, 23.2517030, 113.1870980, '2026-01-22 05:41:48');
INSERT INTO `device_data_logs` VALUES (514, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251706, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 8.01, \"timeinterval\": 10}}', 1348, 8.0, NULL, 0, 23.2517060, 113.1870980, '2026-01-22 05:41:52');
INSERT INTO `device_data_logs` VALUES (515, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251706, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.89, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2517060, 113.1870980, '2026-01-22 05:41:55');
INSERT INTO `device_data_logs` VALUES (516, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251706, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.51, \"timeinterval\": 10}}', 1348, 7.5, NULL, 0, 23.2517060, 113.1870980, '2026-01-22 05:41:58');
INSERT INTO `device_data_logs` VALUES (517, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251706, \"activity\": 1348, \"Longitude\": 113.187098, \"motionstate\": 0, \"temperature\": 7.11, \"timeinterval\": 10}}', 1348, 7.1, NULL, 0, 23.2517060, 113.1870980, '2026-01-22 05:42:02');
INSERT INTO `device_data_logs` VALUES (518, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251719, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 8.41, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2517190, 113.1871230, '2026-01-22 05:42:05');
INSERT INTO `device_data_logs` VALUES (519, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251719, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.55, \"timeinterval\": 10}}', 1348, 7.6, NULL, 0, 23.2517190, 113.1871230, '2026-01-22 05:42:08');
INSERT INTO `device_data_logs` VALUES (520, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251719, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.39, \"timeinterval\": 10}}', 1348, 7.4, NULL, 0, 23.2517190, 113.1871230, '2026-01-22 05:42:12');
INSERT INTO `device_data_logs` VALUES (521, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251719, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2517190, 113.1871230, '2026-01-22 05:42:15');
INSERT INTO `device_data_logs` VALUES (522, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251719, \"activity\": 1348, \"Longitude\": 113.187123, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2517190, 113.1871230, '2026-01-22 05:42:18');
INSERT INTO `device_data_logs` VALUES (523, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.79, \"timeinterval\": 10}}', 1348, 7.8, NULL, 0, 23.2516960, 113.1871490, '2026-01-22 05:42:22');
INSERT INTO `device_data_logs` VALUES (524, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.67, \"timeinterval\": 10}}', 1348, 8.7, NULL, 0, 23.2516960, 113.1871490, '2026-01-22 05:42:25');
INSERT INTO `device_data_logs` VALUES (525, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 7.85, \"timeinterval\": 10}}', 1348, 7.9, NULL, 0, 23.2516960, 113.1871490, '2026-01-22 05:42:28');
INSERT INTO `device_data_logs` VALUES (526, 9, '860678079254720', '{\"ID\": 860678079254720, \"params\": {\"Latitude\": 23.251696, \"activity\": 1348, \"Longitude\": 113.187149, \"motionstate\": 0, \"temperature\": 8.35, \"timeinterval\": 10}}', 1348, 8.4, NULL, 0, 23.2516960, 113.1871490, '2026-01-22 05:42:32');

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
) ENGINE = InnoDB AUTO_INCREMENT = 527 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '设备位置记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of device_locations
-- ----------------------------
INSERT INTO `device_locations` VALUES (1, 9, '860678079254720', 23.2489900, 113.1911620, 23.2516740, 113.1872500, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:13:10', '2026-01-22 05:13:10');
INSERT INTO `device_locations` VALUES (2, 9, '860678079254720', 23.2489900, 113.1911620, 23.2516740, 113.1872500, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:13:13', '2026-01-22 05:13:13');
INSERT INTO `device_locations` VALUES (3, 9, '860678079254720', 23.2489900, 113.1911620, 23.2516740, 113.1872500, NULL, NULL, 1348, 8.8, 0, '2026-01-22 05:13:17', '2026-01-22 05:13:16');
INSERT INTO `device_locations` VALUES (4, 9, '860678079254720', 23.2489840, 113.1911620, 23.2516680, 113.1872500, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:13:20', '2026-01-22 05:13:20');
INSERT INTO `device_locations` VALUES (5, 9, '860678079254720', 23.2489840, 113.1911620, 23.2516680, 113.1872500, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:13:23', '2026-01-22 05:13:23');
INSERT INTO `device_locations` VALUES (6, 9, '860678079254720', 23.2489840, 113.1911620, 23.2516680, 113.1872500, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:13:27', '2026-01-22 05:13:26');
INSERT INTO `device_locations` VALUES (7, 9, '860678079254720', 23.2489840, 113.1911620, 23.2516680, 113.1872500, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:13:30', '2026-01-22 05:13:30');
INSERT INTO `device_locations` VALUES (8, 9, '860678079254720', 23.2489840, 113.1911620, 23.2516680, 113.1872500, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:13:33', '2026-01-22 05:13:33');
INSERT INTO `device_locations` VALUES (9, 9, '860678079254720', 23.2490310, 113.1911620, 23.2517150, 113.1872500, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:13:37', '2026-01-22 05:13:36');
INSERT INTO `device_locations` VALUES (10, 9, '860678079254720', 23.2490310, 113.1911620, 23.2517150, 113.1872500, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:13:40', '2026-01-22 05:13:40');
INSERT INTO `device_locations` VALUES (11, 9, '860678079254720', 23.2490310, 113.1911620, 23.2517150, 113.1872500, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:13:43', '2026-01-22 05:13:43');
INSERT INTO `device_locations` VALUES (12, 9, '860678079254720', 23.2490310, 113.1911620, 23.2517150, 113.1872500, NULL, NULL, 1348, 6.9, 0, '2026-01-22 05:13:47', '2026-01-22 05:13:46');
INSERT INTO `device_locations` VALUES (13, 9, '860678079254720', 23.2490090, 113.1911500, 23.2516930, 113.1872380, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:13:50', '2026-01-22 05:13:50');
INSERT INTO `device_locations` VALUES (14, 9, '860678079254720', 23.2490090, 113.1911500, 23.2516930, 113.1872380, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:13:53', '2026-01-22 05:13:53');
INSERT INTO `device_locations` VALUES (15, 9, '860678079254720', 23.2490090, 113.1911500, 23.2516930, 113.1872380, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:13:57', '2026-01-22 05:13:56');
INSERT INTO `device_locations` VALUES (16, 9, '860678079254720', 23.2490090, 113.1911500, 23.2516930, 113.1872380, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:14:00', '2026-01-22 05:14:00');
INSERT INTO `device_locations` VALUES (17, 9, '860678079254720', 23.2490090, 113.1911500, 23.2516930, 113.1872380, NULL, NULL, 1348, 6.4, 0, '2026-01-22 05:14:04', '2026-01-22 05:14:03');
INSERT INTO `device_locations` VALUES (18, 9, '860678079254720', 23.2490000, 113.1910990, 23.2516840, 113.1871870, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:14:07', '2026-01-22 05:14:06');
INSERT INTO `device_locations` VALUES (19, 9, '860678079254720', 23.2490000, 113.1910990, 23.2516840, 113.1871870, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:14:10', '2026-01-22 05:14:10');
INSERT INTO `device_locations` VALUES (20, 9, '860678079254720', 23.2490000, 113.1910990, 23.2516840, 113.1871870, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:14:14', '2026-01-22 05:14:13');
INSERT INTO `device_locations` VALUES (21, 9, '860678079254720', 23.2490000, 113.1910990, 23.2516840, 113.1871870, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:14:17', '2026-01-22 05:14:16');
INSERT INTO `device_locations` VALUES (22, 9, '860678079254720', 23.2489550, 113.1911500, 23.2516390, 113.1872380, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:14:20', '2026-01-22 05:14:20');
INSERT INTO `device_locations` VALUES (23, 9, '860678079254720', 23.2489550, 113.1911500, 23.2516390, 113.1872380, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:14:24', '2026-01-22 05:14:23');
INSERT INTO `device_locations` VALUES (24, 9, '860678079254720', 23.2489550, 113.1911500, 23.2516390, 113.1872380, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:14:27', '2026-01-22 05:14:26');
INSERT INTO `device_locations` VALUES (25, 9, '860678079254720', 23.2489550, 113.1911500, 23.2516390, 113.1872380, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:14:30', '2026-01-22 05:14:30');
INSERT INTO `device_locations` VALUES (26, 9, '860678079254720', 23.2489550, 113.1911500, 23.2516390, 113.1872380, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:14:34', '2026-01-22 05:14:33');
INSERT INTO `device_locations` VALUES (27, 9, '860678079254720', 23.2489870, 113.1912000, 23.2516710, 113.1872880, NULL, NULL, 1348, 6.4, 0, '2026-01-22 05:14:37', '2026-01-22 05:14:36');
INSERT INTO `device_locations` VALUES (28, 9, '860678079254720', 23.2489870, 113.1912000, 23.2516710, 113.1872880, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:14:40', '2026-01-22 05:14:40');
INSERT INTO `device_locations` VALUES (29, 9, '860678079254720', 23.2489870, 113.1912000, 23.2516710, 113.1872880, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:14:44', '2026-01-22 05:14:43');
INSERT INTO `device_locations` VALUES (30, 9, '860678079254720', 23.2489870, 113.1912000, 23.2516710, 113.1872880, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:14:47', '2026-01-22 05:14:47');
INSERT INTO `device_locations` VALUES (31, 9, '860678079254720', 23.2489580, 113.1911240, 23.2516420, 113.1872120, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:14:50', '2026-01-22 05:14:50');
INSERT INTO `device_locations` VALUES (32, 9, '860678079254720', 23.2489580, 113.1911240, 23.2516420, 113.1872120, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:14:54', '2026-01-22 05:14:53');
INSERT INTO `device_locations` VALUES (33, 9, '860678079254720', 23.2489580, 113.1911240, 23.2516420, 113.1872120, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:14:57', '2026-01-22 05:14:57');
INSERT INTO `device_locations` VALUES (34, 9, '860678079254720', 23.2489580, 113.1911240, 23.2516420, 113.1872120, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:15:00', '2026-01-22 05:15:00');
INSERT INTO `device_locations` VALUES (35, 9, '860678079254720', 23.2489580, 113.1911240, 23.2516420, 113.1872120, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:15:04', '2026-01-22 05:15:03');
INSERT INTO `device_locations` VALUES (36, 9, '860678079254720', 23.2489040, 113.1911110, 23.2515880, 113.1871990, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:15:07', '2026-01-22 05:15:07');
INSERT INTO `device_locations` VALUES (37, 9, '860678079254720', 23.2489040, 113.1911110, 23.2515880, 113.1871990, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:15:10', '2026-01-22 05:15:10');
INSERT INTO `device_locations` VALUES (38, 9, '860678079254720', 23.2489040, 113.1911110, 23.2515880, 113.1871990, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:15:14', '2026-01-22 05:15:13');
INSERT INTO `device_locations` VALUES (39, 9, '860678079254720', 23.2489040, 113.1911110, 23.2515880, 113.1871990, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:15:17', '2026-01-22 05:15:17');
INSERT INTO `device_locations` VALUES (40, 9, '860678079254720', 23.2489170, 113.1910860, 23.2516010, 113.1871740, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:15:20', '2026-01-22 05:15:20');
INSERT INTO `device_locations` VALUES (41, 9, '860678079254720', 23.2489170, 113.1910860, 23.2516010, 113.1871740, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:15:24', '2026-01-22 05:15:23');
INSERT INTO `device_locations` VALUES (42, 9, '860678079254720', 23.2489170, 113.1910860, 23.2516010, 113.1871740, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:15:27', '2026-01-22 05:15:27');
INSERT INTO `device_locations` VALUES (43, 9, '860678079254720', 23.2489170, 113.1910860, 23.2516010, 113.1871740, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:15:30', '2026-01-22 05:15:30');
INSERT INTO `device_locations` VALUES (44, 9, '860678079254720', 23.2489170, 113.1910860, 23.2516010, 113.1871740, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:15:34', '2026-01-22 05:15:33');
INSERT INTO `device_locations` VALUES (45, 9, '860678079254720', 23.2489140, 113.1910990, 23.2515980, 113.1871870, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:15:37', '2026-01-22 05:15:37');
INSERT INTO `device_locations` VALUES (46, 9, '860678079254720', 23.2489140, 113.1910990, 23.2515980, 113.1871870, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:15:40', '2026-01-22 05:15:40');
INSERT INTO `device_locations` VALUES (47, 9, '860678079254720', 23.2489140, 113.1910990, 23.2515980, 113.1871870, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:15:44', '2026-01-22 05:15:43');
INSERT INTO `device_locations` VALUES (48, 9, '860678079254720', 23.2489140, 113.1910990, 23.2515980, 113.1871870, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:15:47', '2026-01-22 05:15:47');
INSERT INTO `device_locations` VALUES (49, 9, '860678079254720', 23.2489170, 113.1910860, 23.2516010, 113.1871740, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:15:51', '2026-01-22 05:15:50');
INSERT INTO `device_locations` VALUES (50, 9, '860678079254720', 23.2489170, 113.1910860, 23.2516010, 113.1871740, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:15:54', '2026-01-22 05:15:53');
INSERT INTO `device_locations` VALUES (51, 9, '860678079254720', 23.2489170, 113.1910860, 23.2516010, 113.1871740, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:15:57', '2026-01-22 05:15:57');
INSERT INTO `device_locations` VALUES (52, 9, '860678079254720', 23.2489170, 113.1910860, 23.2516010, 113.1871740, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:16:01', '2026-01-22 05:16:00');
INSERT INTO `device_locations` VALUES (53, 9, '860678079254720', 23.2489170, 113.1910860, 23.2516010, 113.1871740, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:16:04', '2026-01-22 05:16:03');
INSERT INTO `device_locations` VALUES (54, 9, '860678079254720', 23.2489170, 113.1910350, 23.2516010, 113.1871230, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:16:07', '2026-01-22 05:16:07');
INSERT INTO `device_locations` VALUES (55, 9, '860678079254720', 23.2489170, 113.1910350, 23.2516010, 113.1871230, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:16:11', '2026-01-22 05:16:10');
INSERT INTO `device_locations` VALUES (56, 9, '860678079254720', 23.2489170, 113.1910350, 23.2516010, 113.1871230, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:16:14', '2026-01-22 05:16:13');
INSERT INTO `device_locations` VALUES (57, 9, '860678079254720', 23.2489170, 113.1910350, 23.2516010, 113.1871230, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:16:17', '2026-01-22 05:16:17');
INSERT INTO `device_locations` VALUES (58, 9, '860678079254720', 23.2488730, 113.1910480, 23.2515570, 113.1871360, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:16:21', '2026-01-22 05:16:20');
INSERT INTO `device_locations` VALUES (59, 9, '860678079254720', 23.2488730, 113.1910480, 23.2515570, 113.1871360, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:16:24', '2026-01-22 05:16:23');
INSERT INTO `device_locations` VALUES (60, 9, '860678079254720', 23.2488730, 113.1910480, 23.2515570, 113.1871360, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:16:27', '2026-01-22 05:16:27');
INSERT INTO `device_locations` VALUES (61, 9, '860678079254720', 23.2488730, 113.1910480, 23.2515570, 113.1871360, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:16:31', '2026-01-22 05:16:30');
INSERT INTO `device_locations` VALUES (62, 9, '860678079254720', 23.2488730, 113.1910480, 23.2515570, 113.1871360, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:16:34', '2026-01-22 05:16:34');
INSERT INTO `device_locations` VALUES (63, 9, '860678079254720', 23.2489010, 113.1910730, 23.2515850, 113.1871610, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:16:37', '2026-01-22 05:16:37');
INSERT INTO `device_locations` VALUES (64, 9, '860678079254720', 23.2489010, 113.1910730, 23.2515850, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:16:41', '2026-01-22 05:16:40');
INSERT INTO `device_locations` VALUES (65, 9, '860678079254720', 23.2489010, 113.1910730, 23.2515850, 113.1871610, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:16:44', '2026-01-22 05:16:44');
INSERT INTO `device_locations` VALUES (66, 9, '860678079254720', 23.2489010, 113.1910730, 23.2515850, 113.1871610, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:16:47', '2026-01-22 05:16:47');
INSERT INTO `device_locations` VALUES (67, 9, '860678079254720', 23.2489270, 113.1910610, 23.2516110, 113.1871490, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:16:51', '2026-01-22 05:16:50');
INSERT INTO `device_locations` VALUES (68, 9, '860678079254720', 23.2489270, 113.1910610, 23.2516110, 113.1871490, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:16:54', '2026-01-22 05:16:54');
INSERT INTO `device_locations` VALUES (69, 9, '860678079254720', 23.2489270, 113.1910610, 23.2516110, 113.1871490, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:16:57', '2026-01-22 05:16:57');
INSERT INTO `device_locations` VALUES (70, 9, '860678079254720', 23.2489270, 113.1910610, 23.2516110, 113.1871490, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:17:01', '2026-01-22 05:17:00');
INSERT INTO `device_locations` VALUES (71, 9, '860678079254720', 23.2489270, 113.1910610, 23.2516110, 113.1871490, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:17:04', '2026-01-22 05:17:04');
INSERT INTO `device_locations` VALUES (72, 9, '860678079254720', 23.2489680, 113.1910100, 23.2516520, 113.1870980, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:17:07', '2026-01-22 05:17:07');
INSERT INTO `device_locations` VALUES (73, 9, '860678079254720', 23.2489680, 113.1910100, 23.2516520, 113.1870980, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:17:11', '2026-01-22 05:17:10');
INSERT INTO `device_locations` VALUES (74, 9, '860678079254720', 23.2489680, 113.1910100, 23.2516520, 113.1870980, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:17:14', '2026-01-22 05:17:14');
INSERT INTO `device_locations` VALUES (75, 9, '860678079254720', 23.2489680, 113.1910100, 23.2516520, 113.1870980, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:17:17', '2026-01-22 05:17:17');
INSERT INTO `device_locations` VALUES (76, 9, '860678079254720', 23.2489490, 113.1910220, 23.2516330, 113.1871100, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:17:21', '2026-01-22 05:17:20');
INSERT INTO `device_locations` VALUES (77, 9, '860678079254720', 23.2489490, 113.1910220, 23.2516330, 113.1871100, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:17:24', '2026-01-22 05:17:24');
INSERT INTO `device_locations` VALUES (78, 9, '860678079254720', 23.2489490, 113.1910220, 23.2516330, 113.1871100, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:17:27', '2026-01-22 05:17:27');
INSERT INTO `device_locations` VALUES (79, 9, '860678079254720', 23.2489490, 113.1910220, 23.2516330, 113.1871100, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:17:31', '2026-01-22 05:17:30');
INSERT INTO `device_locations` VALUES (80, 9, '860678079254720', 23.2489420, 113.1910730, 23.2516260, 113.1871610, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:17:34', '2026-01-22 05:17:34');
INSERT INTO `device_locations` VALUES (81, 9, '860678079254720', 23.2489420, 113.1910730, 23.2516260, 113.1871610, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:17:38', '2026-01-22 05:17:37');
INSERT INTO `device_locations` VALUES (82, 9, '860678079254720', 23.2489420, 113.1910730, 23.2516260, 113.1871610, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:17:41', '2026-01-22 05:17:40');
INSERT INTO `device_locations` VALUES (83, 9, '860678079254720', 23.2489420, 113.1910730, 23.2516260, 113.1871610, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:17:44', '2026-01-22 05:17:44');
INSERT INTO `device_locations` VALUES (84, 9, '860678079254720', 23.2489420, 113.1910730, 23.2516260, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:17:48', '2026-01-22 05:17:47');
INSERT INTO `device_locations` VALUES (85, 9, '860678079254720', 23.2489390, 113.1910990, 23.2516230, 113.1871870, NULL, NULL, 1348, 8.3, 0, '2026-01-22 05:17:51', '2026-01-22 05:17:50');
INSERT INTO `device_locations` VALUES (86, 9, '860678079254720', 23.2489390, 113.1910990, 23.2516230, 113.1871870, NULL, NULL, 1348, 9.0, 0, '2026-01-22 05:17:54', '2026-01-22 05:17:54');
INSERT INTO `device_locations` VALUES (87, 9, '860678079254720', 23.2489390, 113.1910990, 23.2516230, 113.1871870, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:17:58', '2026-01-22 05:17:57');
INSERT INTO `device_locations` VALUES (88, 9, '860678079254720', 23.2489390, 113.1910990, 23.2516230, 113.1871870, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:18:01', '2026-01-22 05:18:00');
INSERT INTO `device_locations` VALUES (89, 9, '860678079254720', 23.2489170, 113.1911110, 23.2516010, 113.1871990, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:18:04', '2026-01-22 05:18:04');
INSERT INTO `device_locations` VALUES (90, 9, '860678079254720', 23.2489170, 113.1911110, 23.2516010, 113.1871990, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:18:08', '2026-01-22 05:18:07');
INSERT INTO `device_locations` VALUES (91, 9, '860678079254720', 23.2489170, 113.1911110, 23.2516010, 113.1871990, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:18:11', '2026-01-22 05:18:10');
INSERT INTO `device_locations` VALUES (92, 9, '860678079254720', 23.2489170, 113.1911110, 23.2516010, 113.1871990, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:18:14', '2026-01-22 05:18:14');
INSERT INTO `device_locations` VALUES (93, 9, '860678079254720', 23.2489170, 113.1911110, 23.2516010, 113.1871990, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:18:18', '2026-01-22 05:18:17');
INSERT INTO `device_locations` VALUES (94, 9, '860678079254720', 23.2489330, 113.1911240, 23.2516170, 113.1872120, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:18:21', '2026-01-22 05:18:21');
INSERT INTO `device_locations` VALUES (95, 9, '860678079254720', 23.2489330, 113.1911240, 23.2516170, 113.1872120, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:18:24', '2026-01-22 05:18:24');
INSERT INTO `device_locations` VALUES (96, 9, '860678079254720', 23.2489330, 113.1911240, 23.2516170, 113.1872120, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:18:28', '2026-01-22 05:18:27');
INSERT INTO `device_locations` VALUES (97, 9, '860678079254720', 23.2489330, 113.1911240, 23.2516170, 113.1872120, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:18:31', '2026-01-22 05:18:31');
INSERT INTO `device_locations` VALUES (98, 9, '860678079254720', 23.2489550, 113.1911110, 23.2516390, 113.1871990, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:18:34', '2026-01-22 05:18:34');
INSERT INTO `device_locations` VALUES (99, 9, '860678079254720', 23.2489550, 113.1911110, 23.2516390, 113.1871990, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:18:38', '2026-01-22 05:18:37');
INSERT INTO `device_locations` VALUES (100, 9, '860678079254720', 23.2489550, 113.1911110, 23.2516390, 113.1871990, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:18:41', '2026-01-22 05:18:41');
INSERT INTO `device_locations` VALUES (101, 9, '860678079254720', 23.2489550, 113.1911110, 23.2516390, 113.1871990, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:18:44', '2026-01-22 05:18:44');
INSERT INTO `device_locations` VALUES (102, 9, '860678079254720', 23.2489550, 113.1911110, 23.2516390, 113.1871990, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:18:48', '2026-01-22 05:18:47');
INSERT INTO `device_locations` VALUES (103, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:18:51', '2026-01-22 05:18:51');
INSERT INTO `device_locations` VALUES (104, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:18:54', '2026-01-22 05:18:54');
INSERT INTO `device_locations` VALUES (105, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:18:58', '2026-01-22 05:18:57');
INSERT INTO `device_locations` VALUES (106, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:19:01', '2026-01-22 05:19:01');
INSERT INTO `device_locations` VALUES (107, 9, '860678079254720', 23.2489460, 113.1910610, 23.2516300, 113.1871490, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:19:04', '2026-01-22 05:19:04');
INSERT INTO `device_locations` VALUES (108, 9, '860678079254720', 23.2489460, 113.1910610, 23.2516300, 113.1871490, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:19:08', '2026-01-22 05:19:07');
INSERT INTO `device_locations` VALUES (109, 9, '860678079254720', 23.2489460, 113.1910610, 23.2516300, 113.1871490, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:19:11', '2026-01-22 05:19:11');
INSERT INTO `device_locations` VALUES (110, 9, '860678079254720', 23.2489460, 113.1910610, 23.2516300, 113.1871490, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:19:14', '2026-01-22 05:19:14');
INSERT INTO `device_locations` VALUES (111, 9, '860678079254720', 23.2489460, 113.1910610, 23.2516300, 113.1871490, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:19:18', '2026-01-22 05:19:17');
INSERT INTO `device_locations` VALUES (112, 9, '860678079254720', 23.2489270, 113.1911240, 23.2516110, 113.1872120, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:19:21', '2026-01-22 05:19:21');
INSERT INTO `device_locations` VALUES (113, 9, '860678079254720', 23.2489270, 113.1911240, 23.2516110, 113.1872120, NULL, NULL, 1348, 6.4, 0, '2026-01-22 05:19:25', '2026-01-22 05:19:24');
INSERT INTO `device_locations` VALUES (114, 9, '860678079254720', 23.2489270, 113.1911240, 23.2516110, 113.1872120, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:19:28', '2026-01-22 05:19:27');
INSERT INTO `device_locations` VALUES (115, 9, '860678079254720', 23.2489270, 113.1911240, 23.2516110, 113.1872120, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:19:31', '2026-01-22 05:19:31');
INSERT INTO `device_locations` VALUES (116, 9, '860678079254720', 23.2489270, 113.1911240, 23.2516110, 113.1872120, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:19:35', '2026-01-22 05:19:34');
INSERT INTO `device_locations` VALUES (117, 9, '860678079254720', 23.2489270, 113.1911240, 23.2516110, 113.1872120, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:19:38', '2026-01-22 05:19:37');
INSERT INTO `device_locations` VALUES (118, 9, '860678079254720', 23.2489270, 113.1911240, 23.2516110, 113.1872120, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:19:41', '2026-01-22 05:19:41');
INSERT INTO `device_locations` VALUES (119, 9, '860678079254720', 23.2489270, 113.1911240, 23.2516110, 113.1872120, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:19:45', '2026-01-22 05:19:44');
INSERT INTO `device_locations` VALUES (120, 9, '860678079254720', 23.2489270, 113.1911240, 23.2516110, 113.1872120, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:19:48', '2026-01-22 05:19:47');
INSERT INTO `device_locations` VALUES (121, 9, '860678079254720', 23.2489140, 113.1911110, 23.2515980, 113.1871990, NULL, NULL, 1348, 6.6, 0, '2026-01-22 05:19:51', '2026-01-22 05:19:51');
INSERT INTO `device_locations` VALUES (122, 9, '860678079254720', 23.2489140, 113.1911110, 23.2515980, 113.1871990, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:19:55', '2026-01-22 05:19:54');
INSERT INTO `device_locations` VALUES (123, 9, '860678079254720', 23.2489140, 113.1911110, 23.2515980, 113.1871990, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:19:58', '2026-01-22 05:19:57');
INSERT INTO `device_locations` VALUES (124, 9, '860678079254720', 23.2489140, 113.1911110, 23.2515980, 113.1871990, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:20:01', '2026-01-22 05:20:01');
INSERT INTO `device_locations` VALUES (125, 9, '860678079254720', 23.2489230, 113.1910990, 23.2516070, 113.1871870, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:20:05', '2026-01-22 05:20:04');
INSERT INTO `device_locations` VALUES (126, 9, '860678079254720', 23.2489230, 113.1910990, 23.2516070, 113.1871870, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:20:08', '2026-01-22 05:20:07');
INSERT INTO `device_locations` VALUES (127, 9, '860678079254720', 23.2489230, 113.1910990, 23.2516070, 113.1871870, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:20:11', '2026-01-22 05:20:11');
INSERT INTO `device_locations` VALUES (128, 9, '860678079254720', 23.2489230, 113.1910990, 23.2516070, 113.1871870, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:20:15', '2026-01-22 05:20:14');
INSERT INTO `device_locations` VALUES (129, 9, '860678079254720', 23.2489230, 113.1910990, 23.2516070, 113.1871870, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:20:18', '2026-01-22 05:20:18');
INSERT INTO `device_locations` VALUES (130, 9, '860678079254720', 23.2489200, 113.1910730, 23.2516040, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:20:21', '2026-01-22 05:20:21');
INSERT INTO `device_locations` VALUES (131, 9, '860678079254720', 23.2489200, 113.1910730, 23.2516040, 113.1871610, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:20:25', '2026-01-22 05:20:24');
INSERT INTO `device_locations` VALUES (132, 9, '860678079254720', 23.2489200, 113.1910730, 23.2516040, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:20:28', '2026-01-22 05:20:28');
INSERT INTO `device_locations` VALUES (133, 9, '860678079254720', 23.2489200, 113.1910730, 23.2516040, 113.1871610, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:20:31', '2026-01-22 05:20:31');
INSERT INTO `device_locations` VALUES (134, 9, '860678079254720', 23.2489110, 113.1910730, 23.2515950, 113.1871610, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:20:35', '2026-01-22 05:20:34');
INSERT INTO `device_locations` VALUES (135, 9, '860678079254720', 23.2489110, 113.1910730, 23.2515950, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:20:38', '2026-01-22 05:20:38');
INSERT INTO `device_locations` VALUES (136, 9, '860678079254720', 23.2489110, 113.1910730, 23.2515950, 113.1871610, NULL, NULL, 1348, 8.3, 0, '2026-01-22 05:20:41', '2026-01-22 05:20:41');
INSERT INTO `device_locations` VALUES (137, 9, '860678079254720', 23.2489110, 113.1910730, 23.2515950, 113.1871610, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:20:45', '2026-01-22 05:20:44');
INSERT INTO `device_locations` VALUES (138, 9, '860678079254720', 23.2489110, 113.1910730, 23.2515950, 113.1871610, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:20:49', '2026-01-22 05:20:48');
INSERT INTO `device_locations` VALUES (139, 9, '860678079254720', 23.2489110, 113.1910730, 23.2515950, 113.1871610, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:20:51', '2026-01-22 05:20:51');
INSERT INTO `device_locations` VALUES (140, 9, '860678079254720', 23.2489110, 113.1910730, 23.2515950, 113.1871610, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:20:55', '2026-01-22 05:20:54');
INSERT INTO `device_locations` VALUES (141, 9, '860678079254720', 23.2489110, 113.1910730, 23.2515950, 113.1871610, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:20:58', '2026-01-22 05:20:58');
INSERT INTO `device_locations` VALUES (142, 9, '860678079254720', 23.2489110, 113.1910730, 23.2515950, 113.1871610, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:21:01', '2026-01-22 05:21:01');
INSERT INTO `device_locations` VALUES (143, 9, '860678079254720', 23.2489360, 113.1910730, 23.2516200, 113.1871610, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:21:05', '2026-01-22 05:21:04');
INSERT INTO `device_locations` VALUES (144, 9, '860678079254720', 23.2489360, 113.1910730, 23.2516200, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:21:08', '2026-01-22 05:21:08');
INSERT INTO `device_locations` VALUES (145, 9, '860678079254720', 23.2489360, 113.1910730, 23.2516200, 113.1871610, NULL, NULL, 1348, 6.2, 0, '2026-01-22 05:21:12', '2026-01-22 05:21:11');
INSERT INTO `device_locations` VALUES (146, 9, '860678079254720', 23.2489360, 113.1910730, 23.2516200, 113.1871610, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:21:15', '2026-01-22 05:21:14');
INSERT INTO `device_locations` VALUES (147, 9, '860678079254720', 23.2489360, 113.1910730, 23.2516200, 113.1871610, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:21:18', '2026-01-22 05:21:18');
INSERT INTO `device_locations` VALUES (148, 9, '860678079254720', 23.2489360, 113.1910730, 23.2516200, 113.1871610, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:21:22', '2026-01-22 05:21:21');
INSERT INTO `device_locations` VALUES (149, 9, '860678079254720', 23.2489360, 113.1910730, 23.2516200, 113.1871610, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:21:25', '2026-01-22 05:21:24');
INSERT INTO `device_locations` VALUES (150, 9, '860678079254720', 23.2489360, 113.1910730, 23.2516200, 113.1871610, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:21:28', '2026-01-22 05:21:28');
INSERT INTO `device_locations` VALUES (151, 9, '860678079254720', 23.2489360, 113.1910730, 23.2516200, 113.1871610, NULL, NULL, 1348, 8.3, 0, '2026-01-22 05:21:32', '2026-01-22 05:21:31');
INSERT INTO `device_locations` VALUES (152, 9, '860678079254720', 23.2489710, 113.1911110, 23.2516550, 113.1871990, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:21:35', '2026-01-22 05:21:34');
INSERT INTO `device_locations` VALUES (153, 9, '860678079254720', 23.2489710, 113.1911110, 23.2516550, 113.1871990, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:21:38', '2026-01-22 05:21:38');
INSERT INTO `device_locations` VALUES (154, 9, '860678079254720', 23.2489710, 113.1911110, 23.2516550, 113.1871990, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:21:42', '2026-01-22 05:21:41');
INSERT INTO `device_locations` VALUES (155, 9, '860678079254720', 23.2489710, 113.1911110, 23.2516550, 113.1871990, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:21:45', '2026-01-22 05:21:44');
INSERT INTO `device_locations` VALUES (156, 9, '860678079254720', 23.2489710, 113.1911110, 23.2516550, 113.1871990, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:21:48', '2026-01-22 05:21:48');
INSERT INTO `device_locations` VALUES (157, 9, '860678079254720', 23.2489710, 113.1911110, 23.2516550, 113.1871990, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:21:52', '2026-01-22 05:21:51');
INSERT INTO `device_locations` VALUES (158, 9, '860678079254720', 23.2489710, 113.1911110, 23.2516550, 113.1871990, NULL, NULL, 1348, 8.8, 0, '2026-01-22 05:21:55', '2026-01-22 05:21:55');
INSERT INTO `device_locations` VALUES (159, 9, '860678079254720', 23.2489710, 113.1911110, 23.2516550, 113.1871990, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:21:58', '2026-01-22 05:21:58');
INSERT INTO `device_locations` VALUES (160, 9, '860678079254720', 23.2489710, 113.1911110, 23.2516550, 113.1871990, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:22:02', '2026-01-22 05:22:01');
INSERT INTO `device_locations` VALUES (161, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:22:05', '2026-01-22 05:22:05');
INSERT INTO `device_locations` VALUES (162, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:22:08', '2026-01-22 05:22:08');
INSERT INTO `device_locations` VALUES (163, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:22:12', '2026-01-22 05:22:11');
INSERT INTO `device_locations` VALUES (164, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:22:15', '2026-01-22 05:22:15');
INSERT INTO `device_locations` VALUES (165, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:22:18', '2026-01-22 05:22:18');
INSERT INTO `device_locations` VALUES (166, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:22:22', '2026-01-22 05:22:21');
INSERT INTO `device_locations` VALUES (167, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 6.9, 0, '2026-01-22 05:22:25', '2026-01-22 05:22:25');
INSERT INTO `device_locations` VALUES (168, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:22:28', '2026-01-22 05:22:28');
INSERT INTO `device_locations` VALUES (169, 9, '860678079254720', 23.2489520, 113.1910990, 23.2516360, 113.1871870, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:22:32', '2026-01-22 05:22:31');
INSERT INTO `device_locations` VALUES (170, 9, '860678079254720', 23.2488920, 113.1910730, 23.2515760, 113.1871610, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:22:35', '2026-01-22 05:22:35');
INSERT INTO `device_locations` VALUES (171, 9, '860678079254720', 23.2488920, 113.1910730, 23.2515760, 113.1871610, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:22:38', '2026-01-22 05:22:38');
INSERT INTO `device_locations` VALUES (172, 9, '860678079254720', 23.2488920, 113.1910730, 23.2515760, 113.1871610, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:22:42', '2026-01-22 05:22:41');
INSERT INTO `device_locations` VALUES (173, 9, '860678079254720', 23.2488920, 113.1910730, 23.2515760, 113.1871610, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:22:45', '2026-01-22 05:22:45');
INSERT INTO `device_locations` VALUES (174, 9, '860678079254720', 23.2488920, 113.1910730, 23.2515760, 113.1871610, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:22:49', '2026-01-22 05:22:48');
INSERT INTO `device_locations` VALUES (175, 9, '860678079254720', 23.2488850, 113.1910480, 23.2515690, 113.1871360, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:22:52', '2026-01-22 05:22:51');
INSERT INTO `device_locations` VALUES (176, 9, '860678079254720', 23.2488850, 113.1910480, 23.2515690, 113.1871360, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:22:55', '2026-01-22 05:22:55');
INSERT INTO `device_locations` VALUES (177, 9, '860678079254720', 23.2488850, 113.1910480, 23.2515690, 113.1871360, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:22:59', '2026-01-22 05:22:58');
INSERT INTO `device_locations` VALUES (178, 9, '860678079254720', 23.2488850, 113.1910480, 23.2515690, 113.1871360, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:23:02', '2026-01-22 05:23:01');
INSERT INTO `device_locations` VALUES (179, 9, '860678079254720', 23.2488950, 113.1910480, 23.2515790, 113.1871360, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:23:05', '2026-01-22 05:23:05');
INSERT INTO `device_locations` VALUES (180, 9, '860678079254720', 23.2488950, 113.1910480, 23.2515790, 113.1871360, NULL, NULL, 1348, 9.0, 0, '2026-01-22 05:23:09', '2026-01-22 05:23:08');
INSERT INTO `device_locations` VALUES (181, 9, '860678079254720', 23.2488950, 113.1910480, 23.2515790, 113.1871360, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:23:12', '2026-01-22 05:23:11');
INSERT INTO `device_locations` VALUES (182, 9, '860678079254720', 23.2488950, 113.1910480, 23.2515790, 113.1871360, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:23:15', '2026-01-22 05:23:15');
INSERT INTO `device_locations` VALUES (183, 9, '860678079254720', 23.2488950, 113.1910480, 23.2515790, 113.1871360, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:23:19', '2026-01-22 05:23:18');
INSERT INTO `device_locations` VALUES (184, 9, '860678079254720', 23.2488980, 113.1910220, 23.2515820, 113.1871100, NULL, NULL, 1348, 8.9, 0, '2026-01-22 05:23:22', '2026-01-22 05:23:21');
INSERT INTO `device_locations` VALUES (185, 9, '860678079254720', 23.2488980, 113.1910220, 23.2515820, 113.1871100, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:23:25', '2026-01-22 05:23:25');
INSERT INTO `device_locations` VALUES (186, 9, '860678079254720', 23.2488980, 113.1910220, 23.2515820, 113.1871100, NULL, NULL, 1348, 9.1, 0, '2026-01-22 05:23:29', '2026-01-22 05:23:28');
INSERT INTO `device_locations` VALUES (187, 9, '860678079254720', 23.2488980, 113.1910220, 23.2515820, 113.1871100, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:23:32', '2026-01-22 05:23:31');
INSERT INTO `device_locations` VALUES (188, 9, '860678079254720', 23.2488820, 113.1910610, 23.2515660, 113.1871490, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:23:35', '2026-01-22 05:23:35');
INSERT INTO `device_locations` VALUES (189, 9, '860678079254720', 23.2488820, 113.1910610, 23.2515660, 113.1871490, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:23:39', '2026-01-22 05:23:38');
INSERT INTO `device_locations` VALUES (190, 9, '860678079254720', 23.2488820, 113.1910610, 23.2515660, 113.1871490, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:23:42', '2026-01-22 05:23:42');
INSERT INTO `device_locations` VALUES (191, 9, '860678079254720', 23.2488820, 113.1910610, 23.2515660, 113.1871490, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:23:45', '2026-01-22 05:23:45');
INSERT INTO `device_locations` VALUES (192, 9, '860678079254720', 23.2488820, 113.1910610, 23.2515660, 113.1871490, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:23:49', '2026-01-22 05:23:48');
INSERT INTO `device_locations` VALUES (193, 9, '860678079254720', 23.2488690, 113.1910610, 23.2515530, 113.1871490, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:23:52', '2026-01-22 05:23:52');
INSERT INTO `device_locations` VALUES (194, 9, '860678079254720', 23.2488690, 113.1910610, 23.2515530, 113.1871490, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:23:55', '2026-01-22 05:23:55');
INSERT INTO `device_locations` VALUES (195, 9, '860678079254720', 23.2488690, 113.1910610, 23.2515530, 113.1871490, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:23:59', '2026-01-22 05:23:58');
INSERT INTO `device_locations` VALUES (196, 9, '860678079254720', 23.2488690, 113.1910610, 23.2515530, 113.1871490, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:24:02', '2026-01-22 05:24:02');
INSERT INTO `device_locations` VALUES (197, 9, '860678079254720', 23.2488820, 113.1910480, 23.2515660, 113.1871360, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:24:05', '2026-01-22 05:24:05');
INSERT INTO `device_locations` VALUES (198, 9, '860678079254720', 23.2488820, 113.1910480, 23.2515660, 113.1871360, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:24:09', '2026-01-22 05:24:08');
INSERT INTO `device_locations` VALUES (199, 9, '860678079254720', 23.2488820, 113.1910480, 23.2515660, 113.1871360, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:24:12', '2026-01-22 05:24:12');
INSERT INTO `device_locations` VALUES (200, 9, '860678079254720', 23.2488820, 113.1910480, 23.2515660, 113.1871360, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:24:15', '2026-01-22 05:24:15');
INSERT INTO `device_locations` VALUES (201, 9, '860678079254720', 23.2488820, 113.1910480, 23.2515660, 113.1871360, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:24:19', '2026-01-22 05:24:18');
INSERT INTO `device_locations` VALUES (202, 9, '860678079254720', 23.2488950, 113.1910730, 23.2515790, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:24:22', '2026-01-22 05:24:22');
INSERT INTO `device_locations` VALUES (203, 9, '860678079254720', 23.2488950, 113.1910730, 23.2515790, 113.1871610, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:24:25', '2026-01-22 05:24:25');
INSERT INTO `device_locations` VALUES (204, 9, '860678079254720', 23.2488950, 113.1910730, 23.2515790, 113.1871610, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:24:29', '2026-01-22 05:24:28');
INSERT INTO `device_locations` VALUES (205, 9, '860678079254720', 23.2488950, 113.1910730, 23.2515790, 113.1871610, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:24:32', '2026-01-22 05:24:32');
INSERT INTO `device_locations` VALUES (206, 9, '860678079254720', 23.2488690, 113.1910610, 23.2515530, 113.1871490, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:24:36', '2026-01-22 05:24:35');
INSERT INTO `device_locations` VALUES (207, 9, '860678079254720', 23.2488690, 113.1910610, 23.2515530, 113.1871490, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:24:39', '2026-01-22 05:24:38');
INSERT INTO `device_locations` VALUES (208, 9, '860678079254720', 23.2488690, 113.1910610, 23.2515530, 113.1871490, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:24:42', '2026-01-22 05:24:42');
INSERT INTO `device_locations` VALUES (209, 9, '860678079254720', 23.2488690, 113.1910610, 23.2515530, 113.1871490, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:24:46', '2026-01-22 05:24:45');
INSERT INTO `device_locations` VALUES (210, 9, '860678079254720', 23.2488690, 113.1910610, 23.2515530, 113.1871490, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:24:49', '2026-01-22 05:24:48');
INSERT INTO `device_locations` VALUES (211, 9, '860678079254720', 23.2488880, 113.1911110, 23.2515720, 113.1871990, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:24:52', '2026-01-22 05:24:52');
INSERT INTO `device_locations` VALUES (212, 9, '860678079254720', 23.2488880, 113.1911110, 23.2515720, 113.1871990, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:24:56', '2026-01-22 05:24:55');
INSERT INTO `device_locations` VALUES (213, 9, '860678079254720', 23.2488880, 113.1911110, 23.2515720, 113.1871990, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:24:59', '2026-01-22 05:24:58');
INSERT INTO `device_locations` VALUES (214, 9, '860678079254720', 23.2488880, 113.1911110, 23.2515720, 113.1871990, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:25:02', '2026-01-22 05:25:02');
INSERT INTO `device_locations` VALUES (215, 9, '860678079254720', 23.2489010, 113.1911240, 23.2515850, 113.1872120, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:25:06', '2026-01-22 05:25:05');
INSERT INTO `device_locations` VALUES (216, 9, '860678079254720', 23.2489010, 113.1911240, 23.2515850, 113.1872120, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:25:09', '2026-01-22 05:25:08');
INSERT INTO `device_locations` VALUES (217, 9, '860678079254720', 23.2489010, 113.1911240, 23.2515850, 113.1872120, NULL, NULL, 1348, 9.1, 0, '2026-01-22 05:25:12', '2026-01-22 05:25:12');
INSERT INTO `device_locations` VALUES (218, 9, '860678079254720', 23.2489010, 113.1911240, 23.2515850, 113.1872120, NULL, NULL, 1348, 9.0, 0, '2026-01-22 05:25:16', '2026-01-22 05:25:15');
INSERT INTO `device_locations` VALUES (219, 9, '860678079254720', 23.2489010, 113.1911240, 23.2515850, 113.1872120, NULL, NULL, 1348, 8.8, 0, '2026-01-22 05:25:19', '2026-01-22 05:25:19');
INSERT INTO `device_locations` VALUES (220, 9, '860678079254720', 23.2489010, 113.1910990, 23.2515850, 113.1871870, NULL, NULL, 1348, 9.0, 0, '2026-01-22 05:25:22', '2026-01-22 05:25:22');
INSERT INTO `device_locations` VALUES (221, 9, '860678079254720', 23.2489010, 113.1910990, 23.2515850, 113.1871870, NULL, NULL, 1348, 8.9, 0, '2026-01-22 05:25:26', '2026-01-22 05:25:25');
INSERT INTO `device_locations` VALUES (222, 9, '860678079254720', 23.2489010, 113.1910990, 23.2515850, 113.1871870, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:25:29', '2026-01-22 05:25:29');
INSERT INTO `device_locations` VALUES (223, 9, '860678079254720', 23.2489010, 113.1910990, 23.2515850, 113.1871870, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:25:32', '2026-01-22 05:25:32');
INSERT INTO `device_locations` VALUES (224, 9, '860678079254720', 23.2488850, 113.1911110, 23.2515690, 113.1871990, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:25:36', '2026-01-22 05:25:35');
INSERT INTO `device_locations` VALUES (225, 9, '860678079254720', 23.2488850, 113.1911110, 23.2515690, 113.1871990, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:25:39', '2026-01-22 05:25:39');
INSERT INTO `device_locations` VALUES (226, 9, '860678079254720', 23.2488850, 113.1911110, 23.2515690, 113.1871990, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:25:42', '2026-01-22 05:25:42');
INSERT INTO `device_locations` VALUES (227, 9, '860678079254720', 23.2488850, 113.1911110, 23.2515690, 113.1871990, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:25:46', '2026-01-22 05:25:45');
INSERT INTO `device_locations` VALUES (228, 9, '860678079254720', 23.2488850, 113.1911110, 23.2515690, 113.1871990, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:25:49', '2026-01-22 05:25:49');
INSERT INTO `device_locations` VALUES (229, 9, '860678079254720', 23.2489140, 113.1911110, 23.2515980, 113.1871990, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:25:52', '2026-01-22 05:25:52');
INSERT INTO `device_locations` VALUES (230, 9, '860678079254720', 23.2489140, 113.1911110, 23.2515980, 113.1871990, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:25:56', '2026-01-22 05:25:55');
INSERT INTO `device_locations` VALUES (231, 9, '860678079254720', 23.2489140, 113.1911110, 23.2515980, 113.1871990, NULL, NULL, 1348, 8.8, 0, '2026-01-22 05:25:59', '2026-01-22 05:25:59');
INSERT INTO `device_locations` VALUES (232, 9, '860678079254720', 23.2489140, 113.1911110, 23.2515980, 113.1871990, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:26:02', '2026-01-22 05:26:02');
INSERT INTO `device_locations` VALUES (233, 9, '860678079254720', 23.2489200, 113.1910990, 23.2516040, 113.1871870, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:26:06', '2026-01-22 05:26:05');
INSERT INTO `device_locations` VALUES (234, 9, '860678079254720', 23.2489200, 113.1910990, 23.2516040, 113.1871870, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:26:09', '2026-01-22 05:26:09');
INSERT INTO `device_locations` VALUES (235, 9, '860678079254720', 23.2489200, 113.1910990, 23.2516040, 113.1871870, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:26:13', '2026-01-22 05:26:12');
INSERT INTO `device_locations` VALUES (236, 9, '860678079254720', 23.2489200, 113.1910990, 23.2516040, 113.1871870, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:26:16', '2026-01-22 05:26:15');
INSERT INTO `device_locations` VALUES (237, 9, '860678079254720', 23.2489200, 113.1910990, 23.2516040, 113.1871870, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:26:19', '2026-01-22 05:26:19');
INSERT INTO `device_locations` VALUES (238, 9, '860678079254720', 23.2489170, 113.1910990, 23.2516010, 113.1871870, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:26:23', '2026-01-22 05:26:22');
INSERT INTO `device_locations` VALUES (239, 9, '860678079254720', 23.2489170, 113.1910990, 23.2516010, 113.1871870, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:26:26', '2026-01-22 05:26:25');
INSERT INTO `device_locations` VALUES (240, 9, '860678079254720', 23.2489170, 113.1910990, 23.2516010, 113.1871870, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:26:29', '2026-01-22 05:26:29');
INSERT INTO `device_locations` VALUES (241, 9, '860678079254720', 23.2489170, 113.1910990, 23.2516010, 113.1871870, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:26:33', '2026-01-22 05:26:32');
INSERT INTO `device_locations` VALUES (242, 9, '860678079254720', 23.2489010, 113.1910730, 23.2515850, 113.1871610, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:26:36', '2026-01-22 05:26:35');
INSERT INTO `device_locations` VALUES (243, 9, '860678079254720', 23.2489010, 113.1910730, 23.2515850, 113.1871610, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:26:39', '2026-01-22 05:26:39');
INSERT INTO `device_locations` VALUES (244, 9, '860678079254720', 23.2489010, 113.1910730, 23.2515850, 113.1871610, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:26:43', '2026-01-22 05:26:42');
INSERT INTO `device_locations` VALUES (245, 9, '860678079254720', 23.2489010, 113.1910730, 23.2515850, 113.1871610, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:26:46', '2026-01-22 05:26:45');
INSERT INTO `device_locations` VALUES (246, 9, '860678079254720', 23.2488980, 113.1910610, 23.2515820, 113.1871490, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:26:49', '2026-01-22 05:26:49');
INSERT INTO `device_locations` VALUES (247, 9, '860678079254720', 23.2488980, 113.1910610, 23.2515820, 113.1871490, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:26:53', '2026-01-22 05:26:52');
INSERT INTO `device_locations` VALUES (248, 9, '860678079254720', 23.2488980, 113.1910610, 23.2515820, 113.1871490, NULL, NULL, 1348, 6.0, 0, '2026-01-22 05:26:56', '2026-01-22 05:26:55');
INSERT INTO `device_locations` VALUES (249, 9, '860678079254720', 23.2488980, 113.1910610, 23.2515820, 113.1871490, NULL, NULL, 1348, 6.3, 0, '2026-01-22 05:26:59', '2026-01-22 05:26:59');
INSERT INTO `device_locations` VALUES (250, 9, '860678079254720', 23.2488980, 113.1910610, 23.2515820, 113.1871490, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:27:03', '2026-01-22 05:27:02');
INSERT INTO `device_locations` VALUES (251, 9, '860678079254720', 23.2488850, 113.1910730, 23.2515690, 113.1871610, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:27:06', '2026-01-22 05:27:05');
INSERT INTO `device_locations` VALUES (252, 9, '860678079254720', 23.2488850, 113.1910730, 23.2515690, 113.1871610, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:27:09', '2026-01-22 05:27:09');
INSERT INTO `device_locations` VALUES (253, 9, '860678079254720', 23.2488850, 113.1910730, 23.2515690, 113.1871610, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:27:13', '2026-01-22 05:27:12');
INSERT INTO `device_locations` VALUES (254, 9, '860678079254720', 23.2488850, 113.1910730, 23.2515690, 113.1871610, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:27:16', '2026-01-22 05:27:16');
INSERT INTO `device_locations` VALUES (255, 9, '860678079254720', 23.2488880, 113.1910610, 23.2515720, 113.1871490, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:27:19', '2026-01-22 05:27:19');
INSERT INTO `device_locations` VALUES (256, 9, '860678079254720', 23.2488880, 113.1910610, 23.2515720, 113.1871490, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:27:23', '2026-01-22 05:27:22');
INSERT INTO `device_locations` VALUES (257, 9, '860678079254720', 23.2488880, 113.1910610, 23.2515720, 113.1871490, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:27:26', '2026-01-22 05:27:26');
INSERT INTO `device_locations` VALUES (258, 9, '860678079254720', 23.2488880, 113.1910610, 23.2515720, 113.1871490, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:27:29', '2026-01-22 05:27:29');
INSERT INTO `device_locations` VALUES (259, 9, '860678079254720', 23.2488880, 113.1910610, 23.2515720, 113.1871490, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:27:33', '2026-01-22 05:27:32');
INSERT INTO `device_locations` VALUES (260, 9, '860678079254720', 23.2488950, 113.1910610, 23.2515790, 113.1871490, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:27:36', '2026-01-22 05:27:36');
INSERT INTO `device_locations` VALUES (261, 9, '860678079254720', 23.2488950, 113.1910610, 23.2515790, 113.1871490, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:27:39', '2026-01-22 05:27:39');
INSERT INTO `device_locations` VALUES (262, 9, '860678079254720', 23.2488950, 113.1910610, 23.2515790, 113.1871490, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:27:43', '2026-01-22 05:27:42');
INSERT INTO `device_locations` VALUES (263, 9, '860678079254720', 23.2488950, 113.1910610, 23.2515790, 113.1871490, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:27:46', '2026-01-22 05:27:46');
INSERT INTO `device_locations` VALUES (264, 9, '860678079254720', 23.2488880, 113.1910610, 23.2515720, 113.1871490, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:27:49', '2026-01-22 05:27:49');
INSERT INTO `device_locations` VALUES (265, 9, '860678079254720', 23.2488880, 113.1910610, 23.2515720, 113.1871490, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:27:53', '2026-01-22 05:27:52');
INSERT INTO `device_locations` VALUES (266, 9, '860678079254720', 23.2488880, 113.1910610, 23.2515720, 113.1871490, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:27:56', '2026-01-22 05:27:56');
INSERT INTO `device_locations` VALUES (267, 9, '860678079254720', 23.2488880, 113.1910610, 23.2515720, 113.1871490, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:27:59', '2026-01-22 05:27:59');
INSERT INTO `device_locations` VALUES (268, 9, '860678079254720', 23.2488880, 113.1910610, 23.2515720, 113.1871490, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:28:03', '2026-01-22 05:28:02');
INSERT INTO `device_locations` VALUES (269, 9, '860678079254720', 23.2488950, 113.1910480, 23.2515790, 113.1871360, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:28:06', '2026-01-22 05:28:06');
INSERT INTO `device_locations` VALUES (270, 9, '860678079254720', 23.2488950, 113.1910480, 23.2515790, 113.1871360, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:28:10', '2026-01-22 05:28:09');
INSERT INTO `device_locations` VALUES (271, 9, '860678079254720', 23.2488950, 113.1910480, 23.2515790, 113.1871360, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:28:13', '2026-01-22 05:28:12');
INSERT INTO `device_locations` VALUES (272, 9, '860678079254720', 23.2488950, 113.1910480, 23.2515790, 113.1871360, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:28:16', '2026-01-22 05:28:16');
INSERT INTO `device_locations` VALUES (273, 9, '860678079254720', 23.2489200, 113.1910100, 23.2516040, 113.1870980, NULL, NULL, 1348, 8.3, 0, '2026-01-22 05:28:20', '2026-01-22 05:28:19');
INSERT INTO `device_locations` VALUES (274, 9, '860678079254720', 23.2489200, 113.1910100, 23.2516040, 113.1870980, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:28:23', '2026-01-22 05:28:22');
INSERT INTO `device_locations` VALUES (275, 9, '860678079254720', 23.2489200, 113.1910100, 23.2516040, 113.1870980, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:28:26', '2026-01-22 05:28:26');
INSERT INTO `device_locations` VALUES (276, 9, '860678079254720', 23.2489200, 113.1910100, 23.2516040, 113.1870980, NULL, NULL, 1348, 6.5, 0, '2026-01-22 05:28:30', '2026-01-22 05:28:29');
INSERT INTO `device_locations` VALUES (277, 9, '860678079254720', 23.2489200, 113.1910100, 23.2516040, 113.1870980, NULL, NULL, 1348, 6.2, 0, '2026-01-22 05:28:33', '2026-01-22 05:28:32');
INSERT INTO `device_locations` VALUES (278, 9, '860678079254720', 23.2489390, 113.1910220, 23.2516230, 113.1871100, NULL, NULL, 1348, 6.6, 0, '2026-01-22 05:28:36', '2026-01-22 05:28:36');
INSERT INTO `device_locations` VALUES (279, 9, '860678079254720', 23.2489390, 113.1910220, 23.2516230, 113.1871100, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:28:40', '2026-01-22 05:28:39');
INSERT INTO `device_locations` VALUES (280, 9, '860678079254720', 23.2489390, 113.1910220, 23.2516230, 113.1871100, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:28:43', '2026-01-22 05:28:42');
INSERT INTO `device_locations` VALUES (281, 9, '860678079254720', 23.2489390, 113.1910220, 23.2516230, 113.1871100, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:28:46', '2026-01-22 05:28:46');
INSERT INTO `device_locations` VALUES (282, 9, '860678079254720', 23.2489360, 113.1910480, 23.2516200, 113.1871360, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:28:50', '2026-01-22 05:28:49');
INSERT INTO `device_locations` VALUES (283, 9, '860678079254720', 23.2489360, 113.1910480, 23.2516200, 113.1871360, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:28:53', '2026-01-22 05:28:52');
INSERT INTO `device_locations` VALUES (284, 9, '860678079254720', 23.2489360, 113.1910480, 23.2516200, 113.1871360, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:28:56', '2026-01-22 05:28:56');
INSERT INTO `device_locations` VALUES (285, 9, '860678079254720', 23.2489360, 113.1910480, 23.2516200, 113.1871360, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:29:00', '2026-01-22 05:28:59');
INSERT INTO `device_locations` VALUES (286, 9, '860678079254720', 23.2489360, 113.1910480, 23.2516200, 113.1871360, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:29:03', '2026-01-22 05:29:03');
INSERT INTO `device_locations` VALUES (287, 9, '860678079254720', 23.2489460, 113.1910480, 23.2516300, 113.1871360, NULL, NULL, 1348, 6.3, 0, '2026-01-22 05:29:06', '2026-01-22 05:29:06');
INSERT INTO `device_locations` VALUES (288, 9, '860678079254720', 23.2489460, 113.1910480, 23.2516300, 113.1871360, NULL, NULL, 1348, 6.6, 0, '2026-01-22 05:29:10', '2026-01-22 05:29:09');
INSERT INTO `device_locations` VALUES (289, 9, '860678079254720', 23.2489460, 113.1910480, 23.2516300, 113.1871360, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:29:13', '2026-01-22 05:29:13');
INSERT INTO `device_locations` VALUES (290, 9, '860678079254720', 23.2489460, 113.1910480, 23.2516300, 113.1871360, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:29:16', '2026-01-22 05:29:16');
INSERT INTO `device_locations` VALUES (291, 9, '860678079254720', 23.2489490, 113.1910730, 23.2516330, 113.1871610, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:29:20', '2026-01-22 05:29:19');
INSERT INTO `device_locations` VALUES (292, 9, '860678079254720', 23.2489490, 113.1910730, 23.2516330, 113.1871610, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:29:23', '2026-01-22 05:29:23');
INSERT INTO `device_locations` VALUES (293, 9, '860678079254720', 23.2489490, 113.1910730, 23.2516330, 113.1871610, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:29:26', '2026-01-22 05:29:26');
INSERT INTO `device_locations` VALUES (294, 9, '860678079254720', 23.2489490, 113.1910730, 23.2516330, 113.1871610, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:29:30', '2026-01-22 05:29:29');
INSERT INTO `device_locations` VALUES (295, 9, '860678079254720', 23.2489490, 113.1910730, 23.2516330, 113.1871610, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:29:33', '2026-01-22 05:29:33');
INSERT INTO `device_locations` VALUES (296, 9, '860678079254720', 23.2489110, 113.1910610, 23.2515950, 113.1871490, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:29:36', '2026-01-22 05:29:36');
INSERT INTO `device_locations` VALUES (297, 9, '860678079254720', 23.2489110, 113.1910610, 23.2515950, 113.1871490, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:29:40', '2026-01-22 05:29:39');
INSERT INTO `device_locations` VALUES (298, 9, '860678079254720', 23.2489110, 113.1910610, 23.2515950, 113.1871490, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:29:43', '2026-01-22 05:29:43');
INSERT INTO `device_locations` VALUES (299, 9, '860678079254720', 23.2489110, 113.1910610, 23.2515950, 113.1871490, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:29:46', '2026-01-22 05:29:46');
INSERT INTO `device_locations` VALUES (300, 9, '860678079254720', 23.2489330, 113.1910610, 23.2516170, 113.1871490, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:29:50', '2026-01-22 05:29:49');
INSERT INTO `device_locations` VALUES (301, 9, '860678079254720', 23.2489330, 113.1910610, 23.2516170, 113.1871490, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:29:53', '2026-01-22 05:29:53');
INSERT INTO `device_locations` VALUES (302, 9, '860678079254720', 23.2489330, 113.1910610, 23.2516170, 113.1871490, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:29:57', '2026-01-22 05:29:56');
INSERT INTO `device_locations` VALUES (303, 9, '860678079254720', 23.2489330, 113.1910610, 23.2516170, 113.1871490, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:30:00', '2026-01-22 05:29:59');
INSERT INTO `device_locations` VALUES (304, 9, '860678079254720', 23.2489330, 113.1910610, 23.2516170, 113.1871490, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:30:03', '2026-01-22 05:30:03');
INSERT INTO `device_locations` VALUES (305, 9, '860678079254720', 23.2489200, 113.1910610, 23.2516040, 113.1871490, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:30:07', '2026-01-22 05:30:06');
INSERT INTO `device_locations` VALUES (306, 9, '860678079254720', 23.2489200, 113.1910610, 23.2516040, 113.1871490, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:30:10', '2026-01-22 05:30:09');
INSERT INTO `device_locations` VALUES (307, 9, '860678079254720', 23.2489200, 113.1910610, 23.2516040, 113.1871490, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:30:13', '2026-01-22 05:30:13');
INSERT INTO `device_locations` VALUES (308, 9, '860678079254720', 23.2489200, 113.1910610, 23.2516040, 113.1871490, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:30:17', '2026-01-22 05:30:16');
INSERT INTO `device_locations` VALUES (309, 9, '860678079254720', 23.2489300, 113.1910480, 23.2516140, 113.1871360, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:30:20', '2026-01-22 05:30:19');
INSERT INTO `device_locations` VALUES (310, 9, '860678079254720', 23.2489300, 113.1910480, 23.2516140, 113.1871360, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:30:23', '2026-01-22 05:30:23');
INSERT INTO `device_locations` VALUES (311, 9, '860678079254720', 23.2489300, 113.1910480, 23.2516140, 113.1871360, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:30:27', '2026-01-22 05:30:27');
INSERT INTO `device_locations` VALUES (312, 9, '860678079254720', 23.2489300, 113.1910480, 23.2516140, 113.1871360, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:30:30', '2026-01-22 05:30:29');
INSERT INTO `device_locations` VALUES (313, 9, '860678079254720', 23.2489300, 113.1910480, 23.2516140, 113.1871360, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:30:33', '2026-01-22 05:30:33');
INSERT INTO `device_locations` VALUES (314, 9, '860678079254720', 23.2489300, 113.1910480, 23.2516140, 113.1871360, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:30:37', '2026-01-22 05:30:36');
INSERT INTO `device_locations` VALUES (315, 9, '860678079254720', 23.2489300, 113.1910480, 23.2516140, 113.1871360, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:30:40', '2026-01-22 05:30:39');
INSERT INTO `device_locations` VALUES (316, 9, '860678079254720', 23.2489300, 113.1910480, 23.2516140, 113.1871360, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:30:43', '2026-01-22 05:30:43');
INSERT INTO `device_locations` VALUES (317, 9, '860678079254720', 23.2489300, 113.1910480, 23.2516140, 113.1871360, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:30:47', '2026-01-22 05:30:46');
INSERT INTO `device_locations` VALUES (318, 9, '860678079254720', 23.2489390, 113.1909720, 23.2516230, 113.1870600, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:30:50', '2026-01-22 05:30:50');
INSERT INTO `device_locations` VALUES (319, 9, '860678079254720', 23.2489390, 113.1909720, 23.2516230, 113.1870600, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:30:53', '2026-01-22 05:30:53');
INSERT INTO `device_locations` VALUES (320, 9, '860678079254720', 23.2489390, 113.1909720, 23.2516230, 113.1870600, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:30:57', '2026-01-22 05:30:56');
INSERT INTO `device_locations` VALUES (321, 9, '860678079254720', 23.2489390, 113.1909720, 23.2516230, 113.1870600, NULL, NULL, 1348, 8.3, 0, '2026-01-22 05:31:00', '2026-01-22 05:31:00');
INSERT INTO `device_locations` VALUES (322, 9, '860678079254720', 23.2489390, 113.1909720, 23.2516230, 113.1870600, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:31:03', '2026-01-22 05:31:03');
INSERT INTO `device_locations` VALUES (323, 9, '860678079254720', 23.2489390, 113.1909720, 23.2516230, 113.1870600, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:31:07', '2026-01-22 05:31:06');
INSERT INTO `device_locations` VALUES (324, 9, '860678079254720', 23.2489390, 113.1909720, 23.2516230, 113.1870600, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:31:10', '2026-01-22 05:31:10');
INSERT INTO `device_locations` VALUES (325, 9, '860678079254720', 23.2489390, 113.1909720, 23.2516230, 113.1870600, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:31:13', '2026-01-22 05:31:13');
INSERT INTO `device_locations` VALUES (326, 9, '860678079254720', 23.2489390, 113.1909720, 23.2516230, 113.1870600, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:31:17', '2026-01-22 05:31:16');
INSERT INTO `device_locations` VALUES (327, 9, '860678079254720', 23.2489550, 113.1909840, 23.2516390, 113.1870720, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:31:20', '2026-01-22 05:31:20');
INSERT INTO `device_locations` VALUES (328, 9, '860678079254720', 23.2489550, 113.1909840, 23.2516390, 113.1870720, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:31:23', '2026-01-22 05:31:23');
INSERT INTO `device_locations` VALUES (329, 9, '860678079254720', 23.2489550, 113.1909840, 23.2516390, 113.1870720, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:31:27', '2026-01-22 05:31:26');
INSERT INTO `device_locations` VALUES (330, 9, '860678079254720', 23.2489550, 113.1909840, 23.2516390, 113.1870720, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:31:30', '2026-01-22 05:31:30');
INSERT INTO `device_locations` VALUES (331, 9, '860678079254720', 23.2489550, 113.1909840, 23.2516390, 113.1870720, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:31:34', '2026-01-22 05:31:33');
INSERT INTO `device_locations` VALUES (332, 9, '860678079254720', 23.2489550, 113.1909840, 23.2516390, 113.1870720, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:31:37', '2026-01-22 05:31:36');
INSERT INTO `device_locations` VALUES (333, 9, '860678079254720', 23.2489550, 113.1909840, 23.2516390, 113.1870720, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:31:40', '2026-01-22 05:31:40');
INSERT INTO `device_locations` VALUES (334, 9, '860678079254720', 23.2489550, 113.1909840, 23.2516390, 113.1870720, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:31:44', '2026-01-22 05:31:43');
INSERT INTO `device_locations` VALUES (335, 9, '860678079254720', 23.2489550, 113.1909840, 23.2516390, 113.1870720, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:31:47', '2026-01-22 05:31:46');
INSERT INTO `device_locations` VALUES (336, 9, '860678079254720', 23.2489580, 113.1910220, 23.2516420, 113.1871100, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:31:50', '2026-01-22 05:31:50');
INSERT INTO `device_locations` VALUES (337, 9, '860678079254720', 23.2489580, 113.1910220, 23.2516420, 113.1871100, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:31:54', '2026-01-22 05:31:53');
INSERT INTO `device_locations` VALUES (338, 9, '860678079254720', 23.2489580, 113.1910220, 23.2516420, 113.1871100, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:31:57', '2026-01-22 05:31:56');
INSERT INTO `device_locations` VALUES (339, 9, '860678079254720', 23.2489580, 113.1910220, 23.2516420, 113.1871100, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:32:00', '2026-01-22 05:32:00');
INSERT INTO `device_locations` VALUES (340, 9, '860678079254720', 23.2489580, 113.1910220, 23.2516420, 113.1871100, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:32:04', '2026-01-22 05:32:03');
INSERT INTO `device_locations` VALUES (341, 9, '860678079254720', 23.2489580, 113.1910220, 23.2516420, 113.1871100, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:32:07', '2026-01-22 05:32:06');
INSERT INTO `device_locations` VALUES (342, 9, '860678079254720', 23.2489580, 113.1910220, 23.2516420, 113.1871100, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:32:10', '2026-01-22 05:32:10');
INSERT INTO `device_locations` VALUES (343, 9, '860678079254720', 23.2489580, 113.1910220, 23.2516420, 113.1871100, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:32:14', '2026-01-22 05:32:13');
INSERT INTO `device_locations` VALUES (344, 9, '860678079254720', 23.2489580, 113.1910220, 23.2516420, 113.1871100, NULL, NULL, 1348, 6.6, 0, '2026-01-22 05:32:17', '2026-01-22 05:32:16');
INSERT INTO `device_locations` VALUES (345, 9, '860678079254720', 23.2489460, 113.1910100, 23.2516300, 113.1870980, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:32:20', '2026-01-22 05:32:20');
INSERT INTO `device_locations` VALUES (346, 9, '860678079254720', 23.2489460, 113.1910100, 23.2516300, 113.1870980, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:32:24', '2026-01-22 05:32:23');
INSERT INTO `device_locations` VALUES (347, 9, '860678079254720', 23.2489460, 113.1910100, 23.2516300, 113.1870980, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:32:27', '2026-01-22 05:32:26');
INSERT INTO `device_locations` VALUES (348, 9, '860678079254720', 23.2489460, 113.1910100, 23.2516300, 113.1870980, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:32:30', '2026-01-22 05:32:30');
INSERT INTO `device_locations` VALUES (349, 9, '860678079254720', 23.2489460, 113.1910100, 23.2516300, 113.1870980, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:32:34', '2026-01-22 05:32:33');
INSERT INTO `device_locations` VALUES (350, 9, '860678079254720', 23.2489460, 113.1910220, 23.2516300, 113.1871100, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:32:37', '2026-01-22 05:32:37');
INSERT INTO `device_locations` VALUES (351, 9, '860678079254720', 23.2489460, 113.1910220, 23.2516300, 113.1871100, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:32:40', '2026-01-22 05:32:40');
INSERT INTO `device_locations` VALUES (352, 9, '860678079254720', 23.2489460, 113.1910220, 23.2516300, 113.1871100, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:32:44', '2026-01-22 05:32:43');
INSERT INTO `device_locations` VALUES (353, 9, '860678079254720', 23.2489460, 113.1910220, 23.2516300, 113.1871100, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:32:47', '2026-01-22 05:32:47');
INSERT INTO `device_locations` VALUES (354, 9, '860678079254720', 23.2489390, 113.1910480, 23.2516230, 113.1871360, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:32:50', '2026-01-22 05:32:50');
INSERT INTO `device_locations` VALUES (355, 9, '860678079254720', 23.2489390, 113.1910480, 23.2516230, 113.1871360, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:32:54', '2026-01-22 05:32:53');
INSERT INTO `device_locations` VALUES (356, 9, '860678079254720', 23.2489390, 113.1910480, 23.2516230, 113.1871360, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:32:57', '2026-01-22 05:32:57');
INSERT INTO `device_locations` VALUES (357, 9, '860678079254720', 23.2489390, 113.1910480, 23.2516230, 113.1871360, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:33:00', '2026-01-22 05:33:00');
INSERT INTO `device_locations` VALUES (358, 9, '860678079254720', 23.2489390, 113.1910480, 23.2516230, 113.1871360, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:33:04', '2026-01-22 05:33:03');
INSERT INTO `device_locations` VALUES (359, 9, '860678079254720', 23.2489300, 113.1910730, 23.2516140, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:33:07', '2026-01-22 05:33:07');
INSERT INTO `device_locations` VALUES (360, 9, '860678079254720', 23.2489300, 113.1910730, 23.2516140, 113.1871610, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:33:10', '2026-01-22 05:33:10');
INSERT INTO `device_locations` VALUES (361, 9, '860678079254720', 23.2489300, 113.1910730, 23.2516140, 113.1871610, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:33:14', '2026-01-22 05:33:13');
INSERT INTO `device_locations` VALUES (362, 9, '860678079254720', 23.2489300, 113.1910730, 23.2516140, 113.1871610, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:33:17', '2026-01-22 05:33:17');
INSERT INTO `device_locations` VALUES (363, 9, '860678079254720', 23.2489360, 113.1910860, 23.2516200, 113.1871740, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:33:20', '2026-01-22 05:33:20');
INSERT INTO `device_locations` VALUES (364, 9, '860678079254720', 23.2489360, 113.1910860, 23.2516200, 113.1871740, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:33:24', '2026-01-22 05:33:23');
INSERT INTO `device_locations` VALUES (365, 9, '860678079254720', 23.2489360, 113.1910860, 23.2516200, 113.1871740, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:33:27', '2026-01-22 05:33:27');
INSERT INTO `device_locations` VALUES (366, 9, '860678079254720', 23.2489360, 113.1910860, 23.2516200, 113.1871740, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:33:31', '2026-01-22 05:33:30');
INSERT INTO `device_locations` VALUES (367, 9, '860678079254720', 23.2489360, 113.1910860, 23.2516200, 113.1871740, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:33:34', '2026-01-22 05:33:33');
INSERT INTO `device_locations` VALUES (368, 9, '860678079254720', 23.2489650, 113.1910860, 23.2516490, 113.1871740, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:33:37', '2026-01-22 05:33:37');
INSERT INTO `device_locations` VALUES (369, 9, '860678079254720', 23.2489650, 113.1910860, 23.2516490, 113.1871740, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:33:41', '2026-01-22 05:33:40');
INSERT INTO `device_locations` VALUES (370, 9, '860678079254720', 23.2489650, 113.1910860, 23.2516490, 113.1871740, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:33:44', '2026-01-22 05:33:43');
INSERT INTO `device_locations` VALUES (371, 9, '860678079254720', 23.2489650, 113.1910860, 23.2516490, 113.1871740, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:33:47', '2026-01-22 05:33:47');
INSERT INTO `device_locations` VALUES (372, 9, '860678079254720', 23.2489460, 113.1910990, 23.2516300, 113.1871870, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:33:51', '2026-01-22 05:33:50');
INSERT INTO `device_locations` VALUES (373, 9, '860678079254720', 23.2489460, 113.1910990, 23.2516300, 113.1871870, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:33:54', '2026-01-22 05:33:53');
INSERT INTO `device_locations` VALUES (374, 9, '860678079254720', 23.2489460, 113.1910990, 23.2516300, 113.1871870, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:33:57', '2026-01-22 05:33:57');
INSERT INTO `device_locations` VALUES (375, 9, '860678079254720', 23.2489460, 113.1910990, 23.2516300, 113.1871870, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:34:01', '2026-01-22 05:34:00');
INSERT INTO `device_locations` VALUES (376, 9, '860678079254720', 23.2489460, 113.1910990, 23.2516300, 113.1871870, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:34:04', '2026-01-22 05:34:03');
INSERT INTO `device_locations` VALUES (377, 9, '860678079254720', 23.2489490, 113.1911500, 23.2516330, 113.1872380, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:34:07', '2026-01-22 05:34:07');
INSERT INTO `device_locations` VALUES (378, 9, '860678079254720', 23.2489490, 113.1911500, 23.2516330, 113.1872380, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:34:11', '2026-01-22 05:34:10');
INSERT INTO `device_locations` VALUES (379, 9, '860678079254720', 23.2489490, 113.1911500, 23.2516330, 113.1872380, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:34:14', '2026-01-22 05:34:13');
INSERT INTO `device_locations` VALUES (380, 9, '860678079254720', 23.2489490, 113.1911500, 23.2516330, 113.1872380, NULL, NULL, 1348, 6.5, 0, '2026-01-22 05:34:17', '2026-01-22 05:34:17');
INSERT INTO `device_locations` VALUES (381, 9, '860678079254720', 23.2489520, 113.1911110, 23.2516360, 113.1871990, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:34:21', '2026-01-22 05:34:20');
INSERT INTO `device_locations` VALUES (382, 9, '860678079254720', 23.2489520, 113.1911110, 23.2516360, 113.1871990, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:34:24', '2026-01-22 05:34:24');
INSERT INTO `device_locations` VALUES (383, 9, '860678079254720', 23.2489520, 113.1911110, 23.2516360, 113.1871990, NULL, NULL, 1348, 6.9, 0, '2026-01-22 05:34:27', '2026-01-22 05:34:27');
INSERT INTO `device_locations` VALUES (384, 9, '860678079254720', 23.2489520, 113.1911110, 23.2516360, 113.1871990, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:34:31', '2026-01-22 05:34:30');
INSERT INTO `device_locations` VALUES (385, 9, '860678079254720', 23.2489520, 113.1911110, 23.2516360, 113.1871990, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:34:34', '2026-01-22 05:34:34');
INSERT INTO `device_locations` VALUES (386, 9, '860678079254720', 23.2489740, 113.1910990, 23.2516580, 113.1871870, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:34:37', '2026-01-22 05:34:37');
INSERT INTO `device_locations` VALUES (387, 9, '860678079254720', 23.2489740, 113.1910990, 23.2516580, 113.1871870, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:34:41', '2026-01-22 05:34:40');
INSERT INTO `device_locations` VALUES (388, 9, '860678079254720', 23.2489740, 113.1910990, 23.2516580, 113.1871870, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:34:44', '2026-01-22 05:34:44');
INSERT INTO `device_locations` VALUES (389, 9, '860678079254720', 23.2489740, 113.1910990, 23.2516580, 113.1871870, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:34:47', '2026-01-22 05:34:47');
INSERT INTO `device_locations` VALUES (390, 9, '860678079254720', 23.2489870, 113.1910990, 23.2516710, 113.1871870, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:34:51', '2026-01-22 05:34:50');
INSERT INTO `device_locations` VALUES (391, 9, '860678079254720', 23.2489870, 113.1910990, 23.2516710, 113.1871870, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:34:54', '2026-01-22 05:34:54');
INSERT INTO `device_locations` VALUES (392, 9, '860678079254720', 23.2489870, 113.1910990, 23.2516710, 113.1871870, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:34:57', '2026-01-22 05:34:57');
INSERT INTO `device_locations` VALUES (393, 9, '860678079254720', 23.2489870, 113.1910990, 23.2516710, 113.1871870, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:35:01', '2026-01-22 05:35:00');
INSERT INTO `device_locations` VALUES (394, 9, '860678079254720', 23.2489870, 113.1910990, 23.2516710, 113.1871870, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:35:04', '2026-01-22 05:35:04');
INSERT INTO `device_locations` VALUES (395, 9, '860678079254720', 23.2489900, 113.1910730, 23.2516740, 113.1871610, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:35:07', '2026-01-22 05:35:07');
INSERT INTO `device_locations` VALUES (396, 9, '860678079254720', 23.2489900, 113.1910730, 23.2516740, 113.1871610, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:35:11', '2026-01-22 05:35:10');
INSERT INTO `device_locations` VALUES (397, 9, '860678079254720', 23.2489900, 113.1910730, 23.2516740, 113.1871610, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:35:14', '2026-01-22 05:35:14');
INSERT INTO `device_locations` VALUES (398, 9, '860678079254720', 23.2489900, 113.1910730, 23.2516740, 113.1871610, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:35:18', '2026-01-22 05:35:17');
INSERT INTO `device_locations` VALUES (399, 9, '860678079254720', 23.2489970, 113.1910610, 23.2516810, 113.1871490, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:35:21', '2026-01-22 05:35:20');
INSERT INTO `device_locations` VALUES (400, 9, '860678079254720', 23.2489970, 113.1910610, 23.2516810, 113.1871490, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:35:24', '2026-01-22 05:35:24');
INSERT INTO `device_locations` VALUES (401, 9, '860678079254720', 23.2489970, 113.1910610, 23.2516810, 113.1871490, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:35:28', '2026-01-22 05:35:27');
INSERT INTO `device_locations` VALUES (402, 9, '860678079254720', 23.2489970, 113.1910610, 23.2516810, 113.1871490, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:35:31', '2026-01-22 05:35:30');
INSERT INTO `device_locations` VALUES (403, 9, '860678079254720', 23.2489970, 113.1910610, 23.2516810, 113.1871490, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:35:34', '2026-01-22 05:35:34');
INSERT INTO `device_locations` VALUES (404, 9, '860678079254720', 23.2490000, 113.1910730, 23.2516840, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:35:38', '2026-01-22 05:35:37');
INSERT INTO `device_locations` VALUES (405, 9, '860678079254720', 23.2490000, 113.1910730, 23.2516840, 113.1871610, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:35:41', '2026-01-22 05:35:40');
INSERT INTO `device_locations` VALUES (406, 9, '860678079254720', 23.2490000, 113.1910730, 23.2516840, 113.1871610, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:35:44', '2026-01-22 05:35:44');
INSERT INTO `device_locations` VALUES (407, 9, '860678079254720', 23.2490000, 113.1910730, 23.2516840, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:35:48', '2026-01-22 05:35:47');
INSERT INTO `device_locations` VALUES (408, 9, '860678079254720', 23.2490120, 113.1910730, 23.2516960, 113.1871610, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:35:51', '2026-01-22 05:35:50');
INSERT INTO `device_locations` VALUES (409, 9, '860678079254720', 23.2490120, 113.1910730, 23.2516960, 113.1871610, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:35:54', '2026-01-22 05:35:54');
INSERT INTO `device_locations` VALUES (410, 9, '860678079254720', 23.2490120, 113.1910730, 23.2516960, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:35:58', '2026-01-22 05:35:57');
INSERT INTO `device_locations` VALUES (411, 9, '860678079254720', 23.2490120, 113.1910730, 23.2516960, 113.1871610, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:36:01', '2026-01-22 05:36:01');
INSERT INTO `device_locations` VALUES (412, 9, '860678079254720', 23.2490120, 113.1910730, 23.2516960, 113.1871610, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:36:04', '2026-01-22 05:36:04');
INSERT INTO `device_locations` VALUES (413, 9, '860678079254720', 23.2490190, 113.1910730, 23.2517030, 113.1871610, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:36:08', '2026-01-22 05:36:07');
INSERT INTO `device_locations` VALUES (414, 9, '860678079254720', 23.2490190, 113.1910730, 23.2517030, 113.1871610, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:36:11', '2026-01-22 05:36:10');
INSERT INTO `device_locations` VALUES (415, 9, '860678079254720', 23.2490190, 113.1910730, 23.2517030, 113.1871610, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:36:14', '2026-01-22 05:36:14');
INSERT INTO `device_locations` VALUES (416, 9, '860678079254720', 23.2490190, 113.1910730, 23.2517030, 113.1871610, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:36:18', '2026-01-22 05:36:17');
INSERT INTO `device_locations` VALUES (417, 9, '860678079254720', 23.2490090, 113.1910730, 23.2516930, 113.1871610, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:36:21', '2026-01-22 05:36:21');
INSERT INTO `device_locations` VALUES (418, 9, '860678079254720', 23.2490090, 113.1910730, 23.2516930, 113.1871610, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:36:24', '2026-01-22 05:36:24');
INSERT INTO `device_locations` VALUES (419, 9, '860678079254720', 23.2490090, 113.1910730, 23.2516930, 113.1871610, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:36:28', '2026-01-22 05:36:27');
INSERT INTO `device_locations` VALUES (420, 9, '860678079254720', 23.2490090, 113.1910730, 23.2516930, 113.1871610, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:36:31', '2026-01-22 05:36:31');
INSERT INTO `device_locations` VALUES (421, 9, '860678079254720', 23.2490090, 113.1910990, 23.2516930, 113.1871870, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:36:34', '2026-01-22 05:36:34');
INSERT INTO `device_locations` VALUES (422, 9, '860678079254720', 23.2490090, 113.1910990, 23.2516930, 113.1871870, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:36:38', '2026-01-22 05:36:37');
INSERT INTO `device_locations` VALUES (423, 9, '860678079254720', 23.2490090, 113.1910990, 23.2516930, 113.1871870, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:36:41', '2026-01-22 05:36:41');
INSERT INTO `device_locations` VALUES (424, 9, '860678079254720', 23.2490090, 113.1910990, 23.2516930, 113.1871870, NULL, NULL, 1348, 6.6, 0, '2026-01-22 05:36:44', '2026-01-22 05:36:44');
INSERT INTO `device_locations` VALUES (425, 9, '860678079254720', 23.2490090, 113.1910990, 23.2516930, 113.1871870, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:36:48', '2026-01-22 05:36:47');
INSERT INTO `device_locations` VALUES (426, 9, '860678079254720', 23.2490060, 113.1911110, 23.2516900, 113.1871990, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:36:51', '2026-01-22 05:36:51');
INSERT INTO `device_locations` VALUES (427, 9, '860678079254720', 23.2490060, 113.1911110, 23.2516900, 113.1871990, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:36:54', '2026-01-22 05:36:54');
INSERT INTO `device_locations` VALUES (428, 9, '860678079254720', 23.2490060, 113.1911110, 23.2516900, 113.1871990, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:36:58', '2026-01-22 05:36:57');
INSERT INTO `device_locations` VALUES (429, 9, '860678079254720', 23.2490060, 113.1911110, 23.2516900, 113.1871990, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:37:01', '2026-01-22 05:37:01');
INSERT INTO `device_locations` VALUES (430, 9, '860678079254720', 23.2490120, 113.1911370, 23.2516960, 113.1872250, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:37:05', '2026-01-22 05:37:04');
INSERT INTO `device_locations` VALUES (431, 9, '860678079254720', 23.2490120, 113.1911370, 23.2516960, 113.1872250, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:37:08', '2026-01-22 05:37:07');
INSERT INTO `device_locations` VALUES (432, 9, '860678079254720', 23.2490120, 113.1911370, 23.2516960, 113.1872250, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:37:11', '2026-01-22 05:37:11');
INSERT INTO `device_locations` VALUES (433, 9, '860678079254720', 23.2490120, 113.1911370, 23.2516960, 113.1872250, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:37:15', '2026-01-22 05:37:14');
INSERT INTO `device_locations` VALUES (434, 9, '860678079254720', 23.2490120, 113.1911370, 23.2516960, 113.1872250, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:37:18', '2026-01-22 05:37:17');
INSERT INTO `device_locations` VALUES (435, 9, '860678079254720', 23.2490030, 113.1911370, 23.2516870, 113.1872250, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:37:21', '2026-01-22 05:37:21');
INSERT INTO `device_locations` VALUES (436, 9, '860678079254720', 23.2490030, 113.1911370, 23.2516870, 113.1872250, NULL, NULL, 1348, 6.5, 0, '2026-01-22 05:37:25', '2026-01-22 05:37:24');
INSERT INTO `device_locations` VALUES (437, 9, '860678079254720', 23.2490030, 113.1911370, 23.2516870, 113.1872250, NULL, NULL, 1348, 6.4, 0, '2026-01-22 05:37:28', '2026-01-22 05:37:27');
INSERT INTO `device_locations` VALUES (438, 9, '860678079254720', 23.2490030, 113.1911370, 23.2516870, 113.1872250, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:37:31', '2026-01-22 05:37:31');
INSERT INTO `device_locations` VALUES (439, 9, '860678079254720', 23.2490090, 113.1911500, 23.2516930, 113.1872380, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:37:35', '2026-01-22 05:37:34');
INSERT INTO `device_locations` VALUES (440, 9, '860678079254720', 23.2490090, 113.1911500, 23.2516930, 113.1872380, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:37:38', '2026-01-22 05:37:37');
INSERT INTO `device_locations` VALUES (441, 9, '860678079254720', 23.2490090, 113.1911500, 23.2516930, 113.1872380, NULL, NULL, 1348, 6.9, 0, '2026-01-22 05:37:41', '2026-01-22 05:37:41');
INSERT INTO `device_locations` VALUES (442, 9, '860678079254720', 23.2490090, 113.1911500, 23.2516930, 113.1872380, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:37:45', '2026-01-22 05:37:44');
INSERT INTO `device_locations` VALUES (443, 9, '860678079254720', 23.2490090, 113.1911500, 23.2516930, 113.1872380, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:37:48', '2026-01-22 05:37:47');
INSERT INTO `device_locations` VALUES (444, 9, '860678079254720', 23.2490030, 113.1911240, 23.2516870, 113.1872120, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:37:51', '2026-01-22 05:37:51');
INSERT INTO `device_locations` VALUES (445, 9, '860678079254720', 23.2490030, 113.1911240, 23.2516870, 113.1872120, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:37:55', '2026-01-22 05:37:54');
INSERT INTO `device_locations` VALUES (446, 9, '860678079254720', 23.2490030, 113.1911240, 23.2516870, 113.1872120, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:37:58', '2026-01-22 05:37:58');
INSERT INTO `device_locations` VALUES (447, 9, '860678079254720', 23.2490030, 113.1911240, 23.2516870, 113.1872120, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:38:01', '2026-01-22 05:38:01');
INSERT INTO `device_locations` VALUES (448, 9, '860678079254720', 23.2490030, 113.1910860, 23.2516870, 113.1871740, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:38:05', '2026-01-22 05:38:04');
INSERT INTO `device_locations` VALUES (449, 9, '860678079254720', 23.2490030, 113.1910860, 23.2516870, 113.1871740, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:38:08', '2026-01-22 05:38:08');
INSERT INTO `device_locations` VALUES (450, 9, '860678079254720', 23.2490030, 113.1910860, 23.2516870, 113.1871740, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:38:11', '2026-01-22 05:38:11');
INSERT INTO `device_locations` VALUES (451, 9, '860678079254720', 23.2490030, 113.1910860, 23.2516870, 113.1871740, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:38:15', '2026-01-22 05:38:14');
INSERT INTO `device_locations` VALUES (452, 9, '860678079254720', 23.2490030, 113.1910860, 23.2516870, 113.1871740, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:38:18', '2026-01-22 05:38:18');
INSERT INTO `device_locations` VALUES (453, 9, '860678079254720', 23.2489870, 113.1910730, 23.2516710, 113.1871610, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:38:21', '2026-01-22 05:38:21');
INSERT INTO `device_locations` VALUES (454, 9, '860678079254720', 23.2489870, 113.1910730, 23.2516710, 113.1871610, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:38:25', '2026-01-22 05:38:24');
INSERT INTO `device_locations` VALUES (455, 9, '860678079254720', 23.2489870, 113.1910730, 23.2516710, 113.1871610, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:38:28', '2026-01-22 05:38:28');
INSERT INTO `device_locations` VALUES (456, 9, '860678079254720', 23.2489870, 113.1910730, 23.2516710, 113.1871610, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:38:31', '2026-01-22 05:38:31');
INSERT INTO `device_locations` VALUES (457, 9, '860678079254720', 23.2489770, 113.1910100, 23.2516610, 113.1870980, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:38:35', '2026-01-22 05:38:34');
INSERT INTO `device_locations` VALUES (458, 9, '860678079254720', 23.2489770, 113.1910100, 23.2516610, 113.1870980, NULL, NULL, 1348, 8.2, 0, '2026-01-22 05:38:38', '2026-01-22 05:38:38');
INSERT INTO `device_locations` VALUES (459, 9, '860678079254720', 23.2489770, 113.1910100, 23.2516610, 113.1870980, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:38:41', '2026-01-22 05:38:41');
INSERT INTO `device_locations` VALUES (460, 9, '860678079254720', 23.2489770, 113.1910100, 23.2516610, 113.1870980, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:38:45', '2026-01-22 05:38:44');
INSERT INTO `device_locations` VALUES (461, 9, '860678079254720', 23.2489770, 113.1910100, 23.2516610, 113.1870980, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:38:48', '2026-01-22 05:38:48');
INSERT INTO `device_locations` VALUES (462, 9, '860678079254720', 23.2489680, 113.1910350, 23.2516520, 113.1871230, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:38:52', '2026-01-22 05:38:51');
INSERT INTO `device_locations` VALUES (463, 9, '860678079254720', 23.2489680, 113.1910350, 23.2516520, 113.1871230, NULL, NULL, 1348, 8.6, 0, '2026-01-22 05:38:55', '2026-01-22 05:38:54');
INSERT INTO `device_locations` VALUES (464, 9, '860678079254720', 23.2489680, 113.1910350, 23.2516520, 113.1871230, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:38:58', '2026-01-22 05:38:58');
INSERT INTO `device_locations` VALUES (465, 9, '860678079254720', 23.2489680, 113.1910350, 23.2516520, 113.1871230, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:39:02', '2026-01-22 05:39:01');
INSERT INTO `device_locations` VALUES (466, 9, '860678079254720', 23.2489490, 113.1910350, 23.2516330, 113.1871230, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:39:05', '2026-01-22 05:39:04');
INSERT INTO `device_locations` VALUES (467, 9, '860678079254720', 23.2489490, 113.1910350, 23.2516330, 113.1871230, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:39:08', '2026-01-22 05:39:08');
INSERT INTO `device_locations` VALUES (468, 9, '860678079254720', 23.2489490, 113.1910350, 23.2516330, 113.1871230, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:39:12', '2026-01-22 05:39:11');
INSERT INTO `device_locations` VALUES (469, 9, '860678079254720', 23.2489490, 113.1910350, 23.2516330, 113.1871230, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:39:15', '2026-01-22 05:39:14');
INSERT INTO `device_locations` VALUES (470, 9, '860678079254720', 23.2489490, 113.1910350, 23.2516330, 113.1871230, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:39:18', '2026-01-22 05:39:18');
INSERT INTO `device_locations` VALUES (471, 9, '860678079254720', 23.2489460, 113.1910350, 23.2516300, 113.1871230, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:39:22', '2026-01-22 05:39:21');
INSERT INTO `device_locations` VALUES (472, 9, '860678079254720', 23.2489460, 113.1910350, 23.2516300, 113.1871230, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:39:25', '2026-01-22 05:39:24');
INSERT INTO `device_locations` VALUES (473, 9, '860678079254720', 23.2489460, 113.1910350, 23.2516300, 113.1871230, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:39:28', '2026-01-22 05:39:28');
INSERT INTO `device_locations` VALUES (474, 9, '860678079254720', 23.2489460, 113.1910350, 23.2516300, 113.1871230, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:39:32', '2026-01-22 05:39:31');
INSERT INTO `device_locations` VALUES (475, 9, '860678079254720', 23.2489550, 113.1910480, 23.2516390, 113.1871360, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:39:35', '2026-01-22 05:39:35');
INSERT INTO `device_locations` VALUES (476, 9, '860678079254720', 23.2489550, 113.1910480, 23.2516390, 113.1871360, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:39:38', '2026-01-22 05:39:38');
INSERT INTO `device_locations` VALUES (477, 9, '860678079254720', 23.2489550, 113.1910480, 23.2516390, 113.1871360, NULL, NULL, 1348, 8.5, 0, '2026-01-22 05:39:42', '2026-01-22 05:39:41');
INSERT INTO `device_locations` VALUES (478, 9, '860678079254720', 23.2489550, 113.1910480, 23.2516390, 113.1871360, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:39:45', '2026-01-22 05:39:45');
INSERT INTO `device_locations` VALUES (479, 9, '860678079254720', 23.2489550, 113.1910480, 23.2516390, 113.1871360, NULL, NULL, 1348, 7.7, 0, '2026-01-22 05:39:48', '2026-01-22 05:39:48');
INSERT INTO `device_locations` VALUES (480, 9, '860678079254720', 23.2489550, 113.1910480, 23.2516390, 113.1871360, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:39:52', '2026-01-22 05:39:51');
INSERT INTO `device_locations` VALUES (481, 9, '860678079254720', 23.2489550, 113.1910480, 23.2516390, 113.1871360, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:39:55', '2026-01-22 05:39:55');
INSERT INTO `device_locations` VALUES (482, 9, '860678079254720', 23.2489550, 113.1910480, 23.2516390, 113.1871360, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:39:58', '2026-01-22 05:39:58');
INSERT INTO `device_locations` VALUES (483, 9, '860678079254720', 23.2489550, 113.1910480, 23.2516390, 113.1871360, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:40:02', '2026-01-22 05:40:01');
INSERT INTO `device_locations` VALUES (484, 9, '860678079254720', 23.2489710, 113.1910730, 23.2516550, 113.1871610, NULL, NULL, 1348, 7.0, 0, '2026-01-22 05:40:05', '2026-01-22 05:40:05');
INSERT INTO `device_locations` VALUES (485, 9, '860678079254720', 23.2489710, 113.1910730, 23.2516550, 113.1871610, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:40:08', '2026-01-22 05:40:08');
INSERT INTO `device_locations` VALUES (486, 9, '860678079254720', 23.2489710, 113.1910730, 23.2516550, 113.1871610, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:40:12', '2026-01-22 05:40:11');
INSERT INTO `device_locations` VALUES (487, 9, '860678079254720', 23.2489710, 113.1910730, 23.2516550, 113.1871610, NULL, NULL, 1348, 6.8, 0, '2026-01-22 05:40:15', '2026-01-22 05:40:15');
INSERT INTO `device_locations` VALUES (488, 9, '860678079254720', 23.2489710, 113.1910730, 23.2516550, 113.1871610, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:40:18', '2026-01-22 05:40:18');
INSERT INTO `device_locations` VALUES (489, 9, '860678079254720', 23.2489710, 113.1910730, 23.2516550, 113.1871610, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:40:22', '2026-01-22 05:40:21');
INSERT INTO `device_locations` VALUES (490, 9, '860678079254720', 23.2489710, 113.1910730, 23.2516550, 113.1871610, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:40:32', '2026-01-22 05:40:31');
INSERT INTO `device_locations` VALUES (491, 9, '860678079254720', 23.2490120, 113.1910100, 23.2516960, 113.1870980, NULL, NULL, 1348, 6.7, 0, '2026-01-22 05:40:35', '2026-01-22 05:40:35');
INSERT INTO `device_locations` VALUES (492, 9, '860678079254720', 23.2490120, 113.1910100, 23.2516960, 113.1870980, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:40:39', '2026-01-22 05:40:38');
INSERT INTO `device_locations` VALUES (493, 9, '860678079254720', 23.2490120, 113.1910100, 23.2516960, 113.1870980, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:40:42', '2026-01-22 05:40:41');
INSERT INTO `device_locations` VALUES (494, 9, '860678079254720', 23.2490120, 113.1910100, 23.2516960, 113.1870980, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:40:45', '2026-01-22 05:40:45');
INSERT INTO `device_locations` VALUES (495, 9, '860678079254720', 23.2490120, 113.1910100, 23.2516960, 113.1870980, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:40:49', '2026-01-22 05:40:48');
INSERT INTO `device_locations` VALUES (496, 9, '860678079254720', 23.2490120, 113.1910100, 23.2516960, 113.1870980, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:40:52', '2026-01-22 05:40:51');
INSERT INTO `device_locations` VALUES (497, 9, '860678079254720', 23.2490120, 113.1910100, 23.2516960, 113.1870980, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:40:55', '2026-01-22 05:40:55');
INSERT INTO `device_locations` VALUES (498, 9, '860678079254720', 23.2490120, 113.1910100, 23.2516960, 113.1870980, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:40:59', '2026-01-22 05:40:58');
INSERT INTO `device_locations` VALUES (499, 9, '860678079254720', 23.2490120, 113.1910100, 23.2516960, 113.1870980, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:41:02', '2026-01-22 05:41:01');
INSERT INTO `device_locations` VALUES (500, 9, '860678079254720', 23.2490120, 113.1909720, 23.2516960, 113.1870600, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:41:05', '2026-01-22 05:41:05');
INSERT INTO `device_locations` VALUES (501, 9, '860678079254720', 23.2490120, 113.1909720, 23.2516960, 113.1870600, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:41:09', '2026-01-22 05:41:08');
INSERT INTO `device_locations` VALUES (502, 9, '860678079254720', 23.2490120, 113.1909720, 23.2516960, 113.1870600, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:41:12', '2026-01-22 05:41:11');
INSERT INTO `device_locations` VALUES (503, 9, '860678079254720', 23.2490120, 113.1909720, 23.2516960, 113.1870600, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:41:15', '2026-01-22 05:41:15');
INSERT INTO `device_locations` VALUES (504, 9, '860678079254720', 23.2490120, 113.1909720, 23.2516960, 113.1870600, NULL, NULL, 1348, 8.1, 0, '2026-01-22 05:41:19', '2026-01-22 05:41:18');
INSERT INTO `device_locations` VALUES (505, 9, '860678079254720', 23.2490120, 113.1909720, 23.2516960, 113.1870600, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:41:22', '2026-01-22 05:41:21');
INSERT INTO `device_locations` VALUES (506, 9, '860678079254720', 23.2490120, 113.1909720, 23.2516960, 113.1870600, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:41:25', '2026-01-22 05:41:25');
INSERT INTO `device_locations` VALUES (507, 9, '860678079254720', 23.2490120, 113.1909720, 23.2516960, 113.1870600, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:41:29', '2026-01-22 05:41:28');
INSERT INTO `device_locations` VALUES (508, 9, '860678079254720', 23.2490120, 113.1909720, 23.2516960, 113.1870600, NULL, NULL, 1348, 7.2, 0, '2026-01-22 05:41:32', '2026-01-22 05:41:32');
INSERT INTO `device_locations` VALUES (509, 9, '860678079254720', 23.2490190, 113.1910100, 23.2517030, 113.1870980, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:41:35', '2026-01-22 05:41:35');
INSERT INTO `device_locations` VALUES (510, 9, '860678079254720', 23.2490190, 113.1910100, 23.2517030, 113.1870980, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:41:39', '2026-01-22 05:41:38');
INSERT INTO `device_locations` VALUES (511, 9, '860678079254720', 23.2490190, 113.1910100, 23.2517030, 113.1870980, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:41:42', '2026-01-22 05:41:42');
INSERT INTO `device_locations` VALUES (512, 9, '860678079254720', 23.2490190, 113.1910100, 23.2517030, 113.1870980, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:41:45', '2026-01-22 05:41:45');
INSERT INTO `device_locations` VALUES (513, 9, '860678079254720', 23.2490190, 113.1910100, 23.2517030, 113.1870980, NULL, NULL, 1348, 7.3, 0, '2026-01-22 05:41:49', '2026-01-22 05:41:48');
INSERT INTO `device_locations` VALUES (514, 9, '860678079254720', 23.2490220, 113.1910100, 23.2517060, 113.1870980, NULL, NULL, 1348, 8.0, 0, '2026-01-22 05:41:52', '2026-01-22 05:41:52');
INSERT INTO `device_locations` VALUES (515, 9, '860678079254720', 23.2490220, 113.1910100, 23.2517060, 113.1870980, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:41:55', '2026-01-22 05:41:55');
INSERT INTO `device_locations` VALUES (516, 9, '860678079254720', 23.2490220, 113.1910100, 23.2517060, 113.1870980, NULL, NULL, 1348, 7.5, 0, '2026-01-22 05:41:59', '2026-01-22 05:41:58');
INSERT INTO `device_locations` VALUES (517, 9, '860678079254720', 23.2490220, 113.1910100, 23.2517060, 113.1870980, NULL, NULL, 1348, 7.1, 0, '2026-01-22 05:42:02', '2026-01-22 05:42:02');
INSERT INTO `device_locations` VALUES (518, 9, '860678079254720', 23.2490350, 113.1910350, 23.2517190, 113.1871230, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:42:05', '2026-01-22 05:42:05');
INSERT INTO `device_locations` VALUES (519, 9, '860678079254720', 23.2490350, 113.1910350, 23.2517190, 113.1871230, NULL, NULL, 1348, 7.6, 0, '2026-01-22 05:42:09', '2026-01-22 05:42:08');
INSERT INTO `device_locations` VALUES (520, 9, '860678079254720', 23.2490350, 113.1910350, 23.2517190, 113.1871230, NULL, NULL, 1348, 7.4, 0, '2026-01-22 05:42:12', '2026-01-22 05:42:12');
INSERT INTO `device_locations` VALUES (521, 9, '860678079254720', 23.2490350, 113.1910350, 23.2517190, 113.1871230, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:42:16', '2026-01-22 05:42:15');
INSERT INTO `device_locations` VALUES (522, 9, '860678079254720', 23.2490350, 113.1910350, 23.2517190, 113.1871230, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:42:19', '2026-01-22 05:42:18');
INSERT INTO `device_locations` VALUES (523, 9, '860678079254720', 23.2490120, 113.1910610, 23.2516960, 113.1871490, NULL, NULL, 1348, 7.8, 0, '2026-01-22 05:42:22', '2026-01-22 05:42:22');
INSERT INTO `device_locations` VALUES (524, 9, '860678079254720', 23.2490120, 113.1910610, 23.2516960, 113.1871490, NULL, NULL, 1348, 8.7, 0, '2026-01-22 05:42:26', '2026-01-22 05:42:25');
INSERT INTO `device_locations` VALUES (525, 9, '860678079254720', 23.2490120, 113.1910610, 23.2516960, 113.1871490, NULL, NULL, 1348, 7.9, 0, '2026-01-22 05:42:29', '2026-01-22 05:42:28');
INSERT INTO `device_locations` VALUES (526, 9, '860678079254720', 23.2490120, 113.1910610, 23.2516960, 113.1871490, NULL, NULL, 1348, 8.4, 0, '2026-01-22 05:42:32', '2026-01-22 05:42:32');

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
INSERT INTO `devices` VALUES (9, '860678079254720', 9, 100, 1, '2026-01-22 05:42:32', '2026-01-21 06:03:37', '2026-01-22 05:42:32', 0, 0, 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of growth_logs
-- ----------------------------
INSERT INTO `growth_logs` VALUES (5, 9, 'milestone', '第一次出门', '开心', NULL, '2026-01-21 06:11:57');

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of health_records
-- ----------------------------
INSERT INTO `health_records` VALUES (1, 8, 'medication', '狂犬疫苗', NULL, '2026-01-20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '屁屁', '1片', '每日2次', 30, NULL, NULL, NULL, NULL, 380.00, '生冷少吃', '2026-01-20 06:15:11', '2026-01-20 06:15:11');
INSERT INTO `health_records` VALUES (2, 9, 'vaccination', '狂犬', NULL, '2026-01-21', NULL, '六连', '2025-06-04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 300.00, '没了', '2026-01-21 06:12:59', '2026-01-21 06:12:59');

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
  `status` enum('pending','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending' COMMENT '审核状态：pending-待审核, approved-已通过, rejected-已驳回',
  `reviewed_by_id` int(11) NULL DEFAULT NULL COMMENT '审核人ID（外键关联admins表）',
  `reviewed_at` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `rejection_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '驳回原因',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `pet_id`(`pet_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE,
  INDEX `idx_moments_status`(`status`) USING BTREE,
  INDEX `idx_moments_reviewed_by`(`reviewed_by_id`) USING BTREE,
  INDEX `idx_moments_created_status`(`created_at`, `status`) USING BTREE,
  CONSTRAINT `fk_moments_reviewed_by` FOREIGN KEY (`reviewed_by_id`) REFERENCES `admins` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `moments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `moments_ibfk_2` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of moments
-- ----------------------------
INSERT INTO `moments` VALUES (3, 18, NULL, '11111', '[\"http://localhost:3003/uploads/1768821242646-157863045.png\"]', 1, 1, 0, '2026-01-19 19:14:02', '2026-01-21 09:52:11', 'approved', NULL, NULL, NULL);
INSERT INTO `moments` VALUES (4, 18, 9, '121212', '[\"http://localhost:3003/uploads/1768961071132-851550020.jpg\"]', 1, 0, 0, '2026-01-21 10:04:31', '2026-01-21 10:04:51', 'approved', 3, '2026-01-21 10:04:52', NULL);

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
