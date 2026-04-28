part of 'index.dart';

abstract class VideoAPI {
  static Future<Map<String, dynamic>> getVideo(String workId) async {
    return jsonMap(await HttpService.to.getData('/api/v1/works/$workId/video'));
  }

  static Future<Map<String, dynamic>> generateVideo(String workId) async {
    return jsonMap(
      await HttpService.to.postData('/api/v1/works/$workId/video/generate'),
    );
  }

  static Future<Map<String, dynamic>> createShareLink({
    required String workId,
    int expireDays = 7,
  }) async {
    return jsonMap(
      await HttpService.to.postData(
        '/api/v1/works/$workId/share',
        data: {'expireDays': expireDays},
      ),
    );
  }
}
