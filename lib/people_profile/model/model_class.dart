
class ProfileResponce {
  bool? status;
  String? message;
  Data? data;

  ProfileResponce({this.status, this.message, this.data});

  ProfileResponce.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  Null emailVerifiedAt;
  Null image;
  String? phoneNumber;
  int? type;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  Project? project;
  Resource? resource;

  Data({this.id, this.name, this.email, this.emailVerifiedAt, this.image, this.phoneNumber, this.type, this.deletedAt, this.createdAt, this.updatedAt, this.project, this.resource});

  Data.fromJson(Map<String, dynamic> json) {
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
    project = json['project'] != null ?  Project.fromJson(json['project']) : null;
    resource = json['resource'] != null ?  Resource.fromJson(json['resource']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['image'] = image;
    data['phone_number'] = phoneNumber;
    data['type'] = type;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (project != null) {
      data['project'] = project!.toJson();
    }
    if (resource != null) {
      data['resource'] = resource!.toJson();
    }
    return data;
  }
}

class Project {

Project.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
}

class Resource {
  int? id;
  String? nickname;
  String? bio;
  int? userId;
  String? designation;
  int? departmentId;
  String?  associate;
  int? salary;
  String? salaryCurrency;
  String? availibiltyDay;
  String? availibiltyTime;
  String? country;
  String? city;
  String? timeZone;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;

  Resource({this.id, this.nickname, this.bio, this.userId, this.designation, this.departmentId, this.associate, this.salary, this.salaryCurrency, this.availibiltyDay, this.availibiltyTime, this.country, this.city, this.timeZone, this.deletedAt, this.createdAt, this.updatedAt});

  Resource.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    bio = json['bio'];
    userId = json['user_id'];
    designation = json['designation'];
    departmentId = json['department_id'];
    associate = json['associate'];
    salary = json['salary'];
    salaryCurrency = json['salary_currency'];
    availibiltyDay = json['availibilty_day'];
    availibiltyTime = json['availibilty_time'];
    country = json['country'];
    city = json['city'];
    timeZone = json['time_zone'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['nickname'] = nickname;
    data['bio'] = bio;
    data['user_id'] = userId;
    data['designation'] = designation;
    data['department_id'] = departmentId;
    data['associate'] = associate;
    data['salary'] = salary;
    data['salary_currency'] = salaryCurrency;
    data['availibilty_day'] = availibiltyDay;
    data['availibilty_time'] = availibiltyTime;
    data['country'] = country;
    data['city'] = city;
    data['time_zone'] = timeZone;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}