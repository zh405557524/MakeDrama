import '../services/index.dart';
import '../utils/index.dart';

class CharacterApi {
  CharacterApi(this._http);

  final HttpService _http;

  Future<Map<String, dynamic>> getCharacters(String workId) async {
    return jsonMap(await _http.getData('/api/v1/works/$workId/characters'));
  }

  Future<Map<String, dynamic>> createImageTask({
    required String workId,
    required String characterId,
  }) async {
    return jsonMap(
      await _http.postData(
        '/api/v1/works/$workId/characters/$characterId/image-task',
      ),
    );
  }

  Future<Map<String, dynamic>> saveSelection({
    required String workId,
    required List<String> selectedCharacterIds,
  }) async {
    return jsonMap(
      await _http.putData(
        '/api/v1/works/$workId/characters/selection',
        data: {'selectedCharacterIds': selectedCharacterIds},
      ),
    );
  }
}
