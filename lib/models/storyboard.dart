import '../enums/index.dart';

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
  bool get isRunning =>
      taskStatus == GenerationStatus.running ||
      taskStatus == GenerationStatus.queued;
}
