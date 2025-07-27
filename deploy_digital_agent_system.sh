#!/bin/bash

# 数字专员监控系统部署脚本
# 适用于芋道 Vue Pro 项目

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印彩色信息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 命令未找到，请先安装 $1"
        exit 1
    fi
}

# 检查文件是否存在
check_file() {
    if [ ! -f "$1" ]; then
        print_error "文件 $1 不存在"
        exit 1
    fi
}

# 检查目录是否存在
check_directory() {
    if [ ! -d "$1" ]; then
        print_error "目录 $1 不存在"
        exit 1
    fi
}

# 主函数
main() {
    print_info "========================================"
    print_info "数字专员监控系统部署脚本"
    print_info "基于芋道 Vue Pro 项目"
    print_info "========================================"
    
    # 1. 环境检查
    print_info "1. 检查环境依赖..."
    check_command "node"
    check_command "npm"
    check_command "mysql"
    check_command "java"
    
    NODE_VERSION=$(node -v)
    NPM_VERSION=$(npm -v)
    print_success "Node.js 版本: $NODE_VERSION"
    print_success "npm 版本: $NPM_VERSION"
    
    # 2. 检查项目文件
    print_info "2. 检查项目文件..."
    check_file "n8n.env"
    check_file "sql/mysql/digital_agent_monitoring.sql"
    check_file "workflows/n8n/bmp_digital_agent.json"
    check_file "digital_agent_monitoring_system_design.md"
    print_success "项目文件检查完成"
    
    # 3. 数据库初始化
    print_info "3. 初始化数据库..."
    
    # 读取数据库配置
    DB_HOST=${YUDAO_DB_HOST:-localhost}
    DB_PORT=${YUDAO_DB_PORT:-3306}
    DB_NAME=${YUDAO_DB_NAME:-yudao_vue_pro}
    DB_USER=${YUDAO_DB_USER:-root}
    DB_PASSWORD=${YUDAO_DB_PASSWORD:-123456}
    
    print_info "数据库配置:"
    print_info "  主机: $DB_HOST:$DB_PORT"
    print_info "  数据库: $DB_NAME"
    print_info "  用户: $DB_USER"
    
    # 检查数据库连接
    if mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASSWORD -e "USE $DB_NAME;" 2>/dev/null; then
        print_success "数据库连接成功"
    else
        print_error "数据库连接失败，请检查配置"
        exit 1
    fi
    
    # 执行数据库脚本
    print_info "执行数据库脚本..."
    if mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASSWORD $DB_NAME < sql/mysql/digital_agent_monitoring.sql; then
        print_success "数据库脚本执行成功"
    else
        print_error "数据库脚本执行失败"
        exit 1
    fi
    
    # 4. 安装 n8n
    print_info "4. 安装 n8n..."
    
    if command -v n8n &> /dev/null; then
        print_success "n8n 已安装"
    else
        print_info "安装 n8n..."
        npm install -g n8n
        print_success "n8n 安装完成"
    fi
    
    # 5. 配置 n8n
    print_info "5. 配置 n8n..."
    
    # 创建 n8n 配置目录
    mkdir -p ~/.n8n
    mkdir -p ./logs
    
    # 复制环境配置
    cp n8n.env ~/.n8n/.env
    print_success "n8n 配置完成"
    
    # 6. 启动 n8n
    print_info "6. 启动 n8n..."
    
    # 检查 n8n 是否已运行
    if pgrep -x "n8n" > /dev/null; then
        print_warning "n8n 已在运行中"
    else
        print_info "启动 n8n..."
        nohup n8n start > ./logs/n8n.log 2>&1 &
        sleep 5
        
        if pgrep -x "n8n" > /dev/null; then
            print_success "n8n 启动成功"
        else
            print_error "n8n 启动失败，请检查日志文件 ./logs/n8n.log"
            exit 1
        fi
    fi
    
    # 7. 导入工作流
    print_info "7. 导入工作流..."
    
    # 等待 n8n 完全启动
    sleep 10
    
    # 导入 BPM 工作流
    if [ -f "workflows/n8n/bmp_digital_agent.json" ]; then
        print_info "导入 BPM 数字专员工作流..."
        curl -X POST "http://localhost:5678/rest/workflows/import" \
             -H "Content-Type: application/json" \
             -d @workflows/n8n/bmp_digital_agent.json \
             --user "admin:your-admin-password" \
             > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            print_success "BPM 工作流导入成功"
        else
            print_warning "BPM 工作流导入失败，请手动导入"
        fi
    fi
    
    # 8. 启动芋道项目
    print_info "8. 检查芋道项目状态..."
    
    # 检查项目是否在运行
    if curl -s "http://localhost:8080/admin-api/system/auth/get-permission-info" > /dev/null 2>&1; then
        print_success "芋道项目已运行"
    else
        print_warning "芋道项目未运行，请先启动项目"
        print_info "请在项目根目录执行: mvn spring-boot:run"
    fi
    
    # 9. 验证系统
    print_info "9. 验证系统..."
    
    # 检查 n8n 界面
    if curl -s "http://localhost:5678" > /dev/null 2>&1; then
        print_success "n8n 界面可访问"
    else
        print_error "n8n 界面不可访问"
    fi
    
    # 检查数据库表
    TABLE_COUNT=$(mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASSWORD -s -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_NAME' AND table_name LIKE 'digital_agent_%';" 2>/dev/null)
    
    if [ "$TABLE_COUNT" -eq "4" ]; then
        print_success "数据库表创建成功 ($TABLE_COUNT 个表)"
    else
        print_warning "数据库表创建可能有问题，预期 4 个表，实际 $TABLE_COUNT 个表"
    fi
    
    # 10. 显示访问信息
    print_info "========================================"
    print_success "数字专员监控系统部署完成！"
    print_info "========================================"
    print_info "访问地址:"
    print_info "  n8n 管理界面: http://localhost:5678"
    print_info "  芋道项目: http://localhost:8080"
    print_info ""
    print_info "登录信息:"
    print_info "  n8n 用户名: admin"
    print_info "  n8n 密码: your-admin-password"
    print_info ""
    print_info "日志文件:"
    print_info "  n8n 日志: ./logs/n8n.log"
    print_info ""
    print_info "下一步操作:"
    print_info "  1. 访问 n8n 管理界面配置工作流"
    print_info "  2. 修改 n8n.env 文件中的配置"
    print_info "  3. 查看 digital_agent_monitoring_system_design.md 了解详细设计"
    print_info "  4. 根据需要调整专员配置和调度时间"
    print_info "========================================"
}

# 清理函数
cleanup() {
    print_info "正在清理..."
    # 可以添加清理逻辑
}

# 停止系统函数
stop_system() {
    print_info "正在停止数字专员监控系统..."
    
    # 停止 n8n
    if pgrep -x "n8n" > /dev/null; then
        pkill -x "n8n"
        print_success "n8n 已停止"
    else
        print_info "n8n 未运行"
    fi
    
    print_success "系统停止完成"
}

# 卸载系统函数
uninstall_system() {
    print_warning "这将删除所有数字专员监控系统的数据！"
    read -p "确定要卸载吗？(y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "正在卸载数字专员监控系统..."
        
        # 停止服务
        stop_system
        
        # 删除数据库表
        DB_HOST=${YUDAO_DB_HOST:-localhost}
        DB_PORT=${YUDAO_DB_PORT:-3306}
        DB_NAME=${YUDAO_DB_NAME:-yudao_vue_pro}
        DB_USER=${YUDAO_DB_USER:-root}
        DB_PASSWORD=${YUDAO_DB_PASSWORD:-123456}
        
        mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASSWORD -e "
            DROP TABLE IF EXISTS digital_agent_alert;
            DROP TABLE IF EXISTS digital_agent_config;
            DROP TABLE IF EXISTS digital_agent_statistics;
            DROP TABLE IF EXISTS digital_agent_activity;
            DROP VIEW IF EXISTS digital_agent_dashboard_view;
            DROP PROCEDURE IF EXISTS StatisticsDigitalAgentDaily;
            DROP EVENT IF EXISTS digital_agent_daily_statistics_event;
            DELETE FROM system_mail_template WHERE code = 'digital_agent_daily_report';
        " $DB_NAME 2>/dev/null
        
        # 删除日志文件
        rm -rf ./logs/
        
        # 删除 n8n 配置
        rm -f ~/.n8n/.env
        
        print_success "卸载完成"
    else
        print_info "取消卸载"
    fi
}

# 显示帮助信息
show_help() {
    echo "数字专员监控系统部署脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  install    安装和启动系统 (默认)"
    echo "  stop       停止系统"
    echo "  uninstall  卸载系统"
    echo "  help       显示帮助信息"
    echo ""
    echo "环境变量:"
    echo "  YUDAO_DB_HOST     数据库主机 (默认: localhost)"
    echo "  YUDAO_DB_PORT     数据库端口 (默认: 3306)"
    echo "  YUDAO_DB_NAME     数据库名称 (默认: yudao_vue_pro)"
    echo "  YUDAO_DB_USER     数据库用户 (默认: root)"
    echo "  YUDAO_DB_PASSWORD 数据库密码 (默认: 123456)"
    echo ""
    echo "示例:"
    echo "  $0 install"
    echo "  $0 stop"
    echo "  $0 uninstall"
    echo "  YUDAO_DB_PASSWORD=mypassword $0 install"
}

# 处理命令行参数
case "${1:-install}" in
    install)
        main
        ;;
    stop)
        stop_system
        ;;
    uninstall)
        uninstall_system
        ;;
    help)
        show_help
        ;;
    *)
        print_error "未知选项: $1"
        show_help
        exit 1
        ;;
esac

# 注册清理函数
trap cleanup EXIT 