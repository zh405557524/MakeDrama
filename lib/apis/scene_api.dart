part of 'index.dart';

/// 场景相关接口。
abstract class SceneAPI {
  /// 获取作品的场景列表及其生成信息。
  static Future<WorkStepResult> getScenes(String workId) async {
    return WorkStepResult.fromJson(
      jsonMap(await HttpService.to.getData('/api/v1/works/$workId/scenes')),
      fallbackStep: WorkStep.scenes,
    );
  }

  /// 为指定场景创建图片生成任务。
  static Future<TaskTicket> createImageTask({
    required String workId,
    required String sceneId,
  }) async {
    return TaskTicket.fromJson(
      jsonMap(
        await HttpService.to.postData(
          '/api/v1/works/$workId/scenes/$sceneId/image-task',
        ),
      ),
    );
  }

  /// 保存用户选择的场景集合。
  static Future<void> saveSelection({
    required String workId,
    required List<String> selectedSceneIds,
  }) async {
    await HttpService.to.putData(
      '/api/v1/works/$workId/scenes/selection',
      data: {'selectedSceneIds': selectedSceneIds},
    );
  }
}
