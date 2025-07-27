package cn.iocoder.yudao.module.infra.service.digitalagent;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.infra.controller.admin.digitalagent.vo.InfraDigitalAgentActivityPageReqVO;
import cn.iocoder.yudao.module.infra.controller.admin.digitalagent.vo.InfraDigitalAgentActivitySaveReqVO;
import cn.iocoder.yudao.module.infra.dal.dataobject.digitalagent.InfraDigitalAgentActivityDO;
import cn.iocoder.yudao.module.infra.dal.dataobject.digitalagent.InfraDigitalAgentStatisticsDO;
import cn.iocoder.yudao.module.infra.dal.mysql.digitalagent.InfraDigitalAgentActivityMapper;
import cn.iocoder.yudao.module.infra.dal.mysql.digitalagent.InfraDigitalAgentStatisticsMapper;
import cn.iocoder.yudao.module.infra.enums.digitalagent.DigitalAgentActivityStatusEnum;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 数字专员监控服务实现类
 *
 * @author 芋道源码
 */
@Service
@Validated
public class InfraDigitalAgentServiceImpl implements InfraDigitalAgentService {

    @Resource
    private InfraDigitalAgentActivityMapper activityMapper;
    @Resource
    private InfraDigitalAgentStatisticsMapper statisticsMapper;

    @Override
    @Transactional
    public Long createDigitalAgentActivity(InfraDigitalAgentActivitySaveReqVO createReqVO) {
        // 插入
        InfraDigitalAgentActivityDO activity = BeanUtils.toBean(createReqVO, InfraDigitalAgentActivityDO.class);
        activityMapper.insert(activity);
        return activity.getId();
    }

    @Override
    @Transactional
    public void updateDigitalAgentActivity(InfraDigitalAgentActivitySaveReqVO updateReqVO) {
        // 校验存在
        validateDigitalAgentActivityExists(updateReqVO.getId());
        // 更新
        InfraDigitalAgentActivityDO updateObj = BeanUtils.toBean(updateReqVO, InfraDigitalAgentActivityDO.class);
        activityMapper.updateById(updateObj);
    }

    @Override
    @Transactional
    public void deleteDigitalAgentActivity(Long id) {
        // 校验存在
        validateDigitalAgentActivityExists(id);
        // 删除
        activityMapper.deleteById(id);
    }

    private void validateDigitalAgentActivityExists(Long id) {
        if (activityMapper.selectById(id) == null) {
            throw new IllegalArgumentException("数字专员活动记录不存在");
        }
    }

    @Override
    public InfraDigitalAgentActivityDO getDigitalAgentActivity(Long id) {
        return activityMapper.selectById(id);
    }

    @Override
    public PageResult<InfraDigitalAgentActivityDO> getDigitalAgentActivityPage(InfraDigitalAgentActivityPageReqVO pageReqVO) {
        return activityMapper.selectPage(pageReqVO);
    }

    @Override
    @Transactional
    public Long recordActivityStart(String agentType, String activityType, String activityName, String requestData) {
        InfraDigitalAgentActivityDO activity = new InfraDigitalAgentActivityDO();
        activity.setAgentType(agentType);
        activity.setActivityType(activityType);
        activity.setActivityName(activityName);
        activity.setStatus(DigitalAgentActivityStatusEnum.RUNNING.getCode());
        activity.setRequestData(requestData);
        activity.setStartTime(LocalDateTime.now());
        activityMapper.insert(activity);
        return activity.getId();
    }

    @Override
    @Transactional
    public void recordActivitySuccess(Long activityId, String responseData, Long responseTime) {
        InfraDigitalAgentActivityDO activity = activityMapper.selectById(activityId);
        if (activity != null) {
            activity.setStatus(DigitalAgentActivityStatusEnum.SUCCESS.getCode());
            activity.setResponseData(responseData);
            activity.setResponseTime(responseTime);
            activity.setEndTime(LocalDateTime.now());
            activityMapper.updateById(activity);
        }
    }

    @Override
    @Transactional
    public void recordActivityFailed(Long activityId, String errorMessage, Long responseTime) {
        InfraDigitalAgentActivityDO activity = activityMapper.selectById(activityId);
        if (activity != null) {
            activity.setStatus(DigitalAgentActivityStatusEnum.FAILED.getCode());
            activity.setErrorMessage(errorMessage);
            activity.setResponseTime(responseTime);
            activity.setEndTime(LocalDateTime.now());
            activityMapper.updateById(activity);
        }
    }

    @Override
    public List<InfraDigitalAgentStatisticsDO> getDigitalAgentStatistics(String agentType, String activityType, LocalDate startDate, LocalDate endDate) {
        // TODO: 实现统计查询逻辑
        return statisticsMapper.selectList();
    }

    @Override
    @Transactional
    public void generateDailyStatistics(LocalDate date) {
        // TODO: 实现每日统计生成逻辑
    }

    @Override
    public void checkAndTriggerAlerts(String agentType, String activityType) {
        // TODO: 实现报警检查逻辑
    }

} 