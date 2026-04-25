import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../routes/index.dart';
import '../../store/index.dart';
import '../../theme.dart';
import '../../widgets/index.dart';

class CharacterGeneratePage extends StatelessWidget {
  const CharacterGeneratePage({super.key, required this.controller});

  final WorkStore controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkStore>(
      builder: (controller) {
        final work = controller.currentWork!;
        final disabled = controller.hasRunningCharacterTask;
        return AppShell(
          child: Column(
            children: [
              const BrandTopBar(step: '2 / 4  角色匹配'),
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
                onPressed: () {
                  controller.confirmCharacters();
                  context.goNamed(RouteName.sceneGenerate);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
