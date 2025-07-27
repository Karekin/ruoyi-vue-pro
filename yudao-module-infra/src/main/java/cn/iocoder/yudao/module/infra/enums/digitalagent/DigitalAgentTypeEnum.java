package cn.iocoder.yudao.module.infra.enums.digitalagent;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 数字专员类型枚举
 *
 * @author 芋道源码
 */
@AllArgsConstructor
@Getter
public enum DigitalAgentTypeEnum {

    ERP_PURCHASE("ERP_PURCHASE", "ERP采购管理专员"),
    ERP_SALE("ERP_SALE", "ERP销售管理专员"),
    CRM_CUSTOMER("CRM_CUSTOMER", "CRM客户关系专员"),
    BPM_WORKFLOW("BPM_WORKFLOW", "BPM工作流专员"),
    SYSTEM_MONITOR("SYSTEM_MONITOR", "系统监控专员");

    /**
     * 类型代码
     */
    private final String code;
    /**
     * 类型名称
     */
    private final String name;

} 