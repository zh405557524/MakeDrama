import 'package:get/get.dart';

import '../models/index.dart';

/// 作品全局状态容器。
///
/// 这里只保存跨页面共享的数据和同步状态变更；接口调用、轮询、
/// 页面跳转等业务流程放在各页面 Controller 中。
class WorkStore extends GetxController {
  static WorkStore get to => Get.find<WorkStore>();

  final List<DramaWork> works = [];
  DramaWork? currentWork;
  bool isParsing = false;
  bool isLoadingWorks = false;
  bool isLoadingStep = false;
  String? errorMessage;
  int selectedStoryboardIndex = 0;

  bool get hasRunningCharacterTask {
    return currentWork?.characters.any((item) => item.isRunning) ?? false;
  }

  bool get hasRunningSceneTask {
    return currentWork?.scenes.any((item) => item.isRunning) ?? false;
  }

  StoryboardShot get selectedStoryboard {
    final work = currentWork;
    if (work == null || work.storyboards.isEmpty) {
      return StoryboardShot(
        id: 'empty',
        sortOrder: 1,
        description: '暂无分镜',
        characterIds: const [],
        sceneId: null,
        style: '暗色系',
        voicePreset: '少年感 · 雄厚',
        bgmPreset: '史诗战鼓',
      );
    }
    return work.storyboards[selectedStoryboardIndex.clamp(
      0,
      work.storyboards.length - 1,
    )];
  }

  void setWorks(List<DramaWork> data) {
    works
      ..clear()
      ..addAll(data);
    update();
  }

  void setParsing(bool value) {
    isParsing = value;
    update();
  }

  void setLoadingWorks(bool value) {
    isLoadingWorks = value;
    update();
  }

  void setLoadingStep(bool value) {
    isLoadingStep = value;
    update();
  }

  void setError(Object? error) {
    errorMessage = error == null ? null : errorText(error);
    update();
  }

  void clearError() {
    errorMessage = null;
    update();
  }

  void openWork(DramaWork work) {
    currentWork = work;
    selectedStoryboardIndex = 0;
    errorMessage = null;
    update();
  }

  void mergeCurrentWork(DramaWork next, {bool replaceCurrent = false}) {
    final current = currentWork;
    if (replaceCurrent || current == null || current.id != next.id) {
      currentWork = next;
      upsertWork(next);
      selectedStoryboardIndex = 0;
      update();
      return;
    }

    current.name = next.name;
    current.currentStep = next.currentStep;
    current.durationSeconds = next.durationSeconds;
    current.coverUrl = next.coverUrl ?? current.coverUrl;
    current.videoUrl = next.videoUrl;
    current.videoTaskStatus = next.videoTaskStatus;

    if (next.storyText.isNotEmpty) current.storyText = next.storyText;
    if (next.characters.isNotEmpty) {
      current.characters
        ..clear()
        ..addAll(next.characters);
    }
    if (next.scenes.isNotEmpty) {
      current.scenes
        ..clear()
        ..addAll(next.scenes);
    }
    if (next.storyboards.isNotEmpty) {
      current.storyboards
        ..clear()
        ..addAll(next.storyboards);
      _normalizeStoryboardIndex();
    }

    upsertWork(current);
    update();
  }

  void upsertWork(DramaWork work) {
    final index = works.indexWhere((item) => item.id == work.id);
    if (index >= 0) {
      works[index] = work;
    } else {
      works.insert(0, work);
    }
    update();
  }

  void setCurrentStep(WorkStep step) {
    currentWork?.currentStep = step;
    update();
  }

  void selectStoryboard(int index) {
    selectedStoryboardIndex = index;
    _normalizeStoryboardIndex();
    update();
  }

  void toggleCharacterSelected(CharacterProfile character) {
    character.selected = !character.selected;
    update();
  }

