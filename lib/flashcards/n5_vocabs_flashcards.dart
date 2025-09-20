import 'package:flutter/material.dart';
import 'package:nihongo_app/data/N5_vocabs_data.dart';

class NounFlashcardPage extends StatefulWidget {
  final String level; // nouns, verbs, iAdj, naAdj, Adv, Particles, All
  const NounFlashcardPage({super.key, required this.level});

  @override
  State<NounFlashcardPage> createState() => _NounFlashcardPageState();
}

class _NounFlashcardPageState extends State<NounFlashcardPage> {
  late List<Map<String, String>> vocabList;
  int currentIndex = 0;
  bool showMeaning = false;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() {
    switch (widget.level) {
      case "nouns":
        vocabList = _normalizeNouns(getShuffledNouns());
        break;
      case "verbs":
        vocabList = _normalizeVerbs(getShuffledVerbs());
        break;
      case "iAdj":
        vocabList = _normalizeAdjectives(getShuffledIAdjectives());
        break;
      case "naAdj":
        vocabList = _normalizeAdjectives(getShuffledNaAdjectives());
        break;
      case "Adv":
        vocabList = _normalizeAdverbs(getShuffledAdverbs());
        break;
      case "Particles":
        vocabList = _normalizeParticles(getShuffledParticles());
        break;
      case "All":
        vocabList = getShuffledAllVocab();
        break;
      default:
        vocabList = [];
    }
  }

  List<Map<String, String>> _normalizeNouns(List<Map<String, String>> nouns) {
    return nouns.map((noun) {
      return {
        'display': noun['kanji']?.isNotEmpty == true
            ? noun['kanji']!
            : noun['nihongo']!,
        'reading': noun['reading']!,
        'meaning': noun['meaning']!,
        'type': 'Noun',
      };
    }).toList();
  }

  List<Map<String, String>> _normalizeVerbs(List<Map<String, String>> verbs) {
    return verbs.map((verb) {
      return {
        'display': verb['dictionary']!,
        'reading': verb['reading']!,
        'meaning': verb['meaning']!,
        'type': 'Verb',
      };
    }).toList();
  }

  List<Map<String, String>> _normalizeAdjectives(
      List<Map<String, String>> adjectives) {
    return adjectives.map((adj) {
      return {
        'display': adj['Nihongo']!,
        'reading': adj['reading']!,
        'meaning': adj['meaning']!,
        'type': 'Adjective',
      };
    }).toList();
  }

  List<Map<String, String>> _normalizeAdverbs(
      List<Map<String, String>> adverbs) {
    return adverbs.map((adv) {
      return {
        'display': adv['Nihongo']!,
        'reading': adv['reading']!,
        'meaning': adv['meaning']!,
        'type': 'Adverb',
      };
    }).toList();
  }

  List<Map<String, String>> _normalizeParticles(
      List<Map<String, String>> particles) {
    return particles.map((particle) {
      return {
        'display': particle['Nihongo']!,
        'reading': particle['reading']!,
        'meaning': particle['meaning']!,
        'type': 'Particle',
      };
    }).toList();
  }

  void _reshuffle() {
    setState(() {
      _loadFlashcards(); // This will get a newly shuffled list
      currentIndex = 0;
      showMeaning = false;
    });
  }

  void _nextCard() {
    setState(() {
      if (currentIndex < vocabList.length - 1) {
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

    if (vocabList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Flashcards"),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        body: Center(
          child: Text(
            "No vocab available.",
            style: TextStyle(
              fontSize: 18,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
      );
    }

    final card = vocabList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.level} Flashcards"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: _reshuffle,
            tooltip: 'Shuffle Flashcards',
          ),
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
                            card["display"] ?? "",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Reading: ${card["reading"] ?? ''}",
                            style: TextStyle(
                              fontSize: 20,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Meaning: ${card["meaning"] ?? ''}",
                            style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Type: ${card["type"] ?? ''}",
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            card["display"] ?? "",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            card["type"] ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          // "Tap to reveal" hint - positioned outside the card
          if (!showMeaning)
            Padding(
              padding: const EdgeInsets.only(top: 8),
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
            "${currentIndex + 1} / ${vocabList.length}",
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
