import '../enums/index.dart';
import '../utils/index.dart';

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

  bool get hasImage => imageUrl != null;
  bool get isRunning => taskStatus.isActive || runningTaskId != null;

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
