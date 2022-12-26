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

  int? statusCode;
  bool? status;
  String? error;
  String? message;
  List<Details>? data;

  factory ResourceNeededModel.fromJson(Map<String, dynamic> json) =>
      ResourceNeededModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Details>.from(json["data"].map((x) => Details.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
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
    this.departmentName,
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
  String? nickname;
  String? bio;
  int? userId;
  String? designation;
  int? departmentId;
  String? associate;
  dynamic salary;
  String? salaryCurrency;
  String? availibiltyDay;
  String? availibiltyTime;
  String? capacity;
  String? country;
  String? city;
  int? timeZone;
  String? departmentName;
  Project? project;
  dynamic? resource;
  List<Task>? tasks;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : json["email_verified_at"],
        image: json["image"] == null ? null : json["image"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        type: json["type"] == null ? null : json["type"],
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        nickname: json["nickname"] == null ? null : json["nickname"],
        bio: json["bio"] == null ? null : json["bio"],
        userId: json["user_id"] == null ? null : json["user_id"],
        designation: json["designation"] == null ? null : json["designation"],
        departmentId:
            json["department_id"] == null ? null : json["department_id"],
        associate: json["associate"] == null ? null : json["associate"],
        salary: json["salary"] == null ? null : json["salary"],
        salaryCurrency:
            json["salary_currency"] == null ? null : json["salary_currency"],
        availibiltyDay:
            json["availibilty_day"] == null ? null : json["availibilty_day"],
        availibiltyTime:
            json["availibilty_time"] == null ? null : json["availibilty_time"],
        capacity: json["capacity"] == null ? null : json["capacity"],
        country: json["country"] == null ? null : json["country"],
        city: json["city"] == null ? null : json["city"],
        timeZone: json["time_zone"] == null ? null : json["time_zone"],
        departmentName:
            json["department_name"] == null ? null : json["department_name"],
        project: json["project_detail"] == null
            ? null
            : Project.fromJson(json["project_detail"]),
        resource: json["resource"],
        tasks: json["tasks"] == null
            ? null
            : List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
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
        "time_zone": timeZone == null ? null : timeZone,
        "department_name": departmentName == null ? null : departmentName,
        "project_detail": project == null ? null : project!.toJson(),
        "resource": resource,
        "tasks": tasks == null
            ? null
            : List<dynamic>.from(tasks!.map((x) => x.toJson())),
      };
}

class Project {
  Project();

  factory Project.fromJson(Map<String, dynamic> json) => Project();

  Map<String, dynamic> toJson() => {};
}

class Task {
  Task({
    this.id,
    this.milestoneTaskId,
    this.departmentId,
    this.resourceId,
    this.assignedDate,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? milestoneTaskId;
  int? departmentId;
  int? resourceId;
  dynamic? assignedDate;
  int? status;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"] == null ? null : json["id"],
        milestoneTaskId: json["milestone_task_id"] == null
            ? null
            : json["milestone_task_id"],
        departmentId:
            json["department_id"] == null ? null : json["department_id"],
        resourceId: json["resource_id"] == null ? null : json["resource_id"],
        assignedDate: json["assigned_date"],
        status: json["status"] == null ? null : json["status"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "milestone_task_id": milestoneTaskId == null ? null : milestoneTaskId,
        "department_id": departmentId == null ? null : departmentId,
        "resource_id": resourceId == null ? null : resourceId,
        "assigned_date": assignedDate,
        "status": status == null ? null : status,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
      };
}
