import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zeus/navigator_tabs/people_idle/model/model_class.dart';
import 'package:zeus/utility/util.dart';

import 'app_url.dart';

class MyDropdownData extends StatefulWidget {
  const MyDropdownData({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyDropdownDataState();
}

class _MyDropdownDataState extends State<MyDropdownData> {
  var data;
  var error = false;
  var message = "";

  Future<void> getData() async {
    final response = await http.get(Uri.parse(AppUrl.department));
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        setState(() {
          data = json.decode(response.body);
          if (data["error"]) {
            error = true;
            message = "data not found";
          } else {}
        });
      }
    } else if (response.statusCode == 401) {
      AppUtil.showErrorDialog(context);
    } else {
      setState(() {
        error = true;
        message = "error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
