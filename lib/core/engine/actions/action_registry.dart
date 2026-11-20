import 'package:flutter/material.dart';

class ActionRegistry {
  static late BuildContext _context;

  static void init(BuildContext context) {
    _context = context;
  }

  static void handle(Map<String, dynamic>? action) {
    if (action == null) return;

    switch (action['type']) {
      case 'navigate':
        Navigator.pushNamed(_context, action['route']);
        break;

      case 'show_snackbar':
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(content: Text(action['message'] ?? '')),
        );
        break;
    }
  }
}