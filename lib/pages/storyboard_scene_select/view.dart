part of 'package:make_drama/pages/storyboard_scene_select/index.dart';

class StoryboardSceneSelectPage extends StatelessWidget {
  const StoryboardSceneSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoryboardSceneSelectController>(
      init: StoryboardSceneSelectController(),
      builder: (controller) {
        final workStore = controller.workStore;
        final work = workStore.currentWork;
        if (work == null) {
          return AppShell(
            child: Column(
              children: [
                const PlainTopBar(title: '场景选择', hint: '单选'),
                Expanded(
                  child: StepStateView(
                    icon: Icons.landscape_outlined,
                    title: '还没有选择作品',
                    message: '请先从首页创建或打开一个作品，再选择分镜场景。',
                    actionLabel: '返回首页',
                    onPressed: () => controller.backHome(context),
                  ),
                ),
              ],
            ),
          );
        }
        final selected = workStore.selectedStoryboard.sceneId;
        return AppShell(
          child: Column(
            children: [
              const PlainTopBar(title: '场景选择', hint: '单选'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                  children: [
                    const Text(
                      '选择此分镜场景',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '每个分镜只能选择一个主场景。',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 26),
                    for (final scene in work.scenes)
                      SceneSelectTile(
                        scene: scene,
                        selected: selected == scene.id,
                        onTap: () => controller.setStoryboardScene(scene.id),
                      ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: PrimaryButton(
                    label: '应用此场景',
                    onPressed: () => controller.apply(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
