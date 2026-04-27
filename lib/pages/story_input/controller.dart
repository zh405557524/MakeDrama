part of 'package:make_drama/pages/story_input/index.dart';

/// 文本解析页控制器：负责提交文本并进入角色生成步骤。
class StoryInputController extends GetxController {
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

  /// 调用同步文本解析接口，成功后跳转到角色生成页。
  Future<void> parseAndCreate(BuildContext context, String content) async {
    if (workStore.isParsing) return;
    workStore.setParsing(true);
    workStore.clearError();
    try {
      final work = await _workService.parseAndCreate(content);
      workStore.mergeCurrentWork(work, replaceCurrent: true);
      workStore.upsertWork(work);
      workStore.openWork(work);
      if (!context.mounted) return;
      context.goNamed(RouteName.characterGenerate);
    } catch (error) {
      workStore.setError(error);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(workStore.errorMessage ?? '文本解析失败')),
      );
    } finally {
      workStore.setParsing(false);
    }
  }
}
