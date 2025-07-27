# 基础设施模块数字专员监控系统

## 概述

本系统将数字专员监控系统作为基础设施模块的一部分，集成到 `yudao-module-infra` 模块中，为整个若依系统提供数字专员监控能力。

## 架构更新

### 1. 模块结构

```
yudao-module-infra/
├── src/main/java/cn/iocoder/yudao/module/infra/
│   ├── controller/admin/digitalagent/     # 数字专员控制器
│   ├── service/digitalagent/              # 数字专员服务
│   ├── dal/dataobject/digitalagent/       # 数字专员数据对象
│   ├── dal/mysql/digitalagent/            # 数字专员Mapper
│   └── enums/digitalagent/                # 数字专员枚举
```

### 2. 核心组件

#### 实体类（DO）
- `InfraDigitalAgentActivityDO` - 数字专员活动记录
- `InfraDigitalAgentStatisticsDO` - 数字专员统计数据
- `InfraDigitalAgentConfigDO` - 数字专员配置
- `InfraDigitalAgentAlertDO` - 数字专员报警记录

#### 枚举类
- `DigitalAgentTypeEnum` - 数字专员类型（ERP采购、ERP销售、CRM客户、BPM工作流、系统监控）
- `DigitalAgentActivityTypeEnum` - 活动类型（创建订单、查询数据、审核流程等）
- `DigitalAgentActivityStatusEnum` - 活动状态（待执行、执行中、成功、失败、取消）
- `DigitalAgentAlertTypeEnum` - 报警类型（失败率高、响应时间慢、连续失败等）
- `DigitalAgentAlertLevelEnum` - 报警级别（信息、警告、错误、严重）
- `DigitalAgentAlertStatusEnum` - 报警状态（待处理、处理中、已解决、已忽略）

#### 服务接口
- `InfraDigitalAgentService` - 数字专员监控服务接口
- `InfraDigitalAgentServiceImpl` - 数字专员监控服务实现

#### 控制器
- `InfraDigitalAgentController` - 数字专员监控API控制器

### 3. 数据库表

| 表名 | 描述 | 主要字段 |
|------|------|----------|
| `infra_digital_agent_activity` | 数字专员活动记录表 | id, agent_type, activity_type, status, request_data, response_data, response_time |
| `infra_digital_agent_statistics` | 数字专员统计表 | id, agent_type, activity_type, statistics_date, total_count, success_count, success_rate |
| `infra_digital_agent_config` | 数字专员配置表 | id, agent_type, config_key, config_value, enabled |
| `infra_digital_agent_alert` | 数字专员报警表 | id, agent_type, alert_type, alert_level, alert_title, alert_content, status |

## ERP采购管理专员

### 功能特性

1. **采购订单管理**
   - 创建采购订单
   - 查询采购订单状态
   - 审核采购订单

2. **采购入库管理**
   - 创建采购入库单
   - 处理入库确认
   - 库存状态更新

3. **采购退货管理**
   - 创建采购退货单
   - 处理退货审批
   - 退货原因记录

4. **供应商管理**
   - 创建供应商档案
   - 更新供应商信息
   - 查询供应商状态

### n8n工作流特点

1. **不使用全局变量**
   - 所有数据通过节点间传递
   - 配置信息通过环境变量获取
   - 状态信息通过数据库存储

2. **严格按照项目controller定义**
   - 使用真实的API路径：`/admin-api/erp/purchase-order/create`
   - 遵循项目的请求参数格式
   - 处理标准的响应格式

3. **完整的活动监控**
   - 记录活动开始时间
   - 记录执行结果和响应时间
   - 支持成功/失败状态记录
   - 提供详细的错误信息

### 执行调度

- **执行时间**: 每天上午9点、下午2点、下午5点
- **活动权重**: 采购订单创建(30%) > 采购入库(25%) > 采购退货(20%) > 供应商创建(15%) > 供应商查询(10%)
- **错误处理**: 支持失败重试和异常记录

