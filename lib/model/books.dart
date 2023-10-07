// ignore_for_file: non_constant_identifier_names
import 'package:equatable/equatable.dart';
import 'authors.dart';
import 'comments.dart';
import 'data.dart';

// ignore: must_be_immutable
class Books extends Equatable {
  int? id;
  final String title;
  final String sort;
  final String timestamp;
  final String pubdate;
  final double series_index;
  final String author_sort;
  final String isbn;
  final String lccn;
  final String path;
  final int flags;
  final String uuid;
  final int has_cover;
  final String last_modified;
  //Related classes
  List<Data>? formats;
  List<Authors>? authors;
  Comments? comment;

  Books(
      {this.id,
      this.title = '',
      this.sort = '',
      this.timestamp = '',
      this.pubdate = '',
      this.series_index = 1.0,
      this.author_sort = '',
      this.isbn = '',
      this.lccn = '',
      this.path = '',
      this.flags = 0,
      this.uuid = '',
      this.has_cover = 0,
      this.last_modified = '',
      this.formats,
      this.authors,
      this.comment});

  Books.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        sort = res['sort'],
        timestamp = res['timestamp'],
        pubdate = res['pubdate'],
        series_index = res['series_index'],
        author_sort = res['author_sort'],
        isbn = res['isbn'],
        lccn = res['lccn'],
        path = res['path'],
        flags = res['flags'],
        uuid = res['uuid'],
        has_cover = res['has_cover'],
        last_modified = res['last_modified'];

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'sort': sort,
      'timestamp': timestamp,
      'pubdate': pubdate,
      'series_index': series_index,
      'author_sort': author_sort,
      'isbn': isbn,
      'lccn': lccn,
      'path': path,
      'flags': flags,
      'uuid': uuid,
      'has_cover': has_cover,
      'last_modified': last_modified
    };
  }

  @override
  String toString() {
    return 'Books(id : $id, title : $title, sort : $sort, author_sort : $author_sort)';
  }

  @override
  List<Object?> get props => [
        title,
        sort,
        timestamp,
        pubdate,
        series_index,
        author_sort,
        isbn,
        lccn,
        path,
        flags,
        uuid,
        has_cover
      ];
}