import 'dart:async';

import 'package:get/get.dart';

import '../apis/index.dart';
import '../models/index.dart';
import '../utils/index.dart';

class WorkService extends GetxService {
  final List<DramaWork> _mockWorks = [];

  bool get useMock => AppConfig.useMockApi || Get.testMode;

  Future<List<DramaWork>> listWorks() async {
    if (useMock) {
      _seedMockWorks();
      return _mockWorks;
    }

    final result = await WorkAPI.getWorks();
    return result.items;
  }

  Future<DramaWork> parseAndCreate(String content) async {
    if (useMock) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      final work = _buildMockWork(
        name: _nameFromText(content),
        storyText: content,
      );
      work.currentStep = WorkStep.characters;
      _mockWorks.insert(0, work);
      return work;
    }

    return (await WorkAPI.parseStory(content: content)).work;
  }

  Future<DramaWork> loadCharacters(String workId) async {
    if (useMock) return _findMockWork(workId);
    return (await CharacterAPI.getCharacters(workId)).work;
  }

  Future<GenerationTaskModel> createCharacterImageTask({
    required String workId,
    required CharacterProfile character,
  }) async {
    if (useMock) {
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      character.imageUrl = 'mock://character/${character.id}';
      character.taskStatus = GenerationStatus.succeeded;
      character.runningTaskId = null;
      return _mockSucceededTask(
        workId: workId,
        taskType: 'character_image',
        targetType: 'character',
        targetId: character.id,
      );
    }

    return _taskFromTicket(
      await CharacterAPI.createImageTask(
        workId: workId,
        characterId: character.id,
      ),
      workId: workId,
      taskType: 'character_image',
      targetType: 'character',
      targetId: character.id,
    );
  }

  Future<DramaWork> saveCharacterSelection({
    required String workId,
    required List<String> selectedCharacterIds,
  }) async {
    if (useMock) {
      final work = _findMockWork(workId);
      for (final item in work.characters) {
        item.selected = selectedCharacterIds.contains(item.id);
      }
      work.currentStep = WorkStep.scenes;
      return work;
    }

    await CharacterAPI.saveSelection(
      workId: workId,
      selectedCharacterIds: selectedCharacterIds,
    );
    return loadScenes(workId);
  }

  Future<DramaWork> loadScenes(String workId) async {
    if (useMock) return _findMockWork(workId);
    return (await SceneAPI.getScenes(workId)).work;
  }

  Future<GenerationTaskModel> createSceneImageTask({
    required String workId,
    required SceneProfile scene,
  }) async {
    if (useMock) {
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      scene.imageUrl = 'mock://scene/${scene.id}';
      scene.taskStatus = GenerationStatus.succeeded;
      scene.runningTaskId = null;
      return _mockSucceededTask(
        workId: workId,
        taskType: 'scene_image',
        targetType: 'scene',
        targetId: scene.id,
      );
    }

    return _taskFromTicket(
      await SceneAPI.createImageTask(workId: workId, sceneId: scene.id),
      workId: workId,
      taskType: 'scene_image',
      targetType: 'scene',
      targetId: scene.id,
    );
  }

  Future<DramaWork> saveSceneSelection({
    required String workId,
    required List<String> selectedSceneIds,
  }) async {
    if (useMock) {
      final work = _findMockWork(workId);
      for (final item in work.scenes) {
        item.selected = selectedSceneIds.contains(item.id);
      }
      work.currentStep = WorkStep.storyboards;
      return work;
    }

    await SceneAPI.saveSelection(
      workId: workId,
      selectedSceneIds: selectedSceneIds,
    );
    return loadStoryboards(workId);
  }

  Future<DramaWork> loadStoryboards(String workId) async {
    if (useMock) return _findMockWork(workId);
    return (await StoryboardAPI.getStoryboards(workId)).work;
  }

  Future<void> updateStoryboard({
    required String workId,
    required StoryboardShot shot,
  }) async {
    if (useMock) return;
    await StoryboardAPI.updateStoryboard(workId: workId, shot: shot);
  }

  Future<GenerationTaskModel> generateStoryboard({
    required String workId,
    required StoryboardShot shot,
  }) async {
    if (useMock) {
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      shot.imageUrl = 'mock://storyboard/${shot.id}';
      shot.taskStatus = GenerationStatus.succeeded;
      shot.runningTaskId = null;
      _findMockWork(workId).currentStep = WorkStep.preview;
      return _mockSucceededTask(
        workId: workId,
        taskType: 'storyboard_asset',
        targetType: 'storyboard',
        targetId: shot.id,
      );
    }

    return _taskFromTicket(
      await StoryboardAPI.generateStoryboard(
        workId: workId,
        storyboardId: shot.id,
      ),
      workId: workId,
      taskType: 'storyboard_asset',
      targetType: 'storyboard',
      targetId: shot.id,
    );
  }

  Future<GenerationTaskModel> generateAllStoryboards(String workId) async {
    if (useMock) {
      final work = _findMockWork(workId);
      for (final shot in work.storyboards.where((item) => !item.hasImage)) {
        shot.imageUrl = 'mock://storyboard/${shot.id}';
        shot.taskStatus = GenerationStatus.succeeded;
        shot.runningTaskId = null;
      }
      work.currentStep = WorkStep.preview;
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      return _mockSucceededTask(
        workId: workId,
        taskType: 'storyboard_batch',
        targetType: 'storyboard',
      );
    }

    return _taskFromTicket(
      await StoryboardAPI.generateAllStoryboards(workId),
      workId: workId,
      taskType: 'storyboard_batch',
      targetType: 'storyboard',
    );
  }

  Future<DramaWork> loadVideo(String workId) async {
    if (useMock) return _findMockWork(workId);
    return (await VideoAPI.getVideo(workId)).work;
  }

  Future<GenerationTaskModel> generateVideo(String workId) async {
    if (useMock) {
      final work = _findMockWork(workId);
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      work.videoUrl = 'mock://video/$workId';
      work.videoTaskStatus = GenerationStatus.succeeded;
      work.currentStep = WorkStep.completed;
      return _mockSucceededTask(
        workId: workId,
        taskType: 'video',
        targetType: 'work',
        targetId: workId,
      );
    }

    return _taskFromTicket(
      await VideoAPI.generateVideo(workId),
      workId: workId,
      taskType: 'video',
      targetType: 'work',
      targetId: workId,
    );
  }

  Future<String> createShareLink(String workId) async {
    if (useMock) {
      return 'mock://share/$workId';
    }
    final result = await VideoAPI.createShareLink(workId: workId);
    return result.url;
  }

  GenerationTaskModel _taskFromTicket(
    TaskTicket ticket, {
    required String workId,
    required String taskType,
    required String targetType,
    String? targetId,
  }) {
    if (ticket.taskId == null) {
      return _mockSucceededTask(
        workId: workId,
        taskType: taskType,
        targetType: targetType,
        targetId: targetId,
      );
    }
    return GenerationTaskModel(
      taskId: ticket.taskId!,
      workId: workId,
      taskType: taskType,
      targetType: targetType,
      targetId: targetId,
      status: ticket.status,
      progress: ticket.progress,
      errorMessage: ticket.errorMessage,
      pollingIntervalMs: ticket.pollingIntervalMs,
    );
  }

  GenerationTaskModel _mockSucceededTask({
    required String workId,
    required String taskType,
    required String targetType,
    String? targetId,
  }) {
    return GenerationTaskModel(
      taskId: 'mock-${DateTime.now().microsecondsSinceEpoch}',
      workId: workId,
      taskType: taskType,
      targetType: targetType,
      targetId: targetId,
      status: GenerationStatus.succeeded,
      progress: 100,
      pollingIntervalMs: 200,
    );
  }

  DramaWork _findMockWork(String workId) {
    _seedMockWorks();
    return _mockWorks.firstWhere(
      (item) => item.id == workId,
      orElse: () => _mockWorks.first,
    );
  }

  void _seedMockWorks() {
    if (_mockWorks.isNotEmpty) return;

    final demo = _buildMockWork(
      name: '雨夜霓虹',
      storyText: '雨夜里，少年林风站在废城入口。远处黑雾翻涌，传说中的夜冥即将苏醒。',
      completed: true,
    );
    demo.currentStep = WorkStep.completed;
    demo.videoUrl = 'mock://video/rain-night';
    _mockWorks.add(demo);

    final draft = _buildMockWork(
      name: '黑暗密林',
      storyText: '幽深密林中，林风察觉到异样，夜冥的黑暗气息逼近。',
    );
    draft.currentStep = WorkStep.storyboards;
    _mockWorks.add(draft);
  }

  DramaWork _buildMockWork({
    required String name,
    required String storyText,
    bool completed = false,
  }) {
    final characters = <CharacterProfile>[
      CharacterProfile(
        id: 'linfeng',
        name: '林风',
        roleTag: '主角',
        description: '十八岁少年，天赋异禀，心怀苍生，手持玄铁战戟',
        imageUrl: 'mock://character/linfeng',
      ),
      CharacterProfile(
        id: 'yeming',
        name: '夜冥',
        roleTag: '反派',
        description: '上古魔神，掌控黑暗之力，欲吞噬世间所有光明',
        imageUrl: 'mock://character/yeming',
      ),
      CharacterProfile(
        id: 'suxue',
        name: '苏雪',
        roleTag: '女主',
        description: '冰雪仙子，医术精湛，外冷内热，暗恋林风',
      ),
      CharacterProfile(
        id: 'tianxing',
        name: '天行者',
        roleTag: '导师',
        description: '隐世高人，白须飘飘，是林风修行路上的引路人',
        selected: false,
      ),
    ];

    final scenes = <SceneProfile>[
      SceneProfile(
        id: 'forest',
        name: '黑暗密林',
        description: '幽深密林，雾气弥漫，夜色压住树冠',
        tags: ['暗色系', '紧张'],
        imageUrl: 'mock://scene/forest',
      ),
      SceneProfile(
        id: 'raincity',
        name: '雨夜街口',
        description: '霓虹雨幕下的废城入口，危机逼近',
        tags: ['彩色系', '危机'],
      ),
      SceneProfile(
        id: 'ruins',
        name: '古城废墟',
        description: '断壁残垣与古老符文交错，风声低沉',
        tags: ['国风水墨', '厚重'],
      ),
    ];

    final storyboards = <StoryboardShot>[
      StoryboardShot(
        id: 'shot1',
        sortOrder: 1,
        description: '晴空万里，少年林风孤身站在悬崖之前，远望被黑雾侵蚀的苍茫大地。',
        characterIds: ['linfeng'],
        sceneId: 'raincity',
        style: '暗色系',
        voicePreset: '少年感 · 雄厚',
        bgmPreset: '史诗战鼓',
        imageUrl: 'mock://shot/1',
      ),
      StoryboardShot(
        id: 'shot2',
        sortOrder: 2,
        description: '远处传来低沉号角，黑雾中浮现夜冥的轮廓，林风握紧战戟。',
        characterIds: ['linfeng', 'yeming'],
        sceneId: 'forest',
        style: '暗色系',
        voicePreset: '少年感 · 激昂',
        bgmPreset: '黑暗低鸣',
        imageUrl: completed ? 'mock://shot/2' : null,
      ),
      StoryboardShot(
        id: 'shot3',
        sortOrder: 3,
        description: '苏雪踏雪而来，掌心灵光亮起，为林风指明通往古城的路线。',
        characterIds: ['linfeng', 'suxue'],
        sceneId: 'ruins',
        style: '清新淡雅',
        voicePreset: '温柔 · 女声',
        bgmPreset: '温情旋律',
      ),
      StoryboardShot(
        id: 'shot4',
        sortOrder: 4,
        description: '幽深密林中，林风察觉到异样，夜冥的黑暗气息如潮水般涌来。',
        characterIds: ['linfeng', 'yeming'],
        sceneId: 'forest',
        style: '暗色系',
        voicePreset: '少年感 · 雄厚',
        bgmPreset: '黑暗低鸣',
      ),
    ];

    return DramaWork(
      id: 'work-${DateTime.now().microsecondsSinceEpoch}-${_mockWorks.length}',
      name: name,
      storyText: storyText,
      currentStep: WorkStep.characters,
      characters: characters,
      scenes: scenes,
      storyboards: storyboards,
      videoUrl: completed ? 'mock://video/completed' : null,
      videoTaskStatus: completed
          ? GenerationStatus.succeeded
          : GenerationStatus.idle,
    );
  }

  String _nameFromText(String content) {
    final normalized = content.trim().replaceAll('\n', ' ');
    if (normalized.isEmpty) return '未命名漫剧';
    return normalized.length > 8 ? normalized.substring(0, 8) : normalized;
  }
}
