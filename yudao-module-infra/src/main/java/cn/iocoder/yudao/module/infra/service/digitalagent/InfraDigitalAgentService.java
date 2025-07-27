package cn.iocoder.yudao.module.infra.service.digitalagent;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.infra.controller.admin.digitalagent.vo.InfraDigitalAgentActivityPageReqVO;
import cn.iocoder.yudao.module.infra.controller.admin.digitalagent.vo.InfraDigitalAgentActivitySaveReqVO;
import cn.iocoder.yudao.module.infra.dal.dataobject.digitalagent.InfraDigitalAgentActivityDO;
import cn.iocoder.yudao.module.infra.dal.dataobject.digitalagent.InfraDigitalAgentStatisticsDO;
import jakarta.validation.Valid;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 数字专员监控服务接口
 *
 * @author 芋道源码
 */
public interface InfraDigitalAgentService {

    /**
     * 创建数字专员活动记录
     *
     * @param createReqVO 创建信息
     * @return 编号
     */
    Long createDigitalAgentActivity(@Valid InfraDigitalAgentActivitySaveReqVO createReqVO);

    /**
     * 更新数字专员活动记录
     *
     * @param updateReqVO 更新信息
     */
    void updateDigitalAgentActivity(@Valid InfraDigitalAgentActivitySaveReqVO updateReqVO);

    /**
     * 删除数字专员活动记录
     *
     * @param id 编号
     */
    void deleteDigitalAgentActivity(Long id);

    /**
     * 获得数字专员活动记录
     *
     * @param id 编号
     * @return 数字专员活动记录
     */
    InfraDigitalAgentActivityDO getDigitalAgentActivity(Long id);

    /**
     * 获得数字专员活动记录分页
     *
     * @param pageReqVO 分页查询
     * @return 数字专员活动记录分页
     */
    PageResult<InfraDigitalAgentActivityDO> getDigitalAgentActivityPage(InfraDigitalAgentActivityPageReqVO pageReqVO);

    /**
     * 记录数字专员活动开始
     *
     * @param agentType 专员类型
     * @param activityType 活动类型
     * @param activityName 活动名称
     * @param requestData 请求数据
     * @return 活动ID
     */
    Long recordActivityStart(String agentType, String activityType, String activityName, String requestData);

    /**
     * 记录数字专员活动成功
     *
     * @param activityId 活动ID
     * @param responseData 响应数据
     * @param responseTime 响应时间
     */
    void recordActivitySuccess(Long activityId, String responseData, Long responseTime);

    /**
     * 记录数字专员活动失败
     *
     * @param activityId 活动ID
     * @param errorMessage 错误信息
     * @param responseTime 响应时间
     */
    void recordActivityFailed(Long activityId, String errorMessage, Long responseTime);

    /**
     * 获取数字专员统计数据
     *
     * @param agentType 专员类型
     * @param activityType 活动类型
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 统计数据
     */
    List<InfraDigitalAgentStatisticsDO> getDigitalAgentStatistics(String agentType, String activityType, LocalDate startDate, LocalDate endDate);

    /**
     * 生成每日统计
     *
     * @param date 统计日期
     */
    void generateDailyStatistics(LocalDate date);

    /**
     * 检查并触发报警
     *
     * @param agentType 专员类型
     * @param activityType 活动类型
     */
    void checkAndTriggerAlerts(String agentType, String activityType);

} 