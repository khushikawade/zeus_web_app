import 'package:zeus/utility/app_url.dart';

import 'dart:async';
import 'package:http/http.dart' as http;

import '../utility/constant.dart';

class ApiClient {
  AppUrl appUrl = AppUrl();
  static const BASE_URL = "https://zeus-api.zehntech.net/api/v1";

  Future<http.Response> postMethod(String method, var body,
      {Map<String, String>? header1}) async {
    Map<String, String>? header = Map();
    try {
      var token = storage.read("token");
      var token1 = 'Bearer ' + token;
      header['Authorization'] = token1;
      header['Content-Type'] = "application/json";
      print(header);
      print(body);
      print("HELLO");
    } catch (e) {
      print(e);
    }
    http.Response response = await http.post(Uri.parse(BASE_URL + method),
        body: body, headers: header);
    print('___${response.body.toString()}');
    return response;
  }

  Future<http.Response> putMethod(String method, var body,
      {Map<String, String>? header1}) async {
    Map<String, String>? header = Map();
    try {
      var token = storage.read("token");
      var token1 = 'Bearer ' + token;
      header['Authorization'] = token1;
      header['Content-Type'] = "application/json";
      print(header);
      print(body);
      print("HELLO");
    } catch (e) {
      print(e);
    }
    http.Response response = await http.put(Uri.parse(BASE_URL + method),
        body: body, headers: header);
    print('___${response.body.toString()}');
    return response;
  }

  Future<http.Response> getMethod(String url,
      {Map<String, String>? header}) async {
    var token = 'Bearer ' + storage.read("token");

    http.Response response =
        await http.get(Uri.parse(BASE_URL + url), headers: {
      "Content-Type": "application/json",
      "Authorization": token,
    });

    return response;
  }
}
