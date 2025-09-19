import 'package:flutter/material.dart';
import 'package:nihongo_app/flashcards/create_flashcard.dart';
import 'kanji_flashcard_page.dart';

class KanjiLevelSelect extends StatelessWidget {
  const KanjiLevelSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Kanji Level'),
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
                    _buildLevelCard(
                      context,
                      'N5 Flashcards',
                      Colors.blue.shade100,
                      Icons.looks_one,
                      "N5",
                    ),
                    _buildLevelCard(
                      context,
                      'N4 Flashcards',
                      Colors.green.shade100,
                      Icons.looks_two,
                      "N4",
                    ),
                    _buildLevelCard(
                      context,
                      'Custom Flashcards',
                      Colors.purple.shade100,
                      Icons.create,
                      "Custom",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateFlashcardPage()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Create New Flashcard',
      ),
    );
  }

  Widget _buildLevelCard(
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
              builder: (context) => KanjiFlashcardPage(level: level),
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
