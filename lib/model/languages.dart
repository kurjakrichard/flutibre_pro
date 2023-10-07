// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:equatable/equatable.dart';

class Languages extends Equatable {
  int? id;
  final String lang_code;
  String? link;

  Languages({this.id, required this.lang_code, this.link});

  //Convert a Map object to a model opject
  Languages.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        lang_code = res['lang_code'],
        link = res['link'];

  //Convert a model object to a Map opject
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['lang_code'] = lang_code;
    if (link != null) {
      map['link'] = link;
    }
    return map;
  }

  @override
  String toString() {
    return 'BooksLanguagesLink(id : $id, lang_code : $lang_code, link : $link)';
  }

  @override
  List<Object?> get props => [lang_code, link];
}
