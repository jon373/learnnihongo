import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nihongo_app/utils/storage_permission.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

class CustomFoldersPage extends StatefulWidget {
  const CustomFoldersPage({super.key});

  @override
  State<CustomFoldersPage> createState() => _CustomFoldersPageState();
}

class _CustomFoldersPageState extends State<CustomFoldersPage> {
  List<Map<String, dynamic>> folders = [];
  final TextEditingController _folderNameController = TextEditingController();
  bool _storagePermission = false;
  bool _isLoading = true;
  String? _selectedFolderPath;

  @override
  void initState() {
    super.initState();
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    // Check if already granted
    var status = await Permission.storage.status;

    // Load saved folder path
    final prefs = await SharedPreferences.getInstance();
    _selectedFolderPath = prefs.getString('flashcardFolder');

    setState(() {
      _storagePermission = status.isGranted;
      _isLoading = false;
    });

    if (status.isGranted && _selectedFolderPath != null) {
      _loadFolders();
    }
  }

  Future<File> _getFlashcardFile() async {
    if (_selectedFolderPath != null) {
      final file = File('$_selectedFolderPath/custom_flashcards.json');
      if (!file.existsSync()) {
        await file.create(recursive: true);
      }
      return file;
    } else {
      // fallback: use app documents dir
      final appDir = await getApplicationDocumentsDirectory();
      return File('${appDir.path}/custom_flashcards.json');
    }
  }

  Future<void> _saveFolders() async {
    final file = await _getFlashcardFile();
    await file.writeAsString(json.encode(folders));
  }

