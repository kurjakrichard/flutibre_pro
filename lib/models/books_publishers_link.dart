// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'books_model.dart';

class BooksPublishersLink extends Equatable implements BooksModel {
  @override
  int? id;
  final int book;
  final int publisher;

  BooksPublishersLink({this.id, required this.book, required this.publisher});

  //Convert a Map object to a model object
  @override
  BooksPublishersLink.fromJson(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        publisher = res['publisher'];

  //Convert a model object to a Map opject
  @override
  Map<String, dynamic> toJson() {
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
