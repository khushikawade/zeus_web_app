class ProjectDetailResponse {
  bool? status;
  String? message;
  ProjectDetailData? data;

  ProjectDetailResponse({this.status, this.message, this.data});

  ProjectDetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ProjectDetailData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProjectDetailData {
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
  String? deliveryDate;
  String? status;
  String? reminderDate;
  String? deadlineDate;
  String? startDate;
  String? workingDays;
  String? cost;
  String? createdAt;
  String? updatedAt;
  List<Tags>? tags;
  AccountableCustomer? accountablePerson;
  AccountableCustomer? customer;
  List<Phase>? phase;

  ProjectDetailData({
    this.id,
    this.status,
    this.title,
    this.description,
    this.accountablePersonId,
    this.customerId,
    this.crmTaskId,
    this.workFolderId,
    this.budget,
    this.currency,
    this.estimationHours,
    this.deliveryDate,
    this.reminderDate,
    this.deadlineDate,
    this.startDate,
    this.workingDays,
    this.cost,
    this.createdAt,
    this.updatedAt,
    this.tags,
    this.accountablePerson,
    this.customer,
    this.phase,
  });

  ProjectDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    accountablePersonId = json['accountable_person_id'];
    customerId = json['customer_id'];
    crmTaskId = json['crm_task_id'];
    workFolderId = json['work_folder_id'];
    status = json['status'];
    budget = json['budget'];
    currency = json['currency'];
    estimationHours = json['estimation_hours'];
    deliveryDate = json['delivery_date'];
    reminderDate = json['reminder_date'];
    deadlineDate = json['deadline_date'];
    startDate = json['start_date'];
    workingDays = json['working_days'];
    cost = json['cost'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
    /*if (json['project_resource'] != null) {
      projectResource = new List<Null>();
      json['project_resource'].forEach((v) { projectResource.add(new Null.fromJson(v)); });
    }*/
    accountablePerson = json['accountable_person'] != null
        ? new AccountableCustomer.fromJson(json['accountable_person'])
        : null;
    customer = json['customer'] != null
        ? new AccountableCustomer.fromJson(json['customer'])
        : null;
    if (json['phase'] != null) {
      phase = <Phase>[];
      json['phase'].forEach((v) {
        phase!.add(new Phase.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['accountable_person_id'] = this.accountablePersonId;
    data['customer_id'] = this.customerId;
    data['crm_task_id'] = this.crmTaskId;
    data['work_folder_id'] = this.workFolderId;
    data['budget'] = this.budget;
    data['currency'] = this.currency;
    data['estimation_hours'] = this.estimationHours;
    data['status'] = this.status;

    data['delivery_date'] = this.deliveryDate;
    data['reminder_date'] = this.reminderDate;
    data['deadline_date'] = this.deadlineDate;
    data['working_days'] = this.workingDays;
    data['cost'] = this.cost;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    /* if (this.projectResource != null) {
      data['project_resource'] = this.projectResource.map((v) => v.toJson()).toList();
    }*/
    if (this.accountablePerson != null) {
      data['accountable_person'] = this.accountablePerson!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.phase != null) {
      data['phase'] = this.phase!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Tags {
  int? id;
  int? projectId;
  String? name;
  String? createdAt;
  String? updatedAt;

  Tags({this.id, this.projectId, this.name, this.createdAt, this.updatedAt});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_id'] = this.projectId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AccountableCustomer {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? image;
  int? type;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Project? project;

  AccountableCustomer(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.image,
      this.type,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.project});

  AccountableCustomer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];

    type = json['type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    project =
        json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['image'] = this.image;
    data['type'] = this.type;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    /*if (this.project != null) {
      data['project'] = this.project.toJson();
    }*/
    return data;
  }
}

class Project {
  Project();

  Project.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Phase {
  int? id;
  int? projectId;
  String? title;
  String? phaseType;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  List<AssignedResources>? assignedResources;
  List<Milestone>? milestone;
  Milestone? currentMilestone;

  Phase(
      {this.id,
      this.projectId,
      this.title,
      this.phaseType,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt,
      this.assignedResources,
      this.milestone,
      this.currentMilestone});

  Phase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    title = json['title'];
    phaseType = json['phase_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    /*if (json['assigned_resources'] != null) {
      assignedResources = new List<AssignedResources>();
      json['assigned_resources'].forEach((v) { assignedResources.add(new AssignedResources.fromJson(v)); });
    }
    if (json['milestone'] != null) {
      milestone = new List<Milestone>();
      json['milestone'].forEach((v) { milestone.add(new Milestone.fromJson(v)); });
    }*/
    currentMilestone = json["current_milestone"] == null
        ? null
        : Milestone.fromJson(json["current_milestone"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_id'] = this.projectId;
    data['title'] = this.title;
    data['phase_type'] = this.phaseType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    /*  if (this.assignedResources != null) {
      data['assigned_resources'] = this.assignedResources.map((v) => v.toJson()).toList();
    }
    if (this.milestone != null) {
      data['milestone'] = this.milestone.map((v) => v.toJson()).toList();
    }*/
    data['current_milestone'] =
        currentMilestone == null ? null : currentMilestone!.toJson();
    return data;
  }
}

class AssignedResources {
  int? id;
  int? projectPhaseId;
  int? departmentId;
  int? resourceId;
  String? createdAt;
  String? updatedAt;
  Resource? resource;
  Department? department;

  AssignedResources(
      {this.id,
      this.projectPhaseId,
      this.departmentId,
      this.resourceId,
      this.createdAt,
      this.updatedAt,
      this.resource,
      this.department});

  AssignedResources.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectPhaseId = json['project_phase_id'];
    departmentId = json['department_id'];
    resourceId = json['resource_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    resource = json['resource'] != null
        ? new Resource.fromJson(json['resource'])
        : null;
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_phase_id'] = this.projectPhaseId;
    data['department_id'] = this.departmentId;
    data['resource_id'] = this.resourceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    /*if (this.resource != null) {
      data['resource'] = this.resource.toJson();
    }
    if (this.department != null) {
      data['department'] = this.department.toJson();
    }*/
    return data;
  }
}

class Resource {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? image;

  int? type;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Project? project;

  Resource(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.image,
      this.type,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.project});

  Resource.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];
    type = json['type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    project =
        json['project'] != null ? new Project.fromJson(json['project']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['image'] = this.image;
    data['type'] = this.type;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    /* if (this.project != null) {
      data['project'] = this.project.toJson();
    }*/
    return data;
  }
}

class Department {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Department({this.id, this.name, this.createdAt, this.updatedAt});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Milestone {
  int? id;
  int? projectPhaseId;
  String? title;
  String? mDate;
  String? createdAt;
  String? updatedAt;
  List<SubTasks>? subTasks;

  Milestone(
      {this.id,
      this.projectPhaseId,
      this.title,
      this.mDate,
      this.createdAt,
      this.updatedAt,
      this.subTasks});

  Milestone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectPhaseId = json['project_phase_id'];
    title = json['title'];
    mDate = json['m_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    /* if (json['sub_tasks'] != null) {
      subTasks = new List<SubTasks>();
      json['sub_tasks'].forEach((v) { subTasks.add(new SubTasks.fromJson(v)); });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_phase_id'] = this.projectPhaseId;
    data['title'] = this.title;
    data['m_date'] = this.mDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    /* if (this.subTasks != null) {
      data['sub_tasks'] = this.subTasks.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class SubTasks {
  int? id;
  int? phaseMilestoneId;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  AssignResource? assignResource;

  SubTasks(
      {this.id,
      this.phaseMilestoneId,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt,
      this.assignResource});

  SubTasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phaseMilestoneId = json['phase_milestone_id'];

    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    assignResource = json['assign_resource'] != null
        ? new AssignResource.fromJson(json['assign_resource'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phase_milestone_id'] = this.phaseMilestoneId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    /* if (this.assignResource != null) {
      data['assign_resource'] = this.assignResource.toJson();
    }*/
    return data;
  }
}

class AssignResource {
  int? id;
  int? milestoneTaskId;
  int? departmentId;
  int? resourceId;
  int? status;
  String? createdAt;
  String? updatedAt;
  Resource? resource;
  Department? department;

  AssignResource(
      {this.id,
      this.milestoneTaskId,
      this.departmentId,
      this.resourceId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.resource,
      this.department});

  AssignResource.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    milestoneTaskId = json['milestone_task_id'];
    departmentId = json['department_id'];
    resourceId = json['resource_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    resource = json['resource'] != null
        ? new Resource.fromJson(json['resource'])
        : null;
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['milestone_task_id'] = this.milestoneTaskId;
    data['department_id'] = this.departmentId;
    data['resource_id'] = this.resourceId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    /*if (this.resource != null) {
      data['resource'] = this.resource.toJson();
    }
    if (this.department != null) {
      data['department'] = this.department.toJson();
    }*/
    return data;
  }
}
