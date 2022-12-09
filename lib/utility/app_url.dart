import 'dart:core';
import 'package:zeus/services/api_client.dart';

class AppUrl {
  static const String baseUrl = ApiClient.BASE_URL;
  // 'http://zeusapitst.crebos.online/api/v1';

  static const String login = '$baseUrl/user/signin';
  static const String register = '$baseUrl/registration';
  static const String department = '$baseUrl/departments';
  static const String accountable_person = '$baseUrl/accountable-person';
  static const String customers = '$baseUrl/customer';
  static const String create_project = '$baseUrl/project';
  static const String department_list = '$baseUrl/departments';
  static const String currency = '$baseUrl/currencies';
  static const String search_skills = '$baseUrl/skills';
  static const String ideal_list = '$baseUrl/project';
  static const String people_list = '$baseUrl/resource';
  static const String project_details = '$baseUrl/project';
  static const String update_project = '$baseUrl/project';
  static const String tags_search = '$baseUrl/skills';
  static const String tags = '$baseUrl/tags';
  static const String abc = '$baseUrl/project/';
  static const String delete = '$baseUrl/resource/';
  static const String deleteForProject = '$baseUrl/project/';

  static const String searchLanguage = "$baseUrl/tags";
  static const String departmentResources = '/departments';
  static const String resourceNeeded = '/resource/';

  static const String deleteForphase = "$baseUrl/phase/";
  static const String logOut = "$baseUrl/signout";
  static const String createPhase = "/phase";
  static const String getPhase = "/phase/";
static const String updatePhase = "/phase/";


}
