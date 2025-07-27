package cn.iocoder.yudao.module.infra.dal.dataobject.digitalagent;

import cn.iocoder.yudao.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

/**
 * 数字专员配置 DO
 *
 * @author 芋道源码
 */
@TableName("infra_digital_agent_config")
@KeySequence("infra_digital_agent_config_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class InfraDigitalAgentConfigDO extends BaseDO {

    /**
     * 配置ID
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
     * 配置键
     */
    private String configKey;

    /**
     * 配置值
     */
    private String configValue;

    /**
     * 配置描述
     */
    private String description;

    /**
     * 是否启用
     */
    private Boolean enabled;

} 