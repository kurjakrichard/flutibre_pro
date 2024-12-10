// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'books_model.dart';

class Comments extends Equatable implements BooksModel {
  @override
  int? id;
  final int book;
  final String text;

  Comments({this.id, required this.book, required this.text});

  //Convert a Map object to a model object
  @override
  Comments.fromJson(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        text = res['text'];

  //Convert a model object to a Map opject
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['book'] = book;
    map['text'] = text;
    return map;
  }

  @override
  String toString() {
    return 'Comments(id : $id, book : $book, text : $text[20])';
  }

  @override
  List<Object?> get props => [id, book, text];
}
