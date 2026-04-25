import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const bg = Color(0xFF070510);
  static const surface = Color(0xFF130E26);
  static const surfaceLow = Color(0xFF0D091C);
  static const surfaceHigh = Color(0xFF1A1230);
  static const border = Color(0xFF261F3D);
  static const borderActive = Color(0xFF7A38F2);
  static const brand = Color(0xFF7A38F2);
  static const brandBlue = Color(0xFF475CF2);
  static const textPrimary = Color(0xFFF5F2FF);
  static const textSecondary = Color(0xFFB8ADDB);
  static const textMuted = Color(0xFF857DA3);
  static const success = Color(0xFF2EEBB2);
  static const warning = Color(0xFFF6B93B);
  static const error = Color(0xFFFF5C7A);
}

class CustomTheme {
  const CustomTheme._();

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brand,
        brightness: Brightness.dark,
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }

  static const SystemUiOverlayStyle systemStyleDark = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.bg,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}

BoxDecoration panelDecoration({double radius = 18}) {
  return BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: AppColors.border),
  );
}

LinearGradient placeholderGradient() {
  return const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF120D24), Color(0xFF080510)],
  );
}

LinearGradient dramaticGradient(String seed) {
  final palettes = <List<Color>>[
    [const Color(0xFFEB38C7), const Color(0xFF22134B), const Color(0xFF06030D)],
    [const Color(0xFF0D4F4A), const Color(0xFF102D38), const Color(0xFF04070B)],
    [const Color(0xFFC76E17), const Color(0xFF4B1E40), const Color(0xFF09040D)],
    [const Color(0xFF5C5785), const Color(0xFF211044), const Color(0xFF06030D)],
    [const Color(0xFF1A1F2E), const Color(0xFF33403D), const Color(0xFF080A10)],
  ];
  final index =
      seed.codeUnits.fold<int>(0, (value, item) => value + item) %
      palettes.length;
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: palettes[index],
  );
}
