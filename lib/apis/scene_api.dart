part of 'index.dart';

abstract class SceneAPI {
  static Future<Map<String, dynamic>> getScenes(String workId) async {
    return jsonMap(
      await HttpService.to.getData('/api/v1/works/$workId/scenes'),
    );
  }

  static Future<Map<String, dynamic>> createImageTask({
    required String workId,
    required String sceneId,
  }) async {
    return jsonMap(
      await HttpService.to.postData(
        '/api/v1/works/$workId/scenes/$sceneId/image-task',
      ),
    );
  }

  static Future<Map<String, dynamic>> saveSelection({
    required String workId,
    required List<String> selectedSceneIds,
  }) async {
    return jsonMap(
      await HttpService.to.putData(
        '/api/v1/works/$workId/scenes/selection',
        data: {'selectedSceneIds': selectedSceneIds},
      ),
    );
  }
}
