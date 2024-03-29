// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'database_model.dart';

class Publishers extends Equatable implements DatabaseModel {
  @override
  int? id;
  final String name;
  final String sort;
  final String link;

  Publishers({this.id, this.name = '', this.sort = '', this.link = ''});

  //Convert a Map object to a model object
  @override
  Publishers.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        sort = res['sort'],
        link = res['link'];

  //Convert a model object to a Map object
  @override
  Map<String, dynamic> toMap() {
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
    return 'Publishers(id : $id, name : $name, sort : $sort, link : $link)';
  }

  @override
  List<Object?> get props => [name, sort, link];
}
