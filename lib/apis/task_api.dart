part of 'index.dart';

/// 通用任务查询与重试接口。
abstract class TaskAPI {
  /// 根据任务 ID 查询任务详情与当前状态。
  static Future<GenerationTaskModel> getTask(String taskId) async {
    return GenerationTaskModel.fromJson(
      jsonMap(await HttpService.to.getData('/api/v1/tasks/$taskId')),
    );
  }

  /// 重试指定任务，并返回重试后的任务信息。
  static Future<GenerationTaskModel> retryTask(String taskId) async {
    return GenerationTaskModel.fromJson(
      jsonMap(await HttpService.to.postData('/api/v1/tasks/$taskId/retry')),
    );
  }
}
