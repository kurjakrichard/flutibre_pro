// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Ratings extends Equatable {
  int? id;
  final int rating;
  final String link;

  Ratings({this.id, required this.rating, required this.link});

  //Convert a Map object to a model object
  Ratings.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        rating = res['rating'],
        link = res['link'];

  //Convert a model object to a Map opject
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['rating'] = rating;
    map['link'] = link;
    return map;
  }

  @override
  String toString() {
    return 'Ratings(id : $id, rating : $rating, link : $link)';
  }

  @override
  List<Object?> get props => [rating, link];
}
