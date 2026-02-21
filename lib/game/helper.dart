import 'game_state.dart';

/// Prints the current board state in 2 rows (Player 0 top, Player 1 bottom),
/// shows hole indices for reference and captures, along with scores and turn.
void printBoard(GameState state) {
  final topRow = state.board.sublist(0, GameState.holesPerRow);
  final bottomRow = state.board.sublist(GameState.holesPerRow, GameState.totalHoles);

  // Print column indices for reference
  final indices = List.generate(GameState.holesPerRow, (i) => i);
  final bottomIndices = List.generate(GameState.holesPerRow, (i) => i + GameState.holesPerRow);

  print('\n--- Saddeeqa Board ---');

  print('Top Row (Player 0)  : ${topRow.map((s) => s.toString().padLeft(2)).join(' ')}');
  print('Top Indices          : ${indices.map((i) => i.toString().padLeft(2)).join(' ')}');

  print('Bottom Row (Player 1): ${bottomRow.map((s) => s.toString().padLeft(2)).join(' ')}');
  print('Bottom Indices       : ${bottomIndices.map((i) => i.toString().padLeft(2)).join(' ')}');

  // Show opposite holes mapping (0↔8, 1↔9, ...)
  print('Column mapping       : ${List.generate(GameState.holesPerRow, (i) => '$i↔${i + GameState.holesPerRow}').join(' | ')}');

  // Scores and turn
  print('Scores → P0: ${state.scores[0]}, P1: ${state.scores[1]}');
  print('Current turn → Player ${state.currentPlayer}');
  print('Game Over? ${state.isGameOver ? "Yes" : "No"}');
  if (state.isGameOver) print('Winner → ${state.winner ?? "Tie"}');

  print('----------------------\n');
}

