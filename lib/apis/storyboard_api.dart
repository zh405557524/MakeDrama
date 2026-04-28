part of 'index.dart';

/// 分镜相关接口。
abstract class StoryboardAPI {
  /// 获取作品的分镜列表。
  static Future<WorkStepResult> getStoryboards(String workId) async {
    return WorkStepResult.fromJson(
      jsonMap(await HttpService.to.getData('/api/v1/works/$workId/storyboards')),
      fallbackStep: WorkStep.storyboards,
    );
  }

  /// 更新指定分镜的文本与参数信息。
  static Future<void> updateStoryboard({
    required String workId,
    required StoryboardShot shot,
  }) async {
    await HttpService.to.putData(
      '/api/v1/works/$workId/storyboards/${shot.id}',
      data: shot.toUpdateJson(),
    );
  }

  /// 新建分镜。
  ///
  /// 传入 [insertAfterStoryboardId] 时，会在对应分镜后插入。
  static Future<StoryboardShot> createStoryboard({
    required String workId,
    required String description,
    String? insertAfterStoryboardId,
  }) async {
    final data = <String, dynamic>{'description': description};
    if (insertAfterStoryboardId != null) {
      data['insertAfterStoryboardId'] = insertAfterStoryboardId;
    }
    return StoryboardShot.fromJson(
      jsonMap(
        await HttpService.to.postData(
          '/api/v1/works/$workId/storyboards',
          data: data,
        ),
      ),
    );
  }

  /// 删除指定分镜。
  static Future<void> deleteStoryboard({
    required String workId,
    required String storyboardId,
  }) async {
    await HttpService.to.deleteData(
      '/api/v1/works/$workId/storyboards/$storyboardId',
    );
  }

  /// 触发单个分镜的生成任务。
  static Future<TaskTicket> generateStoryboard({
    required String workId,
    required String storyboardId,
  }) async {
    return TaskTicket.fromJson(
      jsonMap(
        await HttpService.to.postData(
          '/api/v1/works/$workId/storyboards/$storyboardId/generate',
        ),
      ),
    );
  }

  /// 批量触发当前作品全部分镜的生成任务。
  static Future<TaskTicket> generateAllStoryboards(
    String workId,
  ) async {
    return TaskTicket.fromJson(
      jsonMap(
        await HttpService.to.postData(
          '/api/v1/works/$workId/storyboards/generate-all',
        ),
      ),
    );
  }
}
