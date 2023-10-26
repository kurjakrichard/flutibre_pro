// ignore_for_file: non_constant_identifier_names
import 'package:flutibre/model/authors.dart';
import 'package:flutibre/model/comments.dart';
import 'package:flutibre/model/languages.dart';

class BookListItem {
  int id;
  String name;
  String author_sort;
  String title;
  String sort;
  String last_modified;
  int has_cover;
  double series_index;
  String path;
  String? fullPath;
  List<Authors>? authors;
  Comments? comment;
  List<Languages>? languages;
  
  BookListItem({
    this.id = 0,
    this.name = '',
    this.author_sort = '',
    this.title = '',
    this.sort = '',
    this.last_modified = '',
    this.has_cover = 0,
    this.series_index = 1.0,
    this.path = '',
  });

  //Convert a Map object to a model object
  BookListItem.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        author_sort = res['author_sort'],
        title = res['title'],
        sort = res['sort'],
        last_modified = res['last_modified'].toString(),
        has_cover = res['has_cover'],
        series_index = res['series_index'],
        path = res['path'];
}
