import 'package:flutter_test/flutter_test.dart';
import 'package:saddeeqa/game/direction.dart';
import 'package:saddeeqa/game/game_logic.dart';
import 'package:saddeeqa/game/game_state.dart';

void main() {
  group('Basic Moves', () {
    test('Player 0 hole 0 clockwise', () {
      final s = GameState.initial();
      final next = performMove(s, 0, SowingDirection.clockwise);
      expect(next, isNotNull);
      expect(next!.currentPlayer, 1);
    });

    test('Player 1 hole 8 counterClockwise', () {
      final s = GameState.initial().copyWith(currentPlayer: 1);
      final next = performMove(s, 8, SowingDirection.counterClockwise);
      expect(next, isNotNull);
      expect(next!.currentPlayer, 0);
    });

    test('Player 0 hole 7 clockwise wraps to P1 row', () {
      final s = GameState.initial();
      final next = performMove(s, 7, SowingDirection.clockwise);
      expect(next, isNotNull);
      expect(next!.currentPlayer, 1);
    });
  });

  group('Continuous Sowing', () {
    test('Last stone in non-empty hole continues sowing', () {
      final board = List.filled(16, 0);
      board[0] = 4; // will land in hole 1 (non-empty)
      board[1] = 2;
      final s = GameState(board: board, scores: [0, 0], currentPlayer: 0);
      final next = performMove(s, 0, SowingDirection.clockwise);
      expect(next, isNotNull);
      expect(next!.currentPlayer, 1);
      expect(next.board[1], greaterThan(0)); // sowed stones continue
    });

    test('Sowing wraps around board multiple times', () {
      final board = List.filled(16, 0);
      board[0] = 16;
      final s = GameState(board: board, scores: [0, 0], currentPlayer: 0);
      final next = performMove(s, 0, SowingDirection.clockwise);
      expect(next, isNotNull);
      expect(next!.currentPlayer, 1);
      expect(next.board.contains(0), false); // all stones distributed
    });
  });

  group('Capture Scenarios', () {
    test('Landing in empty hole on own row captures opposite', () {
      final board = List.filled(16, 0);
      board[0] = 1;
      board[8] = 1;
      board[9] = 4;
      final s = GameState(board: board, scores: [0, 0], currentPlayer: 0);
      final next = performMove(s, 0, SowingDirection.clockwise);
      expect(next, isNotNull);
      expect(next!.scores[0], 4);
      expect(next.board[9], 0);
    });

    test('Landing in empty hole on own row with opposite empty -> no capture', () {
      final board = List.filled(16, 0);
      board[0] = 1;
      board[8] = 0;
      final s = GameState(board: board, scores: [0, 0], currentPlayer: 0);
      final next = performMove(s, 0, SowingDirection.clockwise);
      expect(next, isNotNull);
      expect(next!.scores[0], 0);
    });
  });

  group('Game End Scenarios', () {
    test('P0 row empty → P1 gets remaining stones', () {
      final board = List.filled(16, 0);
      for (int i = 8; i < 16; i++) board[i] = 3;
      final s = GameState(board: board, scores: [10, 5], currentPlayer: 1);
      final next = applyGameEndIfNeeded(s);
      expect(next.isGameOver, true);
      expect(next.scores[1], 5 + 8 * 3);
      expect(next.winner, 1);
    });

    test('Tie game', () {
      final board = List.filled(16, 0);
      final s = GameState(board: board, scores: [32, 32], currentPlayer: 0);
      final next = applyGameEndIfNeeded(s);
      expect(next.isGameOver, true);
      expect(next.winner, isNull);
    });

    test('P1 row empty → P0 gets remaining stones', () {
      final board = List.filled(16, 0);
      for (int i = 0; i < 8; i++) board[i] = 2;
      final s = GameState(board: board, scores: [0, 20], currentPlayer: 0);
      final next = applyGameEndIfNeeded(s);
      expect(next.isGameOver, true);
      expect(next.scores[0], 16);
      expect(next.winner, 1);
    });
  });

  group('Invalid Moves', () {
    test('Empty hole', () {
      final s = GameState.initial().copyWith(board: [0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]);
      expect(performMove(s, 0, SowingDirection.clockwise), isNull);
    });

    test('Opponent hole', () {
      final s = GameState.initial();
      expect(performMove(s, 8, SowingDirection.clockwise), isNull);
    });

    test('Game already over', () {
      final s = GameState.initial().copyWith(isGameOver: true);
      expect(performMove(s, 0, SowingDirection.clockwise), isNull);
    });
  });

  group('Direction Choice', () {
    test('Clockwise sowing', () {
      final s = GameState.initial();
      final next = performMove(s, 0, SowingDirection.clockwise);
      expect(next, isNotNull);
    });

    test('Counter-clockwise sowing', () {
      final s = GameState.initial();
      final next = performMove(s, 0, SowingDirection.counterClockwise);
      expect(next, isNotNull);
    });
  });
}
