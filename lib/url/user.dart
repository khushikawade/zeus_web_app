import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class Response {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Response({this.id, this.name, this.createdAt, this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
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

class CategoryViewModel {
  static List<Response>? categories;

  static Future loadCategories() async {
    try {
      categories = <Response>[];
      String jsonString = await rootBundle.loadString('assets/categories.json');
      Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson['data'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        categories!.add(new Response.fromJson(categoryJson[i]));
      }
    } catch (e) {
      print(e);
    }
  }
}