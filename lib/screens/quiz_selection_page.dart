import 'package:flutter/material.dart';
import 'package:nihongo_app/components/selection_card.dart';
import 'package:nihongo_app/hiragana_quiz.dart';
import 'package:nihongo_app/katakana_quiz.dart';
import 'package:nihongo_app/screens/kanji_selection_page.dart';

class QuizSelectionPage extends StatelessWidget {
  const QuizSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nihongo Quiz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Quiz Type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SelectionCard(
                      title: 'Hiragana',
                      color: Colors.blue.shade100,
                      icon: Icons.language,
                      destination: HiraganaQuizPage(),
                      description: 'Test your Hiragana knowledge',
                    ),
                    const SizedBox(height: 16),
                    SelectionCard(
                      title: 'Katakana',
                      color: Colors.green.shade100,
                      icon: Icons.translate,
                      destination: KatakanaQuizPage(),
                      description: 'Test your Katakana knowledge',
                    ),
                    const SizedBox(height: 16),
                    SelectionCard(
                      title: 'Kanji',
                      color: Colors.orange.shade100,
                      icon: Icons.brush,
                      destination: const KanjiSelectionPage(),
                      description: 'Test your Kanji knowledge',
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
