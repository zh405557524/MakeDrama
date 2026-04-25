import '../enums/index.dart';
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
  String? videoUrl;
  GenerationStatus videoTaskStatus;

  bool get hasVideo => videoUrl != null;
  bool get isVideoRunning => videoTaskStatus == GenerationStatus.running;
  String get coverSeed => storyboards
      .firstWhere((e) => e.imageUrl != null, orElse: () => storyboards.first)
      .id;
}
