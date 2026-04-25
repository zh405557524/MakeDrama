import 'package:flutter/material.dart';

import '../theme.dart';
import '../models/index.dart';
import 'action_widgets.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.icon, required this.title});

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      decoration: panelDecoration(radius: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 22, color: Color(0xFFA37DFF)),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class NewWorkCard extends StatelessWidget {
  const NewWorkCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF47268C), width: 1.2),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('+', style: TextStyle(color: Color(0xFF9E75FF), fontSize: 38)),
            SizedBox(height: 10),
            Text(
              '新建漫剧',
              style: TextStyle(
                color: Color(0xFF998CBF),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkCard extends StatelessWidget {
  const WorkCard({super.key, required this.work, required this.onTap});

  final DramaWork work;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: panelDecoration(radius: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: dramaticGradient(work.coverSeed),
                ),
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topRight,
                child: StatusPill(
                  label: work.currentStep.label,
                  color: work.currentStep == WorkStep.completed
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    work.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${work.storyboards.length} 个分镜 · ${work.currentStep.label}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
