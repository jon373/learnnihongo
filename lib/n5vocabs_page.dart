import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nihongo_app/data/N5_vocabs_data.dart';

class VocabQuizPage extends StatefulWidget {
  final String quizType; // nouns, verbs, adjectives, all
  final String category;

  const VocabQuizPage({
    super.key,
    required this.quizType,
    required this.category,
  });

  @override
  State<VocabQuizPage> createState() => _VocabQuizPageState();
}

class _VocabQuizPageState extends State<VocabQuizPage> {
  late List<Map<String, dynamic>> quizList;
  late Map<String, dynamic> currentQuestion;
  int currentIndex = 0;
  int score = 0;
  bool answered = false;
  String? selectedAnswer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadQuiz();
    _loadQuestion();
  }

  void _loadQuiz() {
    switch (widget.quizType) {
      case 'nouns':
        quizList = List.from(n5NounsQuiz)..shuffle(_random);
        break;
      case 'verbs':
        quizList = List.from(n5VerbsQuiz)..shuffle(_random);
        break;
      case 'adjectives':
        quizList = [
          ...List.from(n5iAdjectivesQuiz),
          ...List.from(n5NaAdjectivesQuiz),
        ]..shuffle(_random);
        break;
      case 'all':
        quizList = List.from(n5AllVocabQuiz)..shuffle(_random);
        break;
      default:
        quizList = [];
    }
  }

  void _loadQuestion() {
    if (quizList.isEmpty) {
      return;
    }

    currentQuestion = quizList[currentIndex];

    // Shuffle options for this question
    List<String> options = List.from(currentQuestion['options']);
    options.shuffle(_random);
    currentQuestion['options'] = options;
  }

  void _checkAnswer(String selected) {
    if (answered) return;

    setState(() {
      answered = true;
      selectedAnswer = selected;
      if (selected == currentQuestion['answer']) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < quizList.length - 1) {
        setState(() {
          currentIndex++;
          answered = false;
          selectedAnswer = null;
          _loadQuestion();
        });
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        title: Text(
          "Quiz Completed!",
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your score: $score / ${quizList.length}",
              style: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Category: ${widget.category}",
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to selection
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
            child: const Text("Finish"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              _restartQuiz(); // restart same quiz
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  void _restartQuiz() {
    setState(() {
      // Reshuffle the entire quiz
      quizList.shuffle(_random);
      currentIndex = 0;
      score = 0;
      answered = false;
      selectedAnswer = null;
      _loadQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (quizList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("${widget.category} Quiz"),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                "No vocabulary available",
                style: TextStyle(
                  fontSize: 18,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} Quiz"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: (currentIndex + 1) / quizList.length,
                backgroundColor: theme.colorScheme.surface.withOpacity(0.5),
                color: theme.colorScheme.primary,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Question ${currentIndex + 1} of ${quizList.length}",
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "What is the meaning of:",
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Word card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    children: [
                      Text(
                        currentQuestion['word'],
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentQuestion['type'],
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.5),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Multiple choice buttons
              ...(currentQuestion['options'] as List<String>).map((opt) {
                final isCorrect = opt == currentQuestion['answer'];
                final isSelected = opt == selectedAnswer;

                Color btnColor = theme.colorScheme.primary;
                if (answered) {
                  if (isCorrect) {
                    btnColor = Colors.green;
                  } else if (isSelected && !isCorrect) {
                    btnColor = Colors.red;
                  } else {
                    btnColor = theme.colorScheme.primary.withOpacity(0.5);
                  }
                }

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      foregroundColor: Colors.white,
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
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              // Score text
              Text(
                "Score: $score / ${quizList.length}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
