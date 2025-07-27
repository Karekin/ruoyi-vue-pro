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
 * 数字专员活动记录 DO
 *
 * @author 芋道源码
 */
@TableName("infra_digital_agent_activity")
@KeySequence("infra_digital_agent_activity_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class InfraDigitalAgentActivityDO extends BaseDO {

    /**
     * 活动ID
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
     * 活动名称
     */
    private String activityName;

    /**
     * 活动状态
     *
     * 枚举 {@link cn.iocoder.yudao.module.infra.enums.digitalagent.DigitalAgentActivityStatusEnum}
     */
    private String status;

    /**
     * 请求数据
     */
    private String requestData;

    /**
     * 响应数据
     */
    private String responseData;

    /**
     * 响应时间（毫秒）
     */
    private Long responseTime;

    /**
     * 错误信息
     */
    private String errorMessage;

    /**
     * 开始时间
     */
    private LocalDateTime startTime;

    /**
     * 结束时间
     */
    private LocalDateTime endTime;

    /**
     * 备注
     */
    private String remark;

} 