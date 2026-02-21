import 'package:flutter/material.dart';
import 'package:saddeeqa/features/game/domain/models/game_state.dart';
import 'package:saddeeqa/features/game/domain/models/direction.dart';
import 'package:saddeeqa/features/game/domain/services/game_logic.dart';
import 'package:saddeeqa/features/game/presentation/widgets/game_board.dart';
import 'package:saddeeqa/features/game/presentation/widgets/direction_selector.dart';
import 'package:saddeeqa/core/constants/app_colors.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameState _gameState = GameState.initial();
  int? _selectedHoleIndex;
  bool _isAnimating = false;

  bool _isValidHoleForSelection(int holeIndex) {
    if (_gameState.isGameOver || _isAnimating) return false;
    if (_gameState.currentPlayer == 0 && holeIndex >= 0 && holeIndex < 8) {
      return _gameState.board[holeIndex] > 0;
    }
    if (_gameState.currentPlayer == 1 && holeIndex >= 8 && holeIndex < 16) {
      return _gameState.board[holeIndex] > 0;
    }
    return false;
  }

  void _onHoleTap(int holeIndex) {
    if (_isAnimating) return;
    if (_selectedHoleIndex == holeIndex) {
      setState(() => _selectedHoleIndex = null);
      return;
    }
    if (_selectedHoleIndex == null) {
      if (_isValidHoleForSelection(holeIndex)) {
        setState(() => _selectedHoleIndex = holeIndex);
      }
    }
  }

  Future<void> _onDirectionSelected(SowingDirection direction) async {
    if (_selectedHoleIndex == null || _isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    // Animate the move step-by-step
    await _animateMove(_selectedHoleIndex!, direction);

    // Execute the actual move
    final newState = performMove(_gameState, _selectedHoleIndex!, direction);
    if (newState != null) {
      setState(() {
        _gameState = newState;
        _selectedHoleIndex = null;
        _isAnimating = false;
      });
    } else {
      setState(() {
        _isAnimating = false;
      });
    }
  }

  Future<void> _animateMove(int startHole, SowingDirection direction) async {
    // Animation placeholder - can be enhanced later
    await Future.delayed(const Duration(milliseconds: 100));
  }

  void _clearSelection() {
    if (_selectedHoleIndex != null && !_isAnimating) {
      setState(() => _selectedHoleIndex = null);
    }
  }

  void _resetGame() {
    setState(() {
      _gameState = GameState.initial();
      _selectedHoleIndex = null;
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(
        title: const Text('Saddeeqa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'New Game',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/rules');
            },
            tooltip: 'Rules',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _clearSelection,
              child: const SizedBox.expand(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Active player indicator
                  Text(
                    _gameState.isGameOver
                        ? 'Game Over'
                        : 'Player ${_gameState.currentPlayer + 1}\'s Turn',
                    style: const TextStyle(
                      color: Color(AppColors.active),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Board
                  GameBoard(
                    gameState: _gameState,
                    selectedHoleIndex: _selectedHoleIndex,
                    isAnimating: _isAnimating,
                    onHoleTap: _onHoleTap,
                  ),

                  // Direction selector
                  if (!_gameState.isGameOver &&
                      _selectedHoleIndex != null &&
                      !_isAnimating) ...[
                    const SizedBox(height: 24),
                    DirectionSelector(
                      onDirectionSelected: _onDirectionSelected,
                    ),
                  ],

                  // Game over
                  if (_gameState.isGameOver)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        children: [
                          Text(
                            _gameState.winner == null
                                ? 'Game Over — Tie'
                                : 'Player ${_gameState.winner! + 1} Wins',
                            style: const TextStyle(
                              color: Color(AppColors.active),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _resetGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(AppColors.boardBase),
                              foregroundColor: const Color(AppColors.active),
                            ),
                            child: const Text('New Game'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
