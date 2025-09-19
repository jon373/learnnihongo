import 'package:flutter/material.dart';
import 'package:nihongo_app/components/selection_card.dart';
import 'package:nihongo_app/flashcards/custom_folder_page.dart';
import 'package:nihongo_app/flashcards/kanji_level_select.dart';
import 'package:nihongo_app/flashcards/hiragana_flashcards.dart';
import 'package:nihongo_app/flashcards/katakana_flashcards.dart';

class FlashcardsMenu extends StatelessWidget {
  const FlashcardsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nihongo Flashcards'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Flashcard Type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SelectionCard(
                      title: 'Kanji Flashcards',
                      color: Colors.blue.shade100,
                      icon: Icons.brush,
                      destination: const KanjiLevelSelect(),
                      description: 'Practice JLPT Kanji characters',
                    ),
                    const SizedBox(height: 16),
                    SelectionCard(
                      title: 'Hiragana Flashcards',
                      color: Colors.purple.shade100,
                      icon: Icons.language,
                      destination: const HiraganaFlashcards(),
                      description: 'Practice Hiragana characters',
                    ),
                    const SizedBox(height: 16),
                    SelectionCard(
                      title: 'Katakana Flashcards',
                      color: Colors.orange.shade100,
                      icon: Icons.translate,
                      destination: const KatakanaFlashcards(),
                      description: 'Practice Katakana characters',
                    ),
                    const SizedBox(height: 16),
                    SelectionCard(
                      title: 'Custom Flashcards',
                      color: Colors.green.shade100,
                      icon: Icons.folder,
                      destination: const CustomFoldersPage(),
                      description: 'Create and manage your own flashcards',
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
}
