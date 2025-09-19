import 'package:flutter/material.dart';
import 'package:nihongo_app/kanji_quiz.dart';

class KanjiSelectionPage extends StatelessWidget {
  const KanjiSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanji Quiz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Kanji Level',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildKanjiLevelCard(
                      context,
                      'Kanji N5',
                      Colors.orange.shade100,
                      Icons.looks_5_rounded,
                      'N5',
                    ),
                    _buildKanjiLevelCard(
                      context,
                      'Kanji N4',
                      Colors.orange.shade200,
                      Icons.looks_4_rounded,
                      'N4',
                    ),
                    _buildKanjiLevelCard(
                      context,
                      'All N5 + N4',
                      Colors.orange.shade300,
                      Icons.all_inclusive,
                      'All',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKanjiLevelCard(
    BuildContext context,
    String title,
    Color color,
    IconData icon,
    String level,
  ) {
    return Card(
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KanjiQuizPage(level: level),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40),
              const SizedBox(width: 16),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
