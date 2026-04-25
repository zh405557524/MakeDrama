import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../routes/index.dart';
import '../../store/index.dart';
import '../../theme.dart';
import '../../models/index.dart';
import '../../widgets/index.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final WorkStore controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkStore>(
      builder: (controller) {
        return AppShell(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandTopBar(showBack: false),
                const SizedBox(height: 48),
                Center(child: Pill(label: '✦  AI驱动 · 一键生成漫剧', active: true)),
                const SizedBox(height: 26),
                const Center(
                  child: Text(
                    '让故事动起来',
                    style: TextStyle(
                      fontSize: 38,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFC7ADFF),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '输入故事文本，AI 自动生成角色、场景与分镜',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 212,
                    height: 58,
                    child: PrimaryButton(
                      label: '+  开始创作  ›',
                      onPressed: () => _openStoryInput(context),
                    ),
                  ),
                ),
                const SizedBox(height: 46),
                Row(
                  children: const [
                    Expanded(
                      child: FeatureCard(icon: '⚡', title: '秒级生成'),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: FeatureCard(icon: '▣', title: '电影画质'),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: FeatureCard(icon: '☆', title: '风格切换'),
                    ),
                  ],
                ),
                const SizedBox(height: 38),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '我的作品  ${controller.works.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      '全部作品 ›',
                      style: TextStyle(
                        color: Color(0xFF946BFF),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.82,
                  children: [
                    NewWorkCard(onTap: () => _openStoryInput(context)),
                    for (final work in controller.works)
                      WorkCard(
                        work: work,
                        onTap: () => _openWork(context, work),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openStoryInput(BuildContext context) {
    context.pushNamed(RouteName.storyInput);
  }

  void _openWork(BuildContext context, DramaWork work) {
    controller.openWork(work);
    final routeName = switch (work.currentStep) {
      WorkStep.draft => RouteName.storyInput,
      WorkStep.characters => RouteName.characterGenerate,
      WorkStep.scenes => RouteName.sceneGenerate,
      WorkStep.storyboards => RouteName.storyboardEdit,
      WorkStep.preview || WorkStep.completed => RouteName.videoPreview,
    };
    context.pushNamed(routeName);
  }
}
