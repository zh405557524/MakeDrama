import '../services/index.dart';
import '../utils/index.dart';

class WorkApi {
  WorkApi(this._http);

  final HttpService _http;

  Future<Map<String, dynamic>> getWorks() async {
    return jsonMap(await _http.getData('/api/v1/works'));
  }

  Future<Map<String, dynamic>> parseStory({
    required String content,
    String? name,
  }) async {
    return jsonMap(
      await _http.postData(
        '/api/v1/works/parse',
        data: {
          'content': content,
          if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getStep({
    required String workId,
    required String step,
  }) async {
    return jsonMap(await _http.getData('/api/v1/works/$workId/step/$step'));
  }
}
