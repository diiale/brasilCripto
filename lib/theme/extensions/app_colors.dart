import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color warning;
  final Color danger;

  const AppColors({
    required this.success,
    required this.warning,
    required this.danger,
  });

  @override
  AppColors copyWith({Color? success, Color? warning, Color? danger}) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

const appColorsLight = AppColors(
  success: Color(0xFF2ECC71),
  warning: Color(0xFFF1C40F),
  danger:  Color(0xFFE74C3C),
);

const appColorsDark = appColorsLight;
