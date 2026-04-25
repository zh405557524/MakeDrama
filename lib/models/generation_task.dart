import '../enums/index.dart';

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
}
