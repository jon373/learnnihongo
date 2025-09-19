import 'package:flutter/material.dart';
import 'quiz_page.dart';

class HiraganaQuizPage extends StatelessWidget {
  final List<List<String>> groups = [
    ['あ', 'い', 'う', 'え', 'お'],
    ['か', 'き', 'く', 'け', 'こ'],
    ['さ', 'し', 'す', 'せ', 'そ'],
    ['た', 'ち', 'つ', 'て', 'と'],
    ['な', 'に', 'ぬ', 'ね', 'の'],
    ['は', 'ひ', 'ふ', 'へ', 'ほ'],
    ['ま', 'み', 'む', 'め', 'も'],
    ['や', 'ゆ', 'よ'],
    ['ら', 'り', 'る', 'れ', 'ろ'],
    ['わ', 'を', 'ん'],
    ['が', 'ぎ', 'ぐ', 'げ', 'ご'],
    ['ざ', 'じ', 'ず', 'ぜ', 'ぞ'],
    ['だ', 'ぢ', 'づ', 'で', 'ど'],
    ['ば', 'び', 'ぶ', 'べ', 'ぼ'],
    ['ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ'],
  ];
  final List<String> groupNames = [
    'あ', // a
    'か', // ka
    'さ', // sa
    'た', // ta
    'な', // na
    'は', // ha
    'ま', // ma
    'や', // ya
    'ら', // ra
    'わ', // wa
    'が', // ga
    'ざ', // za
    'だ', // da
    'ば', // ba
    'ぱ', // pa
  ];
  HiraganaQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildGroupSelectionPage(context, 'Hiragana', groups);
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
