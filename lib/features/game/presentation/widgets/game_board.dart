import 'package:flutter/material.dart';
import 'package:saddeeqa/features/game/domain/models/game_state.dart';
import 'package:saddeeqa/core/constants/app_colors.dart';
import 'visual_hole.dart';
import 'capture_store.dart';

class GameBoard extends StatelessWidget {
  final GameState gameState;
  final int? selectedHoleIndex;
  final bool isAnimating;
  final Function(int) onHoleTap;

  const GameBoard({
    super.key,
    required this.gameState,
    required this.selectedHoleIndex,
    required this.isAnimating,
    required this.onHoleTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedHoleIndex != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(AppColors.boardBase),
        border: Border.all(
          color: gameState.currentPlayer == 0
              ? const Color(AppColors.active).withOpacity(0.3)
              : const Color(AppColors.border).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Left capture store (Player 1 / bottom row)
          CaptureStore(
            score: gameState.scores[1],
            playerLabel: 'P2',
          ),
          const SizedBox(width: 12),
          // Playing holes
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top row - Player 0 (displayed as Player 2)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(8, (col) {
                  final holeIndex = col;
                  final isSelected = selectedHoleIndex == holeIndex;
                  final canTap = !gameState.isGameOver &&
                      !isAnimating &&
                      (gameState.currentPlayer == 0 &&
                          gameState.board[holeIndex] > 0) &&
                      (!hasSelection || isSelected);
                  return VisualHole(
                    holeIndex: holeIndex,
                    stoneCount: gameState.board[holeIndex],
                    isSelected: isSelected,
                    isEnabled: canTap,
                    isTopRow: true,
                    onTap: () => onHoleTap(holeIndex),
                  );
                }),
              ),
              const SizedBox(height: 12),
              // Bottom row - Player 1 (displayed as Player 1)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(8, (col) {
                  final holeIndex = col + 8;
                  final isSelected = selectedHoleIndex == holeIndex;
                  final canTap = !gameState.isGameOver &&
                      !isAnimating &&
                      (gameState.currentPlayer == 1 &&
                          gameState.board[holeIndex] > 0) &&
                      (!hasSelection || isSelected);
                  return VisualHole(
                    holeIndex: holeIndex,
                    stoneCount: gameState.board[holeIndex],
                    isSelected: isSelected,
                    isEnabled: canTap,
                    isTopRow: false,
                    onTap: () => onHoleTap(holeIndex),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Right capture store (Player 0 / top row)
          CaptureStore(
            score: gameState.scores[0],
            playerLabel: 'P1',
          ),
        ],
      ),
    );
  }
}
