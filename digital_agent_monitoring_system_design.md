# 数字专员运营监控系统设计文档

## 1. 系统概述

基于芋道项目的多模块架构，设计实现一个自动化的数字专员运营监控系统。通过n8n工作流引擎，模拟各个业务模块的数字专员，自动执行运营活动并记录监控数据。

## 2. 数字专员角色定义

### 2.1 BPM 工作流专员 (BPM Digital Agent)
**职责：** 
- 监控工作流实例的创建和执行
- 跟踪任务状态变化
- 模拟流程审批操作
- 监控流程超时和异常

**模拟活动：**
- 每日创建 5-10 个测试工作流实例
- 自动审批待办任务
- 模拟流程驳回和重新提交
- 监控流程性能指标

### 2.2 CRM 客户关系专员 (CRM Digital Agent)
**职责：**
- 管理客户生命周期
- 跟进销售机会
- 处理客户咨询
- 维护客户关系

**模拟活动：**
- 每日创建 3-5 个新客户
- 更新客户跟进记录
- 创建销售机会
- 模拟客户转化流程
- 处理客户投诉和反馈

### 2.3 ERP 运营专员 (ERP Digital Agent)
**职责：**
- 处理采购和销售订单
- 管理库存和产品信息
- 监控财务流水
- 优化供应链

**模拟活动：**
- 每日创建 2-3 个采购订单
- 处理 5-8 个销售订单
- 更新库存信息
- 生成财务报表
- 监控库存预警

### 2.4 系统监控专员 (System Monitor Agent)
**职责：**
- 监控系统性能指标
- 分析用户行为数据
- 跟踪系统异常
- 生成运营报告

**模拟活动：**
- 实时监控系统状态
- 分析用户访问模式
- 检测性能瓶颈
- 生成日报和周报

## 3. 数据记录方案

### 3.1 活动记录表结构

```sql
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
    `tenant_id` bigint COMMENT '租户ID',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_agent_type` (`agent_type`),
    KEY `idx_execution_time` (`execution_time`),
    KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB COMMENT='数字专员活动记录表';

-- 专员统计汇总表
CREATE TABLE `digital_agent_statistics` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '统计ID',
    `agent_type` varchar(50) NOT NULL COMMENT '专员类型',
    `stat_date` date NOT NULL COMMENT '统计日期',
    `total_activities` int NOT NULL DEFAULT 0 COMMENT '总活动数',
    `success_count` int NOT NULL DEFAULT 0 COMMENT '成功数',
    `failed_count` int NOT NULL DEFAULT 0 COMMENT '失败数',
    `avg_duration_ms` int COMMENT '平均耗时（毫秒）',
    `business_metrics` json COMMENT '业务指标',
    `tenant_id` bigint COMMENT '租户ID',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_agent_date_tenant` (`agent_type`, `stat_date`, `tenant_id`)
) ENGINE=InnoDB COMMENT='数字专员统计汇总表';
```

### 3.2 活动类型定义

```java
// 活动类型枚举
public enum DigitalAgentActivityType {
    // BPM 活动
    BPM_PROCESS_CREATE("BPM_PROCESS_CREATE", "创建工作流实例"),
    BPM_TASK_APPROVE("BPM_TASK_APPROVE", "审批任务"),
    BPM_TASK_REJECT("BPM_TASK_REJECT", "驳回任务"),
    BPM_PROCESS_MONITOR("BPM_PROCESS_MONITOR", "监控流程状态"),
    
    // CRM 活动
    CRM_CUSTOMER_CREATE("CRM_CUSTOMER_CREATE", "创建客户"),
    CRM_CUSTOMER_FOLLOW("CRM_CUSTOMER_FOLLOW", "跟进客户"),
    CRM_OPPORTUNITY_CREATE("CRM_OPPORTUNITY_CREATE", "创建销售机会"),
    CRM_LEAD_CONVERT("CRM_LEAD_CONVERT", "转化线索"),
    
    // ERP 活动
    ERP_PURCHASE_ORDER("ERP_PURCHASE_ORDER", "创建采购订单"),
    ERP_SALE_ORDER("ERP_SALE_ORDER", "创建销售订单"),
    ERP_INVENTORY_UPDATE("ERP_INVENTORY_UPDATE", "更新库存"),
    ERP_FINANCE_REPORT("ERP_FINANCE_REPORT", "生成财务报表"),
    
    // 系统监控活动
    SYSTEM_HEALTH_CHECK("SYSTEM_HEALTH_CHECK", "系统健康检查"),
    SYSTEM_PERFORMANCE_MONITOR("SYSTEM_PERFORMANCE_MONITOR", "性能监控"),
    SYSTEM_USER_ANALYSIS("SYSTEM_USER_ANALYSIS", "用户行为分析");
}
```

