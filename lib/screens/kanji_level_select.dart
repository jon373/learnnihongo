import 'package:flutter/material.dart';
import '../flashcards/kanji_flashcard_page.dart';

class KanjiLevelSelect extends StatelessWidget {
  const KanjiLevelSelect({super.key});

  // Helper function to create letter icons
  Widget _buildLetterIcon(String letter,
      {double size = 40, Color color = Colors.white}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: size * 0.7,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Kanji Level'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Kanji Level',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildLevelCard(
                      context,
                      'N5 Kanji Flashcards',
                      theme.colorScheme.primary.withOpacity(0.1),
                      _buildLetterIcon('5', color: theme.colorScheme.onPrimary),
                      "N5",
                    ),
                    const SizedBox(height: 12),
                    _buildLevelCard(
                      context,
                      'N4 Kanji Flashcards',
                      theme.colorScheme.primary.withOpacity(0.15),
                      _buildLetterIcon('4', color: theme.colorScheme.onPrimary),
                      "N4",
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    String title,
    Color color,
    Widget icon, // Changed from IconData to Widget
    String level,
  ) {
    final theme = Theme.of(context);

    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
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
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        highlightColor: theme.colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon container with traditional Japanese style
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(child: icon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 30,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
