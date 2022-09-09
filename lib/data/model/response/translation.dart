class Translation {
  int id;
  String translationableType;
  String translationableId;
  String locale;
  String key;
  String value;
  Null createdAt;
  Null updatedAt;

  Translation(
      {this.id,
      this.translationableType,
      this.translationableId,
      this.locale,
      this.key,
      this.value,
      this.createdAt,
      this.updatedAt});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['translationable_type'] = this.translationableType;
    data['translationable_id'] = this.translationableId;
    data['locale'] = this.locale;
    data['key'] = this.key;
    data['value'] = this.value;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
