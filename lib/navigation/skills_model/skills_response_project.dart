// To parse this JSON data, do
//
//     final skillProject = skillProjectFromJson(jsonString);

import 'dart:convert';

SkillProject skillProjectFromJson(String str) =>
    SkillProject.fromJson(json.decode(str));

String skillProjectToJson(SkillProject data) => json.encode(data.toJson());

class SkillProject {
  SkillProject({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<SkillsData>? data;

  factory SkillProject.fromJson(Map<String, dynamic> json) => SkillProject(
        status: json["status"],
        message: json["message"],
        data: List<SkillsData>.from(
            json["data"].map((x) => SkillsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SkillsData {
  SkillsData({
    this.id,
    this.name,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;

  factory SkillsData.fromJson(Map<String, dynamic> json) => SkillsData(
        id: json["id"],
        name: json["name"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

      
}
