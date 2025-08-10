import 'package:flutter/material.dart';
import 'shimmer.dart';

class RectSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;
  const RectSkeleton({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  final double size;
  const CircleSkeleton({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class CoinTileSkeleton extends StatelessWidget {
  const CoinTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          const CircleSkeleton(size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                RectSkeleton(height: 14, width: 140),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    RectSkeleton(height: 12, width: 80),
                    RectSkeleton(height: 12, width: 70),
                    RectSkeleton(height: 12, width: 70),
                    RectSkeleton(height: 12, width: 40),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const RectSkeleton(
            height: 24,
            width: 24,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ],
      ),
    );
  }
}
