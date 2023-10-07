import 'package:flutter/foundation.dart';
import '../model/authors.dart';
import '../repository/database_handler.dart';

class AuthorsProvider extends ChangeNotifier {
  List<Authors> items = [];

  Future<void> select() async {
    var databaseHelper = DatabaseHandler();
    final dataList = await databaseHelper.selectAll('authors');
    items = dataList.map((item) => Authors.fromMap(item)).toList();
    notifyListeners();
  }

  Future insert(Authors author) async {
    var databaseHelper = DatabaseHandler();
    items.add(author);
    databaseHelper.insert('authors', author);
    notifyListeners();
  }
}
