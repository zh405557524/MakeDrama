import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';

class StoryboardApi {
  StoryboardApi(this._http);

  final HttpService _http;

  Future<Map<String, dynamic>> getStoryboards(String workId) async {
    return jsonMap(await _http.getData('/api/v1/works/$workId/storyboards'));
  }

  Future<Map<String, dynamic>> updateStoryboard({
    required String workId,
    required StoryboardShot shot,
  }) async {
    return jsonMap(
      await _http.putData(
        '/api/v1/works/$workId/storyboards/${shot.id}',
        data: shot.toUpdateJson(),
      ),
    );
  }

  Future<Map<String, dynamic>> createStoryboard({
    required String workId,
    required String description,
    String? insertAfterStoryboardId,
  }) async {
    final data = <String, dynamic>{'description': description};
    if (insertAfterStoryboardId != null) {
      data['insertAfterStoryboardId'] = insertAfterStoryboardId;
    }
    return jsonMap(
      await _http.postData('/api/v1/works/$workId/storyboards', data: data),
    );
  }

  Future<void> deleteStoryboard({
    required String workId,
    required String storyboardId,
  }) async {
    await _http.deleteData('/api/v1/works/$workId/storyboards/$storyboardId');
  }

  Future<Map<String, dynamic>> generateStoryboard({
    required String workId,
    required String storyboardId,
  }) async {
    return jsonMap(
      await _http.postData(
        '/api/v1/works/$workId/storyboards/$storyboardId/generate',
      ),
    );
  }

  Future<Map<String, dynamic>> generateAllStoryboards(String workId) async {
    return jsonMap(
      await _http.postData('/api/v1/works/$workId/storyboards/generate-all'),
    );
  }
}
