import 'package:flutibre/model/booklist_item.dart';
import 'package:flutibre/model/database_model.dart';
import 'package:flutter/foundation.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import '../model/authors.dart';
import '../model/books.dart';
import '../model/books_authors_link.dart';
import '../model/data.dart';
import '../repository/database_handler.dart';

import '../service/file_service.dart';

class BooksListProvider extends ChangeNotifier {
  List<BookListItem> items = [];
  DatabaseHandler databaseHandler = DatabaseHandler();
  FileService fileService = FileService();

  Future<void> selectAll() async {
    items = await databaseHandler.getBookItemList();
    notifyListeners();
  }

  Future insert({required BookListItem newBookListItem}) async {
    //Authors item = Authors(name: author.name, sort: author.name);
    //databaseHandler.insert(table: 'authors', item: item);

    Books newBook = Books(
        id: newBookListItem.id,
        title: newBookListItem.title,
        uuid: newBookListItem.uuid,
        sort: newBookListItem.title,
        author_sort: newBookListItem.author_sort,
        path: newBookListItem.path,
        has_cover: newBookListItem.has_cover,
        timestamp: newBookListItem.timestamp,
        last_modified: newBookListItem.last_modified);

    Data data = Data(
        name:
            '${removeDiacritics(newBookListItem.title)} - ${removeDiacritics(newBookListItem.authors)}',
        book: newBookListItem.id,
        uncompressed_size: newBookListItem.size,
        format: newBookListItem.formats);

    Authors author = Authors(
        name: newBookListItem.authors, sort: newBookListItem.author_sort);
    print('/home/sire/Sablonok/Ebooks3/${newBookListItem.path}');
    await fileService.copyFile(
        oldpath: '/home/sire/Sablonok/Ebooks3/${newBookListItem.name}',
        path: '/home/sire/Sablonok/Ebooks3/${newBookListItem.path}',
        filename:
            '${removeDiacritics(newBookListItem.title)} - ${removeDiacritics(newBookListItem.authors)}',
        extension: newBookListItem.formats);

    int bookId = await databaseHandler.insert(
      dropTrigger: 'insert',
      table: 'books',
      item: newBook,
      createTrigger: 'createinsert',
    );
    await databaseHandler.insert(
      table: 'data',
      item: data,
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
        : checkAuthors[0].id;
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
