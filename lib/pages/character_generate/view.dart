part of 'package:make_drama/pages/character_generate/index.dart';

class CharacterGeneratePage extends StatelessWidget {
  const CharacterGeneratePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CharacterGenerateController>(
      init: CharacterGenerateController(),
      builder: (controller) {
        final workStore = controller.workStore;
        final work = workStore.currentWork;
        if (work == null) {
          return AppShell(
            child: Column(
              children: [
                const BrandTopBar(step: '2 / 4  角色匹配'),
                Expanded(
                  child: StepStateView(
                    icon: Icons.movie_creation_outlined,
                    title: '还没有选择作品',
                    message: '请先从首页创建或打开一个作品，再继续角色生成流程。',
                    actionLabel: '返回首页',
                    onPressed: () => controller.backHome(context),
                  ),
                ),
              ],
            ),
          );
        }
        final disabled = workStore.hasRunningCharacterTask;
        return AppShell(
          child: Column(
            children: [
              const BrandTopBar(step: '2 / 4  角色匹配'),
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
                        label: '已解析 ${work.characters.length} 个角色',
                        active: true,
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        '角色匹配',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '为角色生成形象图；有图即已生成，无图可点击生成。',
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
                          for (final character in work.characters)
                            CharacterCard(
                              character: character,
                              onGenerate: () =>
                                  controller.generateCharacter(character),
                              onToggle: () =>
                                  controller.toggleCharacterSelected(character),
                            ),
                          const AddAssetCard(label: '新建角色'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              BottomAction(
                hint: disabled
                    ? '有角色图片生成中，完成后可进入下一步'
                    : '已选 ${work.characters.where((e) => e.selected).length} 个角色',
                buttonLabel: disabled ? '生成中，请稍候' : '确认角色  ›',
                disabled: disabled,
                onPressed: () => controller.confirmCharacters(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
