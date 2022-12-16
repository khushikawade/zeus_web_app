// To parse this JSON data, do
//
//     final departementModel = departementModelFromJson(jsonString);

import 'dart:convert';

DepartementModel departementModelFromJson(String str) => DepartementModel.fromJson(json.decode(str));

String departementModelToJson(DepartementModel data) => json.encode(data.toJson());

class DepartementModel {
    DepartementModel({
        this.status,
        this.message,
        this.data,
    });

    bool? status;
    String? message;
    List<DepartementData>? data;

    factory DepartementModel.fromJson(Map<String, dynamic> json) => DepartementModel(
        status: json["status"],
        message: json["message"],
        data: List<DepartementData>.from(json["data"].map((x) => DepartementData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class DepartementData {
    DepartementData({
        this.id,
        this.name,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    String? name;
    dynamic deletedAt;
    String? createdAt;
    String? updatedAt;

    factory DepartementData.fromJson(Map<String, dynamic> json) => DepartementData(
        id: json["id"],
        name: json["name"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
