import 'package:flutibre_pro/model/booklist_item.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../repository/database_handler.dart';

class BookListProvider with ChangeNotifier {
  BookListProvider() {
    databaseHandler = DatabaseHandler();
    if (prefs.containsKey("path")) {
      getAllBooks();
    }
  }

  List<String> names = ['Ricsi', 'Dóra', 'Árpád', 'Regina', 'Pálma', 'Pálma'];
  List<BookListItem> _allBooks = [];
  List<BookListItem> _currentBooks = [];
  List<BookListItem> get currentBooks => _currentBooks;
  DatabaseHandler? databaseHandler;

  void filteredBookList([String? stringItem]) async {
    List<BookListItem> filteredBookList = [];

    for (var name in names) {
      if (stringItem == null) {
        _currentBooks = _allBooks;
        return;
      } else {
        if (stringItem == name) {
          filteredBookList.add(BookListItem(name: name));
        }
      }
    }
    _currentBooks = filteredBookList;
    notifyListeners();
  }

  void getAllBooks() async {
    _allBooks.clear();

    _allBooks = await databaseHandler!.getBookList();
    _currentBooks = _allBooks;
    notifyListeners();
  }

  Future<List<BookListItem>> getBookList() async {
    await databaseHandler!.initialDatabase();
    return await databaseHandler!.getBookList();
  }

  void toggleAllBooks() {
    _currentBooks = _allBooks;
    notifyListeners();
  }
}
