import 'package:flutter/material.dart';
import '../main.dart';

class BookListProvider with ChangeNotifier {
  BookListProvider() {
    _loadSettings();
  }

  int _counter = 0;

  // ignore: unnecessary_getters_setters
  int get counter => _counter;

  void _loadSettings() async {
    _counter = prefs.getInt('counter') ?? 0;
    notifyListeners();
  }

  void incrementCounter() async {
    await prefs.setInt('counter', _counter + 1);
    _counter++;
    notifyListeners();
  }

  void reset() async {
    await prefs.setInt('counter', 0);
    _counter = 0;
    notifyListeners();
  }

  void decreaseCounter() async {
    await prefs.setInt('counter', _counter - 1);
    _counter--;
    notifyListeners();
  }
}
