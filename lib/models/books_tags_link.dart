// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'books_model.dart';

class BooksTagsLink extends Equatable implements BooksModel {
  @override
  int? id;
  final int book;
  final int tag;

  BooksTagsLink({this.id, required this.book, required this.tag});

  //Convert a Map object to a model object
  @override
  BooksTagsLink.fromJson(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        tag = res['tag'];

  //Convert a model object to a Map opject
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['book'] = book;
    map['tag'] = tag;
    return map;
  }

  @override
  String toString() {
    return 'BooksTagsLink(id : $id, book : $book, tag : $tag)';
  }

  @override
  List<Object?> get props => [book, tag];
}
