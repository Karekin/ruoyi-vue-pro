package cn.iocoder.yudao.module.infra.enums.digitalagent;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 数字专员报警级别枚举
 *
 * @author 芋道源码
 */
@AllArgsConstructor
@Getter
public enum DigitalAgentAlertLevelEnum {

    INFO("INFO", "信息"),
    WARNING("WARNING", "警告"),
    ERROR("ERROR", "错误"),
    CRITICAL("CRITICAL", "严重");

    /**
     * 级别代码
     */
    private final String code;
    /**
     * 级别名称
     */
    private final String name;

} 