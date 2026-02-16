/// Immutable state for a 2-player local Saddeeqa game.
///
/// Board layout:
/// - Top row (Player 0): holes 0–7.
/// - Bottom row (Player 1): holes 8–15.
/// - Same column: hole [i] and hole [i + 8] (e.g. 0 ↔ 8, 7 ↔ 15).
class GameState {
  /// Stone count per hole. Indices 0–7 = Player 0, 8–15 = Player 1.
  final List<int> board;

  /// [player0Score, player1Score] — captured stones and end-game row stones.
  final List<int> scores;

  /// Whose turn it is: 0 or 1.
  final int currentPlayer;

  /// True when one player's row is empty and final scores have been applied.
  final bool isGameOver;

  /// Winner after game end: 0, 1, or null for tie / game not ended.
  final int? winner;

  static const int holesPerRow = 8;
  static const int totalHoles = 16;
  static const int initialStonesPerHole = 4;

  const GameState({
    required this.board,
    required this.scores,
    required this.currentPlayer,
    this.isGameOver = false,
    this.winner,
  });

  /// New game: 4 stones per hole, no captures, Player 0 to move.
  factory GameState.initial() {
    return GameState(
      board: List.filled(totalHoles, initialStonesPerHole),
      scores: [0, 0],
      currentPlayer: 0,
    );
  }

  /// Copy with optional overrides (for immutable updates).
  GameState copyWith({
    List<int>? board,
    List<int>? scores,
    int? currentPlayer,
    bool? isGameOver,
    int? winner,
  }) {
    return GameState(
      board: board ?? List.from(this.board),
      scores: scores ?? List.from(this.scores),
      currentPlayer: currentPlayer ?? this.currentPlayer,
      isGameOver: isGameOver ?? this.isGameOver,
      winner: winner ?? this.winner,
    );
  }

  /// Holes belonging to Player 0 (top row).
  static List<int> get player0Holes =>
      List.generate(holesPerRow, (i) => i);

  /// Holes belonging to Player 1 (bottom row).
  static List<int> get player1Holes =>
      List.generate(holesPerRow, (i) => i + holesPerRow);
}
