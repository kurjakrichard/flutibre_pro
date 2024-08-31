import 'package:flutibre/model/booklist_item.dart';
import 'package:flutibre/model/comments.dart';
import 'package:flutter/foundation.dart';
import '../model/authors.dart';
import '../model/books.dart';
import '../model/books_authors_link.dart';
import '../model/data.dart';
import '../repository/database_handler.dart';

import '../service/file_service.dart';

class BooksListProvider extends ChangeNotifier {
  List<BookListItem> _items = [];
  DatabaseHandler databaseHandler = DatabaseHandler();
  FileService fileService = FileService();

  List<BookListItem> get items {
    return _items;
  }

  Future<void> selectAll() async {
    _items = await databaseHandler.getBookItemList();
    notifyListeners();
  }

  Future insert({required BookListItem newBookListItem}) async {
    List<String> authorsList = newBookListItem.authors.split('&');
    //Authors author = Authors(
    //  name: newBookListItem.authors, sort: newBookListItem.author_sort);

    List<int> authorsIds = [];

    for (String author in authorsList) {
      List<int> checkAuthors = (await databaseHandler.selectIdsByField(
          table: 'authors',
          type: 'Authors',
          field: 'name',
          searchItem: author.trim()));
      bool authorNotExist = checkAuthors.isEmpty;
      if (authorNotExist) {
        int authorId = await databaseHandler.insert(
          table: 'authors',
          item: Authors(name: author.trim(), sort: 'sort'),
        );
        authorsIds.add(authorId);
      } else {
        authorsIds = [...authorsIds, ...checkAuthors];
      }
    }

    Books newBook = Books(
        id: newBookListItem.id,
        title: newBookListItem.title,
        uuid: newBookListItem.uuid,
        sort: newBookListItem.title,
        author_sort: newBookListItem.author_sort,
        path: newBookListItem.path,
        isbn: newBookListItem.isbn,
        lccn: newBookListItem.lccn,
        has_cover: newBookListItem.has_cover,
        timestamp: newBookListItem.timestamp,
        last_modified: newBookListItem.last_modified);

    Data data = Data(
        name: newBookListItem.name,
        book: newBookListItem.id,
        uncompressed_size: newBookListItem.size,
        format: newBookListItem.formats);

    await fileService.copyFile(
        oldpath:
            '/home/sire/Nyilvános/Ebooks2/${newBookListItem.name}.${newBookListItem.formats}',
        path: '/home/sire/Nyilvános/Ebooks2/${newBookListItem.path}',
        filename: newBookListItem.name,
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

    if (newBookListItem.comments != null || newBookListItem.comments != '') {
      Comments comment =
          Comments(book: bookId, text: newBookListItem.comments!);
      await databaseHandler.insert(table: 'comments', item: comment);
    }

    for (int id in authorsIds) {
      await databaseHandler.insert(
        table: 'books_authors_link',
        item: BooksAuthorsLink(book: bookId, author: id),
      );
    }

    await selectAll();
    notifyListeners();
  }

  void delete(int id) async {
    //var databaseHandler = DatabaseHandler();
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