  Future<void> _loadFolders() async {
    try {
      final file = await _getFlashcardFile();
      if (file.existsSync()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final List<dynamic> loadedFolders = json.decode(content);
          setState(() {
            folders = loadedFolders.map<Map<String, dynamic>>((folder) {
              return {
                'name': folder['name'],
                'cards': List<Map<String, String>>.from(folder['cards']),
              };
            }).toList();
          });
        }
      }
    } catch (e) {
      print('Error loading folders: $e');
      // If loading fails, start with empty folders
      setState(() {
        folders = [];
      });
    }
  }

  Future<void> _requestStoragePermission() async {
    setState(() {
      _isLoading = true;
    });

    // First request storage permission
    bool granted = await StoragePermission.requestPermission();

    if (granted) {
      // Now open folder picker
      await _pickFolder();
    } else {
      setState(() {
        _storagePermission = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Storage permission is required to save flashcards"),
        ),
      );
    }
  }

  Future<void> _pickFolder() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select folder to save flashcards',
      );

      if (selectedDirectory != null && selectedDirectory.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('flashcardFolder', selectedDirectory);

        setState(() {
          _selectedFolderPath = selectedDirectory;
          _storagePermission = true;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Flashcards will be stored in: $selectedDirectory"),
            duration: const Duration(seconds: 3),
          ),
        );

        // Load folders from the new location
        await _loadFolders();
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No folder selected.")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting folder: $e")),
      );
    }
  }

  void _showCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Folder'),
          content: TextField(
            controller: _folderNameController,
            decoration: const InputDecoration(
              hintText: 'Enter folder name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_folderNameController.text.isNotEmpty) {
                  setState(() {
                    folders.add({
                      'name': _folderNameController.text,
                      'cards': [],
                    });
                  });
                  _saveFolders();
                  _folderNameController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToFolder(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomFlashcardsPage(
          folderIndex: index,
          folderName: folders[index]['name'],
          cards: List<Map<String, String>>.from(folders[index]['cards']),
          onUpdate: (updatedCards) {
            setState(() {
              folders[index]['cards'] = updatedCards;
            });
            _saveFolders();
          },
        ),
      ),
    );
  }

  void _deleteFolder(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Folder'),
          content: Text(
              'Are you sure you want to delete "${folders[index]['name']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  folders.removeAt(index);
                });
                _saveFolders();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Flashcards'),
        actions: _storagePermission && _selectedFolderPath != null
            ? [
                IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: _pickFolder,
                  tooltip: 'Change storage location',
                ),
              ]
            : null,
      ),
      body: !_storagePermission || _selectedFolderPath == null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.storage, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      "Select Storage Location",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Please choose where you want to save your flashcards on your device",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _requestStoragePermission,
                      child: const Text('Choose Storage Location'),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedFolderPath != null)
                      Text(
                        'Current location: $_selectedFolderPath',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.folder, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Storage Location",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _selectedFolderPath!,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: _pickFolder,
                            tooltip: 'Change location',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showCreateFolderDialog,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.create_new_folder),
                        SizedBox(width: 8),
                        Text('Create New Folder'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: folders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.folder_open,
                                    size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                const Text(
                                  "No flashcard folders yet",
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Create a folder to start adding your custom flashcards",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: folders.length,
                            itemBuilder: (context, index) {
                              final folder = folders[index];
                              final cardCount = folder['cards'].length;

                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.folder),
                                  title: Text(folder['name']),
                                  subtitle: Text(
                                      '$cardCount card${cardCount != 1 ? 's' : ''}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _deleteFolder(index),
                                  ),
                                  onTap: () => _navigateToFolder(index),
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

class CustomFlashcardsPage extends StatefulWidget {
  final int folderIndex;
  final String folderName;
  final List<Map<String, String>> cards;
  final Function(List<Map<String, String>>) onUpdate;

  const CustomFlashcardsPage({
    super.key,
    required this.folderIndex,
    required this.folderName,
    required this.cards,
    required this.onUpdate,
  });

  @override
  State<CustomFlashcardsPage> createState() => _CustomFlashcardsPageState();
}

class _CustomFlashcardsPageState extends State<CustomFlashcardsPage> {
  late List<Map<String, String>> cards;
  int currentIndex = 0;
  bool showMeaning = false;
  final TextEditingController _kanjiController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _readingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cards = widget.cards;
  }

  void _nextCard() {
    setState(() {
      if (currentIndex < cards.length - 1) {
        currentIndex++;
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

  void _showAddCardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Flashcard'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _kanjiController,
                  decoration: const InputDecoration(
                    labelText: 'Character/Word',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _readingController,
                  decoration: const InputDecoration(
                    labelText: 'Reading (Hiragana/Romaji)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _meaningController,
                  decoration: const InputDecoration(
                    labelText: 'Meaning',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_kanjiController.text.isNotEmpty &&
                    _meaningController.text.isNotEmpty) {
                  setState(() {
                    cards.add({
                      'kanji': _kanjiController.text,
                      'reading': _readingController.text,
                      'meaning': _meaningController.text,
                    });
                  });
                  widget.onUpdate(cards);

                  _kanjiController.clear();
                  _readingController.clear();
                  _meaningController.clear();

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Flashcard added!")),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCard(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Flashcard'),
          content:
              const Text('Are you sure you want to delete this flashcard?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cards.removeAt(index);
                  if (currentIndex >= cards.length) {
                    currentIndex = cards.isEmpty ? 0 : cards.length - 1;
                  }
                });
                widget.onUpdate(cards);
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Flashcard deleted")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCardDialog,
            tooltip: 'Add new flashcard',
          ),
        ],
      ),
      body: cards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.note_add, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "No flashcards yet",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Add some flashcards to get started",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _showAddCardDialog,
                    child: const Text('Add First Flashcard'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _flipCard,
                          onLongPress: () => _deleteCard(currentIndex),
                          child: Card(
                            elevation: 6,
                            margin: const EdgeInsets.all(16),
                            child: Container(
                              height: 200,
                              width: 300,
                              alignment: Alignment.center,
                              child: Text(
                                showMeaning
                                    ? cards[currentIndex]['meaning']!
                                    : cards[currentIndex]['kanji']!,
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        if (!showMeaning &&
                            cards[currentIndex]['reading'] != null &&
                            cards[currentIndex]['reading']!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              cards[currentIndex]['reading']!,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _previousCard,
                              child: const Text("Previous"),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: _nextCard,
                              child: const Text("Next"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text("${currentIndex + 1} / ${cards.length}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
