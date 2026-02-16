/// Sowing direction for distributing stones around the board.
///
/// The board is linear: holes 0–7 (Player 0, top row), holes 8–15 (Player 1, bottom row).
/// - [clockwise]: index increases, wrapping 15 → 0.
/// - [counterClockwise]: index decreases, wrapping 0 → 15.
enum SowingDirection {
  /// Move to the next hole by increasing index: 0→1→…→7→8→…→15→0.
  clockwise,

  /// Move to the next hole by decreasing index: 0→15→14→…→8→7→…→1→0.
  counterClockwise,
}
