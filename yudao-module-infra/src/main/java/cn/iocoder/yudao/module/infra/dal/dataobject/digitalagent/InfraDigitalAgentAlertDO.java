package cn.iocoder.yudao.module.infra.dal.dataobject.digitalagent;

import cn.iocoder.yudao.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 数字专员报警 DO
 *
 * @author 芋道源码
 */
@TableName("infra_digital_agent_alert")
@KeySequence("infra_digital_agent_alert_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class InfraDigitalAgentAlertDO extends BaseDO {

    /**
     * 报警ID
     */
    @TableId
    private Long id;

    /**
     * 专员类型
     *
     * 枚举 {@link cn.iocoder.yudao.module.infra.enums.digitalagent.DigitalAgentTypeEnum}
     */
    private String agentType;

    /**
     * 活动类型
     *
     * 枚举 {@link cn.iocoder.yudao.module.infra.enums.digitalagent.DigitalAgentActivityTypeEnum}
     */
    private String activityType;

    /**
     * 报警类型
     *
     * 枚举 {@link cn.iocoder.yudao.module.infra.enums.digitalagent.DigitalAgentAlertTypeEnum}
     */
    private String alertType;

    /**
     * 报警级别
     *
     * 枚举 {@link cn.iocoder.yudao.module.infra.enums.digitalagent.DigitalAgentAlertLevelEnum}
     */
    private String alertLevel;

    /**
     * 报警标题
     */
    private String alertTitle;

    /**
     * 报警内容
     */
    private String alertContent;

    /**
     * 触发时间
     */
    private LocalDateTime triggerTime;

    /**
     * 处理状态
     *
     * 枚举 {@link cn.iocoder.yudao.module.infra.enums.digitalagent.DigitalAgentAlertStatusEnum}
     */
    private String status;

    /**
     * 处理人
     */
    private String handlerUser;

    /**
     * 处理时间
     */
    private LocalDateTime handlerTime;

    /**
     * 处理备注
     */
    private String handlerRemark;

} 