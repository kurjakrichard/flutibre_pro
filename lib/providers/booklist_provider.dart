import 'package:flutibre_pro/model/booklist_item.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class BookListProvider with ChangeNotifier {
  BookListProvider() {
    getBookList();
  }

  final List<BookListItem> _bookList = [];
  final List<BookListItem> _filteredBookList = [];
  // ignore: unnecessary_getters_setters
  List<BookListItem> get filteredBookList => _bookList;

  void getBookList([String? stringItem]) async {
    _bookList.clear();
    List<String> names = ['Ricsi', 'Dóra', 'Árpád', 'Regina', 'Pálma', 'Pálma'];
    for (var name in names) {
      if (stringItem == null) {
        _bookList.add(BookListItem(name: name));
      } else {
        if (stringItem == name) {
          _bookList.add(BookListItem(name: name));
        }

        notifyListeners();
      }
    }
  }
}
