// ignore_for_file: non_constant_identifier_names

import 'package:flutibre/model/languages.dart';
import 'authors.dart';
import 'comments.dart';
import 'data.dart';
import 'database_model.dart';

class Books implements DatabaseModel {
  @override
  int? id;
  String title;
  String? sort;
  String? timestamp;
  String? pubdate;
  double series_index;
  String? author_sort;
  String? isbn;
  String lccn;
  String path;
  int flags;
  String uuid;
  int has_cover;
  String last_modified;

  Books(
      {this.id,
      this.title = '',
      this.sort,
      this.timestamp,
      this.pubdate,
      this.series_index = 1,
      this.author_sort,
      this.isbn,
      this.lccn = '',
      required this.path,
      this.flags = 1,
      this.has_cover = 0,
      this.last_modified = '2000-01-01 00:00:00+00:00',
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
}
