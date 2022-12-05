// To parse this JSON data, do
//
//     final resourceNeededModel = resourceNeededModelFromJson(jsonString?);

import 'dart:convert';

ResourceNeededModel resourceNeededModelFromJson(String? str) => ResourceNeededModel.fromJson(json.decode(str!));

String? resourceNeededModelToJson(ResourceNeededModel data) => json.encode(data.toJson());

class ResourceNeededModel {
  ResourceNeededModel({
    this.status,
    this.message,
    this.error,
    this.statusCode,
    this.data,
  });

  bool? status;
  String? message="";
  String? error="";
  int? statusCode;
  List<Details>? data;

  factory ResourceNeededModel.fromJson(Map<String?, dynamic?> json) => ResourceNeededModel(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    error: json["error"] == null ? null : json["error"],
    statusCode: json["statusCode"] == null ? null : json["statusCode"],
    data: json["data"] == null ? null : List<Details>.from(json["data"].map((x) => Details.fromJson(x))),
  );

  Map<String?, dynamic?> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "error": error == null ? null : error,
    "statusCode": statusCode == null ? null : statusCode,
    "data": data == null ? null : List<dynamic?>.from(data!.map((x) => x.toJson())),
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
  Resource? resource;
  List<dynamic>? tasks;

  factory Details.fromJson(Map<String?, dynamic?> json) => Details(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    emailVerifiedAt: json["email_verified_at"] == null ? null : json["email_verified_at"],
    image: json["image"] == null ? null : json["image"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    type: json["type"] == null ? null : json["type"],
    deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
    project: json["project"] == null ? null : Project.fromJson(json["project"]),
    resource: json["resource"] == null ? null : Resource.fromJson(json["resource"]),
    tasks: json["tasks"] == null ? null : List<dynamic?>.from(json["tasks"].map((x) => x)),
  );

  Map<String?, dynamic?> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "email_verified_at": emailVerifiedAt == null ? null : emailVerifiedAt,
    "image": image == null ? null : image,
    "phone_number": phoneNumber == null ? null : phoneNumber,
    "type": type == null ? null : type,
    "deleted_at": deletedAt == null ? null : deletedAt,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
    "project": project == null ? null : project!.toJson(),
    "resource": resource == null ? null : resource!.toJson(),
    "tasks": tasks == null ? null : List<dynamic>.from(tasks!.map((x) => x)),
  };
}

class Project {
  Project();

  factory Project.fromJson(Map<String?, dynamic?> json) => Project(
  );

  Map<String?, dynamic?> toJson() => {
  };
}

class Resource {
  Resource({
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
    this.department,
    this.skills,
  });

  int? id;
  String? nickname;
  String? bio;
  int? userId;
  String? designation;
  int? departmentId;
  String? associate;
  int? salary;
  String? salaryCurrency;
  String? availibiltyDay;
  String? availibiltyTime;
  String? capacity;
  String? country;
  String? city;
  TimeZone? timeZone;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;
  Department? department;
  List<Skill>? skills;

  factory Resource.fromJson(Map<String?, dynamic?> json) => Resource(
    id: json["id"] == null ? null : json["id"],
    nickname: json["nickname"] == null ? null : json["nickname"],
    bio: json["bio"] == null ? null : json["bio"],
    userId: json["user_id"] == null ? null : json["user_id"],
    designation: json["designation"] == null ? null : json["designation"],
    departmentId: json["department_id"] == null ? null : json["department_id"],
    associate: json["associate"] == null ? null : json["associate"],
    salary: json["salary"] == null ? null : json["salary"],
    salaryCurrency: json["salary_currency"] == null ? null : json["salary_currency"],
    availibiltyDay: json["availibilty_day"] == null ? null : json["availibilty_day"],
    availibiltyTime: json["availibilty_time"] == null ? null : json["availibilty_time"],
    capacity: json["capacity"] == null ? null : json["capacity"],
    country: json["country"] == null ? null : json["country"],
    city: json["city"] == null ? null : json["city"],
    timeZone: json["time_zone"] == null ? null : TimeZone.fromJson(json["time_zone"]),
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
    department: json["department"] == null ? null : Department.fromJson(json["department"]),
    skills: json["skills"] == null ? null : List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
  );

  Map<String?, dynamic?> toJson() => {
    "id": id == null ? null : id,
    "nickname": nickname == null ? null : nickname,
    "bio": bio == null ? null : bio,
    "user_id": userId == null ? null : userId,
    "designation": designation == null ? null : designation,
    "department_id": departmentId == null ? null : departmentId,
    "associate": associate == null ? null : associate,
    "salary": salary == null ? null : salary,
    "salary_currency": salaryCurrency == null ? null : salaryCurrency,
    "availibilty_day": availibiltyDay == null ? null : availibiltyDay,
    "availibilty_time": availibiltyTime == null ? null : availibiltyTime,
    "capacity": capacity == null ? null : capacity,
    "country": country == null ? null : country,
    "city": city == null ? null : city,
    "time_zone": timeZone == null ? null : timeZone!.toJson(),
    "deleted_at": deletedAt,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
    "department": department == null ? null : department!.toJson(),
    "skills": skills == null ? null : List<dynamic>.from(skills!.map((x) => x.toJson())),
  };
}

class Department {
  Department({
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

  factory Department.fromJson(Map<String?, dynamic?> json) => Department(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
  );

  Map<String?, dynamic?> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "deleted_at": deletedAt,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
  };
}

class Skill {
  Skill({
    this.id,
    this.resourceId,
    this.title,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? resourceId;
  String? title;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;

  factory Skill.fromJson(Map<String?, dynamic?> json) => Skill(
    id: json["id"] == null ? null : json["id"],
    resourceId: json["resource_id"] == null ? null : json["resource_id"],
    title: json["title"] == null ? null : json["title"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
  );

  Map<String?, dynamic?> toJson() => {
    "id": id == null ? null : id,
    "resource_id": resourceId == null ? null : resourceId,
    "title": title == null ? null : title,
    "deleted_at": deletedAt,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
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

  factory TimeZone.fromJson(Map<String?, dynamic?> json) => TimeZone(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    offset: json["offset"] == null ? null : json["offset"],
    diffFromGtm: json["diff_from_gtm"] == null ? null : json["diff_from_gtm"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
  );

  Map<String?, dynamic?> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "offset": offset == null ? null : offset,
    "diff_from_gtm": diffFromGtm == null ? null : diffFromGtm,
    "created_at": createdAt == null ? null : createdAt,
    "updated_at": updatedAt == null ? null : updatedAt,
  };
}
