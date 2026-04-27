part of 'package:make_drama/pages/scene_generate/index.dart';

class SceneGeneratePage extends StatelessWidget {
  const SceneGeneratePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SceneGenerateController>(
      init: SceneGenerateController(),
      builder: (controller) {
        final workStore = controller.workStore;
        final work = workStore.currentWork;
        if (work == null) {
          return AppShell(
            child: Column(
              children: [
                const BrandTopBar(step: '3 / 4  场景匹配'),
                Expanded(
                  child: StepStateView(
                    icon: Icons.landscape_outlined,
                    title: '还没有选择作品',
                    message: '请先从首页创建或打开一个作品，再继续场景生成流程。',
                    actionLabel: '返回首页',
                    onPressed: () => controller.backHome(context),
                  ),
                ),
              ],
            ),
          );
        }
        final disabled = workStore.hasRunningSceneTask;
        return AppShell(
          child: Column(
            children: [
              const BrandTopBar(step: '3 / 4  场景匹配'),
              if (workStore.isLoadingStep)
                const LinearProgressIndicator(
                  minHeight: 3,
                  color: AppColors.brandBlue,
                  backgroundColor: Color(0xFF2E2642),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 18),
                  child: Column(
                    children: [
                      Pill(
                        label: '已解析 ${work.scenes.length} 个场景',
                        active: true,
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        '场景匹配',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '为场景生成画面图；有图即已生成，无图可点击生成。',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 26),
                      if (workStore.errorMessage != null) ...[
                        Text(
                          workStore.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.warning,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 18,
                        childAspectRatio: 0.78,
                        children: [
                          for (final scene in work.scenes)
                            SceneCard(
                              scene: scene,
                              onGenerate: () => controller.generateScene(scene),
                              onToggle: () =>
                                  controller.toggleSceneSelected(scene),
                            ),
                          const AddAssetCard(label: '新建场景'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              BottomAction(
                hint: disabled
                    ? '有场景图片生成中，完成后可进入下一步'
                    : '已选 ${work.scenes.where((e) => e.selected).length} 个场景',
                buttonLabel: disabled ? '生成中，请稍候' : '确认场景  ›',
                disabled: disabled,
                onPressed: () => controller.confirmScenes(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
