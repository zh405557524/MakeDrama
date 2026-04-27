import '../services/index.dart';
import '../utils/index.dart';

class VideoApi {
  VideoApi(this._http);

  final HttpService _http;

  Future<Map<String, dynamic>> getVideo(String workId) async {
    return jsonMap(await _http.getData('/api/v1/works/$workId/video'));
  }

  Future<Map<String, dynamic>> generateVideo(String workId) async {
    return jsonMap(
      await _http.postData('/api/v1/works/$workId/video/generate'),
    );
  }

  Future<Map<String, dynamic>> createShareLink({
    required String workId,
    int expireDays = 7,
  }) async {
    return jsonMap(
      await _http.postData(
        '/api/v1/works/$workId/share',
        data: {'expireDays': expireDays},
      ),
    );
  }
}
