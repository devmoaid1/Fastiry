import 'package:efood_multivendor/data/model/response/translation.dart';

class CategoryModel {
  int _id;
  String _name;
  int _parentId;
  int _position;
  int _status;
  String _createdAt;
  String _updatedAt;
  String _image;
  List<Translation> _translations;

  CategoryModel(
      {int id,
      String name,
      int parentId,
      int position,
      int status,
      String createdAt,
      String updatedAt,
      List<Translation> translations,
      String image}) {
    this._id = id;
    this._name = name;
    this._parentId = parentId;
    this._position = position;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._image = image;
    this._translations = translations;
  }

  int get id => _id;
  String get name => _name;
  int get parentId => _parentId;
  int get position => _position;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get image => _image;
  List<Translation> get translations => _translations;
  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _image = json['image'];
    if (json['translations'] != null) {
      _translations = <Translation>[];
      json['translations'].forEach((v) {
        _translations.add(Translation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['parent_id'] = this._parentId;
    data['position'] = this._position;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['image'] = this._image;

    if (this._translations != null) {
      data['translations'] = this._translations.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
