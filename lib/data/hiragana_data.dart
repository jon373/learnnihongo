import 'dart:math';

final Random _random = Random();

// Hiragana characters data
List<Map<String, String>> hiraganaList = [
  // Basic Hiragana
  {'character': 'あ', 'reading': 'a', 'meaning': 'a'},
  {'character': 'い', 'reading': 'i', 'meaning': 'i'},
  {'character': 'う', 'reading': 'u', 'meaning': 'u'},
  {'character': 'え', 'reading': 'e', 'meaning': 'e'},
  {'character': 'お', 'reading': 'o', 'meaning': 'o'},

  {'character': 'か', 'reading': 'ka', 'meaning': 'ka'},
  {'character': 'き', 'reading': 'ki', 'meaning': 'ki'},
  {'character': 'く', 'reading': 'ku', 'meaning': 'ku'},
  {'character': 'け', 'reading': 'ke', 'meaning': 'ke'},
  {'character': 'こ', 'reading': 'ko', 'meaning': 'ko'},

  {'character': 'さ', 'reading': 'sa', 'meaning': 'sa'},
  {'character': 'し', 'reading': 'shi', 'meaning': 'shi'},
  {'character': 'す', 'reading': 'su', 'meaning': 'su'},
  {'character': 'せ', 'reading': 'se', 'meaning': 'se'},
  {'character': 'そ', 'reading': 'so', 'meaning': 'so'},

  {'character': 'た', 'reading': 'ta', 'meaning': 'ta'},
  {'character': 'ち', 'reading': 'chi', 'meaning': 'chi'},
  {'character': 'つ', 'reading': 'tsu', 'meaning': 'tsu'},
  {'character': 'て', 'reading': 'te', 'meaning': 'te'},
  {'character': 'と', 'reading': 'to', 'meaning': 'to'},

  {'character': 'な', 'reading': 'na', 'meaning': 'na'},
  {'character': 'に', 'reading': 'ni', 'meaning': 'ni'},
  {'character': 'ぬ', 'reading': 'nu', 'meaning': 'nu'},
  {'character': 'ね', 'reading': 'ne', 'meaning': 'ne'},
  {'character': 'の', 'reading': 'no', 'meaning': 'no'},

  {'character': 'は', 'reading': 'ha', 'meaning': 'ha'},
  {'character': 'ひ', 'reading': 'hi', 'meaning': 'hi'},
  {'character': 'ふ', 'reading': 'fu', 'meaning': 'fu'},
  {'character': 'へ', 'reading': 'he', 'meaning': 'he'},
  {'character': 'ほ', 'reading': 'ho', 'meaning': 'ho'},

  {'character': 'ま', 'reading': 'ma', 'meaning': 'ma'},
  {'character': 'み', 'reading': 'mi', 'meaning': 'mi'},
  {'character': 'む', 'reading': 'mu', 'meaning': 'mu'},
  {'character': 'め', 'reading': 'me', 'meaning': 'me'},
  {'character': 'も', 'reading': 'mo', 'meaning': 'mo'},

  {'character': 'や', 'reading': 'ya', 'meaning': 'ya'},
  {'character': 'ゆ', 'reading': 'yu', 'meaning': 'yu'},
  {'character': 'よ', 'reading': 'yo', 'meaning': 'yo'},

  {'character': 'ら', 'reading': 'ra', 'meaning': 'ra'},
  {'character': 'り', 'reading': 'ri', 'meaning': 'ri'},
  {'character': 'る', 'reading': 'ru', 'meaning': 'ru'},
  {'character': 'れ', 'reading': 're', 'meaning': 're'},
  {'character': 'ろ', 'reading': 'ro', 'meaning': 'ro'},

  {'character': 'わ', 'reading': 'wa', 'meaning': 'wa'},
  {'character': 'を', 'reading': 'wo', 'meaning': 'wo'},
  {'character': 'ん', 'reading': 'n', 'meaning': 'n'},

  // Dakuten (voiced) Hiragana
  {'character': 'が', 'reading': 'ga', 'meaning': 'ga'},
  {'character': 'ぎ', 'reading': 'gi', 'meaning': 'gi'},
  {'character': 'ぐ', 'reading': 'gu', 'meaning': 'gu'},
  {'character': 'げ', 'reading': 'ge', 'meaning': 'ge'},
  {'character': 'ご', 'reading': 'go', 'meaning': 'go'},

  {'character': 'ざ', 'reading': 'za', 'meaning': 'za'},
  {'character': 'じ', 'reading': 'ji', 'meaning': 'ji'},
  {'character': 'ず', 'reading': 'zu', 'meaning': 'zu'},
  {'character': 'ぜ', 'reading': 'ze', 'meaning': 'ze'},
  {'character': 'ぞ', 'reading': 'zo', 'meaning': 'zo'},

  {'character': 'だ', 'reading': 'da', 'meaning': 'da'},
  {'character': 'ぢ', 'reading': 'ji', 'meaning': 'ji'},
  {'character': 'づ', 'reading': 'zu', 'meaning': 'zu'},
  {'character': 'で', 'reading': 'de', 'meaning': 'de'},
  {'character': 'ど', 'reading': 'do', 'meaning': 'do'},

  {'character': 'ば', 'reading': 'ba', 'meaning': 'ba'},
  {'character': 'び', 'reading': 'bi', 'meaning': 'bi'},
  {'character': 'ぶ', 'reading': 'bu', 'meaning': 'bu'},
  {'character': 'べ', 'reading': 'be', 'meaning': 'be'},
  {'character': 'ぼ', 'reading': 'bo', 'meaning': 'bo'},

  {'character': 'ぱ', 'reading': 'pa', 'meaning': 'pa'},
  {'character': 'ぴ', 'reading': 'pi', 'meaning': 'pi'},
  {'character': 'ぷ', 'reading': 'pu', 'meaning': 'pu'},
  {'character': 'ぺ', 'reading': 'pe', 'meaning': 'pe'},
  {'character': 'ぽ', 'reading': 'po', 'meaning': 'po'},

  // Youon (contracted) Hiragana
  {'character': 'きゃ', 'reading': 'kya', 'meaning': 'kya'},
  {'character': 'きゅ', 'reading': 'kyu', 'meaning': 'kyu'},
  {'character': 'きょ', 'reading': 'kyo', 'meaning': 'kyo'},

  {'character': 'しゃ', 'reading': 'sha', 'meaning': 'sha'},
  {'character': 'しゅ', 'reading': 'shu', 'meaning': 'shu'},
  {'character': 'しょ', 'reading': 'sho', 'meaning': 'sho'},

  {'character': 'ちゃ', 'reading': 'cha', 'meaning': 'cha'},
  {'character': 'ちゅ', 'reading': 'chu', 'meaning': 'chu'},
  {'character': 'ちょ', 'reading': 'cho', 'meaning': 'cho'},

  {'character': 'にゃ', 'reading': 'nya', 'meaning': 'nya'},
  {'character': 'にゅ', 'reading': 'nyu', 'meaning': 'nyu'},
  {'character': 'にょ', 'reading': 'nyo', 'meaning': 'nyo'},

  {'character': 'ひゃ', 'reading': 'hya', 'meaning': 'hya'},
  {'character': 'ひゅ', 'reading': 'hyu', 'meaning': 'hyu'},
  {'character': 'ひょ', 'reading': 'hyo', 'meaning': 'hyo'},

  {'character': 'みゃ', 'reading': 'mya', 'meaning': 'mya'},
  {'character': 'みゅ', 'reading': 'myu', 'meaning': 'myu'},
  {'character': 'みょ', 'reading': 'myo', 'meaning': 'myo'},

  {'character': 'りゃ', 'reading': 'rya', 'meaning': 'rya'},
  {'character': 'りゅ', 'reading': 'ryu', 'meaning': 'ryu'},
  {'character': 'りょ', 'reading': 'ryo', 'meaning': 'ryo'},

  {'character': 'ぎゃ', 'reading': 'gya', 'meaning': 'gya'},
  {'character': 'ぎゅ', 'reading': 'gyu', 'meaning': 'gyu'},
  {'character': 'ぎょ', 'reading': 'gyo', 'meaning': 'gyo'},

  {'character': 'じゃ', 'reading': 'ja', 'meaning': 'ja'},
  {'character': 'じゅ', 'reading': 'ju', 'meaning': 'ju'},
  {'character': 'じょ', 'reading': 'jo', 'meaning': 'jo'},

  {'character': 'びゃ', 'reading': 'bya', 'meaning': 'bya'},
  {'character': 'びゅ', 'reading': 'byu', 'meaning': 'byu'},
  {'character': 'びょ', 'reading': 'byo', 'meaning': 'byo'},

  {'character': 'ぴゃ', 'reading': 'pya', 'meaning': 'pya'},
  {'character': 'ぴゅ', 'reading': 'pyu', 'meaning': 'pyu'},
  {'character': 'ぴょ', 'reading': 'pyo', 'meaning': 'pyo'},
];

// Shuffle function
List<Map<String, String>> getShuffledHiragana() =>
    List.from(hiraganaList)..shuffle(_random);
