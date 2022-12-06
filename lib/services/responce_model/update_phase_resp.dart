// To parse this JSON data, do
//
//     final updatePhaseResp = updatePhaseRespFromJson(jsonString);

import 'dart:convert';

UpdatePhaseResp updatePhaseRespFromJson(String str) =>
    UpdatePhaseResp.fromJson(json.decode(str));

String updatePhaseRespToJson(UpdatePhaseResp data) =>
    json.encode(data.toJson());

class UpdatePhaseResp {
  UpdatePhaseResp({this.status, this.message, this.data, this.statusCode});

  bool? status;
  String? message;
  Data? data;
  int? statusCode;

  factory UpdatePhaseResp.fromJson(Map<String, dynamic> json) =>
      UpdatePhaseResp(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
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
    this.project,
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
  DataProject? project;
  List<AssignedResource>? assignedResources;
  List<Milestone>? milestone;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        projectId: json["project_id"],
        title: json["title"],
        phaseType: json["phase_type"],
        status: json["status"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        subTasks: List<SubTask>.from(
            json["sub_tasks"].map((x) => SubTask.fromJson(x))),
        project: DataProject.fromJson(json["project"]),
        assignedResources: List<AssignedResource>.from(
            json["assigned_resources"]
                .map((x) => AssignedResource.fromJson(x))),
        milestone: List<Milestone>.from(
            json["milestone"].map((x) => Milestone.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_id": projectId,
        "title": title,
        "phase_type": phaseType,
        "status": status,
        "start_date": startDate,
        "end_date": endDate,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "sub_tasks": List<dynamic>.from(subTasks!.map((x) => x.toJson())),
        "project": project!.toJson(),
        "assigned_resources":
            List<dynamic>.from(assignedResources!.map((x) => x.toJson())),
        "milestone": List<dynamic>.from(milestone!.map((x) => x.toJson())),
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
        id: json["id"],
        projectPhaseId: json["project_phase_id"],
        departmentId: json["department_id"],
        resourceId: json["resource_id"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        resource: Resource.fromJson(json["resource"]),
        department: Department.fromJson(json["department"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_phase_id": projectPhaseId,
        "department_id": departmentId,
        "resource_id": resourceId,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "resource": resource!.toJson(),
        "department": department!.toJson(),
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
  ResourceProject? project;
  dynamic? resource;
  List<Task>? tasks;

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
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
        project: ResourceProject.fromJson(json["project"]),
        resource: json["resource"],
        tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
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
        "project": project!.toJson(),
        "resource": resource,
        "tasks": List<dynamic>.from(tasks!.map((x) => x.toJson())),
      };
}

class ResourceProject {
  ResourceProject();

  factory ResourceProject.fromJson(Map<String, dynamic> json) =>
      ResourceProject();

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
        id: json["id"],
        milestoneTaskId: json["milestone_task_id"],
        departmentId: json["department_id"],
        resourceId: json["resource_id"],
        assignedDate: json["assigned_date"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "milestone_task_id": milestoneTaskId,
        "department_id": departmentId,
        "resource_id": resourceId,
        "assigned_date": assignedDate,
        "status": status,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
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
    this.subTasks,
  });

  int? id;
  int? projectPhaseId;
  String? title;
  int? status;
  String? mDate;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? subTasks;

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        id: json["id"],
        projectPhaseId: json["project_phase_id"],
        title: json["title"],
        status: json["status"],
        mDate: json["m_date"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        subTasks: List<dynamic>.from(json["sub_tasks"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_phase_id": projectPhaseId,
        "title": title,
        "status": status,
        "m_date": mDate,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "sub_tasks": List<dynamic>.from(subTasks!.map((x) => x)),
      };
}

class DataProject {
  DataProject({
    this.id,
    this.title,
    this.description,
    this.accountablePersonId,
    this.customerId,
    this.crmTaskId,
    this.workFolderId,
    this.budget,
    this.currency,
    this.estimationHours,
    this.status,
    this.startDate,
    this.deliveryDate,
    this.reminderDate,
    this.deadlineDate,
    this.workingDays,
    this.cost,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? title;
  String? description;
  int? accountablePersonId;
  int? customerId;
  String? crmTaskId;
  String? workFolderId;
  int? budget;
  String? currency;
  String? estimationHours;
  String? status;
  String? startDate;
  String? deliveryDate;
  String? reminderDate;
  String? deadlineDate;
  String? workingDays;
  String? cost;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;

  factory DataProject.fromJson(Map<String, dynamic> json) => DataProject(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        accountablePersonId: json["accountable_person_id"],
        customerId: json["customer_id"],
        crmTaskId: json["crm_task_id"],
        workFolderId: json["work_folder_id"],
        budget: json["budget"],
        currency: json["currency"],
        estimationHours: json["estimation_hours"],
        status: json["status"],
        startDate: json["start_date"],
        deliveryDate: json["delivery_date"],
        reminderDate: json["reminder_date"],
        deadlineDate: json["deadline_date"],
        workingDays: json["working_days"],
        cost: json["cost"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "accountable_person_id": accountablePersonId,
        "customer_id": customerId,
        "crm_task_id": crmTaskId,
        "work_folder_id": workFolderId,
        "budget": budget,
        "currency": currency,
        "estimation_hours": estimationHours,
        "status": status,
        "start_date": startDate,
        "delivery_date": deliveryDate,
        "reminder_date": reminderDate,
        "deadline_date": deadlineDate,
        "working_days": workingDays,
        "cost": cost,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
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

  factory SubTask.fromJson(Map<String, dynamic> json) => SubTask(
        id: json["id"],
        phaseId: json["phase_id"],
        phaseMilestoneId: json["phase_milestone_id"],
        title: json["title"],
        description: json["description"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phase_id": phaseId,
        "phase_milestone_id": phaseMilestoneId,
        "title": title,
        "description": description,
        "start_date": startDate,
        "end_date": endDate,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