## API接口

### 数字专员监控API

| 接口 | 方法 | 描述 |
|------|------|------|
| `/infra/digital-agent/create` | POST | 创建数字专员活动记录 |
| `/infra/digital-agent/update` | PUT | 更新数字专员活动记录 |
| `/infra/digital-agent/get` | GET | 获取数字专员活动记录 |
| `/infra/digital-agent/page` | GET | 分页查询数字专员活动记录 |
| `/infra/digital-agent/record-start` | POST | 记录数字专员活动开始 |
| `/infra/digital-agent/record-success` | POST | 记录数字专员活动成功 |
| `/infra/digital-agent/record-failed` | POST | 记录数字专员活动失败 |
| `/infra/digital-agent/statistics` | GET | 获取数字专员统计数据 |
| `/infra/digital-agent/generate-daily-statistics` | POST | 生成每日统计 |
| `/infra/digital-agent/check-alerts` | POST | 检查并触发报警 |

### 使用的ERP API

| 接口 | 方法 | 描述 |
|------|------|------|
| `/admin-api/erp/purchase-order/create` | POST | 创建采购订单 |
| `/admin-api/erp/purchase-order/page` | GET | 分页查询采购订单 |
| `/admin-api/erp/purchase-order/get` | GET | 获取采购订单详情 |
| `/admin-api/erp/purchase-in/create` | POST | 创建采购入库 |
| `/admin-api/erp/purchase-return/create` | POST | 创建采购退货 |
| `/admin-api/erp/supplier/create` | POST | 创建供应商 |
| `/admin-api/erp/supplier/page` | GET | 分页查询供应商 |
| `/admin-api/erp/supplier/simple-list` | GET | 获取供应商简单列表 |

## 配置说明

### 环境变量配置

在 `n8n-infra.env` 文件中配置：

```bash
# 若依系统配置
YUDAO_API_BASE_URL=http://localhost:8080
YUDAO_TENANT_ID=1
YUDAO_USERNAME=admin
YUDAO_PASSWORD=admin123

# ERP采购专员配置
ERP_PURCHASE_AGENT_ENABLED=true
ERP_PURCHASE_AGENT_SCHEDULE=0 0 9,14,17 * * ?
ERP_PURCHASE_AGENT_TIMEOUT=300000
ERP_PURCHASE_AGENT_RETRY_COUNT=3
ERP_PURCHASE_AGENT_BATCH_SIZE=5
```

### 数据库配置

执行数据库初始化脚本：

```sql
-- 执行数据库表创建
mysql -u root -p ruoyi-vue-pro < sql/mysql/infra-digital-agent-monitoring.sql
```

## 部署指南

### 1. 数据库初始化

```bash
# 1. 导入数据库表结构
mysql -u root -p ruoyi-vue-pro < sql/mysql/infra-digital-agent-monitoring.sql

# 2. 验证表创建
mysql -u root -p ruoyi-vue-pro -e "SHOW TABLES LIKE 'infra_digital_agent_%'"
```

### 2. 若依系统部署

```bash
# 1. 编译项目
mvn clean package -DskipTests

# 2. 启动项目
java -jar yudao-server/target/yudao-server.jar

# 3. 验证API可用性
curl -X POST "http://localhost:8080/admin-api/system/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123","tenantId":"1"}'
```

### 3. n8n部署

```bash
# 1. 启动n8n
docker run -d \
  --name n8n-digital-agent \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=admin123 \
  -v n8n_data:/home/node/.n8n \
  --env-file n8n-infra.env \
  n8nio/n8n

# 2. 访问n8n界面
open http://localhost:5678

# 3. 导入工作流
# 在n8n界面中导入 workflows/n8n/erp_purchase_agent.json
```

### 4. 验证部署

