import 'package:flutibre/model/authors.dart';
import 'package:flutibre/model/database_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
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

  // Fetch Operation: Get all data from database
  Future<List<Map<String, dynamic>>> selectAll(String table) async {
    final db = await database;
    return db.query(table);
    //return db.rawQuery("SELECT * FROM $todo");
  }

  // Fetch Operation: Get all data from database
  Future<DatabaseModel> selectItem(String table, String type, int id) async {
    final db = await database;
    DatabaseModel? item;
    List<Map<String, dynamic>> itemMap =
        await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);

    switch (type) {
      case 'Authors':
        item = Authors.fromMap(itemMap[0]);
        break;
      case 'BooksAuthorsLink':
        item = BooksAuthorsLink.fromMap(itemMap[0]);
        break;

      default:
    }

    return item!;
  }

  // Insert Operation: Insert new record to database
  Future<int> insert(String table, dynamic item) async {
    Database db = await database;
    var result = await db.insert(table, item.toMap());
    return result;
  }

  // Update Operation: Update record in the database
  Future<int> update(String table, int id, dynamic item) async {
    var db = await database;
    var result = await db.update(table, item.toMap(),
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);

    return result;
  }

  // Delete Operation: Delete record from database
  Future<int> delete(String tableName, int id) async {
    var db = await database;
    int result = await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
