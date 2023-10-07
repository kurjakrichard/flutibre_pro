// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class BooksPublishersLink extends Equatable {
  int? id;
  final int book;
  final int publisher;

  BooksPublishersLink({this.id, required this.book, required this.publisher});

  //Convert a Map object to a model object
  BooksPublishersLink.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        publisher = res['publisher'];

  //Convert a model object to a Map opject
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['book'] = book;
    map['publisher'] = publisher;
    return map;
  }

  @override
  String toString() {
    return 'BooksAuthorsLink(id : $id, book : $book, publisher : $publisher)';
  }

  @override
  List<Object?> get props => [book, publisher];
}
