// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';
import 'package:zeus/helper_widget/delete_dialog.dart';
import 'package:zeus/helper_widget/responsive.dart';
import 'package:zeus/login_screen/login.dart';
import 'package:zeus/navigation/navigation.dart';
import 'package:zeus/navigator_tabs/idle/project_detail_model/project_detail_response.dart';
import 'package:zeus/navigator_tabs/people_idle/model/model_class.dart';
import 'package:zeus/people_profile/screen/people_detail_view.dart';
import 'package:zeus/utility/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/pop_resource_button.dart';
import 'package:zeus/helper_widget/searchbar.dart';
import 'package:zeus/navigation/tag_model/tag_user.dart';
import 'package:zeus/navigation/tag_model/tagresponse.dart';
import 'package:zeus/people_profile/editpage/edit_page.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/dropdrowndata.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:zeus/utility/upertextformate.dart';
import '../DemoContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/scrollbar_helper_widget.dart';
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
      offset: const Offset(0, 59),
      color: const Color(0xff334155),
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
          top: 26.0,
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
          value: 1,
          child: InkWell(
            // hoverColor: Colors.red,
            onTap: () {
              Colors.red;

              LogOut();
            },
            child: Row(
              children: const [
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

      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
        return LoginScreen(
          onSubmit: (String value) {},
        );
      })));
    } else {
      var user = userFromJson(response.body);
      Fluttertoast.showToast(
        msg: user.message != null ? user.message! : 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
      SmartDialog.dismiss();
    }
  }
}
