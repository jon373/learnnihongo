import 'package:flutter/material.dart';
import 'package:nihongo_app/flashcards/create_flashcard.dart';
import 'package:nihongo_app/data/kanji_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  void _loadFlashcards() async {
    List<Map<String, String>> loadedCards = [];

    if (widget.level == "N5") {
      loadedCards = n5KanjiList;
    } else if (widget.level == "N4") {
      loadedCards = n4KanjiList;
    } else if (widget.level == "Custom") {
      // Load custom flashcards from local storage
      final prefs = await SharedPreferences.getInstance();
      final String? customCardsJson = prefs.getString('customFlashcards');

      if (customCardsJson != null) {
        final List<dynamic> customCards = json.decode(customCardsJson);
        loadedCards = customCards.map<Map<String, String>>((item) {
          return {
            'kanji': item['kanji'] ?? '',
            'meaning': item['meaning'] ?? '',
            'reading': item['reading'] ?? '',
          };
        }).toList();
      }
    } else {
      loadedCards = [...n5KanjiList, ...n4KanjiList];
    }

    setState(() {
      kanjiList = loadedCards;
      isLoading = false;
    });
  }

  void _nextCard() {
    setState(() {
      if (currentIndex < kanjiList.length - 1) {
        currentIndex++;
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
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (kanjiList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Flashcards - ${widget.level}"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inbox, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                "No flashcards found",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                "Create some flashcards first!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateFlashcardPage()),
                  );
                },
                child: const Text('Create Flashcard'),
              ),
            ],
          ),
        ),
      );
    }

    final current = kanjiList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcards - ${widget.level}"),
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
                    showMeaning ? current['meaning']! : current['kanji']!,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            if (!showMeaning &&
                current['reading'] != null &&
                current['reading']!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  current['reading']!,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
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
            Text("${currentIndex + 1} / ${kanjiList.length}"),
          ],
        ),
      ),
    );
  }
}
