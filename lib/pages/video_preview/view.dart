import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../routes/index.dart';
import '../../store/index.dart';
import '../../theme.dart';
import '../../widgets/index.dart';

class VideoPreviewPage extends StatefulWidget {
  const VideoPreviewPage({super.key, required this.controller});

  final WorkStore controller;

  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkStore>(
      builder: (controller) {
        final work = controller.currentWork!;
        final current =
            work.storyboards[controller.selectedStoryboardIndex.clamp(
              0,
              work.storyboards.length - 1,
            )];
        return AppShell(
          child: Column(
            children: [
              BrandTopBar(
                step: '4 / 4  视频预览',
                trailing: SmallActionButton(
                  label: '返回编辑',
                  icon: Icons.chevron_left_rounded,
                  onTap: () => context.goNamed(RouteName.storyboardEdit),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        work.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${work.storyboards.length} 个分镜 · 约 ${work.durationSeconds} 秒',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 26),
                      Container(
                        height: 260,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                          gradient: dramaticGradient(current.id),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () => setState(() => playing = !playing),
                                child: Container(
                                  width: 74,
                                  height: 74,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0x77391A7A),
                                    border: Border.all(
                                      color: AppColors.brand,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    playing
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 42,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              right: 10,
                              bottom: 12,
                              child: Text(
                                current.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Panel(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: work.hasVideo ? 0.68 : 0.22,
                                minHeight: 5,
                                color: AppColors.brandBlue,
                                backgroundColor: const Color(0xFF2E2642),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '0s',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.skip_previous_rounded,
                                      ),
                                      color: AppColors.textSecondary,
                                    ),
                                    IconButton.filled(
                                      onPressed: () =>
                                          setState(() => playing = !playing),
                                      icon: Icon(
                                        playing
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppColors.brandBlue,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.skip_next_rounded),
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                                Text(
                                  '${work.durationSeconds}s',
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '分镜胶片',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 64,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: work.storyboards.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final shot = work.storyboards[index];
                            return GestureDetector(
                              onTap: () => controller.selectStoryboard(index),
                              child: Container(
                                width: 76,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        index ==
                                            widget
                                                .controller
                                                .selectedStoryboardIndex
                                        ? AppColors.borderActive
                                        : AppColors.border,
                                  ),
                                  gradient: dramaticGradient(shot.id),
                                ),
                                alignment: Alignment.bottomRight,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                      PrimaryButton(
                        label: work.isVideoRunning
                            ? '视频生成中...'
                            : (work.hasVideo ? '重新生成视频' : '生成视频'),
                        loading: work.isVideoRunning,
                        onPressed: work.isVideoRunning
                            ? null
                            : controller.generateVideo,
                      ),
                      const SizedBox(height: 12),
                      SecondaryButton(
                        label: '分享链接',
                        icon: Icons.share_outlined,
                        onPressed: work.hasVideo
                            ? () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('分享链接已生成')),
                              )
                            : null,
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
}
