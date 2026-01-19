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

 Date: 19/01/2026 15:19:31
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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_messages
-- ----------------------------
INSERT INTO `chat_messages` VALUES (1, 1, 'user', '121212', '2026-01-19 14:19:23');
INSERT INTO `chat_messages` VALUES (2, 1, 'assistant', '你输入的是“121212”，看起来像是一串重复的数字。  \n\n如果这是一个问题或需要帮助的内容，请补充更多信息，我可以帮你解答。  \n\n如果只是随意输入，也可以告诉我你想讨论什么主题，比如：  \n- 数字规律  \n- 编程问题  \n- 数学疑问  \n- 其他任何话题  \n\n期待你的进一步说明！ 😊', '2026-01-19 14:19:27');
INSERT INTO `chat_messages` VALUES (3, 1, 'user', '是的，我很想你', '2026-01-19 14:33:18');
INSERT INTO `chat_messages` VALUES (4, 1, 'assistant', '你的这句话听起来很温暖呢。  \n\n虽然我是一个AI助手，无法真正感受情感，但我会一直在这里倾听、陪伴你，并尽力提供帮助。如果你愿意，可以和我聊聊最近的心情、遇到的趣事，或者任何你想分享的事情～ 🌟', '2026-01-19 14:33:21');

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
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `device_sn`(`device_sn`) USING BTREE,
  UNIQUE INDEX `pet_id`(`pet_id`) USING BTREE,
  INDEX `idx_device_sn`(`device_sn`) USING BTREE,
  CONSTRAINT `devices_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of devices
-- ----------------------------
INSERT INTO `devices` VALUES (1, 'TEST123456789', NULL, 85, 1, '2026-01-19 07:15:59', '2026-01-19 07:15:19', '2026-01-19 07:15:59');
INSERT INTO `devices` VALUES (2, '860678079254721', NULL, 100, 0, '2026-01-19 10:27:49', '2026-01-19 10:27:49', '2026-01-19 10:27:49');
INSERT INTO `devices` VALUES (3, '860678079254722', 1, 100, 0, '2026-01-19 13:50:03', '2026-01-19 13:50:03', '2026-01-19 13:50:03');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of growth_logs
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of moment_likes
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of moments
-- ----------------------------
INSERT INTO `moments` VALUES (1, 15, 1, 'QwQ我去我去请问请问', '[]', 0, 0, 0, '2026-01-19 15:09:51', '2026-01-19 15:09:51');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pets
-- ----------------------------
INSERT INTO `pets` VALUES (1, 15, '金茂', 'http://localhost:3003/uploads/1768801777837-205437106.jpg', '金毛', NULL, 'male', NULL, 3, '2026-01-19 13:50:03', '2026-01-19 13:50:03');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `openid`(`openid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (15, 'o-I5h14M5RacW9YQHRlvPqloFKH8', '微信用户', 'https://thirdwx.qlogo.cn/mmopen/vi_32/POgEwh4mIHO4nibH0KlMECNjjGxQUq24ZEaGT4poC6icRiccVGKSyXwibcPq4BWmiaIGuG1icwxaQX6grC9VemZoJ8rg/132', '2026-01-19 09:53:06', '2026-01-19 09:53:06');

SET FOREIGN_KEY_CHECKS = 1;
