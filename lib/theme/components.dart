import 'package:flutter/material.dart';
import 'tokens/spacing.dart';

InputDecorationTheme inputTheme(ColorScheme cs) => InputDecorationTheme(
  filled: true,
  fillColor: cs.surfaceContainerHighest.withOpacity(.45),
  hintStyle: TextStyle(color: cs.outline),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: Spacing.m,
    vertical: Spacing.m,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(RadiusToken.md),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(RadiusToken.md),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(RadiusToken.md),
    borderSide: BorderSide(color: cs.primary, width: 1.2),
  ),
);

ElevatedButtonThemeData elevatedButtons() => ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      horizontal: Spacing.xl,
      vertical: Spacing.m,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusToken.md),
    ),
  ),
);

FloatingActionButtonThemeData fabTheme(ColorScheme cs) => FloatingActionButtonThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  backgroundColor: cs.primary,
  foregroundColor: cs.onPrimary,
);

AppBarTheme appBarTheme(ColorScheme cs, TextTheme text) => AppBarTheme(
  backgroundColor: Colors.transparent,
  foregroundColor: cs.onSurface,
  elevation: 0,
  centerTitle: true,
  titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
);

ChipThemeData chipTheme(ChipThemeData base) => base.copyWith(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(RadiusToken.sm),
  ),
);

DividerThemeData dividerTheme(ColorScheme cs) => DividerThemeData(
  color: cs.outlineVariant,
  thickness: 1,
);
