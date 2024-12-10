import '../models/authors.dart';
import '../models/books.dart';
import '../models/books_authors_link.dart';
import '../models/data.dart';
import '../models/books_model.dart';
import '../repository/database_handler.dart';

class DatabaseService {
  DatabaseHandler databaseHandler = DatabaseHandler();

  Future insert() async {
    Authors author = Authors(
        id: 15, name: 'Robert Jordan', sort: 'Jordan, Robert', link: 'empty');
    databaseHandler.insert(table: 'authors', item: author);

    Books newBook = Books(
        id: 12,
        title: 'Az újjászületett sárkány',
        sort: 'újjászületett sárkány, az',
        timestamp: '2022-11-10 10:24:50.674242+00:00',
        pubdate: '2022-11-10 10:24:50.674242+00:00',
        series_index: 1,
        author_sort: 'Jordan, Robert',
        isbn: 'isbn',
        lccn: 'lccn',
        path: 'Robert Jordan/Az újjászületett sárkány(12)',
        flags: 1,
        uuid: '5f546874-838a-4c01-aaeb-77fb4d08f20e',
        has_cover: 0,
        last_modified: '2022-11-10 10:24:50.674242+00:00');

    int bookId = await databaseHandler.insert(
      dropTrigger: 'insert',
      table: 'books',
      item: newBook,
      createTrigger: 'createinsert',
    );

    Data data = Data(
      id: 11,
      book: 11,
      uncompressed_size: 1220,
      format: 'epub',
      name: 'Veled jatszom - A. L. Jackson',
    );

    await databaseHandler.insert(
      table: 'data',
      item: data,
    );

    List<BooksModel> checkAuthors = (await databaseHandler.selectItemsByField(
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
  }

  void delete(int id) async {
    var databaseHandler = DatabaseHandler();
    await databaseHandler.delete('books', id);
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
  }
}
