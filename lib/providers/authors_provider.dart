import 'package:flutter/foundation.dart';
import '../model/authors.dart';
import '../repository/database_handler.dart';

class AuthorsProvider extends ChangeNotifier {
  List<Authors> items = [];

  Future<void> selectAll() async {
    var databaseHelper = DatabaseHandler();
    final dataList = await databaseHelper.selectAll('authors');
    items = dataList.map((item) => Authors.fromMap(item)).toList();
    notifyListeners();
  }

  Future insert(Authors author) async {
    var databaseHelper = DatabaseHandler();
    databaseHelper.insert('authors', author);
    selectAll();
    notifyListeners();
  }

  void delete(Authors author) async {
    var databaseHelper = DatabaseHandler();
    await databaseHelper.delete('authors', author.id!);
    selectAll();
    notifyListeners();
  }

  Future update(Authors author, int id) async {
    var databaseHelper = DatabaseHandler();
    databaseHelper.update('authors', id, author);
    selectAll();
    notifyListeners();
  }
}
