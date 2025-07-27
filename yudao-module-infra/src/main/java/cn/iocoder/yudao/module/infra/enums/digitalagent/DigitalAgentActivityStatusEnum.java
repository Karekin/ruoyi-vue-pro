package cn.iocoder.yudao.module.infra.enums.digitalagent;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 数字专员活动状态枚举
 *
 * @author 芋道源码
 */
@AllArgsConstructor
@Getter
public enum DigitalAgentActivityStatusEnum {

    PENDING("PENDING", "待执行"),
    RUNNING("RUNNING", "执行中"),
    SUCCESS("SUCCESS", "成功"),
    FAILED("FAILED", "失败"),
    CANCELLED("CANCELLED", "已取消");

    /**
     * 状态代码
     */
    private final String code;
    /**
     * 状态名称
     */
    private final String name;

} 