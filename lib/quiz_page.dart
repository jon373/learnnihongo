import 'dart:math';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final List<String> quizType;
  final List<String>? filterCharacters;
  final int totalQuestions;

  const QuizPage({
    required this.quizType,
    this.filterCharacters,
    required this.totalQuestions,
    super.key,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<String> quizCharacters;
  late String currentQuestion;
  late List<String> choices;
  int score = 0;
  int questionCount = 0;
  bool isAnswered = false;
  String? selectedAnswer;
  String? correctAnswer;
  List<String> usedQuestions = [];

  final Map<String, String> kanaMap = {
    // Hiragana
    'あ': 'a', 'い': 'i', 'う': 'u', 'え': 'e', 'お': 'o',
    'か': 'ka', 'き': 'ki', 'く': 'ku', 'け': 'ke', 'こ': 'ko',
    'さ': 'sa', 'し': 'shi', 'す': 'su', 'せ': 'se', 'そ': 'so',
    'た': 'ta', 'ち': 'chi', 'つ': 'tsu', 'て': 'te', 'と': 'to',
    'な': 'na', 'に': 'ni', 'ぬ': 'nu', 'ね': 'ne', 'の': 'no',
    'は': 'ha', 'ひ': 'hi', 'ふ': 'fu', 'へ': 'he', 'ほ': 'ho',
    'ま': 'ma', 'み': 'mi', 'む': 'mu', 'め': 'me', 'も': 'mo',
    'や': 'ya', 'ゆ': 'yu', 'よ': 'yo',
    'ら': 'ra', 'り': 'ri', 'る': 'ru', 'れ': 're', 'ろ': 'ro',
    'わ': 'wa', 'を': 'wo', 'ん': 'n',
    // Dakuten and handakuten
    'が': 'ga', 'ぎ': 'gi', 'ぐ': 'gu', 'げ': 'ge', 'ご': 'go',
    'ざ': 'za', 'じ': 'ji', 'ず': 'zu', 'ぜ': 'ze', 'ぞ': 'zo',
    'だ': 'da', 'ぢ': 'ji', 'づ': 'zu', 'で': 'de', 'ど': 'do',
    'ば': 'ba', 'び': 'bi', 'ぶ': 'bu', 'べ': 'be', 'ぼ': 'bo',
    'ぱ': 'pa', 'ぴ': 'pi', 'ぷ': 'pu', 'ぺ': 'pe', 'ぽ': 'po',
    // Katakana
    'ア': 'a', 'イ': 'i', 'ウ': 'u', 'エ': 'e', 'オ': 'o',
    'カ': 'ka', 'キ': 'ki', 'ク': 'ku', 'ケ': 'ke', 'コ': 'ko',
    'サ': 'sa', 'シ': 'shi', 'ス': 'su', 'セ': 'se', 'ソ': 'so',
    'タ': 'ta', 'チ': 'chi', 'ツ': 'tsu', 'テ': 'te', 'ト': 'to',
    'ナ': 'na', 'ニ': 'ni', 'ヌ': 'nu', 'ネ': 'ne', 'ノ': 'no',
    'ハ': 'ha', 'ヒ': 'hi', 'フ': 'fu', 'ヘ': 'he', 'ホ': 'ho',
    'マ': 'ma', 'ミ': 'mi', 'ム': 'mu', 'メ': 'me', 'モ': 'mo',
    'ヤ': 'ya', 'ユ': 'yu', 'ヨ': 'yo',
    'ラ': 'ra', 'リ': 'ri', 'ル': 'ru', 'レ': 're', 'ロ': 'ro',
    'ワ': 'wa', 'ヲ': 'wo', 'ン': 'n',
    // Dakuten and handakuten
    'ガ': 'ga', 'ギ': 'gi', 'グ': 'gu', 'ゲ': 'ge', 'ゴ': 'go',
    'ザ': 'za', 'ジ': 'ji', 'ズ': 'zu', 'ゼ': 'ze', 'ゾ': 'zo',
    'ダ': 'da', 'ヂ': 'ji', 'ヅ': 'zu', 'デ': 'de', 'ド': 'do',
    'バ': 'ba', 'ビ': 'bi', 'ブ': 'bu', 'ベ': 'be', 'ボ': 'bo',
    'パ': 'pa', 'ピ': 'pi', 'プ': 'pu', 'ペ': 'pe', 'ポ': 'po',
  };

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  void _initializeQuiz() {
    quizCharacters = widget.filterCharacters ??
        kanaMap.keys
            .where((k) => widget.quizType.any((type) => _matchType(k, type)))
            .toList();
    _generateNewQuestion();
  }

  bool _matchType(String char, String type) {
    if (type == 'hiragana') {
      return RegExp(r'^[\u3040-\u309F\u309B\u309C\u309D\u309E]$')
          .hasMatch(char);
    }
    if (type == 'katakana') {
      return RegExp(r'^[\u30A0-\u30FF\u309B\u309C\u30FC\u30FD\u30FE]$')
          .hasMatch(char);
    }
    if (type == 'kanji') return RegExp(r'^[\u4E00-\u9FAF]$').hasMatch(char);
    return false;
  }

  void _generateNewQuestion() {
    isAnswered = false;
    selectedAnswer = null;

    final availableQuestions =
        quizCharacters.where((char) => !usedQuestions.contains(char)).toList();

    if (availableQuestions.isEmpty) {
      usedQuestions.clear();
      _generateNewQuestion();
      return;
    }

    currentQuestion =
        availableQuestions[Random().nextInt(availableQuestions.length)];
    usedQuestions.add(currentQuestion);
    correctAnswer = kanaMap[currentQuestion];

    // Get all possible wrong answers first
    List<String> possibleWrongAnswers = quizCharacters
        .where((char) => char != currentQuestion)
        .map((char) => kanaMap[char]!)
        .toList();

    // Shuffle the wrong answers
    possibleWrongAnswers.shuffle();

    // Take up to 3 wrong answers (or less if not available)
    int wrongAnswersNeeded = min(3, possibleWrongAnswers.length);
    Set<String> wrongAnswers =
        possibleWrongAnswers.take(wrongAnswersNeeded).toSet();

    // If we still don't have enough options, we'll just use what we have
    choices = [correctAnswer!, ...wrongAnswers];

    // Ensure we have at least 2 choices (correct + 1 wrong)
    if (choices.length < 2 && quizCharacters.length >= 2) {
      // This handles edge cases where we might have only 1 character somehow
      final extraChar = quizCharacters.firstWhere(
          (char) => char != currentQuestion,
          orElse: () => currentQuestion);
      choices.add(kanaMap[extraChar]!);
    }

    choices.shuffle();
    setState(() {});
  }

  void _handleAnswer(String answer) {
    setState(() {
      isAnswered = true;
      selectedAnswer = answer;
      if (answer == correctAnswer) {
        score++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      questionCount++;
      if (questionCount >= widget.totalQuestions) {
        _showResult();
      } else {
        _generateNewQuestion();
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed'),
        content: Text('Your score: $score / ${widget.totalQuestions}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _getButtonColor(String choice) {
    if (!isAnswered) return Colors.blue;
    if (choice == correctAnswer) return Colors.green;
    if (choice == selectedAnswer && choice != correctAnswer) return Colors.red;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.quizType[0].toUpperCase()} Quiz'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (questionCount + 1) / widget.totalQuestions,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
              minHeight: 10,
            ),
            const SizedBox(height: 20),
            Text(
              'Question ${questionCount + 1} of ${widget.totalQuestions}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'What is the reading/meaning of:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion,
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ...choices.map((choice) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(choice),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isAnswered ? null : () => _handleAnswer(choice),
                    child: Text(
                      choice,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            Text(
              'Score: $score / $questionCount',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
