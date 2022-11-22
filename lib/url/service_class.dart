import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:zeus/utility/app_url.dart';
import '../navigation/tag_model/tagresponse.dart';
import '../navigator_tabs/idle/project_detail_model/project_detail_response.dart';
import '../navigator_tabs/idle/project_idel_model/project_idel_response.dart';
import '../navigator_tabs/people_idle/model/model_class.dart';
import '../utility/constant.dart';

class Service {
  Future<PeopleIdelResponse?> getIdel() async {
    var token = 'Bearer ' + storage.read("token");
    try {
      var response = await http.get(
        Uri.parse(AppUrl.ideal_list),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        var res = response.body;

        PeopleIdelResponse idel = PeopleIdelResponse.fromJson(json.decode(res));
        return idel;

        final stringRes = JsonEncoder.withIndent('').convert(res);
        print(stringRes);
      } else {
        print("failed to much");
      }
    } catch (e) {}
  }

  Future<PeopleList?> getpeopleList() async {
    var token = 'Bearer ' + storage.read("token");
    var response = await http.get(
      Uri.parse(AppUrl.people_list),
      headers: {
        "Accept": "application/json",
        "Authorization": token,
      },
    );
    if (response.statusCode == 200) {
      var res = response.body;
      print('resorceslist' + res);
      PeopleList peopleList = PeopleList.fromJson(json.decode(res));

      return peopleList;
    } else {
      print(response.statusCode);
      print(response.body);
      print("failed to much");
    }
  }

  Future<ProjectDetailResponse?> getIdelDetail(String id) async {
    var url = AppUrl.abc + id;
    var token = 'Bearer ' + storage.read("token");
    print("idd  urll   ===   " + url);
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": token,
      },
    );
    if (response.statusCode == 200) {
      var res = response.body;
      print('IdealProjectDataComming' + res);
      ProjectDetailResponse idel =
          ProjectDetailResponse.fromJson(json.decode(res));
      return idel;

      final stringRes = const JsonEncoder.withIndent('').convert(res);
      print(stringRes);
    } else {
      print("failed to responce ideal detail");
    }
  }

  Future<TagResponse?> getTag() async {
    var token = 'Bearer ' + storage.read("token");
    try {
      var response = await http.get(
        Uri.parse(AppUrl.tags),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        var res = response.body;

        TagResponse tagResponse = TagResponse.fromJson(json.decode(res));
        return tagResponse;

        final stringRes = JsonEncoder.withIndent('').convert(res);
        print(stringRes);
      } else {
        print("failed to much");
      }
    } catch (e) {}
  }
}
