// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'database_model.dart';

class Tags extends Equatable implements DatabaseModel {
  @override
  int? id;
  final int name;
  final String link;

  Tags({this.id, required this.name, required this.link});

  //Convert a Map object to a model object
  @override
  Tags.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        link = res['link'];

  //Convert a model object to a Map opject
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['link'] = link;
    return map;
  }

  @override
  String toString() {
    return 'Tags(id : $id, name : $name, link : $link)';
  }

  @override
  List<Object?> get props => [name, link];
}
