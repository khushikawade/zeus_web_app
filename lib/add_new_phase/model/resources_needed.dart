// To parse this JSON data, do
//
//     final resourceNeededModel = resourceNeededModelFromJson(jsonString);

import 'dart:convert';

ResourceNeededModel resourceNeededModelFromJson(String str) =>
    ResourceNeededModel.fromJson(json.decode(str));

String resourceNeededModelToJson(ResourceNeededModel data) =>
    json.encode(data.toJson());

class ResourceNeededModel {
  ResourceNeededModel(
      {this.status, this.message, this.data, this.statusCode, this.error});

  bool? status;
  String? message;
  List<Details>? data;
  int? statusCode;
  String? error;

  factory ResourceNeededModel.fromJson(Map<String, dynamic> json) =>
      ResourceNeededModel(
        status: json["status"],
        message: json["message"],
        data: List<Details>.from(json["data"].map((x) => Details.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Details {
  Details({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.image,
    this.phoneNumber,
    this.type,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.project,
    this.resource,
    this.tasks,
  });

  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? image;
  String? phoneNumber;
  int? type;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Project? project;
  ResourceDetals? resource;
  List<dynamic>? tasks;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        image: json["image"],
        phoneNumber: json["phone_number"],
        type: json["type"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        project:
            json["project"] != null ? Project.fromJson(json["project"]) : null,
        resource: json["resource"] != null
            ? ResourceDetals.fromJson(json["resource"])
            : null,
        tasks: json["tasks"] != null
            ? List<dynamic>.from(json["tasks"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "image": image,
        "phone_number": phoneNumber,
        "type": type,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "project": project != null ? project!.toJson() : [],
        "resource": resource != null ? resource!.toJson() : [],
        "tasks": tasks != null ? List<dynamic>.from(tasks!.map((x) => x)) : [],
      };
}

class Project {
  Project();

  factory Project.fromJson(Map<String, dynamic> json) => Project();

  Map<String, dynamic> toJson() => {};
}

class ResourceDetals {
  ResourceDetals({
    this.id,
    this.nickname,
    this.bio,
    this.userId,
    this.designation,
    this.departmentId,
    this.associate,
    this.salary,
    this.salaryCurrency,
    this.availibiltyDay,
    this.availibiltyTime,
    this.capacity,
    this.country,
    this.city,
    this.timeZone,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? nickname;
  String? bio;
  int? userId;
  String? designation;
  int? departmentId;
  String? associate;
  double? salary;
  String? salaryCurrency;
  String? availibiltyDay;
  String? availibiltyTime;
  String? capacity;
  String? country;
  String? city;
  TimeZone? timeZone;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  factory ResourceDetals.fromJson(Map<String, dynamic> json) => ResourceDetals(
        id: json["id"],
        nickname: json["nickname"],
        bio: json["bio"],
        userId: json["user_id"],
        designation: json["designation"],
        departmentId: json["department_id"],
        associate: json["associate"],
        salary: json["salary"].toDouble(),
        salaryCurrency: json["salary_currency"],
        availibiltyDay: json["availibilty_day"],
        availibiltyTime: json["availibilty_time"],
        capacity: json["capacity"],
        country: json["country"],
        city: json["city"],
        timeZone: TimeZone.fromJson(json["time_zone"]),
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "bio": bio,
        "user_id": userId,
        "designation": designation,
        "department_id": departmentId,
        "associate": associate,
        "salary": salary,
        "salary_currency": salaryCurrency,
        "availibilty_day": availibiltyDay,
        "availibilty_time": availibiltyTime,
        "capacity": capacity,
        "country": country,
        "city": city,
        "time_zone": timeZone!.toJson(),
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class TimeZone {
  TimeZone({
    this.id,
    this.name,
    this.offset,
    this.diffFromGtm,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? offset;
  String? diffFromGtm;
  String? createdAt;
  String? updatedAt;

  factory TimeZone.fromJson(Map<String, dynamic> json) => TimeZone(
        id: json["id"],
        name: json["name"],
        offset: json["offset"],
        diffFromGtm: json["diff_from_gtm"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "offset": offset,
        "diff_from_gtm": diffFromGtm,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
