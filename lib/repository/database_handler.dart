import 'dart:io';
import 'package:flutibre/model/authors.dart';
import 'package:flutibre/model/comments.dart';
import 'package:flutibre/model/data.dart';
import 'package:flutibre/model/database_model.dart';
import 'package:flutibre/model/identifiers.dart';
import 'package:flutibre/model/languages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import '../model/booklist_item.dart';
import '../model/books.dart';
import '../model/books_authors_link.dart';
import '../model/books_languages_link.dart';
import '../model/books_publishers_link.dart';
import '../model/books_ratings_link.dart';
import '../model/books_series_link.dart';
import '../model/books_tags_link.dart';

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
    const dbPath = "/home/sire/Sablonok/Ebooks3/metadata.db";
    final database = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _onCreate,
      ),
    );
    return database;
  }

// Get Booklist from database
  Future<List<BookListItem>> getBookItemList() async {
    final db = await database;
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
  Future<DatabaseModel?> selectItemById(
      String table, String type, int id) async {
    final db = await database;
    DatabaseModel? item;

    List<Map<String, dynamic>> itemMap =
        await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);

    if (itemMap.isEmpty) {
      return null;
    }

    for (var element in itemMap) {
      switch (type) {
        case 'Authors':
          item = Authors.fromMap(element);
          break;
        case 'BooksAuthorsLink':
          item = BooksAuthorsLink.fromMap(element);
          break;
        case 'BooksLanguagesLink':
          item = BooksLanguagesLink.fromMap(element);
          break;
        case 'BooksPublishersLink':
          item = BooksPublishersLink.fromMap(element);
          break;
        case 'BooksRatingsLink':
          item = BooksRatingsLink.fromMap(element);
          break;
        case 'BooksSeriesLink':
          item = BooksSeriesLink.fromMap(element);
          break;
        case 'BooksTagsLink':
          item = BooksTagsLink.fromMap(element);
          break;
        case 'Books':
          item = Books.fromMap(element);
          break;
        case 'Comments':
          item = Comments.fromMap(element);
          break;
        case 'Data':
          item = Data.fromMap(element);
          break;
        case 'Identifiers':
          item = Identifiers.fromMap(element);
          break;
        case 'Languages':
          item = Languages.fromMap(element);
          break;
        default:
          item = null;
      }
    }
    return item;
  }

  // Fetch Operation: Get item from database by id
  Future<List<DatabaseModel?>> selectItemByLink(
      {required String table,
      required String type,
      required String field,
      required String searchItem}) async {
    final db = await database;
    DatabaseModel? item;
    var items = [];
    List<Map<String, dynamic>> itemMap =
        await db.query(table, where: '$field = ?', whereArgs: [searchItem]);
    print(itemMap.length);
    if (itemMap.isEmpty) {
      return [];
    }

    for (var element in itemMap) {
      switch (type) {
        case 'Authors':
          item = Authors.fromMap(element);
          break;
        case 'BooksAuthorsLink':
          item = BooksAuthorsLink.fromMap(element);
          break;
        case 'BooksLanguagesLink':
          item = BooksLanguagesLink.fromMap(element);
          break;
        case 'BooksPublishersLink':
          item = BooksPublishersLink.fromMap(element);
          break;
        case 'BooksRatingsLink':
          item = BooksRatingsLink.fromMap(element);
          break;
        case 'BooksSeriesLink':
          item = BooksSeriesLink.fromMap(element);
          break;
        case 'BooksTagsLink':
          item = BooksTagsLink.fromMap(element);
          break;
        case 'Books':
          item = Books.fromMap(element);
          break;
        case 'Comments':
          item = Comments.fromMap(element);
          break;
        case 'Data':
          item = Data.fromMap(element);
          break;
        case 'Identifiers':
          item = Identifiers.fromMap(element);
          break;
        case 'Languages':
          item = Languages.fromMap(element);
          break;
        default:
          item = null;
      }
      items.add(item);
    }

    return items as Future<List<DatabaseModel?>>;
  }

  // Fetch Operation: Get item from database by id
  //TODO
  Future<DatabaseModel> selectItemsByField(
      String table, String type, String field, String searchItem) async {
    final db = await database;
    DatabaseModel? item;
    List<Map<String, dynamic>> itemMap = await db.query(table,
        where: '$field = ?', whereArgs: [searchItem], limit: 1);

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

  void copyDatabase(String path) async {
    final file = File(join(path, 'app.db'));

    if (!await file.exists()) {
      // Extract the pre-populated database file from assets
      final blob = await rootBundle.load(join(path, 'metadata.db'));
      final buffer = blob.buffer;
      await file.writeAsBytes(
          buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes));
    }
  }

