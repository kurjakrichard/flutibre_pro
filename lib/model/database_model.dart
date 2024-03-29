abstract class DatabaseModel {
  //Convert a Map object to a model object
  DatabaseModel.fromMap(Map<String, dynamic> res);

  get id => null;

  //Convert a model object to a Map opject
  Map<String, dynamic> toMap();
}
