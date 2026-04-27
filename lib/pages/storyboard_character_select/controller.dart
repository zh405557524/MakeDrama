part of 'package:make_drama/pages/storyboard_character_select/index.dart';

/// 分镜角色选择页控制器：负责当前分镜的角色多选。
class StoryboardCharacterSelectController extends GetxController {
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

  /// 切换当前分镜中的角色。
  void toggleStoryboardCharacter(String characterId) {
    workStore.toggleStoryboardCharacter(characterId);
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
