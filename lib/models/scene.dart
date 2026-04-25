import '../enums/index.dart';

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

  bool get hasImage => imageUrl != null;
  bool get isRunning =>
      taskStatus == GenerationStatus.running ||
      taskStatus == GenerationStatus.queued;
}
