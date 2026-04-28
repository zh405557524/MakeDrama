part of 'index.dart';

abstract class CharacterAPI {
  static Future<Map<String, dynamic>> getCharacters(String workId) async {
    return jsonMap(
      await HttpService.to.getData('/api/v1/works/$workId/characters'),
    );
  }

  static Future<Map<String, dynamic>> createImageTask({
    required String workId,
    required String characterId,
  }) async {
    return jsonMap(
      await HttpService.to.postData(
        '/api/v1/works/$workId/characters/$characterId/image-task',
      ),
    );
  }

  static Future<Map<String, dynamic>> saveSelection({
    required String workId,
    required List<String> selectedCharacterIds,
  }) async {
    return jsonMap(
      await HttpService.to.putData(
        '/api/v1/works/$workId/characters/selection',
        data: {'selectedCharacterIds': selectedCharacterIds},
      ),
    );
  }
}
