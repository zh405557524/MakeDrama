import '../enums/index.dart';
import '../utils/index.dart';
import 'character.dart';
import 'scene.dart';
import 'storyboard.dart';

/// 漫剧作品聚合模型，包含角色、场景、分镜与视频状态。
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

  /// 是否已生成可播放视频。
  bool get hasVideo => videoUrl != null;

  /// 视频生成任务是否仍在处理中。
  bool get isVideoRunning => videoTaskStatus.isActive;

  /// 封面随机种子，优先使用已生成分镜的 ID。
  String get coverSeed {
    if (storyboards.isEmpty) return coverUrl ?? id;
    return storyboards
        .firstWhere((e) => e.imageUrl != null, orElse: () => storyboards.first)
        .id;
  }

  /// 从接口数据构建作品模型。
  ///
  /// 可通过可选参数注入已加载的关联数据，避免重复解析。
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

  /// 转换为完整 JSON 结构，便于缓存或本地持久化。
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

/// 作品列表查询结果。
class WorkListResult {
  WorkListResult({required this.items});

  final List<DramaWork> items;

  factory WorkListResult.fromJson(Map<String, dynamic> json) {
    return WorkListResult(
      items: jsonMapList(json['items']).map(DramaWork.fromJson).toList(),
    );
  }
}

/// 作品流程节点数据（角色/场景/分镜/视频）。
class WorkStepResult {
  WorkStepResult({
    required this.work,
    required this.characters,
    required this.scenes,
    required this.storyboards,
    this.videoUrl,
    this.videoTaskStatus = GenerationStatus.idle,
    this.runningVideoTaskId,
  });

  final DramaWork work;
  final List<CharacterProfile> characters;
  final List<SceneProfile> scenes;
  final List<StoryboardShot> storyboards;
  final String? videoUrl;
  final GenerationStatus videoTaskStatus;
  final String? runningVideoTaskId;

  factory WorkStepResult.fromJson(
    Map<String, dynamic> json, {
    required WorkStep fallbackStep,
  }) {
    final workJson = jsonMap(json['work']);
    final source = workJson.isEmpty ? json : workJson;
    final runningTaskId = jsonString(json['runningTaskId']);

    final work = DramaWork.fromJson(
      {
        ...source,
        'currentStep': source['currentStep'] ?? fallbackStep.wireName,
      },
      characters: jsonMapList(
        json['characters'],
      ).map(CharacterProfile.fromJson).toList(),
      scenes: jsonMapList(json['scenes']).map(SceneProfile.fromJson).toList(),
      storyboards: jsonMapList(
        json['storyboards'],
      ).map(StoryboardShot.fromJson).toList(),
      videoUrl: jsonString(json['videoUrl']),
      videoTaskStatus: runningTaskId != null
          ? GenerationStatus.running
          : generationStatusFromJson(json['status']),
    );

    if (runningTaskId != null) {
      work.videoTaskStatus = GenerationStatus.running;
    }

    return WorkStepResult(
      work: work,
      characters: work.characters,
      scenes: work.scenes,
      storyboards: work.storyboards,
      videoUrl: work.videoUrl,
      videoTaskStatus: work.videoTaskStatus,
      runningVideoTaskId: runningTaskId,
    );
  }
}
