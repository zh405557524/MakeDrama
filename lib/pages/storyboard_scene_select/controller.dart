part of 'package:make_drama/pages/storyboard_scene_select/index.dart';

/// 分镜场景选择页控制器：负责当前分镜的场景单选。
class StoryboardSceneSelectController extends GetxController {
  late final WorkStore workStore;
  late final VoidCallback _storeListener;

  WorkService get _workService => Get.find<WorkService>();

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

  /// 设置当前分镜的唯一场景。
  void setStoryboardScene(String sceneId) {
    workStore.setStoryboardScene(sceneId);
  }

  /// 应用选择并返回上一页。
  Future<void> apply(BuildContext context) async {
    final work = workStore.currentWork;
    final shot = workStore.selectedStoryboard;
    if (work == null || shot.id == 'empty') return;

    try {
      await _workService.updateStoryboard(workId: work.id, shot: shot);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      workStore.setError(error);
    }
  }

  /// 当前没有作品时回到首页。
  void backHome(BuildContext context) {
    context.goNamed(RouteName.home);
  }
}
