import 'package:saddeeqa/game/helper.dart';
import 'package:saddeeqa/game/game_state.dart';
import 'package:saddeeqa/game/game_logic.dart';
import 'package:saddeeqa/game/direction.dart';

void main() {
  // Player 1 (P0) starts from first hole (0) in clockwise direction
  GameState state = GameState.initial();
  print('Initial board:');
  printBoard(state);

  state = performMove(state, 0, SowingDirection.clockwise)!;
  print('After P0 moves from hole 0 (first hole) clockwise:');
  printBoard(state);

  // Expected: P0 row 1 6 6 0 1 6 6 6, P1 row 6 1 5 5 5 5 0 5 (hole 15 = 5 so total = 64)
  const expected = [1, 6, 6, 0, 1, 6, 6, 6, 6, 1, 5, 5, 5, 5, 0, 5];
  print('Expected: P0 [${expected.sublist(0, 8).join(' ')}]  P1 [${expected.sublist(8, 16).join(' ')}]');
  print('Actual:   P0 [${state.board.sublist(0, 8).join(' ')}]  P1 [${state.board.sublist(8, 16).join(' ')}]');
  print('Match: ${state.board == expected}');
}
