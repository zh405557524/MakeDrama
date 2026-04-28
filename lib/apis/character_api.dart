part of 'index.dart';

/// 角色相关接口。
abstract class CharacterAPI {
  /// 获取作品中的角色列表及其生成信息。
  static Future<WorkStepResult> getCharacters(String workId) async {
    return WorkStepResult.fromJson(
      jsonMap(await HttpService.to.getData('/api/v1/works/$workId/characters')),
      fallbackStep: WorkStep.characters,
    );
  }

  /// 为指定角色创建图片生成任务。
  static Future<TaskTicket> createImageTask({
    required String workId,
    required String characterId,
  }) async {
    return TaskTicket.fromJson(
      jsonMap(
        await HttpService.to.postData(
          '/api/v1/works/$workId/characters/$characterId/image-task',
        ),
      ),
    );
  }

  /// 保存用户选择的角色集合。
  static Future<void> saveSelection({
    required String workId,
    required List<String> selectedCharacterIds,
  }) async {
    await HttpService.to.putData(
      '/api/v1/works/$workId/characters/selection',
      data: {'selectedCharacterIds': selectedCharacterIds},
    );
  }
}
