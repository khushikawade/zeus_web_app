
class CustomerResponse {
  bool? status;
  String? message;
  List<CustomerList>? data;

  CustomerResponse({this.status, this.message, this.data});

  CustomerResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CustomerList>[];
      json['data'].forEach((v) { data!.add(new CustomerList.fromJson(v)); });
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

class CustomerList {
  int? id;
  String? name;
  String? email;
  Null? emailVerifiedAt;
  Null? image;
  Null? phoneNumber;
  int? type;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;
  Project? project;

  CustomerList({this.id, this.name, this.email, this.emailVerifiedAt, this.image, this.phoneNumber, this.type, this.deletedAt, this.createdAt, this.updatedAt, this.project});

  CustomerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];
    phoneNumber = json['phone_number'];
    type = json['type'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    project = json['project_detail'] != null ? new Project.fromJson(json['project_detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['image'] = this.image;
    data['phone_number'] = this.phoneNumber;
    data['type'] = this.type;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.project != null) {
      data['project_detail'] = this.project!.toJson();
    }
    return data;
  }
}

class Project {


  Project();

Project.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
}