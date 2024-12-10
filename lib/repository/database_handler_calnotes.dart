import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHandlerCalnotes {
  static DatabaseHandlerCalnotes? _databaseHandlerCalnotes;
  static Database? _databaseCalnotes;
  final String db = 'notes';

  DatabaseHandlerCalnotes._createInstance();

  Future<Database> get database async {
    _databaseCalnotes ??= await initDB();
    return _databaseCalnotes!;
  }

  factory DatabaseHandlerCalnotes() {
    _databaseHandlerCalnotes ??= DatabaseHandlerCalnotes._createInstance();
    return _databaseHandlerCalnotes!;
  }

  void calnotesDbClose() {
    _databaseCalnotes!.close();
  }

  Future<Database> initDB() async {
    sqfliteFfiInit();
    final DatabaseFactory databaseFactory = databaseFactoryFfi;
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String dbPath =
        path.join(appDocumentsDir.path, "databases/.calnotes", "$db.db");

    final Database database = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );

    return database;
  }

  // Fetch Operation: getSqliteSequence from database
  Future<List> getSqliteSequence() async {
    Database db = await database;
    Future<List<Map<String, dynamic>>> result = db.query('sqlite_sequence');
    return result;
  }

  // Copy calnotes.db
  void copyDatabase(String filepath) async {
    final file = File(path.join(filepath, 'app.db'));

    if (!await file.exists()) {
      // Extract the pre-populated database file from assets
      final blob = await rootBundle.load(path.join(filepath, 'metadata.db'));
      final buffer = blob.buffer;
      await file.writeAsBytes(
          buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes));
    }
  }

  void copyDirectorySync(Directory source, Directory destination) {
    /// create destination folder if not exist
    if (!destination.existsSync()) {
      destination.createSync(recursive: true);
    }

    /// get all files from source (recursive: false is important here)
    source.listSync(recursive: false).forEach((entity) {
      final newPath = destination.path +
          Platform.pathSeparator +
          path.basename(entity.path);
      if (entity is File) {
        entity.copySync(newPath);
      } else if (entity is Directory) {
        copyDirectorySync(entity, Directory(newPath));
      }
    });
  }

  // This creates tables in our database.
  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    await db.execute("""
CREATE TABLE notes ( id INTEGER PRIMARY KEY AUTOINCREMENT,
	item INTEGER NOT NULL,
	colname TEXT NOT NULL COLLATE NOCASE,
    doc TEXT NOT NULL DEFAULT '',
    searchable_text TEXT NOT NULL DEFAULT '',
    ctime REAL DEFAULT (unixepoch('subsec')),
    mtime REAL DEFAULT (unixepoch('subsec')),
    UNIQUE(item, colname)
);

CREATE INDEX notes_colname_idx ON notes (colname);

CREATE TABLE resources ( 
    hash TEXT NOT NULL PRIMARY KEY ON CONFLICT FAIL,
    name TEXT NOT NULL UNIQUE ON CONFLICT FAIL
) WITHOUT ROWID;

CREATE TABLE notes_resources_link ( id INTEGER PRIMARY KEY,
    note INTEGER NOT NULL, 
    resource TEXT NOT NULL, 
    FOREIGN KEY(note) REFERENCES notes(id),
    FOREIGN KEY(resource) REFERENCES resources(hash),
    UNIQUE(note, resource)
);


CREATE TRIGGER notes_fts_insert_trg AFTER INSERT ON notes 
BEGIN
    INSERT INTO notes_fts(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
    INSERT INTO notes_fts_stemmed(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
END;

CREATE TRIGGER notes_db_notes_delete_trg BEFORE DELETE ON notes 
    BEGIN
        DELETE FROM notes_resources_link WHERE note=OLD.id;
        INSERT INTO notes_fts(notes_fts, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
        INSERT INTO notes_fts_stemmed(notes_fts_stemmed, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
    END;

CREATE TRIGGER notes_fts_update_trg AFTER UPDATE ON notes
BEGIN
    INSERT INTO notes_fts(notes_fts, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
    INSERT INTO notes_fts(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
    INSERT INTO notes_fts_stemmed(notes_fts_stemmed, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
    INSERT INTO notes_fts_stemmed(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
    UPDATE notes SET mtime=unixepoch('subsec') WHERE id = OLD.id;
END;

CREATE TRIGGER notes_db_resources_delete_trg BEFORE DELETE ON resources 
BEGIN
    DELETE FROM notes_resources_link WHERE resource=OLD.hash;
END;
 """);
  }
}
