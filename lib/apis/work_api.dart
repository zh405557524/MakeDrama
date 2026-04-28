part of 'index.dart';

abstract class WorkAPI {
  static Future<Map<String, dynamic>> getWorks() async {
    return jsonMap(await HttpService.to.getData('/api/v1/works'));
  }

  static Future<Map<String, dynamic>> parseStory({
    required String content,
    String? name,
  }) async {
    return jsonMap(
      await HttpService.to.postData(
        '/api/v1/works/parse',
        data: {
          'content': content,
          if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
        },
      ),
    );
  }

  static Future<Map<String, dynamic>> getStep({
    required String workId,
    required String step,
  }) async {
    return jsonMap(
      await HttpService.to.getData('/api/v1/works/$workId/step/$step'),
    );
  }
}
