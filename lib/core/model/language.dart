import 'dart:convert';

class LanguageModel {
  LanguageModel({
    this.id,
    this.code,
    this.name,
  });

  int id;
  String code;
  String name;

  factory LanguageModel.fromRawJson(String str) =>
      LanguageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
      };

  static List<LanguageModel> toListFromJson(List<dynamic> json) {
    return json == null
        ? null
        : List<LanguageModel>.from(json.map((x) => LanguageModel.fromJson(x)));
  }

  static LanguageModel fromJsonModel(Map<String, dynamic> json) =>
      LanguageModel.fromJson(json);
}
