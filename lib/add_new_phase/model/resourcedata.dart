class ResourceData {
  int? resource_id = 0;
  int? department_id = 0;
  String? resource_name = "";
  String? department_name = "";
  String? profileImage = "";

  ResourceData(
      {this.resource_id,
      this.department_id,
      this.resource_name,
      this.department_name,
      this.profileImage});

  ResourceData.fromJson(Map<String, dynamic> json) {
    resource_id = json['resource_id'];
    department_id = json['department_id'];
    resource_name = json['resource_name'];
    department_name = json['department_name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['resource_id'] = this.resource_id;
    data['department_id'] = this.department_id;
    data['resource_name'] = this.resource_name;
    data['department_name'] = this.department_name;

    return data;
  }
}
