import 'package:flutter/material.dart';
import 'package:saddeeqa/core/constants/app_colors.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.background),
      appBar: AppBar(
        title: const Text('How to Play Saddeeqa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: 'Objective',
              content:
                  'Capture more stones than your opponent by strategically sowing and capturing stones.',
            ),
            _Section(
              title: 'Board Setup',
              content:
                  'The board has 16 holes arranged in two rows of 8 columns:\n'
                  '• Top row (holes 0-7): Player 2\n'
                  '• Bottom row (holes 8-15): Player 1\n'
                  '• Each hole starts with 4 stones\n'
                  '• Two capture stores (one per player) store captured stones',
            ),
            _Section(
              title: 'How to Play',
              children: [
                _Step(
                  number: 1,
                  text: 'Select a hole from your row that contains stones.',
                ),
                _Step(
                  number: 2,
                  text:
                      'Choose a sowing direction (clockwise or counter-clockwise).',
                ),
                _Step(
                  number: 3,
                  text:
                      'Stones are distributed one by one in the chosen direction, including both rows, wrapping around the board if needed.',
                ),
              ],
            ),
            _Section(
              title: 'Continuous Sowing',
              content:
                  'If the last stone lands in a non-empty hole, you pick up all stones from that hole and continue sowing immediately.',
            ),
            _Section(
              title: 'Capture',
              content:
                  'If the last stone lands in an empty hole on your row, you capture all stones from the opposite hole in the same column. The landing hole is not captured.',
            ),
            _Section(
              title: 'Turn End',
              content:
                  'Your turn ends after any capture. If no capture occurs, your turn also ends.',
            ),
            _Section(
              title: 'Game End',
              content:
                  'The game ends when one player\'s row is completely empty. Remaining stones on the other player\'s row are added to their score. The player with the highest total stones wins.',
            ),
            _Section(
              title: 'Tips',
              children: [
                const Text(
                  '• Plan ahead to create capture opportunities',
                  style: TextStyle(color: Color(AppColors.active)),
                ),
                const SizedBox(height: 4),
                const Text(
                  '• Use continuous sowing to move many stones',
                  style: TextStyle(color: Color(AppColors.active)),
                ),
                const SizedBox(height: 4),
                const Text(
                  '• Watch for empty holes on your row',
                  style: TextStyle(color: Color(AppColors.active)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String? content;
  final List<Widget>? children;

  const _Section({
    required this.title,
    this.content,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(AppColors.active),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (content != null)
            Text(
              content!,
              style: const TextStyle(
                color: Color(AppColors.active),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          if (children != null) ...children!,
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final int number;
  final String text;

  const _Step({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(AppColors.boardBase),
              border: Border.all(color: const Color(AppColors.border)),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Color(AppColors.active),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(AppColors.active),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
