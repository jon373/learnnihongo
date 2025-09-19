import 'package:flutter/material.dart';
import 'package:nihongo_app/data/hiragana_data.dart';

class HiraganaFlashcards extends StatefulWidget {
  const HiraganaFlashcards({super.key});

  @override
  State<HiraganaFlashcards> createState() => _HiraganaFlashcardsState();
}

class _HiraganaFlashcardsState extends State<HiraganaFlashcards> {
  int currentIndex = 0;
  bool showReading = false;

  void _nextCard() {
    setState(() {
      if (currentIndex < hiraganaList.length - 1) {
        currentIndex++;
      }
      showReading = false;
    });
  }

  void _previousCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
      showReading = false;
    });
  }

  void _flipCard() {
    setState(() {
      showReading = !showReading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = hiraganaList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hiragana Flashcards"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _flipCard,
              child: Card(
                elevation: 6,
                margin: const EdgeInsets.all(16),
                child: Container(
                  height: 200,
                  width: 300,
                  alignment: Alignment.center,
                  child: Text(
                    showReading ? current['reading']! : current['character']!,
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            if (!showReading)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Tap to reveal reading",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _previousCard,
                  child: const Text("Previous"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _nextCard,
                  child: const Text("Next"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("${currentIndex + 1} / ${hiraganaList.length}"),
          ],
        ),
      ),
    );
  }
}
