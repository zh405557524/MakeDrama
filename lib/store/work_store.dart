import 'dart:async';

import 'package:get/get.dart';

import '../models/index.dart';

class WorkStore extends GetxController {
  static WorkStore get to => Get.find<WorkStore>();
  final List<DramaWork> works = [];
  DramaWork? currentWork;
  bool isParsing = false;
  int selectedStoryboardIndex = 0;

  void seed() {
    final demo = _buildWork(
      name: '雨夜霓虹',
      storyText: '雨夜里，少年林风站在废城入口，远处的霓虹像火焰一样燃烧。',
      completed: true,
    );
    demo.currentStep = WorkStep.completed;
    demo.videoUrl = 'mock://video/rain-night';
    works.add(demo);

    final draft = _buildWork(
      name: '黑暗密林',
      storyText: '幽深密林中，林风察觉到异样，夜冥的黑暗气息逼近。',
    );
    draft.currentStep = WorkStep.storyboards;
    works.add(draft);
  }

  Future<DramaWork> parseAndCreate(String content) async {
    if (isParsing) return currentWork!;
    isParsing = true;
    update();
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final work = _buildWork(name: _nameFromText(content), storyText: content);
    work.currentStep = WorkStep.characters;
    currentWork = work;
    works.insert(0, work);
    isParsing = false;
    update();
    return work;
  }

  void openWork(DramaWork work) {
    currentWork = work;
    selectedStoryboardIndex = 0;
    update();
  }

  Future<void> generateCharacter(CharacterProfile character) async {
    if (character.isRunning) return;
    character.taskStatus = GenerationStatus.running;
    character.runningTaskId =
        'task-character-${character.id}-${DateTime.now().millisecondsSinceEpoch}';
    update();
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    character.imageUrl = 'mock://character/${character.id}';
    character.taskStatus = GenerationStatus.succeeded;
    character.runningTaskId = null;
    update();
  }

  Future<void> generateScene(SceneProfile scene) async {
    if (scene.isRunning) return;
    scene.taskStatus = GenerationStatus.running;
    scene.runningTaskId =
        'task-scene-${scene.id}-${DateTime.now().millisecondsSinceEpoch}';
    update();
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    scene.imageUrl = 'mock://scene/${scene.id}';
    scene.taskStatus = GenerationStatus.succeeded;
    scene.runningTaskId = null;
    update();
  }

  bool get hasRunningCharacterTask {
    return currentWork?.characters.any((item) => item.isRunning) ?? false;
  }

  bool get hasRunningSceneTask {
    return currentWork?.scenes.any((item) => item.isRunning) ?? false;
  }

  void toggleCharacterSelected(CharacterProfile character) {
    character.selected = !character.selected;
    update();
  }

  void toggleSceneSelected(SceneProfile scene) {
    scene.selected = !scene.selected;
    update();
  }

  void confirmCharacters() {
    if (hasRunningCharacterTask) return;
    currentWork?.currentStep = WorkStep.scenes;
    update();
  }

  void confirmScenes() {
    if (hasRunningSceneTask) return;
    currentWork?.currentStep = WorkStep.storyboards;
    update();
  }

  StoryboardShot get selectedStoryboard {
    final work = currentWork!;
    return work.storyboards[selectedStoryboardIndex.clamp(
      0,
      work.storyboards.length - 1,
    )];
  }

  void selectStoryboard(int index) {
    selectedStoryboardIndex = index;
    update();
  }

  void updateStoryboardDescription(String value) {
    selectedStoryboard.description = value;
    update();
  }

  void toggleStoryboardCharacter(String characterId) {
    final ids = selectedStoryboard.characterIds;
    if (ids.contains(characterId)) {
      ids.remove(characterId);
    } else {
      ids.add(characterId);
    }
    update();
  }

  void setStoryboardScene(String? sceneId) {
    selectedStoryboard.sceneId = sceneId;
    update();
  }

  void updateStoryboardStyle(String value) {
    selectedStoryboard.style = value;
    update();
  }

  void updateStoryboardVoice(String value) {
    selectedStoryboard.voicePreset = value;
    update();
  }

  void updateStoryboardBgm(String value) {
    selectedStoryboard.bgmPreset = value;
    update();
  }

  Future<void> generateStoryboard(StoryboardShot shot) async {
    if (shot.isRunning) return;
    shot.taskStatus = GenerationStatus.running;
    shot.runningTaskId =
        'task-storyboard-${shot.id}-${DateTime.now().millisecondsSinceEpoch}';
    update();
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    shot.imageUrl = 'mock://storyboard/${shot.id}';
    shot.taskStatus = GenerationStatus.succeeded;
    shot.runningTaskId = null;
    currentWork?.currentStep = WorkStep.preview;
    update();
  }

  Future<void> generateAllStoryboards() async {
    final work = currentWork;
    if (work == null) return;
    final pending = work.storyboards
        .where((item) => !item.isRunning && item.imageUrl == null)
        .toList();
    for (final shot in pending) {
      unawaited(generateStoryboard(shot));
    }
  }

  Future<void> generateVideo() async {
    final work = currentWork;
    if (work == null || work.isVideoRunning) return;
    work.currentStep = WorkStep.preview;
    work.videoTaskStatus = GenerationStatus.running;
    update();
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    work.videoUrl = 'mock://video/${work.id}';
    work.videoTaskStatus = GenerationStatus.succeeded;
    work.currentStep = WorkStep.completed;
    update();
  }

  DramaWork _buildWork({
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
        imageUrl: completed
            ? 'mock://character/linfeng'
            : 'mock://character/linfeng',
      ),
      CharacterProfile(
        id: 'yeming',
        name: '夜冥',
        roleTag: '反派',
        description: '上古魔神，掌控黑暗之力，欲吞噬世间所有光明',
        imageUrl: completed
            ? 'mock://character/yeming'
            : 'mock://character/yeming',
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
        imageUrl: completed ? 'mock://scene/forest' : 'mock://scene/forest',
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
        imageUrl: completed ? 'mock://shot/1' : 'mock://shot/1',
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
      StoryboardShot(
        id: 'shot5',
        sortOrder: 5,
        description: '一道金色剑光划破黑夜，林风跃起迎向夜冥，战斗正式爆发。',
        characterIds: ['linfeng', 'yeming'],
        sceneId: 'forest',
        style: '科幻赛博',
        voicePreset: '霸气 · 男声',
        bgmPreset: '终极战歌',
      ),
      StoryboardShot(
        id: 'shot6',
        sortOrder: 6,
        description: '黑雾散去，天光落下，林风回望废城，新的旅程才刚刚开始。',
        characterIds: ['linfeng'],
        sceneId: 'ruins',
        style: '国风水墨',
        voicePreset: '中气 · 洪亮',
        bgmPreset: '静谧空灵',
      ),
    ];

    return DramaWork(
      id: 'work-${DateTime.now().microsecondsSinceEpoch}-${works.length}',
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
    return normalized.length > 6 ? normalized.substring(0, 6) : normalized;
  }
}
