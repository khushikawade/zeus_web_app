// To parse this JSON data, do
//
//     final getPhaseDetails = getPhaseDetailsFromJson(jsonString);

import 'dart:convert';

GetPhaseDetails getPhaseDetailsFromJson(String str) =>
    GetPhaseDetails.fromJson(json.decode(str));

String getPhaseDetailsToJson(GetPhaseDetails data) =>
    json.encode(data.toJson());

class GetPhaseDetails {
  GetPhaseDetails({
    this.status,
    this.message,
    this.statusCode,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;
  int? statusCode;

  factory GetPhaseDetails.fromJson(Map<String, dynamic> json) =>
      GetPhaseDetails(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "statusCode": statusCode == null ? null : statusCode,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.projectId,
    this.title,
    this.phaseType,
    this.status,
    this.startDate,
    this.endDate,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.subTasks,
    this.assignedResources,
    this.milestone,
  });

  int? id;
  int? projectId;
  String? title;
  String? phaseType;
  int? status;
  String? startDate;
  String? endDate;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;
  List<SubTask>? subTasks;
  List<AssignedResource>? assignedResources;
  List<Milestone>? milestone;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        projectId: json["project_id"] == null ? null : json["project_id"],
        title: json["title"] == null ? null : json["title"],
        phaseType: json["phase_type"] == null ? null : json["phase_type"],
        status: json["status"] == null ? null : json["status"],
        startDate: json["start_date"] == null ? null : json["start_date"],
        endDate: json["end_date"] == null ? null : json["end_date"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        subTasks: json["sub_tasks"] == null
            ? null
            : List<SubTask>.from(
                json["sub_tasks"].map((x) => SubTask.fromJson(x))),
        assignedResources: json["assigned_resources"] == null
            ? null
            : List<AssignedResource>.from(json["assigned_resources"]
                .map((x) => AssignedResource.fromJson(x))),
        milestone: json["milestone"] == null
            ? null
            : List<Milestone>.from(
                json["milestone"].map((x) => Milestone.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "project_id": projectId == null ? null : projectId,
        "title": title == null ? null : title,
        "phase_type": phaseType == null ? null : phaseType,
        "status": status == null ? null : status,
        "start_date": startDate == null ? null : startDate,
        "end_date": endDate == null ? null : endDate,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "sub_tasks": subTasks == null
            ? null
            : List<dynamic>.from(subTasks!.map((x) => x.toJson())),
        "assigned_resources": assignedResources == null
            ? null
            : List<dynamic>.from(assignedResources!.map((x) => x.toJson())),
        "milestone": milestone == null
            ? null
            : List<dynamic>.from(milestone!.map((x) => x.toJson())),
      };
}

class AssignedResource {
  AssignedResource({
    this.id,
    this.projectPhaseId,
    this.departmentId,
    this.resourceId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.resource,
    this.department,
  });

  int? id;
  int? projectPhaseId;
  int? departmentId;
  int? resourceId;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;
  Resource? resource;
  Department? department;

  factory AssignedResource.fromJson(Map<String, dynamic> json) =>
      AssignedResource(
        id: json["id"] == null ? null : json["id"],
        projectPhaseId:
            json["project_phase_id"] == null ? null : json["project_phase_id"],
        departmentId:
            json["department_id"] == null ? null : json["department_id"],
        resourceId: json["resource_id"] == null ? null : json["resource_id"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        resource: json["resource"] == null
            ? null
            : Resource.fromJson(json["resource"]),
        department: json["department"] == null
            ? null
            : Department.fromJson(json["department"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "project_phase_id": projectPhaseId == null ? null : projectPhaseId,
        "department_id": departmentId == null ? null : departmentId,
        "resource_id": resourceId == null ? null : resourceId,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "resource": resource == null ? null : resource!.toJson(),
        "department": department == null ? null : department!.toJson(),
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

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
      };
}

class AssignResource {
  AssignResource({
    this.id,
    this.milestoneTaskId,
    this.departmentId,
    this.resourceId,
    this.assignedDate,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.resource,
    this.department,
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
  Resource? resource;
  Department? department;

  factory AssignResource.fromJson(Map<String, dynamic> json) => AssignResource(
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
        resource: json["resource"] == null
            ? null
            : Resource.fromJson(json["resource"]),
        department: json["department"] == null
            ? null
            : Department.fromJson(json["department"]),
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
        "resource": resource == null ? null : resource!.toJson(),
        "department": department == null ? null : department!.toJson(),
      };
}

class Resource {
  Resource({
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
  dynamic? resource;
  List<AssignResource>? tasks;

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
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
        project:
            json["project"] == null ? null : Project.fromJson(json["project"]),
        resource: json["resource"],
        tasks: json["tasks"] == null
            ? null
            : List<AssignResource>.from(
                json["tasks"].map((x) => AssignResource.fromJson(x))),
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
        "project": project == null ? null : project!.toJson(),
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

class Milestone {
  Milestone({
    this.id,
    this.projectPhaseId,
    this.title,
    this.status,
    this.mDate,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? projectPhaseId;
  String? title;
  int? status;
  String? mDate;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        id: json["id"] == null ? null : json["id"],
        projectPhaseId:
            json["project_phase_id"] == null ? null : json["project_phase_id"],
        title: json["title"] == null ? null : json["title"],
        status: json["status"] == null ? null : json["status"],
        mDate: json["m_date"] == null ? null : json["m_date"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "project_phase_id": projectPhaseId == null ? null : projectPhaseId,
        "title": title == null ? null : title,
        "status": status == null ? null : status,
        "m_date": mDate == null ? null : mDate,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
      };
}

class SubTask {
  SubTask({
    this.id,
    this.phaseId,
    this.phaseMilestoneId,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.assignResource,
  });

  int? id;
  int? phaseId;
  dynamic? phaseMilestoneId;
  dynamic? title;
  dynamic? description;
  String? startDate;
  String? endDate;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;
  AssignResource? assignResource;

  factory SubTask.fromJson(Map<String, dynamic> json) => SubTask(
        id: json["id"] == null ? null : json["id"],
        phaseId: json["phase_id"] == null ? null : json["phase_id"],
        phaseMilestoneId: json["phase_milestone_id"],
        title: json["title"],
        description: json["description"],
        startDate: json["start_date"] == null ? null : json["start_date"],
        endDate: json["end_date"] == null ? null : json["end_date"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        assignResource: json["assign_resource"] == null
            ? null
            : AssignResource.fromJson(json["assign_resource"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "phase_id": phaseId == null ? null : phaseId,
        "phase_milestone_id": phaseMilestoneId,
        "title": title,
        "description": description,
        "start_date": startDate == null ? null : startDate,
        "end_date": endDate == null ? null : endDate,
        "deleted_at": deletedAt,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "assign_resource":
            assignResource == null ? null : assignResource!.toJson(),
      };
}
