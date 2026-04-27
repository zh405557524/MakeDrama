part of 'package:make_drama/pages/character_generate/index.dart';

/// 角色生成页控制器：负责角色图片任务、选择状态和步骤推进。
class CharacterGenerateController extends GetxController {
  late final WorkStore workStore;
  late final VoidCallback _storeListener;

  WorkService get _workService => Get.find<WorkService>();
  TaskPollingService get _taskPollingService => Get.find<TaskPollingService>();

  @override
  void onInit() {
    super.onInit();
    workStore = WorkStore.to;
    _storeListener = () => update();
    workStore.addListener(_storeListener);
  }

  @override
  void onClose() {
    workStore.removeListener(_storeListener);
    super.onClose();
  }

  /// 生成或重新生成角色图。
  Future<void> generateCharacter(CharacterProfile character) async {
    final work = workStore.currentWork;
    if (work == null || character.isRunning) return;

    workStore.markCharacterRunning(character);
    try {
      final task = await _workService.createCharacterImageTask(
        workId: work.id,
        character: character,
      );
      workStore.applyTask(task);
      _watchTask(task);
    } catch (error) {
      workStore.markCharacterFailed(character, error);
    }
  }

  /// 切换作品级角色选择。
  void toggleCharacterSelected(CharacterProfile character) {
    workStore.toggleCharacterSelected(character);
  }

  /// 保存角色选择，成功后进入场景页。
  Future<void> confirmCharacters(BuildContext context) async {
    final work = workStore.currentWork;
    if (work == null || workStore.hasRunningCharacterTask) return;

    final previousStep = work.currentStep;
    workStore.setCurrentStep(WorkStep.scenes);
    try {
      final loaded = await _workService.saveCharacterSelection(
        workId: work.id,
        selectedCharacterIds: work.characters
            .where((item) => item.selected)
            .map((item) => item.id)
            .toList(),
      );
      workStore.mergeCurrentWork(loaded);
      if (!context.mounted) return;
      context.goNamed(RouteName.sceneGenerate);
    } catch (error) {
      workStore.setCurrentStep(previousStep);
      workStore.setError(error);
    }
  }

  /// 当前没有作品时回到首页。
  void backHome(BuildContext context) {
    context.goNamed(RouteName.home);
  }

  void _watchTask(GenerationTaskModel task) {
    if (task.status.isTerminal) {
      unawaited(_handleTaskFinished(task));
      return;
    }

    _taskPollingService.watch(
      task,
      onTick: (latest) => workStore.applyTask(latest),
      onFinished: _handleTaskFinished,
      onError: workStore.setError,
    );
  }

  Future<void> _handleTaskFinished(GenerationTaskModel task) async {
    workStore.applyTask(task);
    if (task.status == GenerationStatus.failed) {
      workStore.setError(task.errorMessage ?? '角色图片生成失败');
      return;
    }

    final work = workStore.currentWork;
    if (work == null) return;
    try {
      final loaded = await _workService.loadCharacters(work.id);
      workStore.mergeCurrentWork(loaded);
    } catch (error) {
      workStore.setError(error);
    }
  }
}
