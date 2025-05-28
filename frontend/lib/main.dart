import 'dart:async'; // Required for runZonedGuarded
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Error handling with runZonedGuarded
  runZonedGuarded(() {
    runApp(const MoneyTrackerApp());
  }, (error, stackTrace) {
    // Log errors to console (replace with Crashlytics in production)
    debugPrint('⚠️ App Error: $error');
    debugPrint('🔍 Stack Trace: $stackTrace');
  });
}