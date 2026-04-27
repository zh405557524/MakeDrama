import '../services/index.dart';
import '../utils/index.dart';

class SceneApi {
  SceneApi(this._http);

  final HttpService _http;

  Future<Map<String, dynamic>> getScenes(String workId) async {
    return jsonMap(await _http.getData('/api/v1/works/$workId/scenes'));
  }

  Future<Map<String, dynamic>> createImageTask({
    required String workId,
    required String sceneId,
  }) async {
    return jsonMap(
      await _http.postData('/api/v1/works/$workId/scenes/$sceneId/image-task'),
    );
  }

  Future<Map<String, dynamic>> saveSelection({
    required String workId,
    required List<String> selectedSceneIds,
  }) async {
    return jsonMap(
      await _http.putData(
        '/api/v1/works/$workId/scenes/selection',
        data: {'selectedSceneIds': selectedSceneIds},
      ),
    );
  }
}
