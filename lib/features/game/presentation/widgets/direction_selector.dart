import 'package:flutter/material.dart';
import 'package:saddeeqa/features/game/domain/models/direction.dart';
import 'package:saddeeqa/core/constants/app_colors.dart';

class DirectionSelector extends StatelessWidget {
  final Function(SowingDirection) onDirectionSelected;

  const DirectionSelector({
    super.key,
    required this.onDirectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose direction',
            style: TextStyle(
              color: Color(AppColors.label),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DirectionButton(
                direction: SowingDirection.clockwise,
                onTap: () => onDirectionSelected(SowingDirection.clockwise),
              ),
              const SizedBox(width: 16),
              _DirectionButton(
                direction: SowingDirection.counterClockwise,
                onTap: () =>
                    onDirectionSelected(SowingDirection.counterClockwise),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DirectionButton extends StatelessWidget {
  final SowingDirection direction;
  final VoidCallback onTap;

  const _DirectionButton({
    required this.direction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isClockwise = direction == SowingDirection.clockwise;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(AppColors.boardBase),
          border: Border.all(color: const Color(AppColors.border), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Visual arrow indicator
            CustomPaint(
              size: const Size(20, 20),
              painter: _ArrowPainter(isClockwise: isClockwise),
            ),
            const SizedBox(width: 8),
            Text(
              isClockwise ? 'Clockwise' : 'Counter-clockwise',
              style: const TextStyle(
                color: Color(AppColors.active),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final bool isClockwise;

  _ArrowPainter({required this.isClockwise});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(AppColors.active)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Draw circular arrow
    if (isClockwise) {
      // Clockwise: right arc with arrow pointing right
      final path = Path();
      path.addArc(
        Rect.fromCircle(center: center, radius: radius),
        -1.57, // Start at top
        3.14, // Half circle
      );
      canvas.drawPath(path, paint);

      // Arrow head pointing right
      final arrowPath = Path();
      arrowPath.moveTo(center.dx + radius - 2, center.dy);
      arrowPath.lineTo(center.dx + radius - 6, center.dy - 3);
      arrowPath.moveTo(center.dx + radius - 2, center.dy);
      arrowPath.lineTo(center.dx + radius - 6, center.dy + 3);
      canvas.drawPath(arrowPath, paint);
    } else {
      // Counter-clockwise: left arc with arrow pointing left
      final path = Path();
      path.addArc(
        Rect.fromCircle(center: center, radius: radius),
        1.57, // Start at bottom
        3.14, // Half circle
      );
      canvas.drawPath(path, paint);

      // Arrow head pointing left
      final arrowPath = Path();
      arrowPath.moveTo(center.dx - radius + 2, center.dy);
      arrowPath.lineTo(center.dx - radius + 6, center.dy - 3);
      arrowPath.moveTo(center.dx - radius + 2, center.dy);
      arrowPath.lineTo(center.dx - radius + 6, center.dy + 3);
      canvas.drawPath(arrowPath, paint);
    }
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) => false;
}
