package cn.iocoder.yudao.module.infra.enums.digitalagent;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 数字专员报警状态枚举
 *
 * @author 芋道源码
 */
@AllArgsConstructor
@Getter
public enum DigitalAgentAlertStatusEnum {

    PENDING("PENDING", "待处理"),
    PROCESSING("PROCESSING", "处理中"),
    RESOLVED("RESOLVED", "已解决"),
    IGNORED("IGNORED", "已忽略");

    /**
     * 状态代码
     */
    private final String code;
    /**
     * 状态名称
     */
    private final String name;

} 