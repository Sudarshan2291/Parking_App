import 'package:flutter/material.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return 'Invalid email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password required';
    if (value.length < 6) return 'Minimum 6 characters';
    return null;
  }
}

class Logger {
  static void info(String message) {
    debugPrint('ℹ️ INFO: $message');
  }

  static void error(String message) {
    debugPrint('❌ ERROR: $message');
  }
}