## 4. n8n 工作流设计

### 4.1 基础工作流模板

每个数字专员都有一个基础的工作流模板，包含以下节点：

1. **定时触发器** - 设置执行频率
2. **数据准备** - 准备模拟数据
3. **业务执行** - 调用系统API执行业务操作
4. **结果记录** - 记录执行结果到数据库
5. **异常处理** - 处理执行异常
6. **通知发送** - 发送通知邮件/消息

### 4.2 BPM 专员工作流

```json
{
  "name": "BPM Digital Agent Workflow",
  "nodes": [
    {
      "name": "Schedule Trigger",
      "type": "n8n-nodes-base.cron",
      "parameters": {
        "rule": {
          "hour": "*/2",
          "minute": "0"
        }
      }
    },
    {
      "name": "Generate Test Data",
      "type": "n8n-nodes-base.code",
      "parameters": {
        "jsCode": "// 生成测试流程数据\nconst processTypes = ['oa_leave', 'purchase_approval', 'expense_claim'];\nconst randomType = processTypes[Math.floor(Math.random() * processTypes.length)];\n\nreturn [{\n  processType: randomType,\n  applicant: 'digital_agent_' + Math.floor(Math.random() * 100),\n  data: {\n    amount: Math.floor(Math.random() * 10000),\n    reason: '数字专员模拟申请',\n    startTime: new Date().toISOString()\n  }\n}];"
      }
    },
    {
      "name": "Create Process Instance",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://localhost:8080/admin-api/bpm/process-instance/create",
        "method": "POST",
        "headers": {
          "Content-Type": "application/json",
          "Authorization": "Bearer {{$env.ADMIN_TOKEN}}"
        },
        "body": {
          "processDefinitionKey": "={{$json.processType}}",
          "variables": "={{$json.data}}"
        }
      }
    },
    {
      "name": "Record Activity",
      "type": "n8n-nodes-base.mysql",
      "parameters": {
        "operation": "insert",
        "table": "digital_agent_activity",
        "columns": "agent_type,agent_name,activity_type,activity_desc,business_data,result_status,execution_time,duration_ms",
        "values": "='BPM','BPM数字专员','BPM_PROCESS_CREATE','创建工作流实例',JSON_OBJECT('processType', '{{$json.processType}}', 'instanceId', '{{$json.instanceId}}'),'SUCCESS',NOW(),{{$json.duration}}'"
      }
    }
  ],
  "connections": {
    "Schedule Trigger": {
      "main": [["Generate Test Data"]]
    },
    "Generate Test Data": {
      "main": [["Create Process Instance"]]
    },
    "Create Process Instance": {
      "main": [["Record Activity"]]
    }
  }
}
```

### 4.3 CRM 专员工作流

