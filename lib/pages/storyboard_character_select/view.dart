import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../store/index.dart';
import '../../theme.dart';
import '../../widgets/index.dart';

class StoryboardCharacterSelectPage extends StatelessWidget {
  const StoryboardCharacterSelectPage({super.key, required this.controller});

  final WorkStore controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkStore>(
      builder: (controller) {
        final work = controller.currentWork!;
        final selectedIds = controller.selectedStoryboard.characterIds;
        return AppShell(
          child: Column(
            children: [
              const PlainTopBar(title: '角色选择', hint: '可多选'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                  children: [
                    const Text(
                      '选择此分镜出现的角色',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '已选 ${selectedIds.length} 个角色，可多选后应用到当前分镜。',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SearchBox(label: '搜索角色名称'),
                    const SizedBox(height: 24),
                    for (final character in work.characters)
                      SelectListTile(
                        title: character.name,
                        subtitle:
                            '${character.roleTag} · ${selectedIds.contains(character.id) ? '已选' : '未选'}',
                        selected: selectedIds.contains(character.id),
                        seed: character.id,
                        onTap: () =>
                            controller.toggleStoryboardCharacter(character.id),
                      ),
                    const SizedBox(height: 14),
                    const AddWideButton(label: '+  新建角色'),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: PrimaryButton(
                    label: '应用 ${selectedIds.length} 个角色',
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
