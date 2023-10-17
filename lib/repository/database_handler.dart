import 'dart:io';
import 'package:flutibre/model/authors.dart';
import 'package:flutibre/model/database_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import '../model/booklist_item.dart';
import '../model/books.dart';
import '../model/books_authors_link.dart';

class DatabaseHandler {
  static DatabaseHandler? _databaseHandler;
  static Database? _database;
  final db = 'metadata';

  DatabaseHandler._createInstance();

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  factory DatabaseHandler() {
    _databaseHandler ??= DatabaseHandler._createInstance();
    return _databaseHandler!;
  }

  Future<Database> initDB() async {
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;
    //final appDocumentsDir = await getApplicationDocumentsDirectory();
    //final dbPath = join(appDocumentsDir.path, "databases", "$db.db");
    const dbPath = "/home/sire/Sablonok/Ebooks2/metadata.db";
    final database = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
    return database;
  }

  // This creates tables in our database.
  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    await db.execute(""" CREATE TABLE IF NOT EXISTS authors(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            sort TEXT,
            link TEXT
          )
 """);
  }

// Get Booklist from database
  Future<List<BookListItem>> getBookItemList() async {
    final db = await initDB();
    var resultSet = await db.rawQuery('SELECT COUNT(*) FROM books');
    int? count = resultSet.length;

    List<BookListItem> bookListItems = <BookListItem>[];

    if (count != 0) {
      var resultSet = await db.rawQuery(
          'SELECT DISTINCT books.id, (SELECT group_concat(name) from authors INNER JOIN books_authors_link on authors.id = books_authors_link.author WHERE book = books.id) as name, author_sort, title, books.sort, series_index, timestamp, has_cover, path from books INNER JOIN books_authors_link on books.id = books_authors_link.book INNER JOIN authors on books_authors_link.author = authors.id ORDER BY books.sort');

      for (var item in resultSet) {
        BookListItem bookListItem = BookListItem.fromMap(item);
        bookListItems.add(bookListItem);
      }
      return bookListItems;
    }
    return bookListItems;
  }

  // Fetch Operation: Get all data from database
  Future<List<Map<String, dynamic>>> selectAll(String table) async {
    final db = await database;
    return db.query(table);
    //return db.rawQuery("SELECT * FROM $todo");
  }

  // Fetch Operation: Get item from database by id
  Future<DatabaseModel> selectItemById(
      String table, String type, int id) async {
    final db = await database;
    DatabaseModel? item;
    List<Map<String, dynamic>> itemMap =
        await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);

    switch (type) {
      case 'Books':
        item = Books.fromMap(itemMap[0]);
        break;
      case 'BooksAuthorsLink':
        item = BooksAuthorsLink.fromMap(itemMap[0]);
        break;
      case 'Authors':
        item = Authors.fromMap(itemMap[0]);
        break;
      default:
        item = null;
    }

    return item!;
  }

  // Fetch Operation: Get item from database by id
  Future<DatabaseModel> selectItemByField(
      String table, String type, String field, String searchItem) async {
    final db = await database;
    DatabaseModel? item;
    List<Map<String, dynamic>> itemMap = await db.query(table,
        where: '$field = ?', whereArgs: [selectAll(table)], limit: 1);

    switch (type) {
      case 'Books':
        item = Books.fromMap(itemMap[0]);
        break;
      case 'BooksAuthorsLink':
        item = BooksAuthorsLink.fromMap(itemMap[0]);
        break;
      case 'Authors':
        item = Authors.fromMap(itemMap[0]);
        break;
      default:
        item = null;
    }

    return item!;
  }

  // Fetch Operation: Get item from database by id
  //TODO
  Future<DatabaseModel> selectItemsByField(
      String table, String type, String field, String searchItem) async {
    final db = await database;
    DatabaseModel? item;
    List<Map<String, dynamic>> itemMap = await db.query(table,
        where: '$field = ?', whereArgs: [selectAll(table)], limit: 1);

    switch (type) {
      case 'Books':
        item = Books.fromMap(itemMap[0]);
        break;
      case 'BooksAuthorsLink':
        item = BooksAuthorsLink.fromMap(itemMap[0]);
        break;
      case 'Authors':
        item = Authors.fromMap(itemMap[0]);
        break;
      default:
        item = null;
    }

    return item!;
  }

  // Insert Operation: Insert new record to database
  Future<int> insert(
      {String? dropTrigger,
      required table,
      required item,
      String? createTrigger}) async {
    Database db = await database;
    int result;

    try {
      if (dropTrigger != null) {
        try {
          db.execute(dropTrigger);
        } catch (e) {
          throw Exception('Some error$e');
        }
      }

      result = await db.insert(table, item.toMap());
    } catch (e) {
      throw Exception('Some error$e');
    } finally {
      if (createTrigger != null) {
        try {
          db.execute(createTrigger);
        } catch (e) {
          throw Exception('Some error$e');
        }
      }
    }
    return result;
  }

  // Update Operation: Update record in the database
  Future<int> update(
      {String? dropTrigger,
      required String table,
      required int id,
      required dynamic item,
      String? createTrigger}) async {
    var db = await database;
    int result;
    try {
      if (dropTrigger != null) {
        try {
          db.execute(dropTrigger);
        } catch (e) {
          throw Exception('Some error$e');
        }
      }
      result = await db.update(table, item.toMap(),
          where: 'id = ?',
          whereArgs: [id],
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception('Some error$e');
    } finally {
      if (createTrigger != null) {
        try {
          db.execute(createTrigger);
        } catch (e) {
          throw Exception('Some error$e');
        }
      }
    }
    return result;
  }

  // Delete Operation: Delete record from database
  Future<int> delete(String tableName, int id) async {
    var db = await database;
    int result = await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  // Delete triggers: Delete triggers from database
  void runTrigger(List<String> triggers) async {
    var db = await database;
    for (String trigger in triggers) {
      try {
        await db.execute(trigger);
      } catch (e) {
        print(e);
      }
    }
  }

  void copyDatabase() async {
    String dbFolder = "/home/sire/Sablonok/Ebooks2/";
    final file = File(join(dbFolder, 'app.db'));

    if (!await file.exists()) {
      // Extract the pre-populated database file from assets
      final blob = await rootBundle.load(join(dbFolder, 'metadata.db'));
      final buffer = blob.buffer;
      await file.writeAsBytes(
          buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes));
    }
  }
}
