// lib/kanji_data.dart

import 'dart:math';

// Add these functions to shuffle your kanji lists
List<Map<String, String>> getShuffledN5Kanji() =>
    List.from(n5KanjiList)..shuffle(_random);
List<Map<String, String>> getShuffledN4Kanji() =>
    List.from(n4KanjiList)..shuffle(_random);
List<Map<String, String>> getShuffledAllKanji() {
  return [
    ...getShuffledN5Kanji(),
    ...getShuffledN4Kanji(),
  ]..shuffle(_random);
}

// Shuffled quiz versions
List<Map<String, dynamic>> getShuffledN5KanjiQuiz() =>
    List.from(n5KanjiQuiz)..shuffle(_random);
List<Map<String, dynamic>> getShuffledN4KanjiQuiz() =>
    List.from(n4KanjiQuiz)..shuffle(_random);

final Random _random = Random();

/// JLPT N5 Kanji Quiz
final List<Map<String, dynamic>> n5KanjiQuiz = _generateQuiz(
  n5KanjiList,
);

/// JLPT N4 Kanji Quiz
final List<Map<String, dynamic>> n4KanjiQuiz = _generateQuiz(
  n4KanjiList,
);

List<Map<String, dynamic>> _generateQuiz(List<Map<String, String>> kanjiList) {
  List<String> allMeanings = kanjiList.map((e) => e['meaning']!).toList();
  List<Map<String, dynamic>> quiz = [];

  for (var kanji in kanjiList) {
    String correct = kanji['meaning']!;
    // pick 3 random distractors excluding the correct answer
    List<String> distractors = [];
    List<String> tempMeanings = List.from(allMeanings)..remove(correct);

    while (distractors.length < 3) {
      String choice = tempMeanings[_random.nextInt(tempMeanings.length)];
      if (!distractors.contains(choice)) distractors.add(choice);
    }

    List<String> options = List.from(distractors)..add(correct);
    options.shuffle(_random);

    quiz.add({
      'kanji': kanji['kanji']!,
      'answer': correct,
      'options': options,
    });
  }

  return quiz;
}

/// JLPT N5 Kanji List (~100)
final List<Map<String, String>> n5KanjiList = [
  {"kanji": "日", "meaning": "day"},
  {"kanji": "一", "meaning": "one"},
  {"kanji": "国", "meaning": "country"},
  {"kanji": "人", "meaning": "person"},
  {"kanji": "年", "meaning": "year"},
  {"kanji": "大", "meaning": "big"},
  {"kanji": "十", "meaning": "ten"},
  {"kanji": "二", "meaning": "two"},
  {"kanji": "本", "meaning": "book"},
  {"kanji": "中", "meaning": "middle"},
  {"kanji": "長", "meaning": "long"},
  {"kanji": "出", "meaning": "exit"},
  {"kanji": "三", "meaning": "three"},
  {"kanji": "時", "meaning": "time"},
  {"kanji": "行", "meaning": "go"},
  {"kanji": "見", "meaning": "see"},
  {"kanji": "月", "meaning": "month"},
  {"kanji": "分", "meaning": "part"},
  {"kanji": "後", "meaning": "after"},
  {"kanji": "前", "meaning": "before"},
  {"kanji": "生", "meaning": "life"},
  {"kanji": "五", "meaning": "five"},
  {"kanji": "間", "meaning": "interval"},
  {"kanji": "上", "meaning": "up"},
  {"kanji": "東", "meaning": "east"},
  {"kanji": "四", "meaning": "four"},
  {"kanji": "今", "meaning": "now"},
  {"kanji": "金", "meaning": "gold"},
  {"kanji": "九", "meaning": "nine"},
  {"kanji": "入", "meaning": "enter"},
  {"kanji": "学", "meaning": "study"},
  {"kanji": "高", "meaning": "high"},
  {"kanji": "円", "meaning": "circle"},
  {"kanji": "子", "meaning": "child"},
  {"kanji": "外", "meaning": "outside"},
  {"kanji": "八", "meaning": "eight"},
  {"kanji": "六", "meaning": "six"},
  {"kanji": "下", "meaning": "down, below"},
  {"kanji": "来", "meaning": "come"},
  {"kanji": "気", "meaning": "spirit"},
  {"kanji": "小", "meaning": "small"},
  {"kanji": "七", "meaning": "seven"},
  {"kanji": "山", "meaning": "mountain"},
  {"kanji": "話", "meaning": "talk"},
  {"kanji": "女", "meaning": "woman"},
  {"kanji": "北", "meaning": "north"},
  {"kanji": "午", "meaning": "noon"},
  {"kanji": "百", "meaning": "hundred"},
  {"kanji": "書", "meaning": "write"},
  {"kanji": "先", "meaning": "before"},
  {"kanji": "名", "meaning": "name"},
  {"kanji": "川", "meaning": "river"},
  {"kanji": "千", "meaning": "thousand"},
  {"kanji": "水", "meaning": "water"},
  {"kanji": "半", "meaning": "half"},
  {"kanji": "男", "meaning": "man"},
  {"kanji": "西", "meaning": "west"},
  {"kanji": "電", "meaning": "electricity"},
  {"kanji": "校", "meaning": "school"},
  {"kanji": "語", "meaning": "language"},
  {"kanji": "土", "meaning": "earth"},
  {"kanji": "木", "meaning": "tree"},
  {"kanji": "聞", "meaning": "hear"},
  {"kanji": "食", "meaning": "eat"},
  {"kanji": "車", "meaning": "car"},
  {"kanji": "何", "meaning": "what"},
  {"kanji": "南", "meaning": "south"},
  {"kanji": "万", "meaning": "ten thousand"},
  {"kanji": "毎", "meaning": "every"},
  {"kanji": "白", "meaning": "white"},
  {"kanji": "天", "meaning": "heaven"},
  {"kanji": "母", "meaning": "mother"},
  {"kanji": "火", "meaning": "fire"},
  {"kanji": "右", "meaning": "right"},
  {"kanji": "読", "meaning": "read"},
  {"kanji": "友", "meaning": "friend"},
  {"kanji": "左", "meaning": "left"},
  {"kanji": "休", "meaning": "rest"},
  {"kanji": "父", "meaning": "father"},
  {"kanji": "雨", "meaning": "rain"}
];

