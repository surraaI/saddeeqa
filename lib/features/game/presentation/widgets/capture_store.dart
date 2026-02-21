import 'package:flutter/material.dart';
import 'package:saddeeqa/core/constants/app_colors.dart';

class CaptureStore extends StatelessWidget {
  final int score;
  final String playerLabel;

  const CaptureStore({
    super.key,
    required this.score,
    required this.playerLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(AppColors.boardBase),
        border: Border.all(color: const Color(AppColors.border), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            playerLabel,
            style: const TextStyle(
              color: Color(AppColors.label),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          // Show marbles in capture store
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 3,
                runSpacing: 3,
                children: List.generate(
                  score.clamp(0, 50), // Limit display for performance
                  (i) => Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(AppColors.marble),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$score',
            style: const TextStyle(
              color: Color(AppColors.active),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