// This creates tables in our database.
  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    await db.execute(""" 
CREATE TABLE authors ( id   INTEGER PRIMARY KEY,
                              name TEXT NOT NULL COLLATE NOCASE,
                              sort TEXT COLLATE NOCASE,
                              link TEXT NOT NULL DEFAULT "",
                              UNIQUE(name)
                             );
CREATE TABLE books ( id      INTEGER PRIMARY KEY AUTOINCREMENT,
                             title     TEXT NOT NULL DEFAULT 'Unknown' COLLATE NOCASE,
                             sort      TEXT COLLATE NOCASE,
                             timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             pubdate   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             series_index REAL NOT NULL DEFAULT 1.0,
                             author_sort TEXT COLLATE NOCASE,
                             isbn TEXT DEFAULT "" COLLATE NOCASE,
                             lccn TEXT DEFAULT "" COLLATE NOCASE,
                             path TEXT NOT NULL DEFAULT "",
                             flags INTEGER NOT NULL DEFAULT 1,
                             uuid TEXT,
                             has_cover BOOL DEFAULT 0,
                             last_modified TIMESTAMP NOT NULL DEFAULT "2000-01-01 00:00:00+00:00");
CREATE TABLE books_authors_link ( id INTEGER PRIMARY KEY,
                                          book INTEGER NOT NULL,
                                          author INTEGER NOT NULL,
                                          UNIQUE(book, author)
                                        );
CREATE TABLE books_languages_link ( id INTEGER PRIMARY KEY,
                                            book INTEGER NOT NULL,
                                            lang_code INTEGER NOT NULL,
                                            item_order INTEGER NOT NULL DEFAULT 0,
                                            UNIQUE(book, lang_code)
        );
CREATE TABLE books_plugin_data(id INTEGER PRIMARY KEY,
                                     book INTEGER NOT NULL,
                                     name TEXT NOT NULL,
                                     val TEXT NOT NULL,
                                     UNIQUE(book,name));
CREATE TABLE books_publishers_link ( id INTEGER PRIMARY KEY,
                                          book INTEGER NOT NULL,
                                          publisher INTEGER NOT NULL,
                                          UNIQUE(book)
                                        );
CREATE TABLE books_ratings_link ( id INTEGER PRIMARY KEY,
                                          book INTEGER NOT NULL,
                                          rating INTEGER NOT NULL,
                                          UNIQUE(book, rating)
                                        );
CREATE TABLE books_series_link ( id INTEGER PRIMARY KEY,
                                          book INTEGER NOT NULL,
                                          series INTEGER NOT NULL,
                                          UNIQUE(book)
                                        );
CREATE TABLE books_tags_link ( id INTEGER PRIMARY KEY,
                                          book INTEGER NOT NULL,
                                          tag INTEGER NOT NULL,
                                          UNIQUE(book, tag)
                                        );
CREATE TABLE comments ( id INTEGER PRIMARY KEY,
                              book INTEGER NOT NULL,
                              text TEXT NOT NULL COLLATE NOCASE,
                              UNIQUE(book)
                            );
CREATE TABLE conversion_options ( id INTEGER PRIMARY KEY,
                                          format TEXT NOT NULL COLLATE NOCASE,
                                          book INTEGER,
                                          data BLOB NOT NULL,
                                          UNIQUE(format,book)
                                        );
CREATE TABLE custom_columns (
                    id       INTEGER PRIMARY KEY AUTOINCREMENT,
                    label    TEXT NOT NULL,
                    name     TEXT NOT NULL,
                    datatype TEXT NOT NULL,
                    mark_for_delete   BOOL DEFAULT 0 NOT NULL,
                    editable BOOL DEFAULT 1 NOT NULL,
                    display  TEXT DEFAULT "{}" NOT NULL,
                    is_multiple BOOL DEFAULT 0 NOT NULL,
                    normalized BOOL NOT NULL,
                    UNIQUE(label)
                );
CREATE TABLE data ( id     INTEGER PRIMARY KEY,
                            book   INTEGER NOT NULL,
                            format TEXT NOT NULL COLLATE NOCASE,
                            uncompressed_size INTEGER NOT NULL,
                            name TEXT NOT NULL,
                            UNIQUE(book, format)
);
CREATE TABLE feeds ( id   INTEGER PRIMARY KEY,
                              title TEXT NOT NULL,
                              script TEXT NOT NULL,
                              UNIQUE(title)
                             );
CREATE TABLE identifiers  ( id     INTEGER PRIMARY KEY,
                                    book   INTEGER NOT NULL,
                                    type   TEXT NOT NULL DEFAULT "isbn" COLLATE NOCASE,
                                    val    TEXT NOT NULL COLLATE NOCASE,
                                    UNIQUE(book, type)
        );
CREATE TABLE languages    ( id        INTEGER PRIMARY KEY,
                                    lang_code TEXT NOT NULL COLLATE NOCASE, link TEXT NOT NULL DEFAULT '',
                                    UNIQUE(lang_code)
        );
CREATE TABLE library_id ( id   INTEGER PRIMARY KEY,
                                  uuid TEXT NOT NULL,
                                  UNIQUE(uuid)
        );
INSERT INTO library_id VALUES(1,'01a02c59-60cb-452a-b30c-038a8aa9ba20');
CREATE TABLE metadata_dirtied(id INTEGER PRIMARY KEY,
                             book INTEGER NOT NULL,
                             UNIQUE(book));
CREATE TABLE annotations_dirtied(id INTEGER PRIMARY KEY,
                             book INTEGER NOT NULL,
                             UNIQUE(book));
CREATE TABLE preferences(id INTEGER PRIMARY KEY,
                                 key TEXT NOT NULL,
                                 val TEXT NOT NULL,
                                 UNIQUE(key));
INSERT INTO preferences VALUES(1,'bools_are_tristate','true');
INSERT INTO preferences VALUES(2,'user_categories','{}');
INSERT INTO preferences VALUES(3,'saved_searches','{}');
INSERT INTO preferences VALUES(4,'grouped_search_terms','{}');
INSERT INTO preferences VALUES(5,'tag_browser_hidden_categories','[]');
INSERT INTO preferences VALUES(6,'library_view books view state',replace('{\n  "column_alignment": {},\n  "column_positions": {\n    "authors": 2,\n    "formats": 13,\n    "id": 12,\n    "languages": 11,\n    "last_modified": 10,\n    "ondevice": 0,\n    "path": 14,\n    "pubdate": 9,\n    "publisher": 7,\n    "rating": 4,\n    "series": 3,\n    "size": 8,\n    "tags": 6,\n    "timestamp": 5,\n    "title": 1\n  },\n  "column_sizes": {\n    "authors": 295,\n    "formats": 0,\n    "id": 0,\n    "languages": 0,\n    "last_modified": 0,\n    "path": 0,\n    "pubdate": 0,\n    "publisher": 0,\n    "rating": 0,\n    "series": 66,\n    "size": 295,\n    "tags": 0,\n    "timestamp": 64,\n    "title": 378\n  },\n  "formats_injected": true,\n  "hidden_columns": [\n    "id",\n    "formats",\n    "path",\n    "last_modified",\n    "languages"\n  ],\n  "id_injected": true,\n  "languages_injected": true,\n  "last_modified_injected": true,\n  "path_injected": true,\n  "sort_history": [\n    [\n      "title",\n      false\n    ],\n    [\n      "#olvasott",\n      true\n    ],\n    [\n      "authors",\n      true\n    ],\n    [\n      "timestamp",\n      false\n    ]\n  ]\n}','\n',char(10)));
INSERT INTO preferences VALUES(7,'books view split pane state',replace('{\n  "column_positions": {\n    "authors": 2,\n    "formats": 13,\n    "id": 12,\n    "languages": 11,\n    "last_modified": 10,\n    "ondevice": 0,\n    "path": 14,\n    "pubdate": 9,\n    "publisher": 8,\n    "rating": 5,\n    "series": 7,\n    "size": 4,\n    "tags": 6,\n    "timestamp": 3,\n    "title": 1\n  },\n  "column_sizes": {\n    "authors": 125,\n    "formats": 100,\n    "id": 100,\n    "languages": 125,\n    "last_modified": 125,\n    "path": 100,\n    "pubdate": 125,\n    "publisher": 125,\n    "rating": 125,\n    "series": 125,\n    "size": 125,\n    "tags": 125,\n    "timestamp": 125,\n    "title": 125\n  },\n  "hidden_columns": []\n}','\n',char(10)));
INSERT INTO preferences VALUES(8,'field_metadata',replace('{\n  "au_map": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {\n      "cache_to_list": ",",\n      "list_to_ui": null,\n      "ui_to_list": null\n    },\n    "kind": "field",\n    "label": "au_map",\n    "name": null,\n    "rec_index": 18,\n    "search_terms": [],\n    "table": null\n  },\n  "author_sort": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "author_sort",\n    "name": "Szerz\u0151 rendez\u00e9si forma",\n    "rec_index": 12,\n    "search_terms": [\n      "author_sort"\n    ],\n    "table": null\n  },\n  "authors": {\n    "category_sort": "sort",\n    "column": "name",\n    "datatype": "text",\n    "display": {},\n    "is_category": true,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {\n      "cache_to_list": ",",\n      "list_to_ui": " & ",\n      "ui_to_list": "&"\n    },\n    "kind": "field",\n    "label": "authors",\n    "link_column": "author",\n    "name": "Szerz\u0151k",\n    "rec_index": 2,\n    "search_terms": [\n      "authors",\n      "author"\n    ],\n    "table": "authors"\n  },\n  "comments": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "comments",\n    "name": "Megjegyz\u00e9s(ek)",\n    "rec_index": 7,\n    "search_terms": [\n      "comments",\n      "comment"\n    ],\n    "table": null\n  },\n  "cover": {\n    "column": null,\n    "datatype": "int",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "cover",\n    "name": "Bor\u00edt\u00f3",\n    "rec_index": 17,\n    "search_terms": [\n      "cover"\n    ],\n    "table": null\n  },\n  "formats": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": true,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {\n      "cache_to_list": ",",\n      "list_to_ui": ", ",\n      "ui_to_list": ","\n    },\n    "kind": "field",\n    "label": "formats",\n    "name": "Form\u00e1tumok",\n    "rec_index": 13,\n    "search_terms": [\n      "formats",\n      "format"\n    ],\n    "table": null\n  },\n  "id": {\n    "column": null,\n    "datatype": "int",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "id",\n    "name": null,\n    "rec_index": 0,\n    "search_terms": [\n      "id"\n    ],\n    "table": null\n  },\n  "identifiers": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": true,\n    "is_csp": true,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {\n      "cache_to_list": ",",\n      "list_to_ui": ", ",\n      "ui_to_list": ","\n    },\n    "kind": "field",\n    "label": "identifiers",\n    "name": "Azonos\u00edt\u00f3k",\n    "rec_index": 20,\n    "search_terms": [\n      "identifiers",\n      "identifier",\n      "isbn"\n    ],\n    "table": null\n  },\n  "languages": {\n    "category_sort": "lang_code",\n    "column": "lang_code",\n    "datatype": "text",\n    "display": {},\n    "is_category": true,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {\n      "cache_to_list": ",",\n      "list_to_ui": ", ",\n      "ui_to_list": ","\n    },\n    "kind": "field",\n    "label": "languages",\n    "link_column": "lang_code",\n    "name": "Nyelvek",\n    "rec_index": 21,\n    "search_terms": [\n      "languages",\n      "language"\n    ],\n    "table": "languages"\n  },\n  "last_modified": {\n    "column": null,\n    "datatype": "datetime",\n    "display": {\n      "date_format": "dd MMM yyyy"\n    },\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "last_modified",\n    "name": "M\u00f3dos\u00edtva",\n    "rec_index": 19,\n    "search_terms": [\n      "last_modified"\n    ],\n    "table": null\n  },\n  "marked": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "marked",\n    "name": null,\n    "rec_index": 23,\n    "search_terms": [\n      "marked"\n    ],\n    "table": null\n  },\n  "news": {\n    "category_sort": "name",\n    "column": "name",\n    "datatype": null,\n    "display": {},\n    "is_category": true,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "category",\n    "label": "news",\n    "name": "H\u00edrek (RSS)",\n    "search_terms": [],\n    "table": "news"\n  },\n  "ondevice": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "ondevice",\n    "name": "Eszk\u00f6z\u00f6n",\n    "rec_index": 22,\n    "search_terms": [\n      "ondevice"\n    ],\n    "table": null\n  },\n  "path": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "path",\n    "name": "El\u00e9r\u00e9si \u00fat",\n    "rec_index": 14,\n    "search_terms": [],\n    "table": null\n  },\n  "pubdate": {\n    "column": null,\n    "datatype": "datetime",\n    "display": {\n      "date_format": "MMM yyyy"\n    },\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "pubdate",\n    "name": "Kiadva",\n    "rec_index": 15,\n    "search_terms": [\n      "pubdate"\n    ],\n    "table": null\n  },\n  "publisher": {\n    "category_sort": "name",\n    "column": "name",\n    "datatype": "text",\n    "display": {},\n    "is_category": true,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "publisher",\n    "link_column": "publisher",\n    "name": "Kiad\u00f3",\n    "rec_index": 9,\n    "search_terms": [\n      "publisher"\n    ],\n    "table": "publishers"\n  },\n  "rating": {\n    "category_sort": "rating",\n    "column": "rating",\n    "datatype": "rating",\n    "display": {},\n    "is_category": true,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "rating",\n    "link_column": "rating",\n    "name": "\u00c9rt\u00e9kel\u00e9s",\n    "rec_index": 5,\n    "search_terms": [\n      "rating"\n    ],\n    "table": "ratings"\n  },\n  "series": {\n    "category_sort": "(title_sort(name))",\n    "column": "name",\n    "datatype": "series",\n    "display": {},\n    "is_category": true,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "series",\n    "link_column": "series",\n    "name": "Sorozat",\n    "rec_index": 8,\n    "search_terms": [\n      "series"\n    ],\n    "table": "series"\n  },\n  "series_index": {\n    "column": null,\n    "datatype": "float",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "series_index",\n    "name": null,\n    "rec_index": 10,\n    "search_terms": [\n      "series_index"\n    ],\n    "table": null\n  },\n  "series_sort": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "series_sort",\n    "name": "Sorozatok rendez\u00e9se",\n    "rec_index": 24,\n    "search_terms": [\n      "series_sort"\n    ],\n    "table": null\n  },\n  "size": {\n    "column": null,\n    "datatype": "float",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "size",\n    "name": "M\u00e9ret",\n    "rec_index": 4,\n    "search_terms": [\n      "size"\n    ],\n    "table": null\n  },\n  "sort": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "sort",\n    "name": "Rendezett c\u00edm",\n    "rec_index": 11,\n    "search_terms": [\n      "title_sort"\n    ],\n    "table": null\n  },\n  "tags": {\n    "category_sort": "name",\n    "column": "name",\n    "datatype": "text",\n    "display": {},\n    "is_category": true,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {\n      "cache_to_list": ",",\n      "list_to_ui": ", ",\n      "ui_to_list": ","\n    },\n    "kind": "field",\n    "label": "tags",\n    "link_column": "tag",\n    "name": "C\u00edmke",\n    "rec_index": 6,\n    "search_terms": [\n      "tags",\n      "tag"\n    ],\n    "table": "tags"\n  },\n  "timestamp": {\n    "column": null,\n    "datatype": "datetime",\n    "display": {\n      "date_format": "dd MMM yyyy"\n    },\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "timestamp",\n    "name": "D\u00e1tum",\n    "rec_index": 3,\n    "search_terms": [\n      "date"\n    ],\n    "table": null\n  },\n  "title": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "title",\n    "name": "C\u00edm",\n    "rec_index": 1,\n    "search_terms": [\n      "title"\n    ],\n    "table": null\n  },\n  "uuid": {\n    "column": null,\n    "datatype": "text",\n    "display": {},\n    "is_category": false,\n    "is_csp": false,\n    "is_custom": false,\n    "is_editable": true,\n    "is_multiple": {},\n    "kind": "field",\n    "label": "uuid",\n    "name": null,\n    "rec_index": 16,\n    "search_terms": [\n      "uuid"\n    ],\n    "table": null\n  }\n}','\n',char(10)));
INSERT INTO preferences VALUES(9,'tag_browser_category_order',replace('[\n  "authors",\n  "languages",\n  "series",\n  "formats",\n  "publisher",\n  "rating",\n  "news",\n  "tags",\n  "identifiers"\n]','\n',char(10)));
INSERT INTO preferences VALUES(10,'last_expired_trash_at','1698324229.8742244');
CREATE TABLE publishers ( id   INTEGER PRIMARY KEY,
                                  name TEXT NOT NULL COLLATE NOCASE,
                                  sort TEXT COLLATE NOCASE, link TEXT NOT NULL DEFAULT '',
                                  UNIQUE(name)
                             );
CREATE TABLE ratings ( id   INTEGER PRIMARY KEY,
                               rating INTEGER CHECK(rating > -1 AND rating < 11), link TEXT NOT NULL DEFAULT '',
                               UNIQUE (rating)
                             );
CREATE TABLE series ( id   INTEGER PRIMARY KEY,
                              name TEXT NOT NULL COLLATE NOCASE,
                              sort TEXT COLLATE NOCASE, link TEXT NOT NULL DEFAULT '',
                              UNIQUE (name)
                             );
CREATE TABLE tags ( id   INTEGER PRIMARY KEY,
                            name TEXT NOT NULL COLLATE NOCASE, link TEXT NOT NULL DEFAULT '',
                            UNIQUE (name)
                             );
CREATE TABLE last_read_positions ( id INTEGER PRIMARY KEY,
	book INTEGER NOT NULL,
	format TEXT NOT NULL COLLATE NOCASE,
	user TEXT NOT NULL,
	device TEXT NOT NULL,
	cfi TEXT NOT NULL,
	epoch REAL NOT NULL,
	pos_frac REAL NOT NULL DEFAULT 0,
	UNIQUE(user, device, book, format)
);
CREATE TABLE annotations ( id INTEGER PRIMARY KEY,
	book INTEGER NOT NULL,
	format TEXT NOT NULL COLLATE NOCASE,
	user_type TEXT NOT NULL,
	user TEXT NOT NULL,
	timestamp REAL NOT NULL,
	annot_id TEXT NOT NULL,
	annot_type TEXT NOT NULL,
	annot_data TEXT NOT NULL,
    searchable_text TEXT NOT NULL DEFAULT "",
    UNIQUE(book, user_type, user, format, annot_type, annot_id)
);
PRAGMA writable_schema=ON;
INSERT INTO sqlite_schema(type,name,tbl_name,rootpage,sql)VALUES('table','annotations_fts','annotations_fts',0,'CREATE VIRTUAL TABLE annotations_fts USING fts5(searchable_text, content = ''annotations'', content_rowid = ''id'', tokenize = ''unicode61 remove_diacritics 2'')');
CREATE TABLE IF NOT EXISTS 'annotations_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
INSERT INTO annotations_fts_data VALUES(1,X'');
INSERT INTO annotations_fts_data VALUES(10,X'00000000000000');
CREATE TABLE IF NOT EXISTS 'annotations_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'annotations_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'annotations_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
INSERT INTO annotations_fts_config VALUES('version',4);
INSERT INTO sqlite_schema(type,name,tbl_name,rootpage,sql)VALUES('table','annotations_fts_stemmed','annotations_fts_stemmed',0,'CREATE VIRTUAL TABLE annotations_fts_stemmed USING fts5(searchable_text, content = ''annotations'', content_rowid = ''id'', tokenize = ''porter unicode61 remove_diacritics 2'')');
CREATE TABLE IF NOT EXISTS 'annotations_fts_stemmed_data'(id INTEGER PRIMARY KEY, block BLOB);
INSERT INTO annotations_fts_stemmed_data VALUES(1,X'');
INSERT INTO annotations_fts_stemmed_data VALUES(10,X'00000000000000');
CREATE TABLE IF NOT EXISTS 'annotations_fts_stemmed_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'annotations_fts_stemmed_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'annotations_fts_stemmed_config'(k PRIMARY KEY, v) WITHOUT ROWID;
INSERT INTO annotations_fts_stemmed_config VALUES('version',4);
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('books',29);
CREATE TRIGGER annotations_fts_insert_trg AFTER INSERT ON annotations 
BEGIN
    INSERT INTO annotations_fts(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
    INSERT INTO annotations_fts_stemmed(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
END;
CREATE TRIGGER annotations_fts_delete_trg AFTER DELETE ON annotations 
BEGIN
    INSERT INTO annotations_fts(annotations_fts, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
    INSERT INTO annotations_fts_stemmed(annotations_fts_stemmed, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
END;
CREATE TRIGGER annotations_fts_update_trg AFTER UPDATE ON annotations 
BEGIN
    INSERT INTO annotations_fts(annotations_fts, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
    INSERT INTO annotations_fts(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
    INSERT INTO annotations_fts_stemmed(annotations_fts_stemmed, rowid, searchable_text) VALUES('delete', OLD.id, OLD.searchable_text);
    INSERT INTO annotations_fts_stemmed(rowid, searchable_text) VALUES (NEW.id, NEW.searchable_text);
END;
CREATE VIEW meta AS
        SELECT id, title,
               (SELECT sortconcat(bal.id, name) FROM books_authors_link AS bal JOIN authors ON(author = authors.id) WHERE book = books.id) authors,
               (SELECT name FROM publishers WHERE publishers.id IN (SELECT publisher from books_publishers_link WHERE book=books.id)) publisher,
               (SELECT rating FROM ratings WHERE ratings.id IN (SELECT rating from books_ratings_link WHERE book=books.id)) rating,
               timestamp,
               (SELECT MAX(uncompressed_size) FROM data WHERE book=books.id) size,
               (SELECT concat(name) FROM tags WHERE tags.id IN (SELECT tag from books_tags_link WHERE book=books.id)) tags,
               (SELECT text FROM comments WHERE book=books.id) comments,
               (SELECT name FROM series WHERE series.id IN (SELECT series FROM books_series_link WHERE book=books.id)) series,
               series_index,
               sort,
               author_sort,
               (SELECT concat(format) FROM data WHERE data.book=books.id) formats,
               isbn,
               path,
               lccn,
               pubdate,
               flags,
               uuid
        FROM books;
CREATE VIEW tag_browser_authors AS SELECT
                    id,
                    name,
                    (SELECT COUNT(id) FROM books_authors_link WHERE author=authors.id) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_authors_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.author=authors.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0) avg_rating,
                     sort AS sort
                FROM authors;
CREATE VIEW tag_browser_filtered_authors AS SELECT
                    id,
                    name,
                    (SELECT COUNT(books_authors_link.id) FROM books_authors_link WHERE
                        author=authors.id AND books_list_filter(book)) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_authors_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.author=authors.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0 AND
                     books_list_filter(bl.book)) avg_rating,
                     sort AS sort
                FROM authors;
CREATE VIEW tag_browser_filtered_publishers AS SELECT
                    id,
                    name,
                    (SELECT COUNT(books_publishers_link.id) FROM books_publishers_link WHERE
                        publisher=publishers.id AND books_list_filter(book)) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_publishers_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.publisher=publishers.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0 AND
                     books_list_filter(bl.book)) avg_rating,
                     name AS sort
                FROM publishers;
CREATE VIEW tag_browser_filtered_ratings AS SELECT
                    id,
                    rating,
                    (SELECT COUNT(books_ratings_link.id) FROM books_ratings_link WHERE
                        rating=ratings.id AND books_list_filter(book)) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_ratings_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.rating=ratings.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0 AND
                     books_list_filter(bl.book)) avg_rating,
                     rating AS sort
                FROM ratings;
CREATE VIEW tag_browser_filtered_series AS SELECT
                    id,
                    name,
                    (SELECT COUNT(books_series_link.id) FROM books_series_link WHERE
                        series=series.id AND books_list_filter(book)) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_series_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.series=series.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0 AND
                     books_list_filter(bl.book)) avg_rating,
                     (title_sort(name)) AS sort
                FROM series;
CREATE VIEW tag_browser_filtered_tags AS SELECT
                    id,
                    name,
                    (SELECT COUNT(books_tags_link.id) FROM books_tags_link WHERE
                        tag=tags.id AND books_list_filter(book)) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_tags_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.tag=tags.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0 AND
                     books_list_filter(bl.book)) avg_rating,
                     name AS sort
                FROM tags;
CREATE VIEW tag_browser_publishers AS SELECT
                    id,
                    name,
                    (SELECT COUNT(id) FROM books_publishers_link WHERE publisher=publishers.id) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_publishers_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.publisher=publishers.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0) avg_rating,
                     name AS sort
                FROM publishers;
CREATE VIEW tag_browser_ratings AS SELECT
                    id,
                    rating,
                    (SELECT COUNT(id) FROM books_ratings_link WHERE rating=ratings.id) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_ratings_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.rating=ratings.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0) avg_rating,
                     rating AS sort
                FROM ratings;
CREATE VIEW tag_browser_series AS SELECT
                    id,
                    name,
                    (SELECT COUNT(id) FROM books_series_link WHERE series=series.id) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_series_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.series=series.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0) avg_rating,
                     (title_sort(name)) AS sort
                FROM series;
CREATE VIEW tag_browser_tags AS SELECT
                    id,
                    name,
                    (SELECT COUNT(id) FROM books_tags_link WHERE tag=tags.id) count,
                    (SELECT AVG(ratings.rating)
                     FROM books_tags_link AS tl, books_ratings_link AS bl, ratings
                     WHERE tl.tag=tags.id AND bl.book=tl.book AND
                     ratings.id = bl.rating AND ratings.rating <> 0) avg_rating,
                     name AS sort
                FROM tags;
CREATE INDEX authors_idx ON books (author_sort COLLATE NOCASE);
CREATE INDEX books_authors_link_aidx ON books_authors_link (author);
CREATE INDEX books_authors_link_bidx ON books_authors_link (book);
CREATE INDEX books_idx ON books (sort COLLATE NOCASE);
CREATE INDEX books_languages_link_aidx ON books_languages_link (lang_code);
CREATE INDEX books_languages_link_bidx ON books_languages_link (book);
CREATE INDEX books_publishers_link_aidx ON books_publishers_link (publisher);
CREATE INDEX books_publishers_link_bidx ON books_publishers_link (book);
CREATE INDEX books_ratings_link_aidx ON books_ratings_link (rating);
CREATE INDEX books_ratings_link_bidx ON books_ratings_link (book);
CREATE INDEX books_series_link_aidx ON books_series_link (series);
CREATE INDEX books_series_link_bidx ON books_series_link (book);
CREATE INDEX books_tags_link_aidx ON books_tags_link (tag);
CREATE INDEX books_tags_link_bidx ON books_tags_link (book);
CREATE INDEX comments_idx ON comments (book);
CREATE INDEX conversion_options_idx_a ON conversion_options (format COLLATE NOCASE);
CREATE INDEX conversion_options_idx_b ON conversion_options (book);
CREATE INDEX custom_columns_idx ON custom_columns (label);
CREATE INDEX data_idx ON data (book);
CREATE INDEX lrp_idx ON last_read_positions (book);
CREATE INDEX annot_idx ON annotations (book);
CREATE INDEX formats_idx ON data (format);
CREATE INDEX languages_idx ON languages (lang_code COLLATE NOCASE);
CREATE INDEX publishers_idx ON publishers (name COLLATE NOCASE);
CREATE INDEX series_idx ON series (name COLLATE NOCASE);
CREATE INDEX tags_idx ON tags (name COLLATE NOCASE);
CREATE TRIGGER books_delete_trg
            AFTER DELETE ON books
            BEGIN
                DELETE FROM books_authors_link WHERE book=OLD.id;
                DELETE FROM books_publishers_link WHERE book=OLD.id;
                DELETE FROM books_ratings_link WHERE book=OLD.id;
                DELETE FROM books_series_link WHERE book=OLD.id;
                DELETE FROM books_tags_link WHERE book=OLD.id;
                DELETE FROM books_languages_link WHERE book=OLD.id;
                DELETE FROM data WHERE book=OLD.id;
                DELETE FROM last_read_positions WHERE book=OLD.id;
                DELETE FROM annotations WHERE book=OLD.id;
                DELETE FROM comments WHERE book=OLD.id;
                DELETE FROM conversion_options WHERE book=OLD.id;
                DELETE FROM books_plugin_data WHERE book=OLD.id;
                DELETE FROM identifiers WHERE book=OLD.id;
        END;
CREATE TRIGGER books_update_trg
            AFTER UPDATE ON books
            BEGIN
            UPDATE books SET sort=title_sort(NEW.title)
                         WHERE id=NEW.id AND OLD.title <> NEW.title;
            END;
CREATE TRIGGER fkc_comments_insert
        BEFORE INSERT ON comments
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_comments_update
        BEFORE UPDATE OF book ON comments
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_data_insert
        BEFORE INSERT ON data
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_data_update
        BEFORE UPDATE OF book ON data
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_lrp_insert
        BEFORE INSERT ON last_read_positions
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_lrp_update
        BEFORE UPDATE OF book ON last_read_positions
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_annot_insert
        BEFORE INSERT ON annotations
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_annot_update
        BEFORE UPDATE OF book ON annotations
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_delete_on_authors
        BEFORE DELETE ON authors
        BEGIN
            SELECT CASE
                WHEN (SELECT COUNT(id) FROM books_authors_link WHERE author=OLD.id) > 0
                THEN RAISE(ABORT, 'Foreign key violation: authors is still referenced')
            END;
        END;
CREATE TRIGGER fkc_delete_on_languages
        BEFORE DELETE ON languages
        BEGIN
            SELECT CASE
                WHEN (SELECT COUNT(id) FROM books_languages_link WHERE lang_code=OLD.id) > 0
                THEN RAISE(ABORT, 'Foreign key violation: language is still referenced')
            END;
        END;
CREATE TRIGGER fkc_delete_on_languages_link
        BEFORE INSERT ON books_languages_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from languages WHERE id=NEW.lang_code) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: lang_code not in languages')
          END;
        END;
CREATE TRIGGER fkc_delete_on_publishers
        BEFORE DELETE ON publishers
        BEGIN
            SELECT CASE
                WHEN (SELECT COUNT(id) FROM books_publishers_link WHERE publisher=OLD.id) > 0
                THEN RAISE(ABORT, 'Foreign key violation: publishers is still referenced')
            END;
        END;
CREATE TRIGGER fkc_delete_on_series
        BEFORE DELETE ON series
        BEGIN
            SELECT CASE
                WHEN (SELECT COUNT(id) FROM books_series_link WHERE series=OLD.id) > 0
                THEN RAISE(ABORT, 'Foreign key violation: series is still referenced')
            END;
        END;
CREATE TRIGGER fkc_delete_on_tags
        BEFORE DELETE ON tags
        BEGIN
            SELECT CASE
                WHEN (SELECT COUNT(id) FROM books_tags_link WHERE tag=OLD.id) > 0
                THEN RAISE(ABORT, 'Foreign key violation: tags is still referenced')
            END;
        END;
CREATE TRIGGER fkc_insert_books_authors_link
        BEFORE INSERT ON books_authors_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from authors WHERE id=NEW.author) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: author not in authors')
          END;
        END;
CREATE TRIGGER fkc_insert_books_publishers_link
        BEFORE INSERT ON books_publishers_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from publishers WHERE id=NEW.publisher) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: publisher not in publishers')
          END;
        END;
CREATE TRIGGER fkc_insert_books_ratings_link
        BEFORE INSERT ON books_ratings_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from ratings WHERE id=NEW.rating) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: rating not in ratings')
          END;
        END;
CREATE TRIGGER fkc_insert_books_series_link
        BEFORE INSERT ON books_series_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from series WHERE id=NEW.series) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: series not in series')
          END;
        END;
CREATE TRIGGER fkc_insert_books_tags_link
        BEFORE INSERT ON books_tags_link
        BEGIN
          SELECT CASE
              WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: book not in books')
              WHEN (SELECT id from tags WHERE id=NEW.tag) IS NULL
              THEN RAISE(ABORT, 'Foreign key violation: tag not in tags')
          END;
        END;
CREATE TRIGGER fkc_update_books_authors_link_a
        BEFORE UPDATE OF book ON books_authors_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_authors_link_b
        BEFORE UPDATE OF author ON books_authors_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from authors WHERE id=NEW.author) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: author not in authors')
            END;
        END;
CREATE TRIGGER fkc_update_books_languages_link_a
        BEFORE UPDATE OF book ON books_languages_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_languages_link_b
        BEFORE UPDATE OF lang_code ON books_languages_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from languages WHERE id=NEW.lang_code) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: lang_code not in languages')
            END;
        END;
CREATE TRIGGER fkc_update_books_publishers_link_a
        BEFORE UPDATE OF book ON books_publishers_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_publishers_link_b
        BEFORE UPDATE OF publisher ON books_publishers_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from publishers WHERE id=NEW.publisher) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: publisher not in publishers')
            END;
        END;
CREATE TRIGGER fkc_update_books_ratings_link_a
        BEFORE UPDATE OF book ON books_ratings_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_ratings_link_b
        BEFORE UPDATE OF rating ON books_ratings_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from ratings WHERE id=NEW.rating) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: rating not in ratings')
            END;
        END;
CREATE TRIGGER fkc_update_books_series_link_a
        BEFORE UPDATE OF book ON books_series_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_series_link_b
        BEFORE UPDATE OF series ON books_series_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from series WHERE id=NEW.series) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: series not in series')
            END;
        END;
CREATE TRIGGER fkc_update_books_tags_link_a
        BEFORE UPDATE OF book ON books_tags_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from books WHERE id=NEW.book) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: book not in books')
            END;
        END;
CREATE TRIGGER fkc_update_books_tags_link_b
        BEFORE UPDATE OF tag ON books_tags_link
        BEGIN
            SELECT CASE
                WHEN (SELECT id from tags WHERE id=NEW.tag) IS NULL
                THEN RAISE(ABORT, 'Foreign key violation: tag not in tags')
            END;
        END;
CREATE TRIGGER series_insert_trg
        AFTER INSERT ON series
        BEGIN
          UPDATE series SET sort=title_sort(NEW.name) WHERE id=NEW.id;
        END;
CREATE TRIGGER series_update_trg
        AFTER UPDATE ON series
        BEGIN
          UPDATE series SET sort=title_sort(NEW.name) WHERE id=NEW.id;
        END;
CREATE TRIGGER books_insert_trg AFTER INSERT ON books BEGIN UPDATE books SET sort=title_sort(NEW.title),uuid=uuid4() WHERE id=NEW.id; END;

 """);
  }
}
