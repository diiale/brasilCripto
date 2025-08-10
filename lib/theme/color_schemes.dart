import 'package:flutter/material.dart';

const seed = Color(0xFF2E5BFF);

final lightScheme = ColorScheme.fromSeed(
  seedColor: seed,
  brightness: Brightness.light,
);

final darkScheme = ColorScheme.fromSeed(
  seedColor: seed,
  brightness: Brightness.dark,
);
