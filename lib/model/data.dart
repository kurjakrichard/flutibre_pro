// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';

import 'database_model.dart';

class Data extends Equatable implements DatabaseModel {
  int? id;
  int book;
  String format;
  int uncompressed_size;
  String name;

  Data(
      {this.id,
      required this.book,
      required this.format,
      required this.uncompressed_size,
      required this.name});

  //Convert a Map object to a model object
  @override
  Data.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        format = res['format'],
        uncompressed_size = res['uncompressed_size'],
        name = res['name'];

  //Convert a model object to a Map opject
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['book'] = book;
    map['format'] = format;
    map['uncompressed_size'] = uncompressed_size;
    map['name'] = name;
    return map;
  }

  @override
  String toString() {
    return 'Data(id : $id, book : $book, format : $format, uncompressed_size: $uncompressed_size, name: $name)';
  }

  @override
  List<Object?> get props => [book, format, uncompressed_size, name];
}
