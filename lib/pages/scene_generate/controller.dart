part of 'package:make_drama/pages/scene_generate/index.dart';

/// 场景生成页控制器：负责场景图片任务、选择状态和步骤推进。
class SceneGenerateController extends GetxController {
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

  /// 生成或重新生成场景图。
  Future<void> generateScene(SceneProfile scene) async {
    final work = workStore.currentWork;
    if (work == null || scene.isRunning) return;

    workStore.markSceneRunning(scene);
    try {
      final task = await _workService.createSceneImageTask(
        workId: work.id,
        scene: scene,
      );
      workStore.applyTask(task);
      _watchTask(task);
    } catch (error) {
      workStore.markSceneFailed(scene, error);
    }
  }

  /// 切换作品级场景选择。
  void toggleSceneSelected(SceneProfile scene) {
    workStore.toggleSceneSelected(scene);
  }

  /// 保存场景选择，成功后进入分镜编辑页。
  Future<void> confirmScenes(BuildContext context) async {
    final work = workStore.currentWork;
    if (work == null || workStore.hasRunningSceneTask) return;

    final previousStep = work.currentStep;
    workStore.setCurrentStep(WorkStep.storyboards);
    try {
      final loaded = await _workService.saveSceneSelection(
        workId: work.id,
        selectedSceneIds: work.scenes
            .where((item) => item.selected)
            .map((item) => item.id)
            .toList(),
      );
      workStore.mergeCurrentWork(loaded);
      if (!context.mounted) return;
      context.goNamed(RouteName.storyboardEdit);
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
      workStore.setError(task.errorMessage ?? '场景图片生成失败');
      return;
    }

    final work = workStore.currentWork;
    if (work == null) return;
    try {
      final loaded = await _workService.loadScenes(work.id);
      workStore.mergeCurrentWork(loaded);
    } catch (error) {
      workStore.setError(error);
    }
  }
}
