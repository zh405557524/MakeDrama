import '../enums/index.dart';

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

  bool get hasImage => imageUrl != null;
  bool get isRunning =>
      taskStatus == GenerationStatus.running ||
      taskStatus == GenerationStatus.queued;
}
