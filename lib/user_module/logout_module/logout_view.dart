import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:vrouter/vrouter.dart';
import 'package:zeus/routers/route_constants.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/user_module/login_screen/login.dart';
import 'package:zeus/utility/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:zeus/utility/app_url.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../helper_widget/search_view.dart';

class LogOut extends StatefulWidget {
  final Offset offset;

  LogOut({this.offset = const Offset(180, 40), Key? key}) : super(key: key);

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
      offset: const Offset(-2, 20),
      color: const Color(0xff334155),
      tooltip: '',
      child: Container(
        width: 24.w,
        height: 24.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xff334155),
          border: Border.all(color: const Color(0xff334155)),
          borderRadius: BorderRadius.circular(
            10.r,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 3.sp),
          child: SvgPicture.asset(
            "images/drop_arrow.svg",
            width: 8.w,
            height: 5.h,
            alignment: Alignment.center,
          ),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 1,
          height: 30.h,
          child: InkWell(
            // hoverColor: Color(0xff1e293b),
            onTap: () {
              Navigator.pop(context);
              SmartDialog.showLoading(
                msg: "Your request is in progress please wait for a while...",
              );
              Future.delayed(const Duration(seconds: 2), () {
                LogOut();
              });
            },
            child: Padding(
              padding: EdgeInsets.only(left: 8.sp, right: 8.sp),
              child: Row(
                children: [
                  SizedBox(
                    width: 8.sp,
                  ),
                  Icon(Icons.logout),
                  SizedBox(
                    width: 8.sp,
                  ),
                  Text(
                    "LogOut",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter-Medium',
                        letterSpacing: 0.1,
                        fontStyle: FontStyle.normal,
                        color: ColorSelect.white_color),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  LogOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = '${AppUrl.logOut}';
    var token = 'Bearer ' + await AppUtil.getToken();

    var response = await http.get(
      Uri.parse(url),
      headers: {"Accept": "application/json", "Authorization": token},
    );

    if (response.statusCode == 200) {
      print("sucess");

      SmartDialog.dismiss();

      //storage.erase();
      sharedPreferences.clear();

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //         builder: (context) => LoginScreen(
      //               onSubmit: (String value) {},
      //             )),
      //     (Route<dynamic> route) => route is LoginScreen);
      //context.vxNav.popToRoot();
      context.vRouter.to(RouteConstants.loginRoute, isReplacement: true);
    } else if (response.statusCode == 401) {
      SmartDialog.dismiss();
      AppUtil.showErrorDialog(
          context, 'Your Session has been expired, Please try again!');
    } else {
      SmartDialog.dismiss();
      var user = userFromJson(response.body);
      Fluttertoast.showToast(
        timeInSecForIosWeb: 5,
        msg: user.message != null ? user.message! : 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
      SmartDialog.dismiss();
    }
  }
}
