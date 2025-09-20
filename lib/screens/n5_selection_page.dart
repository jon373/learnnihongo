import 'package:flutter/material.dart';
import 'package:nihongo_app/flashcards/n5_vocabs_flashcards.dart';

class NounSelectionPage extends StatelessWidget {
  const NounSelectionPage({super.key});

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
        title: const Text('N5 Vocabulary Flashcards'),
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
              'Select Vocabulary Category',
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
                    _buildNounLevelCard(
                      context,
                      'N5 Nouns',
                      theme.colorScheme.primary.withOpacity(0.1),
                      _buildLetterIcon('名', color: theme.colorScheme.onPrimary),
                      'nouns',
                    ),
                    const SizedBox(height: 3),
                    _buildNounLevelCard(
                      context,
                      'N5 Verbs',
                      theme.colorScheme.primary.withOpacity(0.12),
                      _buildLetterIcon('動', color: theme.colorScheme.onPrimary),
                      'verbs',
                    ),
                    const SizedBox(height: 3),
                    _buildNounLevelCard(
                      context,
                      'N5 i-Adjectives',
                      theme.colorScheme.primary.withOpacity(0.14),
                      _buildLetterIcon('い', color: theme.colorScheme.onPrimary),
                      'iAdj',
                    ),
                    const SizedBox(height: 3),
                    _buildNounLevelCard(
                      context,
                      'N5 na-Adjectives',
                      theme.colorScheme.primary.withOpacity(0.16),
                      _buildLetterIcon('な', color: theme.colorScheme.onPrimary),
                      'naAdj',
                    ),
                    const SizedBox(height: 3),
                    _buildNounLevelCard(
                      context,
                      'N5 Adverbs',
                      theme.colorScheme.primary.withOpacity(0.18),
                      _buildLetterIcon('副', color: theme.colorScheme.onPrimary),
                      'Adv',
                    ),
                    const SizedBox(height: 3),
                    _buildNounLevelCard(
                      context,
                      'N5 Particles',
                      theme.colorScheme.primary.withOpacity(0.18),
                      _buildLetterIcon('助', color: theme.colorScheme.onPrimary),
                      'Particles',
                    ),
                    const SizedBox(height: 3),
                    _buildNounLevelCard(
                      context,
                      'All N5 Vocabulary',
                      theme.colorScheme.primary.withOpacity(0.18),
                      _buildLetterIcon('全', color: theme.colorScheme.onPrimary),
                      'All',
                    ),
                    const SizedBox(height: 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNounLevelCard(
    BuildContext context,
    String title,
    Color color,
    Widget icon,
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
              builder: (context) => NounFlashcardPage(level: level),
            ),
          );
        },
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        highlightColor: theme.colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon container with traditional Japanese style (same as Kanji)
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
