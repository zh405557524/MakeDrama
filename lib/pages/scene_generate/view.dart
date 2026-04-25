import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../routes/index.dart';
import '../../store/index.dart';
import '../../theme.dart';
import '../../widgets/index.dart';

class SceneGeneratePage extends StatelessWidget {
  const SceneGeneratePage({super.key, required this.controller});

  final WorkStore controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkStore>(
      builder: (controller) {
        final work = controller.currentWork!;
        final disabled = controller.hasRunningSceneTask;
        return AppShell(
          child: Column(
            children: [
              const BrandTopBar(step: '3 / 4  场景匹配'),
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
                onPressed: () {
                  controller.confirmScenes();
                  context.goNamed(RouteName.storyboardEdit);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
