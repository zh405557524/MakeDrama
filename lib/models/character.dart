import '../enums/index.dart';
import '../utils/index.dart';

/// 角色信息模型。
class CharacterProfile {
  CharacterProfile({
    required this.id,
    required this.name,
    required this.roleTag,
    required this.description,
    this.imageUrl,
    this.selected = true,
    this.taskStatus = GenerationStatus.idle,
    this.runningTaskId,
  });

  final String id;
  String name;
  String roleTag;
  String description;
  String? imageUrl;
  bool selected;
  GenerationStatus taskStatus;
  String? runningTaskId;

  /// 是否已生成角色图片。
  bool get hasImage => imageUrl != null;

  /// 角色图片任务是否仍在处理中。
  bool get isRunning => taskStatus.isActive || runningTaskId != null;

  /// 从接口数据构建角色模型。
  factory CharacterProfile.fromJson(Map<String, dynamic> json) {
    final runningTaskId = jsonString(json['runningTaskId']);
    return CharacterProfile(
      id: jsonStringValue(json['id']),
      name: jsonStringValue(json['name'], fallback: '未命名角色'),
      roleTag: jsonStringValue(json['roleTag'], fallback: '角色'),
      description: jsonStringValue(json['description']),
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
      'roleTag': roleTag,
      'description': description,
      'imageUrl': imageUrl,
      'selected': selected,
      'taskStatus': taskStatus.wireName,
      'runningTaskId': runningTaskId,
    };
  }
}
