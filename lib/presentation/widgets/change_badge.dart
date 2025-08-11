import 'package:flutter/material.dart';

import '../../theme/extensions/app_colors.dart';

class ChangeBadge extends StatelessWidget {
  final double value;
  const ChangeBadge({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final up = value >= 0;

    final ext = Theme.of(context).extension<AppColors>();
    final Color fg = up ? (ext?.success ?? Colors.green) : (ext?.danger ?? Colors.red);
    final Color bg = fg.withOpacity(.15);

    final icon = up ? Icons.trending_up_rounded : Icons.trending_down_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            '${value.toStringAsFixed(2)}%',
            style: TextStyle(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}