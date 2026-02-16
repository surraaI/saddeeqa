🎮 SADDEEQA — OFFICIAL GAME DOCUMENTATION (V1)

Status: LOCKED
Version: 1
Date: Feb 16, 2026
Scope: 2-Player Local Version

1️⃣ Game Overview

Saddeeqa is a two-player strategic board game played with small stones on a 16-hole board, arranged in two rows of eight columns.

The core objective is to capture as many stones as possible and eventually empty your opponent’s row.

Players take turns distributing (“sowing”) stones around the board, capturing stones under specific rules, and carefully planning moves to maximize their score.

2️⃣ Board Layout

The board consists of 16 holes, divided into two rows:

Top Row – Player 0:
[ 0 ][ 1 ][ 2 ][ 3 ][ 4 ][ 5 ][ 6 ][ 7 ]

Bottom Row – Player 1:
[15 ][14 ][13 ][12 ][11 ][10 ][ 9 ][ 8 ]


Each column has one hole per player, forming opposing pairs.

Each hole starts with an equal number of stones (commonly 4).

Captured stones are kept as a score counter, not in holes.

3️⃣ Players

Player 0: Controls the top row (holes 0–7)

Player 1: Controls the bottom row (holes 8–15)

Players take turns alternately.

4️⃣ Turn Order

Any player may start the first turn.

After that, turns strictly alternate.

Each turn is atomic: the player completes sowing (and any capture) before the opponent moves.

Note: There are no bonus turns in this version.

5️⃣ Direction Choice

At the start of a turn, the active player chooses the sowing direction:

Clockwise

Counter-clockwise

This direction applies to the entire move.

It cannot be changed mid-sowing.

Stones move through both rows, wrapping around all 16 holes in the chosen direction.

6️⃣ Valid Moves

A move is valid if:

The chosen hole belongs to the current player’s row.

The chosen hole contains at least one stone.

The game is not over.

Empty holes cannot be selected.

7️⃣ Sowing Mechanics

The player picks up all stones from the chosen hole.

The chosen hole is set to empty.

The stones are placed one by one into subsequent holes following the chosen direction:

Includes both rows

Wraps around the board if necessary

Continuous sowing rule:

If the last stone lands in a hole that already contains stones, the player picks up all stones from that hole and continues sowing.

If the last stone lands in an empty hole, the turn ends.

This allows long sowing chains and strategic moves.

8️⃣ Capture Rules

Capture happens only at the end of a turn (when the last stone lands in an empty hole on the player’s own row).

Conditions for capture:

Last stone lands in an empty hole.

The hole is on the current player’s row.

The opposing hole in the same column contains stones.

Effect:

All stones in the opposing hole are captured and added to the player’s score.

The opponent’s hole becomes empty.

The stone in the landing hole is not captured.

❌ No capture if the empty hole is in the opponent’s row.
❌ No capture if the opposing hole is empty.

9️⃣ Turn End

After any capture (if applicable):

The turn ends immediately.

The opponent takes their turn.

Remember: Only one move per turn; no bonus moves.

10️⃣ Game End Condition

The game ends immediately when one player’s entire row is empty.

When this happens:

Any remaining stones on the opponent’s row are collected and added to their score.

The board becomes completely empty.

The final scores are tallied.

11️⃣ Winning the Game

The winner is the player with the highest total stone count:
captured stones + remaining stones collected at game end

A tie is possible if both players have equal stones.

12️⃣ Summary for New Players

Pick a non-empty hole from your row.

Choose a sowing direction (clockwise or counter-clockwise).

Drop stones one by one, moving through both rows.

If the last stone lands in a non-empty hole → pick up stones and continue sowing.

If the last stone lands in an empty hole on your row → capture opponent stones in the same column.

Alternate turns until one row is empty.

Count captured stones + remaining stones; the player with the most stones wins.

13️⃣ Key Notes (Locked for v1)

Direction choice is only at the start of a move.

Sowing always includes both rows.

Capture only occurs on own row empty hole.

Remaining stones at game end are counted for the respective player.

There are no special holes or bonus turns.

Long sowing chains are allowed.