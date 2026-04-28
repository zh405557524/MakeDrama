part of 'index.dart';

abstract class TaskAPI {
  static Future<GenerationTaskModel> getTask(String taskId) async {
    return GenerationTaskModel.fromJson(
      jsonMap(await HttpService.to.getData('/api/v1/tasks/$taskId')),
    );
  }

  static Future<GenerationTaskModel> retryTask(String taskId) async {
    return GenerationTaskModel.fromJson(
      jsonMap(await HttpService.to.postData('/api/v1/tasks/$taskId/retry')),
    );
  }
}
