import 'package:flutter/material.dart';
import 'package:saddeeqa/core/constants/app_colors.dart';
import 'marble_cluster.dart';

class VisualHole extends StatelessWidget {
  final int holeIndex;
  final int stoneCount;
  final bool isSelected;
  final bool isEnabled;
  final bool isTopRow;
  final VoidCallback onTap;

  const VisualHole({
    super.key,
    required this.holeIndex,
    required this.stoneCount,
    required this.isSelected,
    required this.isEnabled,
    required this.isTopRow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label above for top row
          if (isTopRow)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '×$stoneCount',
                style: const TextStyle(
                  color: Color(AppColors.label),
                  fontSize: 10,
                ),
              ),
            ),
          // Hole with marbles
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 56,
            height: 56,
            margin: const EdgeInsets.all(2),
            transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0),
            decoration: BoxDecoration(
              color: const Color(AppColors.hole),
              border: Border.all(
                color: isSelected
                    ? const Color(AppColors.active)
                    : const Color(AppColors.border),
                width: isSelected ? 2 : 1,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: MarbleCluster(count: stoneCount),
          ),
          // Label below for bottom row
          if (!isTopRow)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '×$stoneCount',
                style: const TextStyle(
                  color: Color(AppColors.label),
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
