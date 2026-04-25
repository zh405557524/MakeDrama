import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../routes/index.dart';
import '../../store/index.dart';
import '../../theme.dart';
import '../../models/index.dart';
import '../../widgets/index.dart';

class StoryboardEditPage extends StatelessWidget {
  const StoryboardEditPage({super.key, required this.controller});

  final WorkStore controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkStore>(
      builder: (controller) {
        final work = controller.currentWork!;
        final shot = controller.selectedStoryboard;
        return AppShell(
          child: Column(
            children: [
              BrandTopBar(
                step: '3 / 4  分镜编辑',
                trailing: SmallActionButton(
                  label: '进入预览',
                  icon: Icons.play_arrow_rounded,
                  onTap: () {
                    work.currentStep = WorkStep.preview;
                    context.pushNamed(RouteName.videoPreview);
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.view_agenda_outlined,
                            color: AppColors.brand,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              work.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${controller.selectedStoryboardIndex + 1} / ${work.storyboards.length}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 76,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: work.storyboards.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final item = work.storyboards[index];
                            return ShotThumb(
                              shot: item,
                              selected:
                                  index == controller.selectedStoryboardIndex,
                              onTap: () => controller.selectStoryboard(index),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      PreviewPanel(shot: shot),
                      const SizedBox(height: 16),
                      Panel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '分镜描述',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              key: ValueKey(shot.id),
                              initialValue: shot.description,
                              maxLines: 4,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.55,
                              ),
                              onChanged: controller.updateStoryboardDescription,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '描述画面、人物动作和氛围',
                                hintStyle: TextStyle(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ParameterPanel(
                        title: '角色选择',
                        icon: Icons.group_outlined,
                        activeColor: const Color(0xFF61A1FF),
                        children: [
                          ActionChipLike(
                            label: _roleLabel(work, shot.characterIds),
                            onTap: () => context.pushNamed(
                              RouteName.storyboardCharacterSelect,
                            ),
                          ),
                        ],
                      ),
                      ParameterPanel(
                        title: '场景选择',
                        icon: Icons.landscape_outlined,
                        activeColor: const Color(0xFF2EEBB2),
                        children: [
                          ActionChipLike(
                            label: _sceneLabel(work, shot.sceneId),
                            onTap: () => context.pushNamed(
                              RouteName.storyboardSceneSelect,
                            ),
                          ),
                        ],
                      ),
                      ParameterPanel(
                        title: '画面风格',
                        icon: Icons.auto_awesome,
                        activeColor: AppColors.brand,
                        children: [
                          for (final item in const [
                            '暗色系',
                            '彩色系',
                            '国风水墨',
                            '科幻赛博',
                            '清新淡雅',
                          ])
                            SelectChip(
                              label: item,
                              selected: shot.style == item,
                              onTap: () =>
                                  controller.updateStoryboardStyle(item),
                            ),
                        ],
                      ),
                      ParameterPanel(
                        title: '角色配音',
                        icon: Icons.mic_none_rounded,
                        activeColor: const Color(0xFF61A1FF),
                        children: [
                          for (final item in const [
                            '少年感 · 雄厚',
                            '少年感 · 激昂',
                            '老者 · 沧桑',
                            '御姐 · 冷酷',
                            '温柔 · 女声',
                            '霸气 · 男声',
                          ])
                            SelectChip(
                              label: item,
                              selected: shot.voicePreset == item,
                              onTap: () =>
                                  controller.updateStoryboardVoice(item),
                            ),
                        ],
                      ),
                      ParameterPanel(
                        title: '背景音效',
                        icon: Icons.music_note_rounded,
                        activeColor: const Color(0xFF00D6A1),
                        children: [
                          for (final item in const [
                            '史诗战鼓',
                            '神秘氛围',
                            '出征号角',
                            '黑暗低鸣',
                            '终极战歌',
                            '温情旋律',
                            '静谧空灵',
                          ])
                            SelectChip(
                              label: item,
                              selected: shot.bgmPreset == item,
                              onTap: () => controller.updateStoryboardBgm(item),
                            ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              label: '一键生成全部',
                              icon: Icons.auto_fix_high_rounded,
                              onPressed: controller.generateAllStoryboards,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              label: shot.isRunning ? '生成中...' : '生成此分镜',
                              loading: shot.isRunning,
                              onPressed: shot.isRunning
                                  ? null
                                  : () => controller.generateStoryboard(shot),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _roleLabel(DramaWork work, List<String> ids) {
    if (ids.isEmpty) return '未选择角色';
    return work.characters
        .where((item) => ids.contains(item.id))
        .map((item) => item.name)
        .join(' · ');
  }

  String _sceneLabel(DramaWork work, String? id) {
    if (id == null) return '未选择场景';
    return work.scenes
        .firstWhere((item) => item.id == id, orElse: () => work.scenes.first)
        .name;
  }
}
