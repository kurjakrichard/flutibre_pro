import 'package:flutibre/model/booklist_item.dart';
import 'package:flutter/foundation.dart';
import '../model/authors.dart';
import '../model/books.dart';
import '../model/books_authors_link.dart';
import '../model/comments.dart';
import '../repository/database_handler.dart';

class BooksProvider extends ChangeNotifier {
  List<BookListItem> items = [];

  Future<void> selectAll() async {
    var databaseHandler = DatabaseHandler();
    items = await databaseHandler.getBookItemList();

    notifyListeners();
  }

  Future insert(
      {required Books book, required Authors author, Comments? comment}) async {
    var databaseHandler = DatabaseHandler();

    int bookId = await databaseHandler.insert(
      dropTrigger: 'DROP TRIGGER books_insert_trg',
      table: 'books',
      item: book,
      createTrigger: '''CREATE TRIGGER books_insert_trg AFTER INSERT ON books
          BEGIN UPDATE books SET sort=title_sort(NEW.title),uuid=uuid4()
          WHERE id=NEW.id; END''',
    );

    int authorId = await databaseHandler.insert(
      table: 'authors',
      item: author,
    );
    await databaseHandler.insert(
      table: 'books_authors_link',
      item: BooksAuthorsLink(book: bookId, author: authorId),
    );

    selectAll();
    notifyListeners();
  }

  void delete(int id) async {
    var databaseHandler = DatabaseHandler();
    await databaseHandler.delete('books', id);
    selectAll();
    notifyListeners();
  }

  Future update(
      {String? dropTrigger,
      Authors? author,
      required Books book,
      required int id,
      String? createTrigger}) async {
    var databaseHandler = DatabaseHandler();
    databaseHandler.update(table: 'books', id: id, item: book);

    selectAll();
    notifyListeners();
  }
}
