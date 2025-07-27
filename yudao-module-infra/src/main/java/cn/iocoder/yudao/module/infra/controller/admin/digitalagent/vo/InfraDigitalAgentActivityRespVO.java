package cn.iocoder.yudao.module.infra.controller.admin.digitalagent.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 数字专员活动记录 Response VO")
@Data
public class InfraDigitalAgentActivityRespVO {

    @Schema(description = "活动ID", example = "1024")
    private Long id;

    @Schema(description = "专员类型", example = "ERP_PURCHASE")
    private String agentType;

    @Schema(description = "活动类型", example = "ERP_PURCHASE_ORDER_CREATE")
    private String activityType;

    @Schema(description = "活动名称", example = "创建采购订单")
    private String activityName;

    @Schema(description = "活动状态", example = "SUCCESS")
    private String status;

    @Schema(description = "请求数据", example = "{\"supplierId\": 1, \"orderTime\": \"2024-01-01 10:00:00\"}")
    private String requestData;

    @Schema(description = "响应数据", example = "{\"orderId\": 1001, \"orderNo\": \"PO20240101001\"}")
    private String responseData;

    @Schema(description = "响应时间（毫秒）", example = "1200")
    private Long responseTime;

    @Schema(description = "错误信息", example = "供应商不存在")
    private String errorMessage;

    @Schema(description = "开始时间")
    private LocalDateTime startTime;

    @Schema(description = "结束时间")
    private LocalDateTime endTime;

    @Schema(description = "备注", example = "系统自动执行")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

} 