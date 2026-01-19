-- 健康记录表
CREATE TABLE IF NOT EXISTS `health_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pet_id` int NOT NULL,
  `record_type` enum('vaccination','illness','medication','checkup') NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text NULL,
  `record_date` date NULL,
  `end_date` date NULL,

  -- 疫苗接种专用字段
  `vaccine_name` varchar(100) NULL,
  `next_vaccination_date` date NULL,

  -- 生病记录专用字段
  `symptoms` varchar(500) NULL,
  `diagnosis` varchar(200) NULL,
  `vet_name` varchar(100) NULL,
  `hospital` varchar(200) NULL,

  -- 用药记录专用字段
  `medicine_name` varchar(100) NULL,
  `dosage` varchar(100) NULL,
  `frequency` varchar(100) NULL,
  `duration_days` int NULL,

  -- 体检记录专用字段
  `weight` decimal(5,2) NULL,
  `temperature` decimal(5,2) NULL,
  `heart_rate` int NULL,
  `checkup_result` text NULL,

  -- 通用字段
  `cost` decimal(10,2) NULL,
  `notes` text NULL,

  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  KEY `idx_pet_id` (`pet_id`),
  KEY `idx_record_type` (`record_type`),
  KEY `idx_record_date` (`record_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
