import 'package:flutibre/models/books_model.dart';

class Authors implements BooksModel {
  @override
  int? id;
  final String name;
  String? sort;
  final String link;

  Authors({this.id, required this.name, required this.sort, this.link = ''});

  //Convert a Map object to a model object
  @override
  Authors.fromJson(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        sort = res['sort'],
        link = res['link'];

  //Convert a model object to a Map object
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['sort'] = sort;
    map['link'] = link;
    return map;
  }

  @override
  String toString() {
    return 'Authors(id : $id, name : $name, sort : $sort, link : $link)';
  }
}
