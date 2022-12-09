// To parse this JSON data, do
//
//     final createPhaseResp = createPhaseRespFromJson(jsonString);

import 'dart:convert';

CreatePhaseResp createPhaseRespFromJson(String str) => CreatePhaseResp.fromJson(json.decode(str));

String createPhaseRespToJson(CreatePhaseResp data) => json.encode(data.toJson());

class CreatePhaseResp {
  CreatePhaseResp({
    this.status,
    this.message,
    this.statusCode,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;
  int?statusCode;

  factory CreatePhaseResp.fromJson(Map<String, dynamic> json) => CreatePhaseResp(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
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
    subTasks: json["sub_tasks"] == null ? null : List<SubTask>.from(json["sub_tasks"].map((x) => SubTask.fromJson(x))),
    project: json["project_detail"] == null ? null : DataProject.fromJson(json["project_detail"]),
    assignedResources: json["assigned_resources"] == null ? null : List<AssignedResource>.from(json["assigned_resources"].map((x) => AssignedResource.fromJson(x))),
    milestone: json["milestone"] == null ? null : List<Milestone>.from(json["milestone"].map((x) => Milestone.fromJson(x))),
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
    "sub_tasks": subTasks == null ? null : List<dynamic>.from(subTasks!.map((x) => x.toJson())),
    "project_detail": project == null ? null : project!.toJson(),
    "assigned_resources": assignedResources == null ? null : List<dynamic>.from(assignedResources!.map((x) => x.toJson())),
    "milestone": milestone == null ? null : List<dynamic>.from(milestone!.map((x) => x.toJson())),
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

  factory AssignedResource.fromJson(Map<String, dynamic> json) => AssignedResource(
    id: json["id"] == null ? null : json["id"],
    projectPhaseId: json["project_phase_id"] == null ? null : json["project_phase_id"],
    departmentId: json["department_id"] == null ? null : json["department_id"],
    resourceId: json["resource_id"] == null ? null : json["resource_id"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
    resource: json["resource"] == null ? null : Resource.fromJson(json["resource"]),
    department: json["department"] == null ? null : Department.fromJson(json["department"]),
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
    project: json["project_detail"] == null ? null : ResourceProject.fromJson(json["project_detail"]),
    resource: json["resource"],
    tasks: json["tasks"] == null ? null : List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
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
    "project_detail": project == null ? null : project!.toJson(),
    "resource": resource,
    "tasks": tasks == null ? null : List<dynamic>.from(tasks!.map((x) => x.toJson())),
  };
}

class ResourceProject {
  ResourceProject();

  factory ResourceProject.fromJson(Map<String, dynamic> json) => ResourceProject(
  );

  Map<String, dynamic> toJson() => {
  };
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
    milestoneTaskId: json["milestone_task_id"] == null ? null : json["milestone_task_id"],
    departmentId: json["department_id"] == null ? null : json["department_id"],
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
    id: json["id"] == null ? null : json["id"],
    projectPhaseId: json["project_phase_id"] == null ? null : json["project_phase_id"],
    title: json["title"] == null ? null : json["title"],
    status: json["status"] == null ? null : json["status"],
    mDate: json["m_date"] == null ? null : json["m_date"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
    subTasks: json["sub_tasks"] == null ? null : List<dynamic>.from(json["sub_tasks"].map((x) => x)),
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
    "sub_tasks": subTasks == null ? null : List<dynamic>.from(subTasks!.map((x) => x)),
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
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    accountablePersonId: json["accountable_person_id"] == null ? null : json["accountable_person_id"],
    customerId: json["customer_id"] == null ? null : json["customer_id"],
    crmTaskId: json["crm_task_id"] == null ? null : json["crm_task_id"],
    workFolderId: json["work_folder_id"] == null ? null : json["work_folder_id"],
    budget: json["budget"] == null ? null : json["budget"],
    currency: json["currency"] == null ? null : json["currency"],
    estimationHours: json["estimation_hours"] == null ? null : json["estimation_hours"],
    status: json["status"] == null ? null : json["status"],
    startDate: json["start_date"] == null ? null : json["start_date"],
    deliveryDate: json["delivery_date"] == null ? null : json["delivery_date"],
    reminderDate: json["reminder_date"] == null ? null : json["reminder_date"],
    deadlineDate: json["deadline_date"] == null ? null : json["deadline_date"],
    workingDays: json["working_days"] == null ? null : json["working_days"],
    cost: json["cost"] == null ? null : json["cost"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : json["created_at"],
    updatedAt: json["updated_at"] == null ? null : json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "accountable_person_id": accountablePersonId == null ? null : accountablePersonId,
    "customer_id": customerId == null ? null : customerId,
    "crm_task_id": crmTaskId == null ? null : crmTaskId,
    "work_folder_id": workFolderId == null ? null : workFolderId,
    "budget": budget == null ? null : budget,
    "currency": currency == null ? null : currency,
    "estimation_hours": estimationHours == null ? null : estimationHours,
    "status": status == null ? null : status,
    "start_date": startDate == null ? null : startDate,
    "delivery_date": deliveryDate == null ? null : deliveryDate,
    "reminder_date": reminderDate == null ? null : reminderDate,
    "deadline_date": deadlineDate == null ? null : deadlineDate,
    "working_days": workingDays == null ? null : workingDays,
    "cost": cost == null ? null : cost,
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
  };
}