```json
{
  "name": "CRM Digital Agent Workflow",
  "nodes": [
    {
      "name": "Daily Customer Activities",
      "type": "n8n-nodes-base.cron",
      "parameters": {
        "rule": {
          "hour": "9,14,17",
          "minute": "0"
        }
      }
    },
    {
      "name": "Choose Activity Type",
      "type": "n8n-nodes-base.code",
      "parameters": {
        "jsCode": "const activities = [\n  'create_customer',\n  'follow_customer',\n  'create_opportunity',\n  'convert_lead'\n];\n\nconst activity = activities[Math.floor(Math.random() * activities.length)];\nreturn [{ activityType: activity }];"
      }
    },
    {
      "name": "Create Customer",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://localhost:8080/admin-api/crm/customer/create",
        "method": "POST",
        "headers": {
          "Content-Type": "application/json",
          "Authorization": "Bearer {{$env.ADMIN_TOKEN}}"
        },
        "body": {
          "name": "数字客户_{{Math.floor(Math.random() * 1000)}}",
          "mobile": "138{{Math.floor(Math.random() * 100000000).toString().padStart(8, '0')}}",
          "industryId": "={{Math.floor(Math.random() * 10) + 1}}",
          "source": "1",
          "ownerUserId": "1"
        }
      }
    },
    {
      "name": "Record CRM Activity",
      "type": "n8n-nodes-base.mysql",
      "parameters": {
        "operation": "insert",
        "table": "digital_agent_activity",
        "columns": "agent_type,agent_name,activity_type,activity_desc,business_data,result_status,execution_time",
        "values": "='CRM','CRM数字专员','CRM_CUSTOMER_CREATE','创建客户',JSON_OBJECT('customerName', '{{$json.name}}', 'customerId', '{{$json.id}}'),'SUCCESS',NOW()'"
      }
    }
  ]
}
```

### 4.4 ERP 专员工作流

```json
{
  "name": "ERP Digital Agent Workflow",
  "nodes": [
    {
      "name": "Business Hours Trigger",
      "type": "n8n-nodes-base.cron",
      "parameters": {
        "rule": {
          "hour": "10,15",
          "minute": "30"
        }
      }
    },
    {
      "name": "Generate Order Data",
      "type": "n8n-nodes-base.code",
      "parameters": {
        "jsCode": "const orderTypes = ['purchase', 'sale'];\nconst type = orderTypes[Math.floor(Math.random() * orderTypes.length)];\n\nif (type === 'purchase') {\n  return [{\n    type: 'purchase',\n    supplierId: Math.floor(Math.random() * 10) + 1,\n    items: [\n      {\n        productId: Math.floor(Math.random() * 50) + 1,\n        count: Math.floor(Math.random() * 100) + 1,\n        price: Math.floor(Math.random() * 1000) + 100\n      }\n    ]\n  }];\n} else {\n  return [{\n    type: 'sale',\n    customerId: Math.floor(Math.random() * 10) + 1,\n    items: [\n      {\n        productId: Math.floor(Math.random() * 50) + 1,\n        count: Math.floor(Math.random() * 50) + 1,\n        price: Math.floor(Math.random() * 2000) + 500\n      }\n    ]\n  }];\n}"
      }
    },
    {
      "name": "Create Purchase Order",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://localhost:8080/admin-api/erp/purchase-order/create",
        "method": "POST",
        "headers": {
          "Content-Type": "application/json",
          "Authorization": "Bearer {{$env.ADMIN_TOKEN}}"
        },
        "body": {
          "supplierId": "={{$json.supplierId}}",
          "items": "={{$json.items}}"
        }
      }
    },
    {
      "name": "Create Sale Order",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "http://localhost:8080/admin-api/erp/sale-order/create",
        "method": "POST",
        "headers": {
          "Content-Type": "application/json",
          "Authorization": "Bearer {{$env.ADMIN_TOKEN}}"
        },
        "body": {
          "customerId": "={{$json.customerId}}",
          "items": "={{$json.items}}"
        }
      }
    }
  ]
}
```

## 5. 通知系统设计

