package cn.iocoder.yudao.module.infra.dal.mysql.digitalagent;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.infra.controller.admin.digitalagent.vo.InfraDigitalAgentActivityPageReqVO;
import cn.iocoder.yudao.module.infra.dal.dataobject.digitalagent.InfraDigitalAgentActivityDO;
import org.apache.ibatis.annotations.Mapper;

/**
 * 数字专员活动记录 Mapper
 *
 * @author 芋道源码
 */
@Mapper
public interface InfraDigitalAgentActivityMapper extends BaseMapperX<InfraDigitalAgentActivityDO> {

    default PageResult<InfraDigitalAgentActivityDO> selectPage(InfraDigitalAgentActivityPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<InfraDigitalAgentActivityDO>()
                .eqIfPresent(InfraDigitalAgentActivityDO::getAgentType, reqVO.getAgentType())
                .eqIfPresent(InfraDigitalAgentActivityDO::getActivityType, reqVO.getActivityType())
                .eqIfPresent(InfraDigitalAgentActivityDO::getStatus, reqVO.getStatus())
                .betweenIfPresent(InfraDigitalAgentActivityDO::getStartTime, reqVO.getStartTime())
                .orderByDesc(InfraDigitalAgentActivityDO::getId));
    }

} 