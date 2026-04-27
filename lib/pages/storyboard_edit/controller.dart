part of 'package:make_drama/pages/storyboard_edit/index.dart';

/// 分镜编辑页控制器：负责分镜参数保存、资源生成和预览入口。
class StoryboardEditController extends GetxController {
  late final WorkStore workStore;
  late final VoidCallback _storeListener;

  Timer? _storyboardSaveDebounce;

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
    _storyboardSaveDebounce?.cancel();
    workStore.removeListener(_storeListener);
    super.onClose();
  }

  /// 选择当前编辑的分镜。
  void selectStoryboard(int index) => workStore.selectStoryboard(index);

  /// 更新分镜描述，并防抖保存到后端。
  void updateStoryboardDescription(String value) {
    final shot = workStore.selectedStoryboard;
    workStore.updateStoryboardDescription(value);
    _scheduleStoryboardSave(shot);
  }

  /// 更新画面风格。
  void updateStoryboardStyle(String value) {
    final shot = workStore.selectedStoryboard;
    workStore.updateStoryboardStyle(value);
    _scheduleStoryboardSave(shot);
  }

  /// 更新角色配音。
  void updateStoryboardVoice(String value) {
    final shot = workStore.selectedStoryboard;
    workStore.updateStoryboardVoice(value);
    _scheduleStoryboardSave(shot);
  }

  /// 更新背景音效。
  void updateStoryboardBgm(String value) {
    final shot = workStore.selectedStoryboard;
    workStore.updateStoryboardBgm(value);
    _scheduleStoryboardSave(shot);
  }

  /// 生成单个分镜资源。
  Future<void> generateStoryboard(StoryboardShot shot) async {
    final work = workStore.currentWork;
    if (work == null || shot.isRunning || shot.id == 'empty') return;

    await _saveStoryboardNow(shot);
    workStore.markStoryboardRunning(shot);
    try {
      final task = await _workService.generateStoryboard(
        workId: work.id,
        shot: shot,
      );
      workStore.applyTask(task);
      _watchTask(task);
    } catch (error) {
      workStore.markStoryboardFailed(shot, error);
    }
  }

  /// 一键生成所有未生成分镜资源。
  Future<void> generateAllStoryboards() async {
    final work = workStore.currentWork;
    if (work == null) return;

    workStore.markPendingStoryboardsRunning();
    try {
      final task = await _workService.generateAllStoryboards(work.id);
      workStore.applyTask(task);
      _watchTask(task);
    } catch (error) {
      workStore.markRunningStoryboardsFailed(error);
    }
  }

  /// 进入预览页前加载视频预览步骤数据。
  Future<void> enterPreview(BuildContext context) async {
    final work = workStore.currentWork;
    if (work == null) return;

    final previousStep = work.currentStep;
    workStore.setCurrentStep(WorkStep.preview);
    try {
      final loaded = await _workService.loadVideo(work.id);
      workStore.mergeCurrentWork(loaded);
      if (!context.mounted) return;
      context.pushNamed(RouteName.videoPreview);
    } catch (error) {
      workStore.setCurrentStep(previousStep);
      workStore.setError(error);
    }
  }

  /// 打开分镜角色选择页。
  void openCharacterSelect(BuildContext context) {
    context.pushNamed(RouteName.storyboardCharacterSelect);
  }

  /// 打开分镜场景选择页。
  void openSceneSelect(BuildContext context) {
    context.pushNamed(RouteName.storyboardSceneSelect);
  }

  /// 当前没有作品时回到首页。
  void backHome(BuildContext context) {
    context.goNamed(RouteName.home);
  }

  void _scheduleStoryboardSave(StoryboardShot shot) {
    if (shot.id == 'empty' || _workService.useMock) return;
    _storyboardSaveDebounce?.cancel();
    _storyboardSaveDebounce = Timer(
      const Duration(milliseconds: 600),
      () => unawaited(_saveStoryboardNow(shot)),
    );
  }

  Future<void> _saveStoryboardNow(StoryboardShot shot) async {
    final work = workStore.currentWork;
    if (work == null || shot.id == 'empty' || _workService.useMock) return;
    _storyboardSaveDebounce?.cancel();
    try {
      await _workService.updateStoryboard(workId: work.id, shot: shot);
    } catch (error) {
      workStore.setError(error);
    }
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
      workStore.setError(task.errorMessage ?? '分镜生成失败');
      return;
    }

    final work = workStore.currentWork;
    if (work == null) return;
    try {
      final loaded = await _workService.loadStoryboards(work.id);
      workStore.mergeCurrentWork(loaded);
    } catch (error) {
      workStore.setError(error);
    }
  }
}
