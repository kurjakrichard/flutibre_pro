// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';

import 'database_model.dart';

class Identifiers extends Equatable implements DatabaseModel {
  int? id;
  int book;
  String type;
  String val;

  Identifiers(
      {this.id, required this.book, required this.type, required this.val});

  //Convert a Map object to a model object
  @override
  Identifiers.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        type = res['type'],
        val = res['val'];

  //Convert a model object to a Map opject
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['book'] = book;
    map['type'] = type;
    map['val'] = val;
    return map;
  }

  @override
  String toString() {
    return 'Identifiers(id : $id, book : $book, type : $type, val: $val)';
  }

  @override
  List<Object?> get props => [book, type, val];
}
