import 'package:flutter_test/flutter_test.dart';
import 'package:saddeeqa/game/direction.dart';
import 'package:saddeeqa/game/game_logic.dart';
import 'package:saddeeqa/game/game_state.dart';

void main() {
  group('Indexing and layout', () {
    test('getNextHoleIndex clockwise wraps 15→0', () {
      expect(getNextHoleIndex(15, SowingDirection.clockwise), 0);
      expect(getNextHoleIndex(0, SowingDirection.clockwise), 1);
      expect(getNextHoleIndex(7, SowingDirection.clockwise), 8);
    });
    test('getNextHoleIndex counterClockwise wraps 0→15', () {
      expect(getNextHoleIndex(0, SowingDirection.counterClockwise), 15);
      expect(getNextHoleIndex(15, SowingDirection.counterClockwise), 14);
      expect(getNextHoleIndex(8, SowingDirection.counterClockwise), 7);
    });
    test('getOppositeHole same column', () {
      expect(getOppositeHole(0), 8);
      expect(getOppositeHole(8), 0);
      expect(getOppositeHole(7), 15);
      expect(getOppositeHole(15), 7);
    });
    test('isHoleInPlayerRow', () {
      for (int i = 0; i < 8; i++) {
        expect(isHoleInPlayerRow(i, 0), true);
        expect(isHoleInPlayerRow(i, 1), false);
      }
      for (int i = 8; i < 16; i++) {
        expect(isHoleInPlayerRow(i, 0), false);
        expect(isHoleInPlayerRow(i, 1), true);
      }
    });
  });

  group('Initial state and validation', () {
    test('initial state has 4 stones per hole, P0 to move', () {
      final s = GameState.initial();
      expect(s.board.length, 16);
      for (int i = 0; i < 16; i++) expect(s.board[i], 4);
      expect(s.scores, [0, 0]);
      expect(s.currentPlayer, 0);
      expect(s.isGameOver, false);
    });
    test('isValidMove: only own row, non-empty', () {
      final s = GameState.initial();
      expect(isValidMove(s, 0, SowingDirection.clockwise), true);
      expect(isValidMove(s, 8, SowingDirection.clockwise), false); // P1 hole
      final empty = s.copyWith(
        board: [0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
      );
      expect(isValidMove(empty, 0, SowingDirection.clockwise), false);
    });
    test('invalid move returns null', () {
      final s = GameState.initial();
      expect(performMove(s, 8, SowingDirection.clockwise), isNull);
      expect(performMove(s, 0, SowingDirection.clockwise), isNotNull);
    });
  });

  group('Sowing clockwise', () {
    test('Player 0 sows from hole 0 clockwise: turn switches', () {
      final s = GameState.initial();
      final next = performMove(s, 0, SowingDirection.clockwise);
      expect(next, isNotNull);
      // Stones are distributed; turn must switch to P1 (hole 0 may get stones again when wrapping)
      expect(next!.currentPlayer, 1);
    });
  });

  group('Sowing counter-clockwise', () {
    test('Player 0 sows from hole 7 counterClockwise: first drop in 6', () {
      final s = GameState.initial();
      final next = performMove(s, 7, SowingDirection.counterClockwise);
      expect(next, isNotNull);
      // First drop goes in 6 (4+1=5); continuous sowing may add more to 6
      expect(next!.board[6], greaterThanOrEqualTo(5));
      expect(next.currentPlayer, 1);
    });
  });

  group('Capture', () {
    test('Land in empty hole on own row captures opposite column', () {
      // P0 hole 0 has 1 stone; sow clockwise → land in 1 (empty), capture hole 9. Keep P1 row non-empty so game does not end (e.g. hole 8 has 1).
      final board = List.filled(16, 0);
      board[0] = 1;
      board[8] = 1;
      board[9] = 5;
      final s = GameState(
        board: board,
        scores: [0, 0],
        currentPlayer: 0,
      );
      final next = performMove(s, 0, SowingDirection.clockwise);
      expect(next, isNotNull);
      expect(next!.board[1], 1); // landing hole keeps our stone
      expect(next.board[9], 0); // captured
      expect(next.scores[0], 5);
      expect(next.currentPlayer, 1);
    });
    test('Land in empty on own row captures opposite (same column)', () {
      // 2 stones in 0; sow clockwise → drop in 1, 2. Land in 2 (empty, P0) → capture opposite hole 10. Keep P1 row non-empty so game does not end.
      final board = List.filled(16, 0);
      board[0] = 2;
      board[8] = 1;
      board[10] = 3; // will be captured
      final s = GameState(board: board, scores: [0, 0], currentPlayer: 0);
      final next = performMove(s, 0, SowingDirection.clockwise);
      expect(next, isNotNull);
      expect(next!.board[2], 1); // landing hole keeps our stone
      expect(next.board[10], 0); // captured
      expect(next.scores[0], 3);
      expect(next.currentPlayer, 1);
    });
  });

  group('Long chain (continuous sowing)', () {
    test('Continuous sowing: one continue then land in empty and capture', () {
      // 1 stone in 0, 4 in 1. Sow from 0 clockwise: drop in 1 → land in 1 (5 stones) → continue; pick 5, drop in 2,3,4,5,6 → land in 6 (P0, was 0, now 1) → capture opposite 14. Put 3 stones in hole 14.
      final board = List.filled(16, 0);
      board[0] = 1;
      board[1] = 4;
      board[14] = 3;
      board[15] = 1; // keep P1 row non-empty so game does not end
      final s = GameState(board: board, scores: [0, 0], currentPlayer: 0);
      final next = performMove(s, 0, SowingDirection.clockwise);
      expect(next, isNotNull);
      expect(next!.currentPlayer, 1);
      expect(next.board[6], 1);
      expect(next.scores[0], 3);
    });
  });

  group('Game end', () {
    test('When P0 row is empty, P1 gets remaining stones and winner set', () {
      final board = List.filled(16, 0);
      for (int i = 8; i < 16; i++) board[i] = 3;
      final s = GameState(
        board: board,
        scores: [10, 5],
        currentPlayer: 1,
      );
      final next = applyGameEndIfNeeded(s);
      expect(next.isGameOver, true);
      expect(next.scores[1], 5 + 8 * 3); // 5 + 24 = 29
      expect(next.winner, 1);
    });
    test('When P1 row is empty, P0 gets remaining stones', () {
      final board = List.filled(16, 0);
      for (int i = 0; i < 8; i++) board[i] = 2;
      final s = GameState(
        board: board,
        scores: [0, 20],
        currentPlayer: 0,
      );
      final next = applyGameEndIfNeeded(s);
      expect(next.isGameOver, true);
      expect(next.scores[0], 16); // 8*2 from P0 row
      expect(next.scores[1], 20);
      expect(next.winner, 1); // 20 > 16
    });
    test('Tie when final scores equal', () {
      // Both rows empty, equal scores → tie
      final board = List.filled(16, 0);
      final s = GameState(
        board: board,
        scores: [32, 32],
        currentPlayer: 0,
      );
      final next = applyGameEndIfNeeded(s);
      expect(next.isGameOver, true);
      expect(next.winner, isNull);
    });
  });

  group('isGameOver and getWinner', () {
    test('isGameOver true when one row empty', () {
      final full = GameState.initial();
      expect(isGameOver(full), false);
      final p0Empty = full.copyWith(
        board: [
          0, 0, 0, 0, 0, 0, 0, 0,
          1, 1, 1, 1, 1, 1, 1, 1,
        ],
      );
      expect(isGameOver(p0Empty), true);
    });
    test('getWinner null when not ended', () {
      expect(getWinner(GameState.initial()), isNull);
    });
  });
}

