import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nihongo_app/screens/flashcards_menu.dart';
import 'screens/quiz_selection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  runApp(const NihongoQuizApp());
}

class NihongoQuizApp extends StatelessWidget {
  const NihongoQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nihongo Quiz',
      theme: _buildJapaneseTheme(),
      home: const MainNavigationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

ThemeData _buildJapaneseTheme() {
  const primaryColor = Color(0xFF8B0000); // Deep torii gate red
  const secondaryColor = Color(0xFF0D3B66); // Navy blue
  const accentColor = Color(0xFFD4AF37); // Gold
  const backgroundColor = Color(0xFFFAFAFA); // Off-white
  const surfaceColor = Color(0xFFFFFFFF); // Pure white
  const onPrimaryColor = Color(0xFFFFFFFF); // White text on red
  const onSecondaryColor = Color(0xFFFFFFFF); // White text on blue
  const onBackgroundColor = Color(0xFF2F2F2F); // Dark gray text
  const onSurfaceColor = Color(0xFF2F2F2F); // Dark gray text

  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
      onSecondary: onSecondaryColor,
      tertiary: accentColor,
      error: Colors.red,
      onError: Colors.white,
      background: backgroundColor,
      onBackground: onBackgroundColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
    ),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
      centerTitle: true,
      elevation: 2,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: onBackgroundColor),
      displayMedium: TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold, color: onBackgroundColor),
      displaySmall: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: onBackgroundColor),
      headlineMedium: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: onBackgroundColor),
      headlineSmall: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: onBackgroundColor),
      titleLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: onBackgroundColor),
      bodyLarge: TextStyle(fontSize: 16, color: onBackgroundColor),
      bodyMedium: TextStyle(fontSize: 14, color: onBackgroundColor),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF666666),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 4,
    ),

    // Card Theme
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(color: onBackgroundColor),
    ),

    // Other theme properties
    scaffoldBackgroundColor: backgroundColor,
    dividerColor: primaryColor.withOpacity(0.2),
  );
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    QuizSelectionPage(),
    FlashcardsMenu(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: const Color(0xFF666666),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: "Quiz",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style),
            label: "Flashcards",
          ),
        ],
      ),
    );
  }
}
