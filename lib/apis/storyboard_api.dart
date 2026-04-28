part of 'index.dart';

abstract class StoryboardAPI {
  static Future<Map<String, dynamic>> getStoryboards(String workId) async {
    return jsonMap(
      await HttpService.to.getData('/api/v1/works/$workId/storyboards'),
    );
  }

  static Future<Map<String, dynamic>> updateStoryboard({
    required String workId,
    required StoryboardShot shot,
  }) async {
    return jsonMap(
      await HttpService.to.putData(
        '/api/v1/works/$workId/storyboards/${shot.id}',
        data: shot.toUpdateJson(),
      ),
    );
  }

  static Future<Map<String, dynamic>> createStoryboard({
    required String workId,
    required String description,
    String? insertAfterStoryboardId,
  }) async {
    final data = <String, dynamic>{'description': description};
    if (insertAfterStoryboardId != null) {
      data['insertAfterStoryboardId'] = insertAfterStoryboardId;
    }
    return jsonMap(
      await HttpService.to.postData(
        '/api/v1/works/$workId/storyboards',
        data: data,
      ),
    );
  }

  static Future<void> deleteStoryboard({
    required String workId,
    required String storyboardId,
  }) async {
    await HttpService.to.deleteData(
      '/api/v1/works/$workId/storyboards/$storyboardId',
    );
  }

  static Future<Map<String, dynamic>> generateStoryboard({
    required String workId,
    required String storyboardId,
  }) async {
    return jsonMap(
      await HttpService.to.postData(
        '/api/v1/works/$workId/storyboards/$storyboardId/generate',
      ),
    );
  }

  static Future<Map<String, dynamic>> generateAllStoryboards(
    String workId,
  ) async {
    return jsonMap(
      await HttpService.to.postData(
        '/api/v1/works/$workId/storyboards/generate-all',
      ),
    );
  }
}
