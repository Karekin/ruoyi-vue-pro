# 数字专员运营监控系统

## 📋 项目概述

基于芋道 Vue Pro 项目开发的数字专员运营监控系统，通过 n8n 工作流引擎模拟各个业务模块的数字专员，自动执行运营活动并记录监控数据，帮助管理者了解系统整体运行状况。

## 🏗️ 系统架构

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   n8n 工作流    │    │   芋道项目API   │    │   数据库存储    │
│                 │    │                 │    │                 │
│ • BPM 专员      │◄──►│ • BPM 模块      │◄──►│ • 活动记录      │
│ • CRM 专员      │    │ • CRM 模块      │    │ • 统计数据      │
│ • ERP 专员      │    │ • ERP 模块      │    │ • 告警信息      │
│ • 系统监控专员  │    │ • 系统模块      │    │ • 配置信息      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                     ┌─────────────────┐
                     │   通知系统      │
                     │                 │
                     │ • 邮件通知      │
                     │ • 钉钉通知      │
                     │ • 企业微信      │
                     │ • 监控面板      │
                     └─────────────────┘
```

## 🤖 数字专员角色

### 1. BPM 工作流专员
- **职责**: 监控工作流实例的创建和执行
- **活动**: 创建流程实例、审批任务、处理超时等
- **调度**: 每2小时执行一次
- **目标**: 每日处理10个流程实例

### 2. CRM 客户关系专员
- **职责**: 管理客户生命周期和销售机会
- **活动**: 创建客户、跟进客户、转化线索等
- **调度**: 每日9点、14点、17点执行
- **目标**: 每日新增5个客户

### 3. ERP 运营专员
- **职责**: 处理采购销售订单和库存管理
- **活动**: 创建采购订单、处理销售订单、更新库存等
- **调度**: 每日10:30、15:30执行
- **目标**: 每日3个采购订单，8个销售订单

### 4. 系统监控专员
- **职责**: 监控系统性能和健康状态
- **活动**: 健康检查、性能监控、错误分析等
- **调度**: 每10分钟执行一次
- **目标**: 实时监控系统状态

## 🚀 快速开始

### 1. 环境要求
- Node.js 18+
- MySQL 8.0+
- Java 17+
- 芋道 Vue Pro 项目

### 2. 安装部署

```bash
# 1. 克隆项目（或将文件放入芋道项目根目录）
git clone <repository-url>

# 2. 配置环境变量
cp n8n.env.example n8n.env
# 编辑 n8n.env 文件，修改数据库连接等配置

# 3. 一键部署
chmod +x deploy_digital_agent_system.sh
./deploy_digital_agent_system.sh install

# 4. 启动芋道项目
mvn spring-boot:run
```

### 3. 访问系统
- n8n 管理界面: http://localhost:5678
- 芋道项目: http://localhost:8080
- 用户名: admin
- 密码: your-admin-password

## 📊 监控功能

### 1. 实时监控
- 专员活动执行状态
- 系统性能指标
- 错误率和响应时间
- 业务数据统计

### 2. 告警系统
- 活动失败率超过阈值
- 系统响应时间过长
- 连续失败次数告警
- 数据库连接异常

### 3. 报告系统
- 日报邮件推送
- 钉钉/企业微信通知
- 实时监控面板
- 历史数据分析

## 📁 项目结构

```
├── digital_agent_monitoring_system_design.md   # 详细设计文档
├── sql/mysql/digital_agent_monitoring.sql      # 数据库脚本
├── workflows/n8n/bmp_digital_agent.json        # BPM专员工作流
├── n8n.env                                      # 环境配置文件
├── deploy_digital_agent_system.sh              # 部署脚本
├── README.md                                    # 项目说明
└── yudao-module-system/src/main/java/cn/iocoder/yudao/module/system/
    └── enums/digitalagent/
        └── DigitalAgentActivityTypeEnum.java    # 活动类型枚举
```

## 🔧 配置说明

### 1. 数据库配置
```env
YUDAO_DB_HOST=localhost
YUDAO_DB_PORT=3306
YUDAO_DB_NAME=yudao_vue_pro
YUDAO_DB_USER=root
YUDAO_DB_PASSWORD=123456
```

### 2. 邮件配置
```env
MAIL_HOST=smtp.163.com
MAIL_PORT=587
MAIL_AUTH_USER=your-email@163.com
MAIL_AUTH_PASSWORD=your-password
```

### 3. 专员配置
```env
BPM_AGENT_ENABLED=true
BPM_AGENT_SCHEDULE=0 0 */2 * * ?
CRM_AGENT_ENABLED=true
CRM_AGENT_SCHEDULE=0 0 9,14,17 * * ?
```

## 📈 数据统计

系统会自动记录以下数据：
- 每个专员的活动次数和成功率
- 系统响应时间和错误率
- 业务数据变化趋势
- 告警信息和处理状态

## 🛠️ 管理操作

### 启动系统
```bash
./deploy_digital_agent_system.sh install
```

### 停止系统
```bash
./deploy_digital_agent_system.sh stop
```

### 卸载系统
```bash
./deploy_digital_agent_system.sh uninstall
```

### 查看日志
```bash
tail -f ./logs/n8n.log
```

## 📝 数据库表结构

- `digital_agent_activity` - 专员活动记录
- `digital_agent_statistics` - 统计数据汇总
- `digital_agent_config` - 专员配置信息
- `digital_agent_alert` - 告警记录

## 🔍 监控指标

### 核心指标
- **活动总数**: 各专员执行的活动数量
- **成功率**: 活动执行成功的比例
- **响应时间**: 系统API调用的平均响应时间
- **错误率**: 活动执行失败的比例

### 业务指标
- **BPM**: 流程实例数、任务处理数、审批通过率
- **CRM**: 新增客户数、跟进记录数、转化率
- **ERP**: 订单处理数、库存更新数、成交金额
- **系统**: 健康分数、性能指标、异常数量

## 🚨 告警规则

1. 专员活动失败率超过10%
2. 系统响应时间超过5秒
3. 连续3次活动失败
4. 数据库连接异常
5. 内存使用率超过80%

## 🔗 扩展功能

### 1. AI 增强
- 集成 GPT 模型生成更智能的模拟数据
- 使用机器学习优化专员决策逻辑
- 实现自然语言处理的告警分析

### 2. 多租户支持
- 为不同租户配置独立的数字专员
- 实现租户级别的监控和统计
- 支持租户自定义专员行为

### 3. 移动端支持
- 开发移动端监控应用
- 实现推送通知功能
- 支持移动端告警处理

## 📖 详细文档

更多详细信息请查看：
- [数字专员监控系统设计文档](digital_agent_monitoring_system_design.md)
- [n8n 工作流配置指南](workflows/n8n/)
- [数据库设计说明](sql/mysql/digital_agent_monitoring.sql)

## 📞 技术支持

如需技术支持，请查看：
1. 系统日志文件 `./logs/n8n.log`
2. 数据库连接状态
3. n8n 工作流执行状态
4. 芋道项目运行状态

## 📄 许可证

本项目基于芋道 Vue Pro 项目开发，遵循相同的许可证协议。

---

🎉 **数字专员监控系统让您的B端系统运营更加智能化！**
