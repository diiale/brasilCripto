import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'typography.dart';
import 'components.dart';
import 'extensions/app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      colorScheme: lightScheme,
      useMaterial3: true,
    );

    final text = buildTextTheme(base.textTheme);
    final cs = base.colorScheme;

    return base.copyWith(
      textTheme: text,
      scaffoldBackgroundColor: cs.surface,
      appBarTheme: appBarTheme(cs, text),
      inputDecorationTheme: inputTheme(cs),
      elevatedButtonTheme: elevatedButtons(),
      floatingActionButtonTheme: fabTheme(cs),
      chipTheme: chipTheme(base.chipTheme),
      dividerTheme: dividerTheme(cs),
      extensions: const [appColorsLight],
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      colorScheme: darkScheme,
      useMaterial3: true,
    );

    final text = buildTextTheme(base.textTheme);
    final cs = base.colorScheme;

    return base.copyWith(
      textTheme: text,
      scaffoldBackgroundColor: cs.surface,
      appBarTheme: appBarTheme(cs, text),
      inputDecorationTheme: inputTheme(cs),
      elevatedButtonTheme: elevatedButtons(),
      floatingActionButtonTheme: fabTheme(cs),
      chipTheme: chipTheme(base.chipTheme),
      dividerTheme: dividerTheme(cs),
      extensions: const [appColorsDark],
    );
  }
}
