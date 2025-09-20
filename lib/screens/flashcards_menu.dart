import 'package:flutter/material.dart';
import 'package:nihongo_app/components/selection_card.dart';
import 'package:nihongo_app/screens/kanji_level_select.dart';
import 'package:nihongo_app/flashcards/hiragana_flashcards.dart';
import 'package:nihongo_app/flashcards/katakana_flashcards.dart';
import 'package:nihongo_app/screens/n5_selection_page.dart';

class FlashcardsMenu extends StatelessWidget {
  const FlashcardsMenu({super.key});

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
        title: const Text('Nihongo Flashcards'),
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
              'Select Flashcard Type',
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
                    SelectionCard(
                      title: 'Kanji Flashcards',
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      icon: _buildLetterIcon('漢',
                          color: theme.colorScheme.onPrimary),
                      destination: const KanjiLevelSelect(),
                      description: 'Practice JLPT Kanji characters',
                    ),
                    const SizedBox(height: 12),
                    SelectionCard(
                      title: 'N5 Flashcards',
                      color: theme.colorScheme.primary.withOpacity(0.15),
                      icon: _buildLetterIcon('N5',
                          color: theme.colorScheme.onPrimary),
                      destination: const NounSelectionPage(),
                      description: 'Practice N5 Vocabs',
                    ),
                    const SizedBox(height: 12),
                    SelectionCard(
                      title: 'Hiragana Flashcards',
                      color: theme.colorScheme.secondary.withOpacity(0.1),
                      icon: _buildLetterIcon('ひ',
                          color: theme.colorScheme.onPrimary),
                      destination: const HiraganaFlashcards(),
                      description: 'Practice Hiragana characters',
                    ),
                    const SizedBox(height: 12),
                    SelectionCard(
                      title: 'Katakana Flashcards',
                      color: theme.colorScheme.tertiary.withOpacity(0.1),
                      icon: _buildLetterIcon('カ',
                          color: theme.colorScheme.onPrimary),
                      destination: const KatakanaFlashcards(),
                      description: 'Practice Katakana characters',
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
}
