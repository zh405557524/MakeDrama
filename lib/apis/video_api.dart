part of 'index.dart';

/// 视频生成与分享相关接口。
abstract class VideoAPI {
  /// 获取作品视频信息（如状态、地址等）。
  static Future<WorkStepResult> getVideo(String workId) async {
    return WorkStepResult.fromJson(
      jsonMap(await HttpService.to.getData('/api/v1/works/$workId/video')),
      fallbackStep: WorkStep.preview,
    );
  }

  /// 触发作品视频生成任务。
  static Future<TaskTicket> generateVideo(String workId) async {
    return TaskTicket.fromJson(
      jsonMap(
        await HttpService.to.postData('/api/v1/works/$workId/video/generate'),
      ),
    );
  }

  /// 创建作品分享链接。
  ///
  /// [expireDays] 为链接有效天数，默认 7 天。
  static Future<ShareLinkResult> createShareLink({
    required String workId,
    int expireDays = 7,
  }) async {
    return ShareLinkResult.fromJson(
      jsonMap(
        await HttpService.to.postData(
          '/api/v1/works/$workId/share',
          data: {'expireDays': expireDays},
        ),
      ),
    );
  }
}
