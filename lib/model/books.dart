// ignore_for_file: non_constant_identifier_names
import 'package:equatable/equatable.dart';
import 'package:flutibre/model/languages.dart';
import 'authors.dart';
import 'comments.dart';
import 'data.dart';
import 'database_model.dart';

// ignore: must_be_immutable
class Books extends Equatable implements DatabaseModel {
  @override
  int? id;
  final String title;
  final String sort;
  String timestamp;
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
  Comments? comment;
  List<Data>? formats;
  List<Authors>? authors;
  List<Languages>? languages;
  List<Data>? datas;

  Books(
      {this.id,
      this.title = '',
      this.sort = '',
      this.timestamp = '',
      this.pubdate = '0101-01-01 00:00:00+00:00',
      this.series_index = 1.0,
      this.author_sort = '',
      this.isbn = '',
      this.lccn = '',
      this.path = '',
      this.flags = 1,
      this.has_cover = 1,
      this.last_modified = '',
      this.formats,
      this.authors,
      this.comment,
      required this.uuid});

  //Convert a Map object to a model object
  @override
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

  //Convert a model object to a Map opject
  @override
  Map<String, Object?> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['sort'] = sort;
    map['timestamp'] = timestamp;
    map['pubdate'] = pubdate;
    map['series_index'] = series_index;
    map['author_sort'] = author_sort;
    map['isbn'] = isbn;
    map['lccn'] = lccn;
    map['path'] = path;
    map['flags'] = flags;
    map['uuid'] = uuid;
    map['has_cover'] = has_cover;
    map['last_modified'] = last_modified;
    return map;
  }

  @override
  String toString() {
    return 'Books(id : $id, title : $title, sort : $sort, author_sort : $author_sort, path: $path)';
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
