

import 'package:zeus/services/model/resourcedata.dart';

class SubTasksModel {
  String? start_date;
  String? end_date;
  ResourceData? resource;

  SubTasksModel({
    this.start_date,
    this.end_date,
    this.resource,
  });

  SubTasksModel.fromJson(Map<String, dynamic> json) {
    start_date = json['start_date'];
    end_date = json['end_date'];
    resource = json['resource'];


  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.start_date;
    data['end_date'] = this.end_date;

    if (this.resource != null) {
      data['resource'] = this.resource;
    }

  
    return data;
  }
}