/// JLPT N4 Kanji List (~170)
final List<Map<String, String>> n4KanjiList = [
  {"kanji": "会", "meaning": "meet"},
  {"kanji": "同", "meaning": "same"},
  {"kanji": "事", "meaning": "thing"},
  {"kanji": "自", "meaning": "oneself"},
  {"kanji": "社", "meaning": "company"},
  {"kanji": "発", "meaning": "departure"},
  {"kanji": "者", "meaning": "person"},
  {"kanji": "地", "meaning": "ground"},
  {"kanji": "業", "meaning": "business"},
  {"kanji": "方", "meaning": "direction"},
  {"kanji": "新", "meaning": "new"},
  {"kanji": "場", "meaning": "place"},
  {"kanji": "員", "meaning": "employee"},
  {"kanji": "立", "meaning": "stand"},
  {"kanji": "開", "meaning": "open"},
  {"kanji": "手", "meaning": "hand"},
  {"kanji": "力", "meaning": "power"},
  {"kanji": "問", "meaning": "question"},
  {"kanji": "代", "meaning": "substitute"},
  {"kanji": "明", "meaning": "bright"},
  {"kanji": "動", "meaning": "move"},
  {"kanji": "京", "meaning": "capital"},
  {"kanji": "目", "meaning": "eye"},
  {"kanji": "通", "meaning": "pass through"},
  {"kanji": "言", "meaning": "say"},
  {"kanji": "理", "meaning": "reason"},
  {"kanji": "体", "meaning": "body"},
  {"kanji": "田", "meaning": "rice field"},
  {"kanji": "主", "meaning": "main"},
  {"kanji": "題", "meaning": "topic"},
  {"kanji": "意", "meaning": "idea"},
  {"kanji": "不", "meaning": "negative"},
  {"kanji": "作", "meaning": "make"},
  {"kanji": "用", "meaning": "use"},
  {"kanji": "度", "meaning": "degree"},
  {"kanji": "強", "meaning": "strong"},
  {"kanji": "公", "meaning": "public"},
  {"kanji": "持", "meaning": "hold"},
  {"kanji": "野", "meaning": "field"},
  {"kanji": "以", "meaning": "by means of"},
  {"kanji": "思", "meaning": "think"},
  {"kanji": "家", "meaning": "house"},
  {"kanji": "世", "meaning": "world"},
  {"kanji": "多", "meaning": "many"},
  {"kanji": "正", "meaning": "correct"},
  {"kanji": "安", "meaning": "safe"},
  {"kanji": "院", "meaning": "institution"},
  {"kanji": "心", "meaning": "heart"},
  {"kanji": "界", "meaning": "world"},
  {"kanji": "教", "meaning": "teach"},
  {"kanji": "文", "meaning": "sentence"},
  {"kanji": "元", "meaning": "origin"},
  {"kanji": "重", "meaning": "heavy"},
  {"kanji": "近", "meaning": "near"},
  {"kanji": "考", "meaning": "consider"},
  {"kanji": "画", "meaning": "picture"},
  {"kanji": "海", "meaning": "sea"},
  {"kanji": "売", "meaning": "sell"},
  {"kanji": "知", "meaning": "know"},
  {"kanji": "道", "meaning": "road"},
  {"kanji": "集", "meaning": "gather"},
  {"kanji": "別", "meaning": "separate"},
  {"kanji": "物", "meaning": "thing"},
  {"kanji": "使", "meaning": "use"},
  {"kanji": "品", "meaning": "goods"},
  {"kanji": "計", "meaning": "plan"},
  {"kanji": "死", "meaning": "death"},
  {"kanji": "特", "meaning": "special"},
  {"kanji": "私", "meaning": "private"},
  {"kanji": "始", "meaning": "begin"},
  {"kanji": "朝", "meaning": "morning"},
  {"kanji": "運", "meaning": "carry"},
  {"kanji": "終", "meaning": "end"},
  {"kanji": "台", "meaning": "stand"},
  {"kanji": "広", "meaning": "wide"},
  {"kanji": "住", "meaning": "live"},
  {"kanji": "無", "meaning": "nothing"},
  {"kanji": "真", "meaning": "true"},
  {"kanji": "有", "meaning": "have"},
  {"kanji": "口", "meaning": "mouth"},
  {"kanji": "少", "meaning": "few"},
  {"kanji": "町", "meaning": "town"},
  {"kanji": "料", "meaning": "fee"},
  {"kanji": "工", "meaning": "craft"},
  {"kanji": "建", "meaning": "build"},
  {"kanji": "空", "meaning": "sky"},
  {"kanji": "急", "meaning": "hurry"},
  {"kanji": "止", "meaning": "stop"},
  {"kanji": "送", "meaning": "send"},
  {"kanji": "切", "meaning": "cut"},
  {"kanji": "転", "meaning": "turn"},
  {"kanji": "研", "meaning": "study"},
  {"kanji": "足", "meaning": "foot"},
  {"kanji": "究", "meaning": "research"},
  {"kanji": "楽", "meaning": "music"},
  {"kanji": "起", "meaning": "wake up"},
  {"kanji": "着", "meaning": "arrive"},
  {"kanji": "店", "meaning": "store"},
  {"kanji": "病", "meaning": "ill"},
  {"kanji": "質", "meaning": "quality"},
  {"kanji": "待", "meaning": "wait"},
  {"kanji": "試", "meaning": "test"},
  {"kanji": "族", "meaning": "family"},
  {"kanji": "銀", "meaning": "silver"},
  {"kanji": "早", "meaning": "early"},
  {"kanji": "映", "meaning": "reflect"},
  {"kanji": "親", "meaning": "parent"},
  {"kanji": "験", "meaning": "test"},
  {"kanji": "英", "meaning": "England"},
  {"kanji": "医", "meaning": "doctor"},
  {"kanji": "仕", "meaning": "serve"},
  {"kanji": "去", "meaning": "gone"},
  {"kanji": "味", "meaning": "taste"},
  {"kanji": "写", "meaning": "copy"},
  {"kanji": "字", "meaning": "character"},
  {"kanji": "答", "meaning": "answer"},
  {"kanji": "夜", "meaning": "night"},
  {"kanji": "音", "meaning": "sound"},
  {"kanji": "注", "meaning": "pour"},
  {"kanji": "帰", "meaning": "return"},
  {"kanji": "古", "meaning": "old"},
  {"kanji": "歌", "meaning": "song"},
  {"kanji": "買", "meaning": "buy"},
  {"kanji": "悪", "meaning": "bad"},
  {"kanji": "図", "meaning": "map"},
  {"kanji": "週", "meaning": "week"},
  {"kanji": "室", "meaning": "room"},
  {"kanji": "歩", "meaning": "walk"},
  {"kanji": "風", "meaning": "wind"},
  {"kanji": "紙", "meaning": "paper"},
  {"kanji": "黒", "meaning": "black"},
  {"kanji": "花", "meaning": "flower"},
  {"kanji": "春", "meaning": "spring"},
  {"kanji": "赤", "meaning": "red"},
  {"kanji": "青", "meaning": "blue"},
  {"kanji": "館", "meaning": "building"},
  {"kanji": "屋", "meaning": "house"},
  {"kanji": "色", "meaning": "color"},
  {"kanji": "走", "meaning": "run"},
  {"kanji": "秋", "meaning": "autumn"},
  {"kanji": "夏", "meaning": "summer"},
  {"kanji": "習", "meaning": "learn"},
  {"kanji": "駅", "meaning": "station"},
  {"kanji": "洋", "meaning": "ocean"},
  {"kanji": "旅", "meaning": "trip"},
  {"kanji": "服", "meaning": "clothing"},
  {"kanji": "夕", "meaning": "evening"},
  {"kanji": "借", "meaning": "borrow"},
  {"kanji": "曜", "meaning": "weekday"},
  {"kanji": "飲", "meaning": "drink"},
  {"kanji": "肉", "meaning": "meat"},
  {"kanji": "貸", "meaning": "lend"},
  {"kanji": "堂", "meaning": "hall"},
  {"kanji": "鳥", "meaning": "bird"},
  {"kanji": "飯", "meaning": "meal"},
  {"kanji": "勉", "meaning": "effort"},
  {"kanji": "冬", "meaning": "winter"},
  {"kanji": "昼", "meaning": "noon"},
  {"kanji": "茶", "meaning": "tea"},
  {"kanji": "弟", "meaning": "younger brother"},
  {"kanji": "牛", "meaning": "cow"},
  {"kanji": "魚", "meaning": "fish"},
  {"kanji": "兄", "meaning": "elder brother"},
  {"kanji": "犬", "meaning": "dog"},
  {"kanji": "妹", "meaning": "younger sister"},
  {"kanji": "姉", "meaning": "elder sister"},
  {"kanji": "漢", "meaning": "China"}
];
