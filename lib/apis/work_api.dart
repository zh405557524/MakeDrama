part of 'index.dart';

/// 作品相关接口。
abstract class WorkAPI {
  /// 获取当前用户的作品列表。
  static Future<WorkListResult> getWorks() async {
    return WorkListResult.fromJson(
      jsonMap(await HttpService.to.getData('/api/v1/works')),
    );
  }

  /// 解析故事文本并创建作品草稿。
  ///
  /// [content] 为故事原文内容；
  /// [name] 可选，传入后会作为作品名称。
  static Future<WorkStepResult> parseStory({
    required String content,
    String? name,
  }) async {
    return WorkStepResult.fromJson(
      jsonMap(
        await HttpService.to.postData(
          '/api/v1/works/parse',
          data: {
            'content': content,
            if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
          },
        ),
      ),
      fallbackStep: WorkStep.characters,
    );
  }

  /// 查询作品在指定流程步骤的处理状态与数据。
  ///
  /// [workId] 为作品 ID；
  /// [step] 为流程步骤标识。
  static Future<WorkStepResult> getStep({
    required String workId,
    required String step,
  }) async {
    return WorkStepResult.fromJson(
      jsonMap(
        await HttpService.to.getData('/api/v1/works/$workId/step/$step'),
      ),
      fallbackStep: workStepFromJson(step),
    );
  }
}
