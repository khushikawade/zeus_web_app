import '../project_detail_model/project_detail_response.dart';

class PeopleIdelResponse {
  bool? status;
  String? message;
  List<Data>? data;

  PeopleIdelResponse({this.status, this.message, this.data});

  PeopleIdelResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? title;

  int? accountablePersonId;
  int? customerId;
  String? crmTaskId;
  String? workFolderId;
  int? budget;
  String? currency;
  String? estimationHours;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deliveryDate;
  String? deadlineDate;
  List<Tags>? tags;

  AccountablePerson? accountablePerson;
  CustomerPerson? customer;
  Phase? currentPhase;

  Data({
    this.id,
    this.title,
    this.accountablePersonId,
    this.customerId,
    this.crmTaskId,
    this.workFolderId,
    this.budget,
    this.currency,
    this.estimationHours,
    this.createdAt,
    this.updatedAt,
    this.deliveryDate,
    this.deadlineDate,
    this.status,
    this.tags,
    this.accountablePerson,
    this.customer,
    this.currentPhase,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    accountablePersonId = json['accountable_person_id'];
    customerId = json['customer_id'];
    crmTaskId = json['crm_task_id'];
    workFolderId = json['work_folder_id'];
    budget = json['budget'];
    currency = json['currency'];
    estimationHours = json['estimation_hours'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryDate = json['delivery_date'];
    deadlineDate = json['deadline_date'];
    /*  if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) { tags!.add(tags!.fromJson(v)); });
    }*/
    /* if (json['project_resource'] != null) {
      projectResource = <Null>[];
      json['project_resource'].forEach((v) { projectResource!.add(new Null.fromJson(v)); });
    }*/
    accountablePerson = json['accountable_person'] != null
        ? new AccountablePerson.fromJson(json['accountable_person'])
        : null;
    customer = json['customer'] != null
        ? new CustomerPerson.fromJson(json['customer'])
        : null;
    /*if (json['phase'] != null) {
      phase = <Null>[];
      json['phase'].forEach((v) { phase!.add(new Null.fromJson(v)); });
    }*/
    currentPhase = json["current_phase"] == null
        ? null
        : Phase.fromJson(json["current_phase"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;

    data['accountable_person_id'] = this.accountablePersonId;
    data['customer_id'] = this.customerId;
    data['crm_task_id'] = this.crmTaskId;
    data['work_folder_id'] = this.workFolderId;
    data['budget'] = this.budget;
    data['currency'] = this.currency;
    data['estimation_hours'] = this.estimationHours;

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_date'] = this.deliveryDate;
    data['deadline_date'] = this.deadlineDate;
    /* if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v!.toJson()).toList();
    }*/
    /*if (this.projectResource != null) {
      data['project_resource'] = this.projectResource!.map((v) => v.toJson()).toList();
    }*/
    if (this.accountablePerson != null) {
      data['accountable_person'] = this.accountablePerson!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    /* if (this.phase != null) {
      data['phase'] = this.phase!.map((v) => v.toJson()).toList();
    }*/
    data['current_phase'] =
        currentPhase == null ? null : currentPhase!.toJson();
    return data;
  }
}

class AccountablePerson {
  int? id;
  String? name;
  String? email;

  int? type;

  String? createdAt;
  String? updatedAt;
  Project? project;

  AccountablePerson(
      {this.id,
      this.name,
      this.email,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.project});

  AccountablePerson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];

    type = json['type'];

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

    data['type'] = this.type;

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.project != null) {
      data['project'] = this.project!.toJson();
    }
    return data;
  }
}

class Tags {}

class CustomerPerson {
  int? id;
  String? name;
  String? email;

  int? type;

  String? createdAt;
  String? updatedAt;
  Project? project;
  String? image;

  CustomerPerson(
      {this.id,
      this.name,
      this.email,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.project,
      this.image});

  CustomerPerson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];

    type = json['type'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    project =
        json['project'] != null ? new Project.fromJson(json['project']) : null;
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;

    data['type'] = this.type;

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.project != null) {
      data['project'] = this.project!.toJson();
    }
    data['image'] = this.image;
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
