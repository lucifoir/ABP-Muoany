import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class MoneyTrackerApp extends StatelessWidget {
  const MoneyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          elevation: 4,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.white,
          elevation: 8,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      builder: (context, child) {
        return MediaQuery(
          // Updated from textScaleFactor to textScaler
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0), // Fixes deprecated warning
          ),
          child: Scaffold(
            body: SafeArea(
              child: child!,
            ),
          ),
        );
      },
    );
  }
}

// Extension for navigation
extension AppNavigation on BuildContext {
  void navigateTo(Widget screen) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void navigateBack() {
    if (Navigator.canPop(this)) {
      Navigator.pop(this);
    }
  }
}