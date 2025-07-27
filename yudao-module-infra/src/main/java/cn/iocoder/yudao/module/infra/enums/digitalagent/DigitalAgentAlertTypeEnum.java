package cn.iocoder.yudao.module.infra.enums.digitalagent;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 数字专员报警类型枚举
 *
 * @author 芋道源码
 */
@AllArgsConstructor
@Getter
public enum DigitalAgentAlertTypeEnum {

    FAILURE_RATE_HIGH("FAILURE_RATE_HIGH", "失败率过高"),
    RESPONSE_TIME_SLOW("RESPONSE_TIME_SLOW", "响应时间过慢"),
    CONSECUTIVE_FAILURES("CONSECUTIVE_FAILURES", "连续失败"),
    EXECUTION_TIMEOUT("EXECUTION_TIMEOUT", "执行超时"),
    SYSTEM_ERROR("SYSTEM_ERROR", "系统错误"),
    CONFIGURATION_ERROR("CONFIGURATION_ERROR", "配置错误");

    /**
     * 报警类型代码
     */
    private final String code;
    /**
     * 报警类型名称
     */
    private final String name;

} 