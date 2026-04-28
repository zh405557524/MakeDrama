import '../enums/index.dart';
import '../utils/index.dart';

/// 场景信息模型。
class SceneProfile {
  SceneProfile({
    required this.id,
    required this.name,
    required this.description,
    required this.tags,
    this.imageUrl,
    this.selected = true,
    this.taskStatus = GenerationStatus.idle,
    this.runningTaskId,
  });

  final String id;
  String name;
  String description;
  List<String> tags;
  String? imageUrl;
  bool selected;
  GenerationStatus taskStatus;
  String? runningTaskId;

  /// 是否已生成场景图片。
  bool get hasImage => imageUrl != null;

  /// 场景图片任务是否仍在处理中。
  bool get isRunning => taskStatus.isActive || runningTaskId != null;

  /// 从接口数据构建场景模型。
  factory SceneProfile.fromJson(Map<String, dynamic> json) {
    final runningTaskId = jsonString(json['runningTaskId']);
    return SceneProfile(
      id: jsonStringValue(json['id']),
      name: jsonStringValue(json['name'], fallback: '未命名场景'),
      description: jsonStringValue(json['description']),
      tags: jsonStringList(json['tags']),
      imageUrl: jsonString(json['imageUrl']),
      selected: jsonBool(json['selected'], fallback: true),
      taskStatus: runningTaskId != null
          ? GenerationStatus.running
          : generationStatusFromJson(json['status'] ?? json['taskStatus']),
      runningTaskId: runningTaskId,
    );
  }

  /// 转换为可持久化的 JSON 结构。
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags,
      'imageUrl': imageUrl,
      'selected': selected,
      'taskStatus': taskStatus.wireName,
      'runningTaskId': runningTaskId,
    };
  }
}
