import 'package:flutter/material.dart';

import '../theme.dart';
import '../models/index.dart';
import 'action_widgets.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    super.key,
    required this.character,
    required this.onGenerate,
    required this.onToggle,
  });

  final CharacterProfile character;
  final VoidCallback onGenerate;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AssetProfileCard(
      title: character.name,
      subtitle: character.description,
      tag: character.roleTag,
      seed: character.id,
      hasImage: character.hasImage,
      selected: character.selected,
      running: character.isRunning,
      actionLabel: character.isRunning
          ? '生成中...'
          : (character.hasImage ? '重新生成' : '生成角色'),
      onGenerate: onGenerate,
      onToggle: onToggle,
    );
  }
}

class SceneCard extends StatelessWidget {
  const SceneCard({
    super.key,
    required this.scene,
    required this.onGenerate,
    required this.onToggle,
  });

  final SceneProfile scene;
  final VoidCallback onGenerate;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AssetProfileCard(
      title: scene.name,
      subtitle: scene.description,
      tag: scene.tags.join(' · '),
      seed: scene.id,
      hasImage: scene.hasImage,
      selected: scene.selected,
      running: scene.isRunning,
      actionLabel: scene.isRunning
          ? '生成中...'
          : (scene.hasImage ? '重新生成' : '生成场景'),
      onGenerate: onGenerate,
      onToggle: onToggle,
    );
  }
}

class AssetProfileCard extends StatelessWidget {
  const AssetProfileCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.seed,
    required this.hasImage,
    required this.selected,
    required this.running,
    required this.actionLabel,
    required this.onGenerate,
    required this.onToggle,
  });

  final String title;
  final String subtitle;
  final String tag;
  final String seed;
  final bool hasImage;
  final bool selected;
  final bool running;
  final String actionLabel;
  final VoidCallback onGenerate;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? AppColors.borderActive : AppColors.border,
          width: 1.3,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: hasImage
                          ? dramaticGradient(seed)
                          : placeholderGradient(),
                    ),
                    child: running
                        ? const Center(child: TaskLoading(label: '生成中'))
                        : (!hasImage
                              ? const Center(
                                  child: Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: Color(0xFF9E75FF),
                                    size: 30,
                                  ),
                                )
                              : null),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: StatusPill(label: tag, color: AppColors.brand),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: running ? null : onGenerate,
                          child: Text(
                            actionLabel,
                            style: TextStyle(
                              color: running
                                  ? AppColors.textMuted
                                  : const Color(0xFFA880FF),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selected)
            const Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.brandBlue,
                child: Icon(Icons.check_rounded, size: 18, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class AddAssetCard extends StatelessWidget {
  const AddAssetCard({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF332457)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF211045),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.add_rounded,
              color: Color(0xFF9E75FF),
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewPanel extends StatelessWidget {
  const PreviewPanel({super.key, required this.shot});

  final StoryboardShot shot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        gradient: shot.hasImage
            ? dramaticGradient(shot.id)
            : placeholderGradient(),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Pill(label: '第 ${shot.sortOrder} 幕', active: true),
          ),
          Center(
            child: shot.isRunning
                ? const TaskLoading(label: '生成中')
                : (!shot.hasImage
                      ? const StatusPill(
                          label: '待生成',
                          color: AppColors.textSecondary,
                        )
                      : const SizedBox.shrink()),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Text(
              shot.description,
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
    );
  }
}
