class PeopleList {
  bool? status;
  String? message;
  List<PeopleData>? data;

  PeopleList({this.status, this.message, this.data});

  PeopleList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PeopleData>[];
      json['data'].forEach((v) {
        data!.add(PeopleData.fromJson(v));
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

class PeopleData {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  int? type;
  String? createdAt;
  String? updatedAt;
  String? image;
  Project? project;
  Resource? resource;

  PeopleData(
      {this.id,
      this.name,
      this.image,
      this.email,
      this.phoneNumber,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.project,
      this.resource});

  PeopleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    image = json['image'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    project = json['project_detail'] != null
        ? new Project.fromJson(json['project_detail'])
        : null;
    resource = json['resource'] != null
        ? new Resource.fromJson(json['resource'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    data['updated_at'] = this.updatedAt;
    if (this.project != null) {
      data['project_detail'] = this.project!.toJson();
    }
    if (this.resource != null) {
      data['resource'] = this.resource!.toJson();
    }
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

class Resource {
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
  String? createdAt;
  String? updatedAt;
  Department? department;
  List<Skills>? skills;

  Resource(
      {this.id,
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
      this.createdAt,
      this.updatedAt,
      this.department,
      this.skills});

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
    capacity = json["capacity"];
    country = json['country'];
    city = json['city'];
    timeZone = json['time_zone'] != null
        ? new TimeZone.fromJson(json['time_zone'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    if (json['skills'] != null) {
      skills = <Skills>[];
      json['skills'].forEach((v) {
        skills!.add(new Skills.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['bio'] = this.bio;
    data['user_id'] = this.userId;
    data['designation'] = this.designation;
    data['department_id'] = this.departmentId;
    data['associate'] = this.associate;
    data['salary'] = this.salary;
    data['salary_currency'] = this.salaryCurrency;
    data['availibilty_day'] = this.availibiltyDay;
    data['availibilty_time'] = this.availibiltyTime;
    data['capacity'] = this.capacity;
    data['country'] = this.country;
    data['city'] = this.city;
    if (this.timeZone != null) {
      data['time_zone'] = this.timeZone!.toJson();
    }

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    if (this.skills != null) {
      data['skills'] = this.skills!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeZone {
  int? id;
  String? name;
  String? offset;
  String? diffFromGtm;
  String? createdAt;
  String? updatedAt;

  TimeZone(
      {this.id,
      this.name,
      this.offset,
      this.diffFromGtm,
      this.createdAt,
      this.updatedAt});

  TimeZone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    offset = json['offset'];
    diffFromGtm = json['diff_from_gtm'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['offset'] = this.offset;
    data['diff_from_gtm'] = this.diffFromGtm;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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

class Skills {
  int? id;
  int? resourceId;
  String? title;
  String? createdAt;
  String? updatedAt;

  Skills(
      {this.id, this.resourceId, this.title, this.createdAt, this.updatedAt});

  Skills.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resourceId = json['resource_id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['resource_id'] = this.resourceId;
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