```bash
# 1. 检查数字专员API
curl -X GET "http://localhost:8080/infra/digital-agent/statistics?startDate=2024-01-01&endDate=2024-12-31" \
  -H "Authorization: Bearer YOUR_TOKEN"

# 2. 检查n8n工作流
curl -X GET "http://localhost:5678/rest/workflows" \
  -H "Authorization: Basic YWRtaW46YWRtaW4xMjM="

# 3. 手动触发工作流测试
curl -X POST "http://localhost:5678/rest/workflows/erp-purchase-agent/activate" \
  -H "Authorization: Basic YWRtaW46YWRtaW4xMjM="
```

## 监控与报警

### 1. 活动监控

- **实时监控**: 每分钟检查活动执行状态
- **失败率监控**: 失败率超过10%触发报警
- **响应时间监控**: 响应时间超过5秒触发报警
- **连续失败监控**: 连续失败超过5次触发报警

### 2. 报警通知

- **邮件通知**: 支持SMTP邮件发送
- **钉钉通知**: 支持钉钉群机器人通知
- **企业微信通知**: 支持企业微信群机器人通知

### 3. 统计报表

- **每日统计**: 每天凌晨1点生成前一天的统计数据
- **邮件报表**: 每天上午8点发送统计邮件
- **数据清理**: 活动数据保留30天，统计数据保留90天

## 权限配置

### 1. 菜单权限

```sql
-- 数字专员监控菜单
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status) VALUES
('数字专员监控', 'infra:digital-agent:query', 1, 1, 2, 'digital-agent', 'monitor', 'infra/digitalagent/index', 0);

-- 数字专员活动记录菜单
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, status) VALUES
('活动记录', 'infra:digital-agent:query', 1, 1, LAST_INSERT_ID(), 'activity', 'log', 'infra/digitalagent/activity', 0);
```

### 2. 操作权限

```sql
-- 数字专员监控权限
INSERT INTO system_menu (name, permission, type, sort, parent_id, status) VALUES
('数字专员监控查询', 'infra:digital-agent:query', 3, 1, LAST_INSERT_ID(), 0),
('数字专员监控创建', 'infra:digital-agent:create', 3, 2, LAST_INSERT_ID(), 0),
('数字专员监控更新', 'infra:digital-agent:update', 3, 3, LAST_INSERT_ID(), 0),
('数字专员监控删除', 'infra:digital-agent:delete', 3, 4, LAST_INSERT_ID(), 0);
```

## 扩展功能

### 1. 多租户支持

系统支持多租户架构，每个租户的数字专员数据完全隔离。

### 2. 高可用部署

- **n8n集群**: 支持多节点n8n集群部署
- **数据库主从**: 支持MySQL主从复制
- **负载均衡**: 支持nginx负载均衡

### 3. 监控大屏

- **实时监控**: 实时显示各专员执行状态
- **统计图表**: 展示成功率、响应时间趋势
- **报警面板**: 显示当前报警信息

## 常见问题

### 1. 工作流执行失败

**问题**: n8n工作流执行失败
**解决**: 检查API接口是否正常，验证认证token是否有效

### 2. 数据库连接失败

**问题**: 数字专员监控数据无法保存
**解决**: 检查数据库连接配置，确认表结构是否正确

### 3. 报警通知无法发送

**问题**: 报警邮件或钉钉通知无法发送
**解决**: 检查邮件SMTP配置或钉钉webhook配置

## 总结

本次更新将数字专员监控系统完全集成到了若依系统的基础设施模块中，提供了：

1. **完整的基础设施支持**: 实体类、服务接口、控制器、数据库表
2. **标准化的API接口**: 遵循若依项目的接口规范
3. **强化的ERP采购专员**: 支持完整的采购业务流程
4. **无全局变量的n8n工作流**: 提高了工作流的可维护性
5. **严格的API调用**: 完全按照项目controller定义调用接口

系统现在可以作为基础设施的一部分，为其他模块提供数字专员监控能力，实现了真正的企业级数字化运营监控。 