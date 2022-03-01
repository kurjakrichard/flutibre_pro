import 'package:flutibre_pro/utils/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final databaseFactory = databaseFactoryFfi; //singleton database

  SettingsProvider settingsProvider = SettingsProvider();

  Future databasefactory() async {
    Future<String> path = settingsProvider.readJsonData();

    // Init ffi loader if needed.
    sqfliteFfiInit();

    Database db = await databaseFactory.openDatabase('$path/book.db');

    /** await db.execute('''
      CREATE TABLE Product (
      id INTEGER PRIMARY KEY,
      title TEXT
              )
      '''); 
      **/

    await db.insert('Product', <String, Object?>{'title': 'Product 1'});
    await db.insert('Product', <String, Object?>{'title': 'Product 1'});

    List<Map<String, Object?>> result = await db.query('Product');
    print(result);
    // prints [{id: 1, title: Product 1}, {id: 2, title: Product 1}]
    await db.close();
  }
}
