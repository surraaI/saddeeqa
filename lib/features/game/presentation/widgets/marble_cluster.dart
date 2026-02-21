import 'package:flutter/material.dart';
import 'package:saddeeqa/core/constants/app_colors.dart';

class MarbleCluster extends StatelessWidget {
  final int count;

  const MarbleCluster({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return const SizedBox.shrink();
    }

    // Arrange marbles in a natural cluster
    final positions = _calculateMarblePositions(count);

    return Stack(
      children: positions.map((pos) {
        return Positioned(
          left: pos.dx,
          top: pos.dy,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(AppColors.marble),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 2,
                  offset: const Offset(-1, -1),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Offset> _calculateMarblePositions(int count) {
    final positions = <Offset>[];
    final centerX = 28.0; // Half of 56
    final centerY = 28.0;
    final radius = 12.0;

    if (count == 1) {
      positions.add(Offset(centerX - 4, centerY - 4));
    } else if (count <= 4) {
      // Small cluster in center
      for (int i = 0; i < count; i++) {
        final x = centerX + (radius * 0.3 * (i % 2 == 0 ? 1 : -1)) - 4;
        final y = centerY + (radius * 0.3 * (i < 2 ? 1 : -1)) - 4;
        positions.add(Offset(x.clamp(4.0, 44.0), y.clamp(4.0, 44.0)));
      }
    } else {
      // Larger cluster with natural distribution
      final rows = (count / 3).ceil();
      var remaining = count;
      for (int row = 0; row < rows && remaining > 0; row++) {
        final colsInRow = (remaining / rows).ceil();
        for (int col = 0; col < colsInRow && remaining > 0; col++) {
          final x = centerX - (colsInRow - 1) * 6 + col * 12 - 4;
          final y = centerY - (rows - 1) * 6 + row * 12 - 4;
          positions.add(Offset(x.clamp(4.0, 44.0), y.clamp(4.0, 44.0)));
          remaining--;
        }
      }
    }

    return positions;
  }
}
