import '../enums/index.dart';
import '../utils/index.dart';

/// 分镜镜头模型。
class StoryboardShot {
  StoryboardShot({
    required this.id,
    required this.sortOrder,
    required this.description,
    required this.characterIds,
    required this.sceneId,
    required this.style,
    required this.voicePreset,
    required this.bgmPreset,
    this.imageUrl,
    this.taskStatus = GenerationStatus.idle,
    this.runningTaskId,
  });

  final String id;
  int sortOrder;
  String description;
  List<String> characterIds;
  String? sceneId;
  String style;
  String voicePreset;
  String bgmPreset;
  String? imageUrl;
  GenerationStatus taskStatus;
  String? runningTaskId;

  /// 是否已生成分镜图片。
  bool get hasImage => imageUrl != null;

  /// 分镜生成任务是否仍在处理中。
  bool get isRunning => taskStatus.isActive || runningTaskId != null;

  /// 从接口数据构建分镜模型。
  factory StoryboardShot.fromJson(Map<String, dynamic> json) {
    final runningTaskId = jsonString(json['runningTaskId']);
    return StoryboardShot(
      id: jsonStringValue(json['id']),
      sortOrder: jsonInt(json['sortOrder'], fallback: 1),
      description: jsonStringValue(json['description']),
      characterIds: jsonStringList(json['characterIds']),
      sceneId: jsonString(json['sceneId']),
      style: jsonStringValue(json['style'], fallback: '暗色系'),
      voicePreset: jsonStringValue(json['voicePreset'], fallback: '少年感 · 雄厚'),
      bgmPreset: jsonStringValue(json['bgmPreset'], fallback: '史诗战鼓'),
      imageUrl: jsonString(json['imageUrl']),
      taskStatus: runningTaskId != null
          ? GenerationStatus.running
          : generationStatusFromJson(json['status'] ?? json['taskStatus']),
      runningTaskId: runningTaskId,
    );
  }

  /// 生成用于更新分镜的最小字段集合。
  Map<String, dynamic> toUpdateJson() {
    return {
      'description': description,
      'characterIds': characterIds,
      'sceneId': sceneId,
      'style': style,
      'voicePreset': voicePreset,
      'bgmPreset': bgmPreset,
    };
  }

  /// 转换为完整 JSON 结构。
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sortOrder': sortOrder,
      ...toUpdateJson(),
      'imageUrl': imageUrl,
      'taskStatus': taskStatus.wireName,
      'runningTaskId': runningTaskId,
    };
  }
}
