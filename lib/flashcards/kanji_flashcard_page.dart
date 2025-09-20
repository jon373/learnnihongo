import 'package:flutter/material.dart';
import 'package:nihongo_app/data/kanji_data.dart';

class KanjiFlashcardPage extends StatefulWidget {
  final String level;
  const KanjiFlashcardPage({super.key, required this.level});

  @override
  State<KanjiFlashcardPage> createState() => _KanjiFlashcardPageState();
}

class _KanjiFlashcardPageState extends State<KanjiFlashcardPage> {
  late List<Map<String, String>> kanjiList;
  int currentIndex = 0;
  bool showMeaning = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() {
    List<Map<String, String>> loadedCards = [];

    // Load base kanji list based on level
    if (widget.level == "N5") {
      loadedCards = getShuffledN5Kanji();
    } else if (widget.level == "N4") {
      loadedCards = getShuffledN4Kanji();
    } else {
      loadedCards = getShuffledAllKanji();
    }

    setState(() {
      kanjiList = loadedCards;
      isLoading = false;
    });
  }

  void _reshuffle() {
    setState(() {
      isLoading = true;
      _loadFlashcards(); // This will get a newly shuffled list
      currentIndex = 0;
      showMeaning = false;
    });
  }

  void _nextCard() {
    setState(() {
      if (currentIndex < kanjiList.length - 1) {
        currentIndex++;
      } else {
        // Reached end, reshuffle and start over
        _reshuffle();
      }
      showMeaning = false;
    });
  }

  void _previousCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
      showMeaning = false;
    });
  }

  void _flipCard() {
    setState(() {
      showMeaning = !showMeaning;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    if (kanjiList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("${widget.level} Kanji Flashcards"),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        body: Center(
          child: Text(
            "No flashcards available",
            style: TextStyle(
              fontSize: 18,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
      );
    }

    final currentCard = kanjiList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.level} Kanji Flashcards"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: _reshuffle,
            tooltip: 'Shuffle Flashcards',
          )
        ],
      ),
      body: Column(
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
                child: showMeaning
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentCard['meaning'] ?? '',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (currentCard['reading'] != null &&
                              currentCard['reading']!.isNotEmpty)
                            Text(
                              "(${currentCard['reading']})",
                              style: TextStyle(
                                fontSize: 20,
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.7),
                              ),
                            ),
                        ],
                      )
                    : Text(
                        currentCard['kanji'] ?? '',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
              ),
            ),
          ),
          // Added "Tap to reveal" hint for Kanji
          if (!showMeaning)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                "Tap to reveal meaning",
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
            "${currentIndex + 1} / ${kanjiList.length}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
