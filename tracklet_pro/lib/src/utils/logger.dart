import 'package:flutter/foundation.dart';

/// A simple logger utility that only prints in debug mode
class Logger {
  static void debug(String message) {
    if (kDebugMode) {
      // In debug mode, print the message
      debugPrint('DEBUG: $message');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('INFO: $message');
    }
  }

  static void error(String message) {
    if (kDebugMode) {
      debugPrint('ERROR: $message');
    }
  }

  static void warn(String message) {
    if (kDebugMode) {
      debugPrint('WARN: $message');
    }
  }
}