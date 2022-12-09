
class Milestones {
  int? id;
  String? title="";
  String? m_date="";

  Milestones({
    this.title,
    this.m_date,
    this.id

  });

  Milestones.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    m_date = json['m_date'];
    id = json['id'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = this.title;
    data['m_date'] = this.m_date;
    data['id'] = this.id;

    // if (this.milestone != null) {
    //   data['milestone'] = this.milestone!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
