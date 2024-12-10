abstract class BooksModel {
  get id;

  //Convert a Map object to a model object
  BooksModel.fromJson(Map<String, dynamic> res);

  //Convert a model object to a Map opject
  Map<String, dynamic> toJson();
}
