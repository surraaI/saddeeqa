import 'direction.dart';
import 'game_state.dart';

// ---------------------------------------------------------------------------
// Helpers: indexing and board layout
// ---------------------------------------------------------------------------

/// Returns the next hole index in the given direction (board wraps 0–15).
int getNextHoleIndex(int current, SowingDirection direction) {
  switch (direction) {
    case SowingDirection.clockwise:
      return (current + 1) % GameState.totalHoles;
    case SowingDirection.counterClockwise:
      return (current - 1 + GameState.totalHoles) % GameState.totalHoles;
  }
}

/// Returns the opposite hole in the same column (0↔8, 1↔9, …, 7↔15).
int getOppositeHole(int hole) {
  return (hole + GameState.holesPerRow) % GameState.totalHoles;
}

/// True if [hole] belongs to [player]'s row (0: 0–7, 1: 8–15).
bool isHoleInPlayerRow(int hole, int player) {
  if (player == 0) return hole >= 0 && hole < GameState.holesPerRow;
  return hole >= GameState.holesPerRow && hole < GameState.totalHoles;
}

// ---------------------------------------------------------------------------
// Move validation
// ---------------------------------------------------------------------------

/// True if moving from [holeIndex] in [direction] is allowed.
/// The hole must be in the current player's row, non-empty, and game not over.
bool isValidMove(GameState state, int holeIndex, SowingDirection direction) {
  if (state.isGameOver) return false;
  if (holeIndex < 0 || holeIndex >= GameState.totalHoles) return false;
  if (!isHoleInPlayerRow(holeIndex, state.currentPlayer)) return false;
  return state.board[holeIndex] > 0;
}

// ---------------------------------------------------------------------------
// Sowing and capture
// ---------------------------------------------------------------------------

/// Performs one full move: pick from [holeIndex], sow in [direction],
/// handle continuous sowing and capture, then check game end.
/// Returns the new state, or null if the move is invalid.
GameState? performMove(
  GameState state,
  int holeIndex,
  SowingDirection direction,
) {
  if (!isValidMove(state, holeIndex, direction)) return null;

  List<int> board = List.from(state.board);
  List<int> scores = List.from(state.scores);
  int currentPlayer = state.currentPlayer;

  // 1. Pick all stones from the chosen hole and clear it
  int stonesInHand = board[holeIndex];
  board[holeIndex] = 0;

  // 2. Start sowing from the next hole in the chosen direction
  int currentHole = getNextHoleIndex(holeIndex, direction);

  while (true) {
    // Drop one stone into current hole
    board[currentHole]++;
    stonesInHand--;

    if (stonesInHand > 0) {
      // More stones to distribute: move to next hole and continue
      currentHole = getNextHoleIndex(currentHole, direction);
      continue;
    }

    // Last stone just landed in [currentHole]
    if (board[currentHole] > 1) {
      // Continuous sowing: hole was non-empty; pick up all and keep sowing
      stonesInHand = board[currentHole];
      board[currentHole] = 0;
      currentHole = getNextHoleIndex(currentHole, direction);
      continue;
    }

    // Landing hole has exactly 1 stone (was empty before we dropped)
    if (isHoleInPlayerRow(currentHole, currentPlayer)) {
      // Capture: take all stones from the opposite hole (same column)
      int opposite = getOppositeHole(currentHole);
      int captured = board[opposite];
      scores[currentPlayer] += captured;
      board[opposite] = 0;
      // Landing hole is not captured; it keeps the 1 stone we dropped
    }
    // Turn ends (after any capture, or when landing elsewhere)
    break;
  }

  // 3. Switch turn
  int nextPlayer = 1 - currentPlayer;
  GameState newState = state.copyWith(
    board: board,
    scores: scores,
    currentPlayer: nextPlayer,
  );

  // 4. Detect game end and apply final scores
  return applyGameEndIfNeeded(newState);
}

/// If one player's row is empty, add the other row's stones to that player's
/// score and set game over and winner. Exposed for testing.
GameState applyGameEndIfNeeded(GameState state) {
  int p0RowSum = 0;
  for (int i = 0; i < GameState.holesPerRow; i++) p0RowSum += state.board[i];
  int p1RowSum = 0;
  for (int i = GameState.holesPerRow; i < GameState.totalHoles; i++) {
    p1RowSum += state.board[i];
  }

  if (p0RowSum == 0) {
    // Player 0's row empty → remaining stones on Player 1's row go to P1
    List<int> scores = List.from(state.scores);
    scores[1] += p1RowSum;
    int? winner = scores[0] > scores[1] ? 0 : (scores[1] > scores[0] ? 1 : null);
    return state.copyWith(
      board: List.filled(GameState.totalHoles, 0),
      scores: scores,
      isGameOver: true,
      winner: winner,
    );
  }
  if (p1RowSum == 0) {
    // Player 1's row empty → remaining stones on Player 0's row go to P0
    List<int> scores = List.from(state.scores);
    scores[0] += p0RowSum;
    int? winner = scores[0] > scores[1] ? 0 : (scores[1] > scores[0] ? 1 : null);
    return state.copyWith(
      board: List.filled(GameState.totalHoles, 0),
      scores: scores,
      isGameOver: true,
      winner: winner,
    );
  }
  return state;
}

// ---------------------------------------------------------------------------
// Game end and winner
// ---------------------------------------------------------------------------

/// True if the game is over (one player's row is empty).
bool isGameOver(GameState state) {
  if (state.isGameOver) return true;
  int p0 = 0, p1 = 0;
  for (int i = 0; i < GameState.holesPerRow; i++) p0 += state.board[i];
  for (int i = GameState.holesPerRow; i < GameState.totalHoles; i++) {
    p1 += state.board[i];
  }
  return p0 == 0 || p1 == 0;
}

/// Returns 0, 1, or null (tie / not ended). Only meaningful after game end.
int? getWinner(GameState state) {
  if (!state.isGameOver) return null;
  return state.winner;
}

/// Returns final scores [p0, p1] after game end; otherwise current scores.
List<int> getFinalScores(GameState state) {
  return List.from(state.scores);
}
