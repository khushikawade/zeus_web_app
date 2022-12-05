import 'package:zeus/add_new_phase/model/subtask_model.dart';
import 'package:zeus/navigator_tabs/idle/project_detail_model/project_detail_response.dart';

class Milestones {
  String? title="";
  String? m_date="";

  Milestones({
    this.title,
    this.m_date,

  });

  Milestones.fromJson(Map<String, dynamic> json) {
    title = json['title'];

    m_date = json['m_date'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = this.title;
    data['m_date'] = this.m_date;

    // if (this.milestone != null) {
    //   data['milestone'] = this.milestone!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
