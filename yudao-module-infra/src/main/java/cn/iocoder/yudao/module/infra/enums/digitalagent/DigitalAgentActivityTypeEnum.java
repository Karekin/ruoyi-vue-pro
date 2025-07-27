package cn.iocoder.yudao.module.infra.enums.digitalagent;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 数字专员活动类型枚举
 *
 * @author 芋道源码
 */
@AllArgsConstructor
@Getter
public enum DigitalAgentActivityTypeEnum {

    // ERP采购管理专员活动
    ERP_PURCHASE_ORDER_CREATE("ERP_PURCHASE_ORDER_CREATE", "创建采购订单"),
    ERP_PURCHASE_ORDER_APPROVE("ERP_PURCHASE_ORDER_APPROVE", "审核采购订单"),
    ERP_PURCHASE_ORDER_QUERY("ERP_PURCHASE_ORDER_QUERY", "查询采购订单"),
    ERP_PURCHASE_IN_CREATE("ERP_PURCHASE_IN_CREATE", "创建采购入库"),
    ERP_PURCHASE_IN_APPROVE("ERP_PURCHASE_IN_APPROVE", "审核采购入库"),
    ERP_PURCHASE_RETURN_CREATE("ERP_PURCHASE_RETURN_CREATE", "创建采购退货"),
    ERP_PURCHASE_RETURN_APPROVE("ERP_PURCHASE_RETURN_APPROVE", "审核采购退货"),
    ERP_SUPPLIER_CREATE("ERP_SUPPLIER_CREATE", "创建供应商"),
    ERP_SUPPLIER_UPDATE("ERP_SUPPLIER_UPDATE", "更新供应商信息"),
    ERP_SUPPLIER_QUERY("ERP_SUPPLIER_QUERY", "查询供应商信息"),

    // ERP销售管理专员活动
    ERP_SALE_ORDER_CREATE("ERP_SALE_ORDER_CREATE", "创建销售订单"),
    ERP_SALE_ORDER_APPROVE("ERP_SALE_ORDER_APPROVE", "审核销售订单"),
    ERP_SALE_OUT_CREATE("ERP_SALE_OUT_CREATE", "创建销售出库"),
    ERP_CUSTOMER_CREATE("ERP_CUSTOMER_CREATE", "创建客户"),
    ERP_CUSTOMER_UPDATE("ERP_CUSTOMER_UPDATE", "更新客户信息"),

    // CRM客户关系专员活动
    CRM_CUSTOMER_CREATE("CRM_CUSTOMER_CREATE", "创建CRM客户"),
    CRM_CUSTOMER_FOLLOW("CRM_CUSTOMER_FOLLOW", "客户跟进"),
    CRM_BUSINESS_CREATE("CRM_BUSINESS_CREATE", "创建商机"),
    CRM_CONTRACT_CREATE("CRM_CONTRACT_CREATE", "创建合同"),

    // BPM工作流专员活动
    BPM_PROCESS_CREATE("BPM_PROCESS_CREATE", "创建流程实例"),
    BPM_TASK_COMPLETE("BPM_TASK_COMPLETE", "完成任务"),
    BPM_PROCESS_QUERY("BPM_PROCESS_QUERY", "查询流程"),

    // 系统监控专员活动
    SYSTEM_HEALTH_CHECK("SYSTEM_HEALTH_CHECK", "系统健康检查"),
    SYSTEM_PERFORMANCE_CHECK("SYSTEM_PERFORMANCE_CHECK", "系统性能检查"),
    SYSTEM_LOG_ANALYSIS("SYSTEM_LOG_ANALYSIS", "系统日志分析");

    /**
     * 活动类型代码
     */
    private final String code;
    /**
     * 活动类型名称
     */
    private final String name;

} 