// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class BooksSeriesLink extends Equatable {
  int? id;
  final int book;
  final int series;

  BooksSeriesLink({this.id, required this.book, required this.series});

  //Convert a Map object to a model object
  BooksSeriesLink.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        book = res['book'],
        series = res['series'];

  //Convert a model object to a Map opject
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['book'] = book;
    map['series'] = series;
    return map;
  }

  @override
  String toString() {
    return 'BooksRatingsLink(id : $id, book : $book, series : $series)';
  }

  @override
  List<Object?> get props => [book, series];
}
