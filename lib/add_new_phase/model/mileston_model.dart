import 'package:zeus/add_new_phase/model/subtask_model.dart';
import 'package:zeus/navigator_tabs/idle/project_detail_model/project_detail_response.dart';

class Milestones {
  String? title;
  String? m_date;

  // List<ResourceData>? resource;
  List<SubTasksModel>? sub_tasks;

  Milestones({
    this.title,
    this.m_date,
    this.sub_tasks,
  });

  Milestones.fromJson(Map<String, dynamic> json) {
    title = json['title'];

    m_date = json['m_date'];

    if (json['sub_tasks'] != null) {
      sub_tasks = <SubTasksModel>[];
      json['sub_tasks'].forEach((v) {
        sub_tasks!.add(SubTasksModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = this.title;
    data['m_date'] = this.m_date;

    if (this.sub_tasks != null) {
      data['sub_tasks'] = this.sub_tasks!.map((v) => v.toJson()).toList();
    }

    // if (this.milestone != null) {
    //   data['milestone'] = this.milestone!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