  void toggleSceneSelected(SceneProfile scene) {
    scene.selected = !scene.selected;
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

  void markCharacterRunning(CharacterProfile character) {
    character.taskStatus = GenerationStatus.running;
    character.runningTaskId =
        'local-character-${DateTime.now().microsecondsSinceEpoch}';
    update();
  }

  void markSceneRunning(SceneProfile scene) {
    scene.taskStatus = GenerationStatus.running;
    scene.runningTaskId =
        'local-scene-${DateTime.now().microsecondsSinceEpoch}';
    update();
  }

  void markStoryboardRunning(StoryboardShot shot) {
    shot.taskStatus = GenerationStatus.running;
    shot.runningTaskId =
        'local-storyboard-${DateTime.now().microsecondsSinceEpoch}';
    update();
  }

  void markPendingStoryboardsRunning() {
    final work = currentWork;
    if (work == null) return;
    for (final shot in work.storyboards.where((item) => !item.hasImage)) {
      markStoryboardRunning(shot);
    }
    update();
  }

  void markVideoRunning() {
    final work = currentWork;
    if (work == null) return;
    work.currentStep = WorkStep.preview;
    work.videoTaskStatus = GenerationStatus.running;
    update();
  }

  void markCharacterFailed(CharacterProfile character, Object error) {
    character.taskStatus = GenerationStatus.failed;
    character.runningTaskId = null;
    errorMessage = errorText(error);
    update();
  }

  void markSceneFailed(SceneProfile scene, Object error) {
    scene.taskStatus = GenerationStatus.failed;
    scene.runningTaskId = null;
    errorMessage = errorText(error);
    update();
  }

  void markStoryboardFailed(StoryboardShot shot, Object error) {
    shot.taskStatus = GenerationStatus.failed;
    shot.runningTaskId = null;
    errorMessage = errorText(error);
    update();
  }

  void markRunningStoryboardsFailed(Object error) {
    final work = currentWork;
    if (work == null) return;
    for (final shot in work.storyboards.where((item) => item.isRunning)) {
      shot.taskStatus = GenerationStatus.failed;
      shot.runningTaskId = null;
    }
    errorMessage = errorText(error);
    update();
  }

  void markVideoFailed(Object error) {
    final work = currentWork;
    if (work == null) return;
    work.videoTaskStatus = GenerationStatus.failed;
    errorMessage = errorText(error);
    update();
  }

  void applyTask(GenerationTaskModel task) {
    final work = currentWork;
    if (work == null) return;

    if (task.taskType == 'video') {
      work.videoTaskStatus = task.status;
      if (task.status == GenerationStatus.succeeded) {
        work.currentStep = WorkStep.completed;
      }
      update();
      return;
    }

    if (task.taskType == 'storyboard_batch' && task.targetId == null) {
      for (final shot in work.storyboards.where((item) => item.isRunning)) {
        shot.taskStatus = task.status;
        if (task.status.isTerminal) shot.runningTaskId = null;
      }
      update();
      return;
    }

    final targetId = task.targetId;
    if (targetId == null) return;

    switch (task.targetType) {
      case 'character':
        final character = work.characters.firstWhereOrNull(
          (item) => item.id == targetId,
        );
        if (character != null) {
          character.taskStatus = task.status;
          character.runningTaskId = task.status.isTerminal ? null : task.taskId;
        }
        break;
      case 'scene':
        final scene = work.scenes.firstWhereOrNull(
          (item) => item.id == targetId,
        );
        if (scene != null) {
          scene.taskStatus = task.status;
          scene.runningTaskId = task.status.isTerminal ? null : task.taskId;
        }
        break;
      case 'storyboard':
        final shot = work.storyboards.firstWhereOrNull(
          (item) => item.id == targetId,
        );
        if (shot != null) {
          shot.taskStatus = task.status;
          shot.runningTaskId = task.status.isTerminal ? null : task.taskId;
        }
        break;
    }
    update();
  }

  String errorText(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }

  void _normalizeStoryboardIndex() {
    final length = currentWork?.storyboards.length ?? 0;
    if (length == 0) {
      selectedStoryboardIndex = 0;
      return;
    }
    if (selectedStoryboardIndex >= length) selectedStoryboardIndex = length - 1;
    if (selectedStoryboardIndex < 0) selectedStoryboardIndex = 0;
  }
}
