part of 'package:make_drama/pages/video_preview/index.dart';

/// 视频预览页控制器：负责视频生成、分享和返回编辑。
class VideoPreviewController extends GetxController {
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

  /// 切换胶片分镜。
  void selectStoryboard(int index) => workStore.selectStoryboard(index);

  /// 创建视频生成任务。
  Future<void> generateVideo() async {
    final work = workStore.currentWork;
    if (work == null || work.isVideoRunning) return;

    workStore.markVideoRunning();
    try {
      final task = await _workService.generateVideo(work.id);
      workStore.applyTask(task);
      _watchTask(task);
    } catch (error) {
      workStore.markVideoFailed(error);
    }
  }

  /// 调用分享接口并给用户反馈。
  Future<void> share(BuildContext context) async {
    final work = workStore.currentWork;
    if (work == null || !work.hasVideo) return;

    String? url;
    try {
      url = await _workService.createShareLink(work.id);
    } catch (error) {
      workStore.setError(error);
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(url == null || url.isEmpty ? '分享链接生成失败' : '分享链接已生成：$url'),
      ),
    );
  }

  /// 返回分镜编辑页。
  void backToEdit(BuildContext context) {
    context.goNamed(RouteName.storyboardEdit);
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
      workStore.setError(task.errorMessage ?? '视频生成失败');
      return;
    }

    final work = workStore.currentWork;
    if (work == null) return;
    try {
      final loaded = await _workService.loadVideo(work.id);
      workStore.mergeCurrentWork(loaded);
    } catch (error) {
      workStore.setError(error);
    }
  }
}
