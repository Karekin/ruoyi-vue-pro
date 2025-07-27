package cn.iocoder.yudao.module.infra.controller.admin.digitalagent;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.infra.controller.admin.digitalagent.vo.InfraDigitalAgentActivityPageReqVO;
import cn.iocoder.yudao.module.infra.controller.admin.digitalagent.vo.InfraDigitalAgentActivityRespVO;
import cn.iocoder.yudao.module.infra.controller.admin.digitalagent.vo.InfraDigitalAgentActivitySaveReqVO;
import cn.iocoder.yudao.module.infra.dal.dataobject.digitalagent.InfraDigitalAgentActivityDO;
import cn.iocoder.yudao.module.infra.dal.dataobject.digitalagent.InfraDigitalAgentStatisticsDO;
import cn.iocoder.yudao.module.infra.service.digitalagent.InfraDigitalAgentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 数字专员监控")
@RestController
@RequestMapping("/infra/digital-agent")
@Validated
public class InfraDigitalAgentController {

    @Resource
    private InfraDigitalAgentService digitalAgentService;

    @PostMapping("/create")
    @Operation(summary = "创建数字专员活动记录")
    @PreAuthorize("@ss.hasPermission('infra:digital-agent:create')")
    public CommonResult<Long> createDigitalAgentActivity(@Valid @RequestBody InfraDigitalAgentActivitySaveReqVO createReqVO) {
        return success(digitalAgentService.createDigitalAgentActivity(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新数字专员活动记录")
    @PreAuthorize("@ss.hasPermission('infra:digital-agent:update')")
    public CommonResult<Boolean> updateDigitalAgentActivity(@Valid @RequestBody InfraDigitalAgentActivitySaveReqVO updateReqVO) {
        digitalAgentService.updateDigitalAgentActivity(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除数字专员活动记录")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('infra:digital-agent:delete')")
    public CommonResult<Boolean> deleteDigitalAgentActivity(@RequestParam("id") Long id) {
        digitalAgentService.deleteDigitalAgentActivity(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得数字专员活动记录")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('infra:digital-agent:query')")
    public CommonResult<InfraDigitalAgentActivityRespVO> getDigitalAgentActivity(@RequestParam("id") Long id) {
        InfraDigitalAgentActivityDO activity = digitalAgentService.getDigitalAgentActivity(id);
        return success(BeanUtils.toBean(activity, InfraDigitalAgentActivityRespVO.class));
    }

    @GetMapping("/page")
    @Operation(summary = "获得数字专员活动记录分页")
    @PreAuthorize("@ss.hasPermission('infra:digital-agent:query')")
    public CommonResult<PageResult<InfraDigitalAgentActivityRespVO>> getDigitalAgentActivityPage(@Valid InfraDigitalAgentActivityPageReqVO pageReqVO) {
        PageResult<InfraDigitalAgentActivityDO> pageResult = digitalAgentService.getDigitalAgentActivityPage(pageReqVO);
        return success(BeanUtils.toBean(pageResult, InfraDigitalAgentActivityRespVO.class));
    }

    @PostMapping("/record-start")
    @Operation(summary = "记录数字专员活动开始")
    public CommonResult<Long> recordActivityStart(@RequestParam("agentType") String agentType,
                                                  @RequestParam("activityType") String activityType,
                                                  @RequestParam("activityName") String activityName,
                                                  @RequestParam(value = "requestData", required = false) String requestData) {
        return success(digitalAgentService.recordActivityStart(agentType, activityType, activityName, requestData));
    }

    @PostMapping("/record-success")
    @Operation(summary = "记录数字专员活动成功")
    public CommonResult<Boolean> recordActivitySuccess(@RequestParam("activityId") Long activityId,
                                                       @RequestParam(value = "responseData", required = false) String responseData,
                                                       @RequestParam("responseTime") Long responseTime) {
        digitalAgentService.recordActivitySuccess(activityId, responseData, responseTime);
        return success(true);
    }

    @PostMapping("/record-failed")
    @Operation(summary = "记录数字专员活动失败")
    public CommonResult<Boolean> recordActivityFailed(@RequestParam("activityId") Long activityId,
                                                      @RequestParam("errorMessage") String errorMessage,
                                                      @RequestParam("responseTime") Long responseTime) {
        digitalAgentService.recordActivityFailed(activityId, errorMessage, responseTime);
        return success(true);
    }

    @GetMapping("/statistics")
    @Operation(summary = "获取数字专员统计数据")
    @PreAuthorize("@ss.hasPermission('infra:digital-agent:query')")
    public CommonResult<List<InfraDigitalAgentStatisticsDO>> getDigitalAgentStatistics(
            @RequestParam(value = "agentType", required = false) String agentType,
            @RequestParam(value = "activityType", required = false) String activityType,
            @RequestParam("startDate") LocalDate startDate,
            @RequestParam("endDate") LocalDate endDate) {
        List<InfraDigitalAgentStatisticsDO> statistics = digitalAgentService.getDigitalAgentStatistics(agentType, activityType, startDate, endDate);
        return success(statistics);
    }

    @PostMapping("/generate-daily-statistics")
    @Operation(summary = "生成每日统计")
    @PreAuthorize("@ss.hasPermission('infra:digital-agent:update')")
    public CommonResult<Boolean> generateDailyStatistics(@RequestParam("date") LocalDate date) {
        digitalAgentService.generateDailyStatistics(date);
        return success(true);
    }

    @PostMapping("/check-alerts")
    @Operation(summary = "检查并触发报警")
    @PreAuthorize("@ss.hasPermission('infra:digital-agent:update')")
    public CommonResult<Boolean> checkAndTriggerAlerts(@RequestParam("agentType") String agentType,
                                                       @RequestParam("activityType") String activityType) {
        digitalAgentService.checkAndTriggerAlerts(agentType, activityType);
        return success(true);
    }

} 