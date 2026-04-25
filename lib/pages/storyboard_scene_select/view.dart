import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../store/index.dart';
import '../../theme.dart';
import '../../widgets/index.dart';

class StoryboardSceneSelectPage extends StatelessWidget {
  const StoryboardSceneSelectPage({super.key, required this.controller});

  final WorkStore controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkStore>(
      builder: (controller) {
        final work = controller.currentWork!;
        final selected = controller.selectedStoryboard.sceneId;
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
                    onPressed: () => Navigator.of(context).pop(),
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
