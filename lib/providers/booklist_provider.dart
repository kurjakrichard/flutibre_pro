import 'package:flutibre/model/booklist_item.dart';
import 'package:flutibre/model/database_model.dart';
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

    List<DatabaseModel> checkAuthors =
        (await databaseHandler.selectItemsByField(
                table: 'authors',
                type: 'Authors',
                field: 'name',
                searchItem: author.name))
            .cast<Authors>();

    bool authorExist = checkAuthors.isEmpty;

    int authorId = authorExist
        ? await databaseHandler.insert(
            table: 'authors',
            item: author,
          )
        : author.id!;
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

  Future update({
    required Authors author,
    required Books book,
    required int id,
  }) async {
    var databaseHandler = DatabaseHandler();
    databaseHandler.update(
        dropTrigger: 'DROP TRIGGER "main"."books_update_trg"',
        table: 'books',
        id: id,
        item: book,
        createTrigger: '''CREATE TRIGGER books_update_trg AFTER UPDATE ON books 
            BEGIN UPDATE books SET sort=title_sort(NEW.title) 
            WHERE id=NEW.id AND OLD.title NEW.title; END''');

    Authors? checkAuthor = await databaseHandler.selectItemByLink(
        table: 'authors',
        type: 'Authors',
        field: 'name',
        linkTable: 'books_authors_link',
        bookId: book.id!) as Authors?;

    bool authorExist = checkAuthor == null;

    int authorId = authorExist
        ? await databaseHandler.insert(
            table: 'authors',
            item: author,
          )
        : checkAuthor.id!;
    await databaseHandler.insert(
      table: 'books_authors_link',
      item: BooksAuthorsLink(book: book.id!, author: authorId),
    );

    selectAll();
    notifyListeners();
  }
}
