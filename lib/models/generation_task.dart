import '../enums/index.dart';
import '../utils/index.dart';

/// 生成任务模型（图片、视频等异步任务通用）。
class GenerationTaskModel {
  GenerationTaskModel({
    required this.taskId,
    required this.workId,
    required this.taskType,
    required this.targetType,
    this.targetId,
    this.status = GenerationStatus.queued,
    this.progress = 0,
    this.errorMessage,
    this.pollingIntervalMs = 2000,
  });

  final String taskId;
  final String workId;
  final String taskType;
  final String targetType;
  final String? targetId;
  GenerationStatus status;
  int progress;
  String? errorMessage;
  int pollingIntervalMs;

  /// 从接口响应构建任务模型。
  factory GenerationTaskModel.fromJson(Map<String, dynamic> json) {
    return GenerationTaskModel(
      taskId: jsonStringValue(json['taskId'] ?? json['id']),
      workId: jsonStringValue(json['workId']),
      taskType: jsonStringValue(json['taskType']),
      targetType: jsonStringValue(json['targetType']),
      targetId: jsonString(json['targetId']),
      status: generationStatusFromJson(json['status']),
      progress: jsonInt(json['progress']),
      errorMessage: jsonString(json['errorMessage']),
      pollingIntervalMs: jsonInt(json['pollingIntervalMs'], fallback: 2000),
    );
  }

  /// 转换为 JSON 结构，便于缓存或传递。
  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'workId': workId,
      'taskType': taskType,
      'targetType': targetType,
      'targetId': targetId,
      'status': status.wireName,
      'progress': progress,
      'errorMessage': errorMessage,
      'pollingIntervalMs': pollingIntervalMs,
    };
  }
}

/// 任务触发接口返回的任务票据。
///
/// 某些接口不会返回完整任务信息，因此使用该模型承载可选字段。
class TaskTicket {
  TaskTicket({
    this.taskId,
    this.status = GenerationStatus.queued,
    this.progress = 0,
    this.errorMessage,
    this.pollingIntervalMs = 2000,
  });

  final String? taskId;
  final GenerationStatus status;
  final int progress;
  final String? errorMessage;
  final int pollingIntervalMs;

  factory TaskTicket.fromJson(Map<String, dynamic> json) {
    return TaskTicket(
      taskId: jsonString(json['taskId'] ?? json['id']),
      status: generationStatusFromJson(json['status']),
      progress: jsonInt(json['progress']),
      errorMessage: jsonString(json['errorMessage']),
      pollingIntervalMs: jsonInt(json['pollingIntervalMs'], fallback: 2000),
    );
  }
}

/// 分享链接创建结果。
class ShareLinkResult {
  ShareLinkResult({required this.url});

  final String url;

  factory ShareLinkResult.fromJson(Map<String, dynamic> json) {
    return ShareLinkResult(url: jsonStringValue(json['url']));
  }
}
