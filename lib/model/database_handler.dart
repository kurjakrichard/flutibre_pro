import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'book.dart';

class DatabaseHandler {
  static Future<Database> initializeDB() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      String path = '/home/sire/VScode/flutibre/assets/books/';
      DatabaseFactory databaseFactory = databaseFactoryFfi;
      String dbpath = '${path}metadata.db';
      Database db = await databaseFactory.openDatabase(dbpath);
      return db;
    } else {
      String path = await getDatabasesPath();
      return openDatabase(
        join(path, 'metadata.db'),
        onCreate: (database, version) async {
          await database.execute(
            "CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, series_index REAL, author_sort TEXT NOT NULL )",
          );
        },
        version: 1,
      );
    }
  }

  Future<int> addBook(Book book) async {
    final Database db = await initializeDB();

    if (Platform.isWindows || Platform.isLinux) {
      try {
        await db.execute('DROP TRIGGER books_insert_trg');
        return await db.insert('books', book.toMap());
      } catch (e) {
        throw Exception('Some error');
      } finally {
        await db.rawQuery(
            'CREATE TRIGGER books_insert_trg AFTER INSERT ON books BEGIN UPDATE books SET sort=title_sort(NEW.title),uuid=uuid4() WHERE id=NEW.id; END');
      }
    } else {
      return await db.insert('books', book.toMap());
    }
  }

  Future<List<Book>> retrieveBooks() async {
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult = await db.query('books');
    return queryResult.map((e) => Book.fromMap(e)).toList();
  }
}
