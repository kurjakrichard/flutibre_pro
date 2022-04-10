import 'package:flutter/material.dart';
import 'database_handler.dart';
import 'book.dart';

final handler = DatabaseHandler();

class BookProvider with ChangeNotifier {
  Book? _book;
  Book? get book => _book;

  void addingBook(Book book) {
    _book = book;

    notifyListeners();
  }
}
