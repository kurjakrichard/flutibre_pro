// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:equatable/equatable.dart';
import 'database_model.dart';

class BooksLanguagesLink extends Equatable implements DatabaseModel {
  @override
  int? id;
  final int book;
  final int lang_code;
  final int item_order;

  BooksLanguagesLink(
      {this.id,
      required this.book,
      required this.lang_code,
      required this.item_order});

  //Convert a Map object to a model opject
  @override
  BooksLanguagesLink.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        lang_code = res['lang_code'],
        item_order = res['item_order'];

  //Convert a model object to a Map opject
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['book'] = book;
    map['lang_code'] = lang_code;
    map['item_order'] = item_order;
    return map;
  }

  @override
  String toString() {
    return 'BooksLanguagesLink(id : $id, book : $book, lang_code : $lang_code, item_order : $item_order)';
  }

  @override
  List<Object?> get props => [book, lang_code, item_order];
}
