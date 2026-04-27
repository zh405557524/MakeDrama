import '../enums/index.dart';
import '../utils/index.dart';

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
