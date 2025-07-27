package cn.iocoder.yudao.module.infra.controller.admin.digitalagent.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

import static cn.iocoder.yudao.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND;

@Schema(description = "管理后台 - 数字专员活动记录分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class InfraDigitalAgentActivityPageReqVO extends PageParam {

    @Schema(description = "专员类型", example = "ERP_PURCHASE")
    private String agentType;

    @Schema(description = "活动类型", example = "ERP_PURCHASE_ORDER_CREATE")
    private String activityType;

    @Schema(description = "活动状态", example = "SUCCESS")
    private String status;

    @Schema(description = "开始时间")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime[] startTime;

} 