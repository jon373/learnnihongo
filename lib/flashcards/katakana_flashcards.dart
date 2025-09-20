import 'package:flutter/material.dart';
import 'package:nihongo_app/data/katakana_data.dart';

class KatakanaFlashcards extends StatefulWidget {
  const KatakanaFlashcards({super.key});

  @override
  State<KatakanaFlashcards> createState() => _KatakanaFlashcardsState();
}

class _KatakanaFlashcardsState extends State<KatakanaFlashcards> {
  int currentIndex = 0;
  bool showReading = false;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() {
    katakanaList = getShuffledKatakana(); // or getShuffledKatakana()
  }

  void _reshuffle() {
    setState(() {
      _loadFlashcards(); // This will get a newly shuffled list
      currentIndex = 0;
      showReading = false;
    });
  }

  void _nextCard() {
    setState(() {
      if (currentIndex < katakanaList.length - 1) {
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
    final theme = Theme.of(context);
    final current = katakanaList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hiragana Flashcards"), // or "Katakana Flashcards"
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: _reshuffle,
            tooltip: 'Shuffle Flashcards',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _flipCard,
              child: Card(
                elevation: 6,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.surface.withOpacity(0.9),
                        theme.colorScheme.surface.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Text(
                    showReading ? current['reading']! : current['character']!,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ),
            if (!showReading)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Tap to reveal reading",
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onBackground.withOpacity(0.6),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _previousCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(120, 48),
                  ),
                  child: const Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: _nextCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(120, 48),
                  ),
                  child: const Text("Next"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "${currentIndex + 1} / ${katakanaList.length}",
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
