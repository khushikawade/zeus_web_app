import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zeus/services/model/model_class.dart';
import 'package:zeus/services/response_model/project_idel_response.dart';
import 'package:zeus/services/response_model/project_detail_response.dart';
import 'package:zeus/services/response_model/tag_model/tagresponse.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/util.dart';
import '../utility/constant.dart';

class Service {
  Future<ProjectDetailsResponse?> getIdel(String? searchText) async {
    var token = 'Bearer ' + await AppUtil.getToken();
    try {
      var response = await http.get(
        Uri.parse(AppUrl.ideal_list + '?search=${searchText ?? ''}'),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        var res = response.body;

        ProjectDetailsResponse idel =
            ProjectDetailsResponse.fromJson(json.decode(res));
        return idel;

        final stringRes = JsonEncoder.withIndent('').convert(res);
        print(stringRes);
      } else {
        print("failed to much");
      }
    } catch (e) {}
    return null;
  }

  Future<PeopleList?> getpeopleList(String? searchText) async {
    var token = 'Bearer ' + await AppUtil.getToken();
    var response = await http.get(
      Uri.parse(AppUrl.people_list + '?search=${searchText ?? ''}'),
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
    return null;
  }

  Future<ProjectDetailResponse?> getIdelDetail(String id) async {
    var url = AppUrl.abc + id;
    var token = 'Bearer ' + await AppUtil.getToken();

    print("Token   ===   " + token);
    print("Token END ");
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
    return null;
  }

  Future<TagResponse?> getTag() async {
    var token = 'Bearer ' + await AppUtil.getToken();
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
    return null;
  }
}
