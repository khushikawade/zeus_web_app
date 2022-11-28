class ResourceData {
  String? resource_id;
  String? department_id;
  String? resource_name;

  ResourceData({this.resource_id, this.department_id, this.resource_name});

  ResourceData.fromJson(Map<String, dynamic> json) {
    resource_id = json['resource_id'];
    department_id = json['department_id'];
    resource_name = json['resource_name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['resource_id'] = this.resource_id;
    data['department_id'] = this.department_id;
    data['resource_name'] = this.resource_name;

    return data;
  }
}
