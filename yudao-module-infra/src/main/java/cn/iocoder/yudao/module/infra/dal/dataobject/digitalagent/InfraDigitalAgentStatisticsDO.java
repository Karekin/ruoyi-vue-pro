package cn.iocoder.yudao.module.infra.dal.dataobject.digitalagent;

import cn.iocoder.yudao.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.time.LocalDate;

/**
 * 数字专员统计 DO
 *
 * @author 芋道源码
 */
@TableName("infra_digital_agent_statistics")
@KeySequence("infra_digital_agent_statistics_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class InfraDigitalAgentStatisticsDO extends BaseDO {

    /**
     * 统计ID
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
     * 统计日期
     */
    private LocalDate statisticsDate;

    /**
     * 总执行次数
     */
    private Integer totalCount;

    /**
     * 成功次数
     */
    private Integer successCount;

    /**
     * 失败次数
     */
    private Integer failedCount;

    /**
     * 平均响应时间（毫秒）
     */
    private Long avgResponseTime;

    /**
     * 最大响应时间（毫秒）
     */
    private Long maxResponseTime;

    /**
     * 最小响应时间（毫秒）
     */
    private Long minResponseTime;

    /**
     * 成功率（百分比）
     */
    private Double successRate;

} 