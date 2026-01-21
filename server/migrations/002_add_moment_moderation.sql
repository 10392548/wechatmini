-- =====================================================
-- 朋友圈内容审核功能
-- 版本: 1.0
-- 日期: 2026-01-21
-- =====================================================

USE pet_app;

-- -----------------------------------------------------
-- 1. 添加审核状态字段
-- -----------------------------------------------------
ALTER TABLE moments
ADD COLUMN status ENUM('pending', 'approved', 'rejected')
  DEFAULT 'pending'
  COMMENT '审核状态：pending-待审核, approved-已通过, rejected-已驳回';

-- -----------------------------------------------------
-- 2. 添加审核追踪字段
-- -----------------------------------------------------
ALTER TABLE moments
ADD COLUMN reviewed_by_id INT NULL
  COMMENT '审核人ID（外键关联admins表）',
ADD COLUMN reviewed_at TIMESTAMP NULL
  COMMENT '审核时间',
ADD COLUMN rejection_reason TEXT NULL
  COMMENT '驳回原因';

-- -----------------------------------------------------
-- 3. 添加外键约束
-- -----------------------------------------------------
ALTER TABLE moments
ADD CONSTRAINT fk_moments_reviewed_by
  FOREIGN KEY (reviewed_by_id) REFERENCES admins(id)
  ON DELETE SET NULL;

-- -----------------------------------------------------
-- 4. 添加索引优化查询
-- -----------------------------------------------------
CREATE INDEX idx_moments_status ON moments(status);
CREATE INDEX idx_moments_reviewed_by ON moments(reviewed_by_id);
CREATE INDEX idx_moments_created_status ON moments(created_at, status);

-- -----------------------------------------------------
-- 5. 将现有已发布内容标记为已通过
-- -----------------------------------------------------
UPDATE moments
SET status = 'approved'
WHERE status = 'pending';
