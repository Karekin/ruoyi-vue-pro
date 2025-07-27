-- 数字专员监控系统数据库脚本
-- 适用于芋道 Vue Pro 项目

-- 数字专员活动记录表
CREATE TABLE `digital_agent_activity` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
    `agent_type` varchar(50) NOT NULL COMMENT '专员类型：BPM/CRM/ERP/SYSTEM',
    `agent_name` varchar(100) NOT NULL COMMENT '专员名称',
    `activity_type` varchar(50) NOT NULL COMMENT '活动类型',
    `activity_desc` text COMMENT '活动描述',
    `business_data` json COMMENT '业务数据',
    `result_status` varchar(20) NOT NULL COMMENT '执行结果：SUCCESS/FAILED/PENDING',
    `error_message` text COMMENT '错误信息',
    `execution_time` datetime NOT NULL COMMENT '执行时间',
    `duration_ms` int COMMENT '执行耗时（毫秒）',
    `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户ID',
    `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    KEY `idx_agent_type` (`agent_type`),
    KEY `idx_execution_time` (`execution_time`),
    KEY `idx_tenant_id` (`tenant_id`),
    KEY `idx_create_time` (`create_time`),
    KEY `idx_result_status` (`result_status`)
) ENGINE=InnoDB COMMENT='数字专员活动记录表';

-- 专员统计汇总表
CREATE TABLE `digital_agent_statistics` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '统计ID',
    `agent_type` varchar(50) NOT NULL COMMENT '专员类型',
    `stat_date` date NOT NULL COMMENT '统计日期',
    `total_activities` int NOT NULL DEFAULT 0 COMMENT '总活动数',
    `success_count` int NOT NULL DEFAULT 0 COMMENT '成功数',
    `failed_count` int NOT NULL DEFAULT 0 COMMENT '失败数',
    `pending_count` int NOT NULL DEFAULT 0 COMMENT '待处理数',
    `avg_duration_ms` int COMMENT '平均耗时（毫秒）',
    `max_duration_ms` int COMMENT '最大耗时（毫秒）',
    `min_duration_ms` int COMMENT '最小耗时（毫秒）',
    `business_metrics` json COMMENT '业务指标',
    `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户ID',
    `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_agent_date_tenant` (`agent_type`, `stat_date`, `tenant_id`),
    KEY `idx_stat_date` (`stat_date`),
    KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB COMMENT='数字专员统计汇总表';

-- 专员配置表
CREATE TABLE `digital_agent_config` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID',
    `agent_type` varchar(50) NOT NULL COMMENT '专员类型',
    `agent_name` varchar(100) NOT NULL COMMENT '专员名称',
    `is_enabled` bit(1) NOT NULL DEFAULT b'1' COMMENT '是否启用',
    `schedule_config` json COMMENT '调度配置',
    `business_config` json COMMENT '业务配置',
    `notification_config` json COMMENT '通知配置',
    `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户ID',
    `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_agent_type_tenant` (`agent_type`, `tenant_id`),
    KEY `idx_is_enabled` (`is_enabled`),
    KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB COMMENT='数字专员配置表';

-- 专员告警记录表
CREATE TABLE `digital_agent_alert` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '告警ID',
    `agent_type` varchar(50) NOT NULL COMMENT '专员类型',
    `alert_type` varchar(50) NOT NULL COMMENT '告警类型：FAILURE_RATE/TIMEOUT/EXCEPTION',
    `alert_level` varchar(20) NOT NULL COMMENT '告警级别：LOW/MEDIUM/HIGH/CRITICAL',
    `alert_title` varchar(200) NOT NULL COMMENT '告警标题',
    `alert_message` text COMMENT '告警内容',
    `alert_data` json COMMENT '告警数据',
    `is_resolved` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否已解决',
    `resolved_time` datetime COMMENT '解决时间',
    `resolved_by` varchar(64) COMMENT '解决人',
    `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT '租户ID',
    `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    KEY `idx_agent_type` (`agent_type`),
    KEY `idx_alert_type` (`alert_type`),
    KEY `idx_alert_level` (`alert_level`),
    KEY `idx_is_resolved` (`is_resolved`),
    KEY `idx_create_time` (`create_time`),
    KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB COMMENT='数字专员告警记录表';

