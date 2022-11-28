import 'package:zeus/add_new_phase/model/mileston_model.dart';
import 'package:zeus/add_new_phase/model/resourcedata.dart';

import 'dart:convert';

PhaseDetails phaseDetailsFromJson(String str) =>
    PhaseDetails.fromJson(json.decode(str));

String phaseDetailsToJson(PhaseDetails data) => json.encode(data.toJson());

class PhaseDetails {
  String? project_id;
  String? title;

  String? phase_type;
  String? start_date;
  String? end_date;
  List<ResourceData>? resource;
  List<Milestones>? milestone;
  int? statusCode;
  String? error;

  PhaseDetails({
    this.project_id,
    this.title,
    this.phase_type,
    this.start_date,
    this.end_date,
    this.resource,
    this.milestone,
    this.error,
    this.statusCode,
  });

  PhaseDetails.fromJson(Map<String, dynamic> json) {
    project_id = json['project_id'];
    title = json['title'];
    phase_type = json['phase_type'];
    start_date = json['start_date'];
    end_date = json['end_date'];

    if (json['resource'] != null) {
      resource = <ResourceData>[];
      json['resource'].forEach((v) {
        resource!.add(ResourceData.fromJson(v));
      });
    }
    if (json['milestone'] != null) {
      milestone = <Milestones>[];
      json['milestone'].forEach((v) {
        milestone!.add(Milestones.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.project_id;
    data['title'] = this.title;
    data['phase_type'] = this.phase_type;
    data['start_date'] = this.start_date;
    data['end_date'] = this.end_date;

    if (this.resource != null) {
      data['resource'] = this.resource!.map((v) => v.toJson()).toList();
    }
    if (this.milestone != null) {
      data['milestone'] = this.milestone!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
