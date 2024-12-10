// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';

class BookListItem extends Equatable {
  int id;
  String title;
  String authors;
  String? publisher;
  double? rating;
  String timestamp;
  int size;
  String? tags;
  String? comments;
  String? series;
  double series_index;
  String sort;
  String author_sort;
  String formats;
  String isbn;
  String path;
  String name;
  String lccn;
  String pubdate;
  String last_modified;
  String uuid;
  int has_cover;

  BookListItem({
    this.id = 0,
    this.title = '',
    this.authors = '',
    this.publisher,
    this.rating = 1.0,
    this.timestamp = '',
    this.size = 0,
    this.tags,
    this.comments,
    this.series,
    this.series_index = 1.0,
    this.sort = '',
    this.author_sort = '',
    this.formats = '',
    this.isbn = '',
    this.path = '',
    this.name = '',
    this.lccn = '',
    this.pubdate = '',
    this.last_modified = '',
    this.uuid = '',
    this.has_cover = 0,
  });
  //Convert a Map object to a model object
  BookListItem.fromJson(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        authors = res['authors'] ?? '',
        publisher = res['publisher'],
        rating = res['rating'],
        timestamp = res['timestamp'],
        size = res['size'] ?? 0,
        tags = res['tags'],
        comments = res['comments'],
        series = res['series'],
        series_index = res['series_index'],
        sort = res['sort'],
        author_sort = res['author_sort'],
        formats = res['formats'].toString().toLowerCase(),
        isbn = res['isbn'],
        path = res['path'],
        name = res['filename'] ?? '',
        lccn = res['lccn'],
        pubdate = res['pubdate'],
        last_modified = res['last_modified'],
        uuid = res['uuid'] ?? '',
        has_cover = res['has_cover'] ?? 0;

  @override
  String toString() {
    return 'BookListItem(id : $id, authors : $authors, title : $title, formats : $formats, size: $size, path: $path, uuid: $uuid)';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        authors,
        publisher,
        rating,
        timestamp,
        size,
        tags,
        comments,
        series,
        series_index,
        sort,
        author_sort,
        formats,
        isbn,
        path,
        name,
        lccn,
        pubdate,
        last_modified,
        uuid,
        has_cover
      ];
}