### 5.1 邮件通知模板

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>数字专员运营日报</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #4CAF50; color: white; padding: 20px; text-align: center; }
        .content { padding: 20px; }
        .agent-section { margin: 20px 0; border: 1px solid #ddd; padding: 15px; }
        .metrics { display: flex; justify-content: space-around; margin: 15px 0; }
        .metric { text-align: center; }
        .metric-value { font-size: 24px; font-weight: bold; color: #4CAF50; }
        .metric-label { font-size: 14px; color: #666; }
        .alert { background: #ffeb3b; padding: 10px; margin: 10px 0; border-radius: 4px; }
        .error { background: #f44336; color: white; padding: 10px; margin: 10px 0; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>数字专员运营日报</h1>
        <p>{{reportDate}}</p>
    </div>
    
    <div class="content">
        <div class="agent-section">
            <h2>🔄 BPM 工作流专员</h2>
            <div class="metrics">
                <div class="metric">
                    <div class="metric-value">{{bpmTotalActivities}}</div>
                    <div class="metric-label">处理流程数</div>
                </div>
                <div class="metric">
                    <div class="metric-value">{{bpmSuccessRate}}%</div>
                    <div class="metric-label">成功率</div>
                </div>
                <div class="metric">
                    <div class="metric-value">{{bpmAvgDuration}}ms</div>
                    <div class="metric-label">平均耗时</div>
                </div>
            </div>
            <p>今日主要活动：创建了 {{bpmProcessCount}} 个工作流实例，审批了 {{bpmApprovalCount}} 个任务</p>
        </div>
        
        <div class="agent-section">
            <h2>👥 CRM 客户关系专员</h2>
            <div class="metrics">
                <div class="metric">
                    <div class="metric-value">{{crmCustomerCount}}</div>
                    <div class="metric-label">新增客户</div>
                </div>
                <div class="metric">
                    <div class="metric-value">{{crmOpportunityCount}}</div>
                    <div class="metric-label">新增机会</div>
                </div>
                <div class="metric">
                    <div class="metric-value">{{crmFollowUpCount}}</div>
                    <div class="metric-label">跟进记录</div>
                </div>
            </div>
            <p>今日主要活动：新增客户 {{crmCustomerCount}} 个，跟进客户 {{crmFollowUpCount}} 次</p>
        </div>
        
        <div class="agent-section">
            <h2>📦 ERP 运营专员</h2>
            <div class="metrics">
                <div class="metric">
                    <div class="metric-value">{{erpPurchaseCount}}</div>
                    <div class="metric-label">采购订单</div>
                </div>
                <div class="metric">
                    <div class="metric-value">{{erpSaleCount}}</div>
                    <div class="metric-label">销售订单</div>
                </div>
                <div class="metric">
                    <div class="metric-value">{{erpInventoryUpdates}}</div>
                    <div class="metric-label">库存更新</div>
                </div>
            </div>
            <p>今日主要活动：处理采购订单 {{erpPurchaseCount}} 个，销售订单 {{erpSaleCount}} 个</p>
        </div>
        
        <div class="agent-section">
            <h2>📊 系统监控专员</h2>
            <div class="metrics">
                <div class="metric">
                    <div class="metric-value">{{systemHealthScore}}</div>
                    <div class="metric-label">健康分数</div>
                </div>
                <div class="metric">
                    <div class="metric-value">{{systemResponseTime}}ms</div>
                    <div class="metric-label">响应时间</div>
                </div>
                <div class="metric">
                    <div class="metric-value">{{systemErrorRate}}%</div>
                    <div class="metric-label">错误率</div>
                </div>
            </div>
            <p>今日主要活动：执行了 {{systemHealthChecks}} 次健康检查，发现 {{systemAlerts}} 个告警</p>
        </div>
        
        {{#if alerts}}
        <div class="agent-section">
            <h2>⚠️ 告警信息</h2>
            {{#each alerts}}
            <div class="alert">
                <strong>{{this.type}}</strong>: {{this.message}} ({{this.time}})
            </div>
            {{/each}}
        </div>
        {{/if}}
        
        {{#if errors}}
        <div class="agent-section">
            <h2>❌ 错误信息</h2>
            {{#each errors}}
            <div class="error">
                <strong>{{this.agent}}</strong>: {{this.error}} ({{this.time}})
            </div>
            {{/each}}
        </div>
        {{/if}}
    </div>
</body>
</html>
```

### 5.2 钉钉/企业微信通知

```json
{
  "msgtype": "markdown",
  "markdown": {
    "title": "数字专员运营日报",
    "text": "# 数字专员运营日报\n\n**日期**: {{reportDate}}\n\n## 📊 总体概况\n- 🔄 BPM专员: 处理 {{bpmTotalActivities}} 个流程\n- 👥 CRM专员: 新增 {{crmCustomerCount}} 个客户\n- 📦 ERP专员: 处理 {{erpOrderCount}} 个订单\n- 📊 系统专员: 健康分数 {{systemHealthScore}}\n\n## 🎯 关键指标\n- 总活动数: {{totalActivities}}\n- 成功率: {{overallSuccessRate}}%\n- 平均响应时间: {{avgResponseTime}}ms\n\n---\n\n> 系统运行正常，如有异常请及时处理"
  }
}
```

## 6. 监控面板设计

### 6.1 实时监控指标

- **活动总数**: 实时统计各专员的活动数量
- **成功率**: 计算各专员的成功率趋势
- **响应时间**: 监控系统响应时间分布
- **错误率**: 跟踪系统错误率变化
- **业务指标**: 各模块的核心业务指标

### 6.2 告警规则

- 专员活动失败率超过 10%
- 系统响应时间超过 5 秒
- 连续 3 次活动失败
- 数据库连接异常
- 内存使用率超过 80%

## 7. 部署和配置

### 7.1 环境要求

- n8n 版本：最新稳定版
- 数据库：MySQL 8.0+
- 运行环境：Node.js 18+
- 内存：建议 2GB+

### 7.2 配置文件

```env
# n8n 配置
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http

# 数据库配置
DB_TYPE=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=yudao_vue_pro
DB_USERNAME=root
DB_PASSWORD=123456

# 系统配置
SYSTEM_BASE_URL=http://localhost:8080
ADMIN_TOKEN=your_admin_token
MAIL_HOST=smtp.163.com
MAIL_PORT=587
MAIL_USERNAME=your_email@163.com
MAIL_PASSWORD=your_password

# 钉钉/企业微信配置
DINGTALK_WEBHOOK_URL=https://oapi.dingtalk.com/robot/send?access_token=xxx
WECHAT_WEBHOOK_URL=https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxx
```

### 7.3 启动脚本

```bash
#!/bin/bash
# start_digital_agents.sh

echo "启动数字专员监控系统..."

# 启动 n8n
n8n start &

# 等待 n8n 启动
sleep 10

# 导入工作流
echo "导入数字专员工作流..."
n8n import:workflow --input=./workflows/bpm_agent.json
n8n import:workflow --input=./workflows/crm_agent.json
n8n import:workflow --input=./workflows/erp_agent.json
n8n import:workflow --input=./workflows/system_monitor.json

# 启动工作流
echo "启动数字专员工作流..."
n8n start:workflow --name="BPM Digital Agent Workflow"
n8n start:workflow --name="CRM Digital Agent Workflow"
n8n start:workflow --name="ERP Digital Agent Workflow"
n8n start:workflow --name="System Monitor Workflow"

echo "数字专员监控系统启动完成！"
echo "访问地址: http://localhost:5678"
```

## 8. 扩展建议

### 8.1 AI 增强

- 集成 GPT 模型，生成更智能的模拟数据
- 使用机器学习优化专员决策逻辑
- 实现自然语言处理的告警分析

### 8.2 多租户支持

- 为不同租户配置独立的数字专员
- 实现租户级别的监控和统计
- 支持租户自定义专员行为

### 8.3 移动端支持

- 开发移动端监控应用
- 实现推送通知功能
- 支持移动端告警处理

### 8.4 高可用部署

- 支持 n8n 集群部署
- 实现数据库主从复制
- 配置负载均衡和故障转移

这个设计提供了一个完整的数字专员监控系统框架，可以根据实际需求进行调整和扩展。系统通过模拟真实用户行为，帮助您了解系统的整体运行状况，并及时发现潜在问题。 