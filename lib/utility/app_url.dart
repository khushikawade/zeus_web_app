import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

class AppUrl {
  static const String baseUrl = 'https://zeus-api.zehntech.net/api/v1';
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
// static const String forgotPassword = baseUrl +

  // Future<String?> getAccountable() async {
  //   String? value;
  //   if (value == null) {
  //     var response = await http.get(
  //       Uri.parse('${AppUrl.baseUrl}/'),
  //       headers: {
  //         "Accept": "application/json",
  //         "Authorization":
  //             'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNzliY2M1NzFjNWFlNzMzNzkxMGY2ZWU0ZjU1YzBhYzA0ZDljNjdkNzhjZmJhZTNmYTAyOWFkOWIyZDY4NGIwOGZiMTFlMzIzNTM2YjFiNDQiLCJpYXQiOjE2NjIzMTY1MzIuNzczOTQ3LCJuYmYiOjE2NjIzMTY1MzIuNzczOTUxLCJleHAiOjE2OTM4NTI1MzIuNjU0NTE0LCJzdWIiOiIxMSIsInNjb3BlcyI6W119.1U8cAr8-DcLT3ZoqknGd3qSyjJZJiu89wxIgb8vsafP6z8rOOGkg7C9ZF3oDbZX4dwEeRlH9pCy_CKsUIL0_zizJHhbbDbn_IUXdhvJXizmBV2GE-W4XAzsExF-81_k02AY7nZ9y2u0ITzRKw-WyJe1zjvmQz5XJ9LEoz767o00u274XFzByGf42Xpd4S_RyRujJ9vGgqC72aIcgjQWr1KW2cJP7FRKlSAyml4NXfZqdjr8OT8ldgHHbBqBfVkGKZN3jpunLCl90VczGiQ-VewFcvdC264DI0uelBYHEW99oJeLmxTiBK5pl2pUAx-lULDdB-A68OvB0jsCOPtbbk0fjBSib0dMw9ckaZ7d69ug7976gIlJ_PYoL0_VehpYHtNVagaImGI7LWgE0RbJIg85SUshNZOi7NIdD3-VU1FFTVsnQfL9Pby8YNac9OeIbAY8n9s8AUFT8iVJKM1QRhqSvZIRx_5Gwdu1GELkoOo33cvwZEt0cpIloQvg8twk0KSvLw1XfEGmqJue1dGPk8NE1v_wtNwspptsUgqPejlFvXK-trJU9HBYpeNKXaBXSpdwWPnSLxzGF2m_isGeZtREwoYBCtQ2VNaKzFsdQHwRUguzQ84Td04VJKpi3j3lgT4TYoV24T5O47Dt1sNXfdTDsLPPWRn0bvR33B084WJc'
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> map = jsonDecode(response.body.toString());
  //     } else {
  //       print("failed to much");
  //     }
  //     return value;
  //   }
  // }
}
