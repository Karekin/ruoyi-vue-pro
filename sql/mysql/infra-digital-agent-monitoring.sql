-- 数字专员监控系统数据库表结构
-- 用于基础设施模块的数字专员监控系统

-- 1. 数字专员活动记录表
CREATE TABLE `infra_digital_agent_activity` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '活动ID',
    `agent_type` varchar(50) NOT NULL COMMENT '专员类型',
    `activity_type` varchar(50) NOT NULL COMMENT '活动类型',
    `activity_name` varchar(100) NOT NULL COMMENT '活动名称',
    `status` varchar(20) NOT NULL COMMENT '活动状态',
    `request_data` text COMMENT '请求数据',
    `response_data` text COMMENT '响应数据',
    `response_time` bigint(20) COMMENT '响应时间（毫秒）',
    `error_message` text COMMENT '错误信息',
    `start_time` datetime NOT NULL COMMENT '开始时间',
    `end_time` datetime COMMENT '结束时间',
    `remark` varchar(500) COMMENT '备注',
    `creator` varchar(64) DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`),
    KEY `idx_agent_type` (`agent_type`),
    KEY `idx_activity_type` (`activity_type`),
    KEY `idx_status` (`status`),
    KEY `idx_start_time` (`start_time`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数字专员活动记录表';

-- 2. 数字专员统计表
CREATE TABLE `infra_digital_agent_statistics` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '统计ID',
    `agent_type` varchar(50) NOT NULL COMMENT '专员类型',
    `activity_type` varchar(50) NOT NULL COMMENT '活动类型',
    `statistics_date` date NOT NULL COMMENT '统计日期',
    `total_count` int(11) NOT NULL DEFAULT 0 COMMENT '总执行次数',
    `success_count` int(11) NOT NULL DEFAULT 0 COMMENT '成功次数',
    `failed_count` int(11) NOT NULL DEFAULT 0 COMMENT '失败次数',
    `avg_response_time` bigint(20) NOT NULL DEFAULT 0 COMMENT '平均响应时间（毫秒）',
    `max_response_time` bigint(20) NOT NULL DEFAULT 0 COMMENT '最大响应时间（毫秒）',
    `min_response_time` bigint(20) NOT NULL DEFAULT 0 COMMENT '最小响应时间（毫秒）',
    `success_rate` decimal(5,2) NOT NULL DEFAULT 0.00 COMMENT '成功率（百分比）',
    `creator` varchar(64) DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_agent_activity_date` (`agent_type`, `activity_type`, `statistics_date`),
    KEY `idx_statistics_date` (`statistics_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数字专员统计表';

-- 3. 数字专员配置表
CREATE TABLE `infra_digital_agent_config` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '配置ID',
    `agent_type` varchar(50) NOT NULL COMMENT '专员类型',
    `config_key` varchar(100) NOT NULL COMMENT '配置键',
    `config_value` varchar(500) NOT NULL COMMENT '配置值',
    `description` varchar(200) COMMENT '配置描述',
    `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
    `creator` varchar(64) DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_agent_config_key` (`agent_type`, `config_key`),
    KEY `idx_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数字专员配置表';

-- 4. 数字专员报警表
CREATE TABLE `infra_digital_agent_alert` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '报警ID',
    `agent_type` varchar(50) NOT NULL COMMENT '专员类型',
    `activity_type` varchar(50) COMMENT '活动类型',
    `alert_type` varchar(50) NOT NULL COMMENT '报警类型',
    `alert_level` varchar(20) NOT NULL COMMENT '报警级别',
    `alert_title` varchar(200) NOT NULL COMMENT '报警标题',
    `alert_content` text NOT NULL COMMENT '报警内容',
    `trigger_time` datetime NOT NULL COMMENT '触发时间',
    `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT '处理状态',
    `handler_user` varchar(64) COMMENT '处理人',
    `handler_time` datetime COMMENT '处理时间',
    `handler_remark` varchar(500) COMMENT '处理备注',
    `creator` varchar(64) DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`),
    KEY `idx_agent_type` (`agent_type`),
    KEY `idx_alert_type` (`alert_type`),
    KEY `idx_alert_level` (`alert_level`),
    KEY `idx_status` (`status`),
    KEY `idx_trigger_time` (`trigger_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数字专员报警表';

-- 5. 视图：数字专员活动统计视图
CREATE VIEW `infra_digital_agent_activity_stats` AS
SELECT 
    `agent_type`,
    `activity_type`,
    DATE(`start_time`) AS `activity_date`,
    COUNT(*) AS `total_count`,
    SUM(CASE WHEN `status` = 'SUCCESS' THEN 1 ELSE 0 END) AS `success_count`,
    SUM(CASE WHEN `status` = 'FAILED' THEN 1 ELSE 0 END) AS `failed_count`,
    ROUND(AVG(`response_time`), 2) AS `avg_response_time`,
    MAX(`response_time`) AS `max_response_time`,
    MIN(`response_time`) AS `min_response_time`,
    ROUND(SUM(CASE WHEN `status` = 'SUCCESS' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS `success_rate`
FROM `infra_digital_agent_activity`
WHERE `deleted` = b'0'
GROUP BY `agent_type`, `activity_type`, DATE(`start_time`);

-- 6. 初始化数据
INSERT INTO `infra_digital_agent_config` (`agent_type`, `config_key`, `config_value`, `description`, `enabled`) VALUES
('ERP_PURCHASE', 'execution_interval', '30', 'ERP采购专员执行间隔（分钟）', 1),
('ERP_PURCHASE', 'max_retry_count', '3', '最大重试次数', 1),
('ERP_PURCHASE', 'timeout_seconds', '300', '执行超时时间（秒）', 1),
('ERP_PURCHASE', 'failure_rate_threshold', '10', '失败率阈值（百分比）', 1),
('ERP_PURCHASE', 'response_time_threshold', '5000', '响应时间阈值（毫秒）', 1),
('ERP_PURCHASE', 'consecutive_failures_threshold', '5', '连续失败次数阈值', 1),

('ERP_SALE', 'execution_interval', '30', 'ERP销售专员执行间隔（分钟）', 1),
('ERP_SALE', 'max_retry_count', '3', '最大重试次数', 1),
('ERP_SALE', 'timeout_seconds', '300', '执行超时时间（秒）', 1),
('ERP_SALE', 'failure_rate_threshold', '10', '失败率阈值（百分比）', 1),
('ERP_SALE', 'response_time_threshold', '5000', '响应时间阈值（毫秒）', 1),
('ERP_SALE', 'consecutive_failures_threshold', '5', '连续失败次数阈值', 1),

('CRM_CUSTOMER', 'execution_interval', '60', 'CRM客户专员执行间隔（分钟）', 1),
('CRM_CUSTOMER', 'max_retry_count', '3', '最大重试次数', 1),
('CRM_CUSTOMER', 'timeout_seconds', '300', '执行超时时间（秒）', 1),
('CRM_CUSTOMER', 'failure_rate_threshold', '10', '失败率阈值（百分比）', 1),
('CRM_CUSTOMER', 'response_time_threshold', '5000', '响应时间阈值（毫秒）', 1),
('CRM_CUSTOMER', 'consecutive_failures_threshold', '5', '连续失败次数阈值', 1),

('BPM_WORKFLOW', 'execution_interval', '120', 'BPM工作流专员执行间隔（分钟）', 1),
('BPM_WORKFLOW', 'max_retry_count', '3', '最大重试次数', 1),
('BPM_WORKFLOW', 'timeout_seconds', '300', '执行超时时间（秒）', 1),
('BPM_WORKFLOW', 'failure_rate_threshold', '10', '失败率阈值（百分比）', 1),
('BPM_WORKFLOW', 'response_time_threshold', '5000', '响应时间阈值（毫秒）', 1),
('BPM_WORKFLOW', 'consecutive_failures_threshold', '5', '连续失败次数阈值', 1),

('SYSTEM_MONITOR', 'execution_interval', '10', '系统监控专员执行间隔（分钟）', 1),
('SYSTEM_MONITOR', 'max_retry_count', '3', '最大重试次数', 1),
('SYSTEM_MONITOR', 'timeout_seconds', '60', '执行超时时间（秒）', 1),
('SYSTEM_MONITOR', 'failure_rate_threshold', '5', '失败率阈值（百分比）', 1),
('SYSTEM_MONITOR', 'response_time_threshold', '3000', '响应时间阈值（毫秒）', 1),
('SYSTEM_MONITOR', 'consecutive_failures_threshold', '3', '连续失败次数阈值', 1); 