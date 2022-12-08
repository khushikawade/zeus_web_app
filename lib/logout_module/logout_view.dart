// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:zeus/login_screen/login.dart';
import 'package:zeus/utility/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';
import '../DemoContainer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:zeus/utility/app_url.dart';

class LogOut extends StatefulWidget {
  final Function? returnValue;
  final Offset offset;

  LogOut({this.returnValue, this.offset = const Offset(180, 40), Key? key})
      : super(key: key);

  @override
  State<LogOut> createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      position: PopupMenuPosition.under,
      offset: widget.offset,
      color: const Color(0xff334155),
      // padding: const EdgeInsets.only(
      //   left: 50,
      //   top: 20,
      // ),
      tooltip: '',
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          color: const Color(0xff334155),
          border: Border.all(color: const Color(0xff334155)),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        margin: const EdgeInsets.only(
          top: 16.0,
          left: 8.0,
          right: 20.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SvgPicture.asset(
            "images/drop_arrow.svg",
          ),
        ),
      ),

      itemBuilder: (context) => [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 1,
          child: InkWell(
            hoverColor: Color(0xff1e293b),
            onTap: () {
              Colors.red;
              SmartDialog.showLoading(
                msg: "Your request is in progress please wait for a while...",
              );
              Future.delayed(const Duration(seconds: 2), () {
                LogOut();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: const [
                  SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.logout),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "LogOut",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                        color: ColorSelect.white_color),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      // child: Text(widget.title),
    );
  }

  LogOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = '${AppUrl.logOut}';
    var token = 'Bearer ' + storage.read("token");

    var response = await http.get(
      Uri.parse(url),
      headers: {"Accept": "application/json", "Authorization": token},
    );

    if (response.statusCode == 200) {
      print("sucess");

      SmartDialog.dismiss();

      widget.returnValue!();
      storage.erase();
      sharedPreferences.clear();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => LoginScreen(
                    onSubmit: (String value) {},
                  )),
          (Route<dynamic> route) => route is LoginScreen);
    } else if (response.statusCode == 401) {
      SmartDialog.dismiss();
      AppUtil.showErrorDialog(context);
    } else {
      SmartDialog.dismiss();
      var user = userFromJson(response.body);
      Fluttertoast.showToast(
        msg: user.message != null ? user.message! : 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
      SmartDialog.dismiss();
    }
  }
}
