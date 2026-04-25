import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../routes/index.dart';
import '../../store/index.dart';
import '../../theme.dart';
import '../../widgets/index.dart';

class StoryInputPage extends StatefulWidget {
  const StoryInputPage({super.key, required this.controller});

  final WorkStore controller;

  @override
  State<StoryInputPage> createState() => _StoryInputPageState();
}

class _StoryInputPageState extends State<StoryInputPage> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(
      text: '雨夜里，少年林风站在废城入口。远处黑雾翻涌，传说中的夜冥即将苏醒。',
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkStore>(
      builder: (controller) {
        return AppShell(
          child: Column(
            children: [
              const BrandTopBar(step: '1 / 4  文本解析'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '写下你的故事',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '输入剧情或小说片段，AI 自动拆解角色、场景与分镜。',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        height: 302,
                        padding: const EdgeInsets.all(18),
                        decoration: panelDecoration(radius: 18),
                        child: TextField(
                          controller: textController,
                          maxLines: null,
                          expands: true,
                          maxLength: 5000,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            height: 1.55,
                          ),
                          cursorColor: AppColors.brand,
                          decoration: const InputDecoration(
                            hintText: '例如：雨夜里，少年林风站在废城入口……',
                            hintStyle: TextStyle(color: Color(0xFF7A7099)),
                            border: InputBorder.none,
                            counterStyle: TextStyle(color: Color(0xFF756B8F)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        '生成偏好',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: const [
                          Pill(label: '暗色系', active: true),
                          Pill(label: '约 12 秒'),
                          Pill(label: '9:16 竖屏'),
                        ],
                      ),
                      const SizedBox(height: 36),
                      const Text(
                        '解析后可在下一步生成或修改角色、场景。',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: PrimaryButton(
                    label: controller.isParsing ? '正在解析...' : '开始解析',
                    loading: controller.isParsing,
                    onPressed: controller.isParsing
                        ? null
                        : () async {
                            final work = await controller.parseAndCreate(
                              textController.text,
                            );
                            controller.openWork(work);
                            if (!context.mounted) return;
                            context.goNamed(RouteName.characterGenerate);
                          },
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
