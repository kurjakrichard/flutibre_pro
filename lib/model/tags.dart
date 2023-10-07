// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Tags extends Equatable {
  int? id;
  final int name;
  final String link;

  Tags({this.id, required this.name, required this.link});

  //Convert a Map object to a model object
  Tags.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        link = res['link'];

  //Convert a model object to a Map opject
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
