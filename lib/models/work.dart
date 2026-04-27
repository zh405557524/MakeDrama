import '../enums/index.dart';
import '../utils/index.dart';
import 'character.dart';
import 'scene.dart';
import 'storyboard.dart';

class DramaWork {
  DramaWork({
    required this.id,
    required this.name,
    required this.storyText,
    required this.currentStep,
    required this.characters,
    required this.scenes,
    required this.storyboards,
    this.durationSeconds = 12,
    this.coverUrl,
    this.videoUrl,
    this.videoTaskStatus = GenerationStatus.idle,
  });

  final String id;
  String name;
  String storyText;
  WorkStep currentStep;
  final List<CharacterProfile> characters;
  final List<SceneProfile> scenes;
  final List<StoryboardShot> storyboards;
  int durationSeconds;
  String? coverUrl;
  String? videoUrl;
  GenerationStatus videoTaskStatus;

  bool get hasVideo => videoUrl != null;
  bool get isVideoRunning => videoTaskStatus.isActive;
  String get coverSeed {
    if (storyboards.isEmpty) return coverUrl ?? id;
    return storyboards
        .firstWhere((e) => e.imageUrl != null, orElse: () => storyboards.first)
        .id;
  }

  factory DramaWork.fromJson(
    Map<String, dynamic> json, {
    String? storyText,
    List<CharacterProfile>? characters,
    List<SceneProfile>? scenes,
    List<StoryboardShot>? storyboards,
    String? videoUrl,
    GenerationStatus? videoTaskStatus,
  }) {
    return DramaWork(
      id: jsonStringValue(json['id'] ?? json['workId']),
      name: jsonStringValue(json['name'], fallback: '未命名漫剧'),
      storyText: storyText ?? jsonStringValue(json['storyText']),
      currentStep: workStepFromJson(json['currentStep']),
      characters: characters ?? <CharacterProfile>[],
      scenes: scenes ?? <SceneProfile>[],
      storyboards: storyboards ?? <StoryboardShot>[],
      durationSeconds: jsonInt(json['durationSeconds'], fallback: 12),
      coverUrl: jsonString(json['coverUrl']),
      videoUrl: videoUrl ?? jsonString(json['videoUrl']),
      videoTaskStatus:
          videoTaskStatus ??
          generationStatusFromJson(json['videoStatus'] ?? json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'storyText': storyText,
      'currentStep': currentStep.wireName,
      'characters': characters.map((item) => item.toJson()).toList(),
      'scenes': scenes.map((item) => item.toJson()).toList(),
      'storyboards': storyboards.map((item) => item.toJson()).toList(),
      'durationSeconds': durationSeconds,
      'coverUrl': coverUrl,
      'videoUrl': videoUrl,
      'videoTaskStatus': videoTaskStatus.wireName,
    };
  }
}
