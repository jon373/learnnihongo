import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FlashcardStorage {
  static const String customFlashcardsKey = 'customFlashcards';

  // Save a flashcard to local storage
  static Future<void> saveFlashcard(Map<String, String> flashcard) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingCardsJson = prefs.getString(customFlashcardsKey);
    List<dynamic> customCards = [];

    if (existingCardsJson != null) {
      customCards = json.decode(existingCardsJson);
    }

    customCards.add(flashcard);
    await prefs.setString(customFlashcardsKey, json.encode(customCards));
  }

  // Get all custom flashcards from local storage
  static Future<List<Map<String, String>>> getCustomFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? customCardsJson = prefs.getString(customFlashcardsKey);

    if (customCardsJson != null) {
      final List<dynamic> customCards = json.decode(customCardsJson);
      return customCards.map<Map<String, String>>((item) {
        return {
          'kanji': item['kanji'] ?? '',
          'meaning': item['meaning'] ?? '',
          'reading': item['reading'] ?? '',
        };
      }).toList();
    }

    return [];
  }

  // Clear all custom flashcards
  static Future<void> clearAllFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(customFlashcardsKey);
  }
}
