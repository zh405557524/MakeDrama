part of 'package:make_drama/pages/home/index.dart';

/// 首页控制器：负责首页入口、作品打开和路由分发。
class HomeController extends GetxController {
  late final WorkStore workStore;
  late final VoidCallback _storeListener;

  WorkService get _workService => Get.find<WorkService>();

  @override
  void onInit() {
    super.onInit();
    workStore = WorkStore.to;
    _storeListener = () => update();
    workStore.addListener(_storeListener);
    unawaited(loadWorks());
  }

  @override
  void onClose() {
    workStore.removeListener(_storeListener);
    super.onClose();
  }

  /// 进入作品创建页。
  void openStoryInput(BuildContext context) {
    context.pushNamed(RouteName.storyInput);
  }

  /// 根据作品当前步骤进入对应业务页面。
  void openWork(BuildContext context, DramaWork work) {
    workStore.openWork(work);
    unawaited(loadCurrentStep());
    final routeName = switch (work.currentStep) {
      WorkStep.draft => RouteName.storyInput,
      WorkStep.characters => RouteName.characterGenerate,
      WorkStep.scenes => RouteName.sceneGenerate,
      WorkStep.storyboards => RouteName.storyboardEdit,
      WorkStep.preview || WorkStep.completed => RouteName.videoPreview,
    };
    context.pushNamed(routeName);
  }

  /// 首页作品列表加载业务。
  Future<void> loadWorks() async {
    workStore.setLoadingWorks(true);
    workStore.clearError();
    try {
      final works = await _workService.listWorks();
      workStore.setWorks(works);
    } catch (error) {
      workStore.setError(error);
    } finally {
      workStore.setLoadingWorks(false);
    }
  }

  /// 打开作品时按作品步骤拉取该步骤所需数据。
  Future<void> loadCurrentStep() async {
    final work = workStore.currentWork;
    if (work == null) return;

    workStore.setLoadingStep(true);
    workStore.clearError();
    try {
      final loaded = switch (work.currentStep) {
        WorkStep.draft => work,
        WorkStep.characters => await _workService.loadCharacters(work.id),
        WorkStep.scenes => await _workService.loadScenes(work.id),
        WorkStep.storyboards => await _workService.loadStoryboards(work.id),
        WorkStep.preview ||
        WorkStep.completed => await _workService.loadVideo(work.id),
      };
      workStore.mergeCurrentWork(loaded);
    } catch (error) {
      workStore.setError(error);
    } finally {
      workStore.setLoadingStep(false);
    }
  }
}
