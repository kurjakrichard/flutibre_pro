// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'books_model.dart';

class BooksRatingsLink extends Equatable implements BooksModel {
  @override
  int? id;
  final int book;
  final int rating;

  BooksRatingsLink({this.id, required this.book, required this.rating});

  //Convert a Map object to a model object
  @override
  BooksRatingsLink.fromJson(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        rating = res['rating'];

  //Convert a model object to a Map opject
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['book'] = book;
    map['rating'] = rating;
    return map;
  }

  @override
  String toString() {
    return 'BooksRatingsLink(id : $id, book : $book, rating : $rating)';
  }

  @override
  List<Object?> get props => [book, rating];
}
