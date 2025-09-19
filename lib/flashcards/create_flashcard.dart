import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CreateFlashcardPage extends StatefulWidget {
  const CreateFlashcardPage({super.key});

  @override
  State<CreateFlashcardPage> createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kanjiController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _readingController = TextEditingController();

  bool _storagePermission = false;

  @override
  void initState() {
    super.initState();
    _checkStoragePermission();
  }

  void _checkStoragePermission() async {
    // In a real app, you would check for storage permissions here
    // For this example, we'll simulate it
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _storagePermission = true;
    });
  }

  void _requestStoragePermission() async {
    // In a real app, you would request storage permissions here
    // For this example, we'll simulate it
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Requesting storage permission...")),
    );

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _storagePermission = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Storage permission granted!")),
    );
  }

  void _saveFlashcard() async {
    if (_formKey.currentState!.validate() && _storagePermission) {
      final newCard = {
        'kanji': _kanjiController.text,
        'meaning': _meaningController.text,
        'reading': _readingController.text,
      };

      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      final String? existingCardsJson = prefs.getString('customFlashcards');
      List<dynamic> customCards = [];

      if (existingCardsJson != null) {
        customCards = json.decode(existingCardsJson);
      }

      customCards.add(newCard);
      await prefs.setString('customFlashcards', json.encode(customCards));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Flashcard saved successfully!")),
      );

      // Clear the form
      _kanjiController.clear();
      _meaningController.clear();
      _readingController.clear();
    } else if (!_storagePermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please grant storage permission first")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Custom Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!_storagePermission) ...[
                Card(
                  color: Colors.amber.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.storage, size: 40),
                        const SizedBox(height: 10),
                        const Text(
                          'Storage Permission Required',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'This app needs permission to save flashcards to your device',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _requestStoragePermission,
                          child: const Text('Grant Permission'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              TextFormField(
                controller: _kanjiController,
                decoration: const InputDecoration(
                  labelText: 'Kanji Character',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a kanji character';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _meaningController,
                decoration: const InputDecoration(
                  labelText: 'Meaning',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the meaning';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _readingController,
                decoration: const InputDecoration(
                  labelText: 'Reading (Hiragana)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reading';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveFlashcard,
                child: const Text('Save Flashcard'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
