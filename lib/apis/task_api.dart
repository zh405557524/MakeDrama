import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';

class TaskApi {
  TaskApi(this._http);

  final HttpService _http;

  Future<GenerationTaskModel> getTask(String taskId) async {
    return GenerationTaskModel.fromJson(
      jsonMap(await _http.getData('/api/v1/tasks/$taskId')),
    );
  }

  Future<GenerationTaskModel> retryTask(String taskId) async {
    return GenerationTaskModel.fromJson(
      jsonMap(await _http.postData('/api/v1/tasks/$taskId/retry')),
    );
  }
}
