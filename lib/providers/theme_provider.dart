import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = _lightTheme;
  bool _isDarkMode = false;

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  static final _lightTheme = ThemeData(
    primarySwatch: Colors.cyan,
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Orbitron'),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.cyan,
      secondary: Colors.purpleAccent,
      surface: Colors.white.withOpacity(0.2),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black.withOpacity(0.7),
      foregroundColor: Colors.cyan,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.cyan),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      hintStyle: const TextStyle(color: Colors.cyanAccent),
    ),
  );

  static final _darkTheme = ThemeData(
    primarySwatch: Colors.cyan,
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.cyanAccent, fontFamily: 'Orbitron'),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.cyan,
      secondary: Colors.purpleAccent,
      surface: Colors.black.withOpacity(0.4),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black.withOpacity(0.8),
      foregroundColor: Colors.cyanAccent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.cyan),
      ),
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      hintStyle: const TextStyle(color: Colors.cyanAccent),
    ),
  );

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _currentTheme = _isDarkMode ? _darkTheme : _lightTheme;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? _darkTheme : _lightTheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}