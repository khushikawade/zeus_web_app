import 'dart:convert';

import 'package:zeus/add_new_phase/model/phase_details.dart';
import 'package:zeus/add_new_phase/model/resources_needed.dart';
import 'package:zeus/services/api_client.dart';

import 'package:http/http.dart';
import 'package:zeus/services/responce_model/create_phase_resp.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/constants.dart';
import 'package:zeus/utility/util.dart';

import '../utility/constant.dart';

class Api {
  AppUrl appUrl = AppUrl();
  final ApiClient _apiClient = ApiClient();

  registerUser(
    //createPhase
    var body,
  ) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return PhaseDetails(error: Constants.noInternet, statusCode: 401);
    }

    Response response =
        await _apiClient.postMethod(AppUrl.create_project, body);
    if (response.statusCode == 200) {
      try {
        if (response.body.contains('error')) {
          var jsonResponse = json.decode(response.body);
          return PhaseDetails(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          PhaseDetails resp =
              PhaseDetails.fromJson(jsonDecode(response.body.toString()));
          resp.statusCode = response.statusCode;
          return resp;
        }
      } catch (e) {
        print(e);
        return PhaseDetails(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      return PhaseDetails(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  getDeparment() async {
    List department = [];
    bool internet = await AppUtil.checkNetwork();
    // if (!internet) {
    //   return SearchResponse(error: Constants.noInternet, statusCode: 501);
    // }

    Response response = await _apiClient.getMethod(AppUrl.departmentResources);
    // if (response.statusCode == 200) {
    //   try {
    //     if (response.body.contains('error')) {
    //       var jsonResponse = json.decode(response.body);
    //       return SearchResponse(
    //           error: jsonResponse['error']['message'], statusCode: 500);
    //     } else {
    //       SearchResponse resp =
    //           SearchResponse.fromJson(jsonDecode(response.body.toString()));
    //       resp.statusCode = response.statusCode;
    //       return resp;
    //     }
    //   } catch (e) {
    //     print(e);
    //     return SearchResponse(
    //         error: Constants.somethingWentWorng, statusCode: 500);
    //   }
    // } else {
    //   return SearchResponse(
    //       error: Constants.somethingWentWorng, statusCode: response.statusCode);
    // }

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body.toString());
      List<dynamic> mdata = map["data"];
      department = mdata;
      return department;
    } else {
      print('department error===========>>>>>>>>');
      print("failed to much");
    }
  }

  // //Call Api for Get Product Sub Categoruy
  Future<ResourceNeededModel> getResourceNeeded(String key) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return ResourceNeededModel(error: Constants.noInternet, statusCode: 401);
    }
    print('<<<<<<<<<<<<<<<<<<<<<resource data>>>>>>>>>>>>>>>>>>>>>');
    print(AppUrl.resourceNeeded + "search?type=$key");
    Response response =
        await _apiClient.getMethod(AppUrl.resourceNeeded + "search?type=$key");
    if (response.statusCode == 200) {
      try {
        if (response.body.contains('error')) {
          var jsonResponse = json.decode(response.body);
          return ResourceNeededModel(
              error: jsonResponse['error']['message'], statusCode: 500);
        } else {
          var resourceNeededModel = resourceNeededModelFromJson(response.body);
          print(resourceNeededModel);
          return resourceNeededModel;
        }
      } catch (e) {
        print(e);
        return ResourceNeededModel(
            error: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      return ResourceNeededModel(
          error: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }

  // //Call Api for Get Product Sub Categoruy
  Future<CreatePhaseResp> createNewPhase(String key) async {
    bool internet = await AppUtil.checkNetwork();
    if (!internet) {
      return CreatePhaseResp(message: Constants.noInternet, statusCode: 401);
    }
    Response? response;
    try{
       response = await _apiClient.postMethod(AppUrl.createPhase, key);
       print('<<<<<<<<<<<<<<<<<<<<<<<    response.body      >>>>>>>>>>>>>>>>>>>>>>>');
       print(response.body);
    }
    catch(e){
      print(e);
    }

    if (response!.statusCode == 200) {
      try {
        if (response.body.contains('error')) {
          var jsonResponse = json.decode(response.body);
          return CreatePhaseResp(
              message: jsonResponse['error']['message'], statusCode: 500);
        } else {
          CreatePhaseResp resourceNeededModel = createPhaseRespFromJson(response.body);
          resourceNeededModel.statusCode=200;
          return resourceNeededModel;
        }
      } catch (e) {
        print(e);
        return CreatePhaseResp(
            message: Constants.somethingWentWorng, statusCode: 500);
      }
    } else {
      return CreatePhaseResp(
          message: Constants.somethingWentWorng, statusCode: response.statusCode);
    }
  }
}
