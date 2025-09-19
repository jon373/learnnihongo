import 'package:flutter/material.dart';
import 'package:nihongo_app/data/kanji_data.dart';

class KanjiQuizPage extends StatefulWidget {
  final String level;
  const KanjiQuizPage({super.key, required this.level});

  @override
  State<KanjiQuizPage> createState() => _KanjiQuizPageState();
}

class _KanjiQuizPageState extends State<KanjiQuizPage> {
  late List<Map<String, dynamic>> kanjiList;
  int currentIndex = 0;
  int score = 0;
  bool answered = false;
  String? selectedAnswer;
  List<String> currentOptions = [];

  @override
  void initState() {
    super.initState();
    _loadKanjiList();
    _loadOptions();
  }

  void _loadKanjiList() {
    if (widget.level == "N5") {
      kanjiList = List.from(n5KanjiQuiz); // connect to N5 quiz
    } else if (widget.level == "N4") {
      kanjiList = List.from(n4KanjiQuiz); // connect to N4 quiz
    } else {
      kanjiList = [...n5KanjiQuiz, ...n4KanjiQuiz]; // both levels
    }
    kanjiList.shuffle(); // shuffle question order
  }

  void _loadOptions() {
    currentOptions = List<String>.from(kanjiList[currentIndex]['options']);
    currentOptions.shuffle(); // always shuffle choices
  }

  void _checkAnswer(String selected) {
    if (answered) return;

    setState(() {
      answered = true;
      selectedAnswer = selected;
      if (selected == kanjiList[currentIndex]['answer']) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < kanjiList.length - 1) {
        setState(() {
          currentIndex++;
          answered = false;
          selectedAnswer = null;
          _loadOptions(); // reload & shuffle next question’s options
        });
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Finished"),
        content: Text("Your score: $score / ${kanjiList.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kanjiList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("KANJI Quiz ${widget.level}")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    var question = kanjiList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("KANJI Quiz ${widget.level}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // 👈 centers everything
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // 👈 vertical centering
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar (now centered with rest of content)
              // Progress bar
              LinearProgressIndicator(
                value: (currentIndex + 1) / kanjiList.length,
                backgroundColor: Colors.grey[200],
                color: Colors.blue,
                minHeight: 10, // 👈 makes it thicker
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Question ${currentIndex + 1} of ${kanjiList.length}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),

              const Center(
                child: Text(
                  "What is the reading/meaning of:",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  question['kanji'],
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Multiple choice buttons
              ...currentOptions.map((opt) {
                final isCorrect = opt == question['answer'];
                final isSelected = opt == selectedAnswer;

                Color btnColor = Colors.blue;
                if (answered) {
                  if (isCorrect && isSelected) {
                    btnColor = Colors.green;
                  } else if (!isCorrect && isSelected) {
                    btnColor = Colors.red;
                  } else {
                    btnColor = Colors.blue;
                  }
                }

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (!answered) {
                        _checkAnswer(opt);
                      }
                    },
                    child: Text(
                      opt,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Score text
              Text(
                "Score: $score / ${kanjiList.length}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
