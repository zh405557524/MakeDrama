import 'package:flutter/material.dart';

import '../theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0E0821), AppColors.bg],
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}

class BrandTopBar extends StatelessWidget {
  const BrandTopBar({
    super.key,
    this.showBack = true,
    this.step,
    this.trailing,
  });

  final bool showBack;
  final String? step;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: const SizedBox(
                width: 28,
                child: Text(
                  '‹',
                  style: TextStyle(
                    fontSize: 30,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF5E42FA),
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: const Text(
              '✦',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'AI漫剧',
            style: TextStyle(
              color: Color(0xFFBFA6FF),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          if (trailing != null)
            trailing!
          else
            Text(
              step ?? '新手教程',
              style: TextStyle(
                color: step == null
                    ? AppColors.textMuted
                    : const Color(0xFF9973FF),
                fontSize: step == null ? 13 : 12,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }
}

class PlainTopBar extends StatelessWidget {
  const PlainTopBar({super.key, required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const SizedBox(
              width: 28,
              child: Text(
                '‹',
                style: TextStyle(fontSize: 30, color: AppColors.textSecondary),
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          Text(
            hint,
            style: const TextStyle(
              color: Color(0xFF946BFF),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
