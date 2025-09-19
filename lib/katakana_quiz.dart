import 'package:flutter/material.dart';
import 'quiz_page.dart';

class KatakanaQuizPage extends StatelessWidget {
  final List<List<String>> groups = [
    ['ア', 'イ', 'ウ', 'エ', 'オ'],
    ['カ', 'キ', 'ク', 'ケ', 'コ'],
    ['サ', 'シ', 'ス', 'セ', 'ソ'],
    ['タ', 'チ', 'ツ', 'テ', 'ト'],
    ['ナ', 'ニ', 'ヌ', 'ネ', 'ノ'],
    ['ハ', 'ヒ', 'フ', 'ヘ', 'ホ'],
    ['マ', 'ミ', 'ム', 'メ', 'モ'],
    ['ヤ', 'ユ', 'ヨ'],
    ['ラ', 'リ', 'ル', 'レ', 'ロ'],
    ['ワ', 'ヲ', 'ン'],
    ['ガ', 'ギ', 'グ', 'ゲ', 'ゴ'],
    ['ザ', 'ジ', 'ズ', 'ゼ', 'ゾ'],
    ['ダ', 'ヂ', 'ヅ', 'デ', 'ド'],
    ['バ', 'ビ', 'ブ', 'ベ', 'ボ'],
    ['パ', 'ピ', 'プ', 'ペ', 'ポ'],
  ];
  final List<String> groupNames = [
    'ア', // a
    'カ', // ka
    'サ', // sa
    'タ', // ta
    'ナ', // na
    'ハ', // ha
    'マ', // ma
    'ヤ', // ya
    'ラ', // ra
    'ワ', // wa
    'ガ', // ga
    'ザ', // za
    'ダ', // da
    'バ', // ba
    'パ', // pa
  ];

  KatakanaQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildGroupSelectionPage(context, 'Katakana', groups);
  }

  Widget _buildGroupSelectionPage(
      BuildContext context, String title, List<List<String>> groups) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Groups'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(
                    quizType: [title.toLowerCase()],
                    totalQuestions: groups.expand((g) => g).length,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'All $title',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Or practice by group:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${groupNames[index]}: ', // bold group name
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: groups[index].join(' '), // normal text
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: const Icon(Icons.quiz),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPage(
                            quizType: [title.toLowerCase()],
                            filterCharacters: groups[index],
                            totalQuestions: groups[index].length,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
