import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;

  const Shimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.baseColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final hi = widget.highlightColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final dx = -1.0 + 2.0 * _ctrl.value; // -1 -> 1
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(-1 + dx, 0),
              end: Alignment(1 + dx, 0),
              colors: [base, hi, base],
              stops: const [0.25, 0.5, 0.75],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}