-- 邮件模板数据
INSERT INTO `system_mail_template` (`id`, `name`, `code`, `account_id`, `nickname`, `title`, `content`, `params`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(10, '数字专员日报', 'digital_agent_daily_report', 1, '数字专员监控系统', '数字专员运营日报 - {{reportDate}}', 
'<div style=\"font-family: Arial, sans-serif; margin: 20px;\">
    <div style=\"background: #4CAF50; color: white; padding: 20px; text-align: center;\">
        <h1>数字专员运营日报</h1>
        <p>{{reportDate}}</p>
    </div>
    
    <div style=\"padding: 20px;\">
        <div style=\"margin: 20px 0; border: 1px solid #ddd; padding: 15px;\">
            <h2>🔄 BPM 工作流专员</h2>
            <p>处理流程数: {{bpmTotalActivities}}</p>
            <p>成功率: {{bpmSuccessRate}}%</p>
            <p>平均耗时: {{bpmAvgDuration}}ms</p>
        </div>
        
        <div style=\"margin: 20px 0; border: 1px solid #ddd; padding: 15px;\">
            <h2>👥 CRM 客户关系专员</h2>
            <p>新增客户: {{crmCustomerCount}}</p>
            <p>跟进记录: {{crmFollowUpCount}}</p>
            <p>商机数量: {{crmOpportunityCount}}</p>
        </div>
        
        <div style=\"margin: 20px 0; border: 1px solid #ddd; padding: 15px;\">
            <h2>📦 ERP 运营专员</h2>
            <p>采购订单: {{erpPurchaseCount}}</p>
            <p>销售订单: {{erpSaleCount}}</p>
            <p>库存更新: {{erpInventoryUpdates}}</p>
        </div>
        
        <div style=\"margin: 20px 0; border: 1px solid #ddd; padding: 15px;\">
            <h2>📊 系统监控专员</h2>
            <p>健康分数: {{systemHealthScore}}</p>
            <p>响应时间: {{systemResponseTime}}ms</p>
            <p>错误率: {{systemErrorRate}}%</p>
        </div>
    </div>
</div>',
'[\"reportDate\", \"bpmTotalActivities\", \"bpmSuccessRate\", \"bpmAvgDuration\", \"crmCustomerCount\", \"crmFollowUpCount\", \"crmOpportunityCount\", \"erpPurchaseCount\", \"erpSaleCount\", \"erpInventoryUpdates\", \"systemHealthScore\", \"systemResponseTime\", \"systemErrorRate\"]',
1, '数字专员监控系统日报邮件模板', '1', NOW(), '1', NOW(), b'0');

-- 初始化专员配置数据
INSERT INTO `digital_agent_config` (`agent_type`, `agent_name`, `is_enabled`, `schedule_config`, `business_config`, `notification_config`, `tenant_id`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
('BPM', 'BPM工作流专员', b'1', 
'{"cron": "0 0 */2 * * ?", "timezone": "Asia/Shanghai"}',
'{"processTypes": ["oa_leave", "purchase_approval", "expense_claim"], "dailyTarget": 10, "approvalRate": 0.8}',
'{"email": true, "webhook": false, "alertThreshold": 0.1}',
1, '1', NOW(), '1', NOW(), b'0'),

('CRM', 'CRM客户关系专员', b'1',
'{"cron": "0 0 9,14,17 * * ?", "timezone": "Asia/Shanghai"}',
'{"dailyCustomers": 5, "followUpRate": 0.7, "conversionRate": 0.15}',
'{"email": true, "webhook": false, "alertThreshold": 0.1}',
1, '1', NOW(), '1', NOW(), b'0'),

('ERP', 'ERP运营专员', b'1',
'{"cron": "0 30 10,15 * * ?", "timezone": "Asia/Shanghai"}',
'{"dailyPurchaseOrders": 3, "dailySaleOrders": 8, "inventoryCheckInterval": 1}',
'{"email": true, "webhook": false, "alertThreshold": 0.1}',
1, '1', NOW(), '1', NOW(), b'0'),

('SYSTEM', '系统监控专员', b'1',
'{"cron": "0 */10 * * * ?", "timezone": "Asia/Shanghai"}',
'{"healthCheckInterval": 10, "performanceThreshold": 5000, "errorRateThreshold": 0.05}',
'{"email": true, "webhook": true, "alertThreshold": 0.02}',
1, '1', NOW(), '1', NOW(), b'0');

-- 创建视图用于统计查询
CREATE VIEW `digital_agent_dashboard_view` AS
SELECT 
    agent_type,
    DATE(execution_time) as exec_date,
    COUNT(*) as total_count,
    SUM(CASE WHEN result_status = 'SUCCESS' THEN 1 ELSE 0 END) as success_count,
    SUM(CASE WHEN result_status = 'FAILED' THEN 1 ELSE 0 END) as failed_count,
    SUM(CASE WHEN result_status = 'PENDING' THEN 1 ELSE 0 END) as pending_count,
    AVG(duration_ms) as avg_duration,
    MAX(duration_ms) as max_duration,
    MIN(duration_ms) as min_duration,
    ROUND(SUM(CASE WHEN result_status = 'SUCCESS' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as success_rate
FROM digital_agent_activity
WHERE deleted = 0
GROUP BY agent_type, DATE(execution_time);

-- 创建存储过程用于统计数据汇总
DELIMITER $$

CREATE PROCEDURE `StatisticsDigitalAgentDaily`(IN stat_date DATE)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE agent_type_var VARCHAR(50);
    DECLARE agent_cursor CURSOR FOR 
        SELECT DISTINCT agent_type FROM digital_agent_activity WHERE DATE(execution_time) = stat_date;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN agent_cursor;
    
    read_loop: LOOP
        FETCH agent_cursor INTO agent_type_var;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        INSERT INTO digital_agent_statistics (
            agent_type, stat_date, total_activities, success_count, failed_count, pending_count,
            avg_duration_ms, max_duration_ms, min_duration_ms, business_metrics, tenant_id, creator, updater
        )
        SELECT 
            agent_type_var,
            stat_date,
            COUNT(*),
            SUM(CASE WHEN result_status = 'SUCCESS' THEN 1 ELSE 0 END),
            SUM(CASE WHEN result_status = 'FAILED' THEN 1 ELSE 0 END),
            SUM(CASE WHEN result_status = 'PENDING' THEN 1 ELSE 0 END),
            AVG(duration_ms),
            MAX(duration_ms),
            MIN(duration_ms),
            JSON_OBJECT(
                'successRate', ROUND(SUM(CASE WHEN result_status = 'SUCCESS' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2),
                'errorRate', ROUND(SUM(CASE WHEN result_status = 'FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2),
                'activities', JSON_ARRAYAGG(activity_type)
            ),
            1,
            '1',
            '1'
        FROM digital_agent_activity 
        WHERE agent_type = agent_type_var AND DATE(execution_time) = stat_date
        ON DUPLICATE KEY UPDATE
            total_activities = VALUES(total_activities),
            success_count = VALUES(success_count),
            failed_count = VALUES(failed_count),
            pending_count = VALUES(pending_count),
            avg_duration_ms = VALUES(avg_duration_ms),
            max_duration_ms = VALUES(max_duration_ms),
            min_duration_ms = VALUES(min_duration_ms),
            business_metrics = VALUES(business_metrics),
            updater = '1',
            update_time = NOW();
    END LOOP;
    
    CLOSE agent_cursor;
END$$

DELIMITER ;

-- 创建定时任务用于每日统计（需要开启事件调度器）
-- SET GLOBAL event_scheduler = ON;

CREATE EVENT IF NOT EXISTS `digital_agent_daily_statistics_event`
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE + INTERVAL 1 DAY, '01:00:00')
DO
  CALL StatisticsDigitalAgentDaily(DATE_SUB(CURDATE(), INTERVAL 1 DAY)); 