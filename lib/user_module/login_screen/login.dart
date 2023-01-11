import 'dart:convert';
import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';
import 'package:zeus/helper_widget/custom_form_field.dart';
import 'package:zeus/helper_widget/responsive.dart';
import 'package:zeus/helper_widget/textformfield.dart';
import 'package:zeus/home_module/home_page.dart';
import 'package:zeus/routers/route_constants.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/colors.dart';
import 'package:zeus/utility/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeus/utility/util.dart';
import 'dart:html' as html;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:html' as html;

class LoginScreen extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  LoginScreen({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  bool _submitted = false;
  String _name = '';
  bool enableClickupLogin = false;

  var _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _submit() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_name);
    }
  }

  @override
  void initState() {
    if (html.window.location.toString().contains("?code=")) {
      String url = html.window.location.href;
      Uri stringUri = Uri.parse(url);
      String authenticationCode = stringUri.queryParameters["code"]!;
      print("Contains code --------------------------------------- ");
      print("Code value --------------------- ${authenticationCode}");
      callSaveCodeAPI(authenticationCode);
    } else {
      print("Not contained --------------------------------------");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return Material(
      child: MediaQuery(
        data: mediaQueryData.copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: const Color(0xff0F172A),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 26.sp, bottom: 26.sp),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset(
                        'images/logo.svg',
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Text(
                        "Welcome to",
                        style: TextStyle(
                            color: ColorSelect.text_color,
                            fontSize: 14.sp,
                            letterSpacing: 0.1,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Inter-Medium',
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Zestful Empowering Utilization System",
                        style: TextStyle(
                            color: ColorSelect.white_color,
                            fontSize: 22.sp,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.1,
                            fontFamily: 'Inter-Bold',
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 25.sp,
                            right: 25.sp,
                            top: 40.sp,
                            bottom: 30.sp),
                        width: 560.w,
                        //height: 340.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: ColorSelect.peoplelistbackgroundcolor),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                  color: ColorSelect.white_color,
                                  fontSize: 20.sp,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.1,
                                  fontFamily: 'Inter-Bold',
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            CustomFormField(
                              controller: emailController,
                              hint: 'Enter email address',
                              label: "Email address",
                              validator: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    //createProjectValidate = false;
                                  });

                                  return 'Please enter email';
                                }

                                return null;
                              },
                              onChange: (text) => setState(() => _name = text),
                            ),
                            CustomFormField(
                              label: 'Password',
                              controller: passwordController,
                              hint: 'Enter password',
                              validator: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    //createProjectValidate = false;
                                  });

                                  return 'Please enter password';
                                }

                                return null;
                              },
                              onChange: (text) => setState(() => _name = text),
                              obsecqureText: true,
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (emailController.text.isEmpty &&
                                        passwordController.text.isEmpty) {
                                      _submit();
                                    } else {
                                      SmartDialog.showLoading(
                                        msg:
                                            "Your request is in progress please wait for a while...",
                                      );
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        login();
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 87.w,
                                    height: 40.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7DD3FC),
                                      borderRadius: BorderRadius.circular(
                                        40.r,
                                      ),
                                    ),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: ColorSelect.black_color,
                                          fontFamily: 'Inter-Bold',
                                          letterSpacing: 0.1,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // call Clickup code save API
  Future<void> callSaveCodeAPI(String authenticationCode) async {
    var responseJson;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = await sharedPreferences.getString("login");

    if (token != null && token.isNotEmpty) {
      var response = await http.post(
        Uri.parse(AppUrl.clickUpAuth),
        body: jsonEncode({"code": authenticationCode}),
        headers: {
          "Authorization": "Bearer ${token}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        responseJson =
            jsonDecode(response.body.toString()) as Map<String, dynamic>;

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        sharedPreferences.setBool('isLogin', true);
        //storage.write(isLogin, true);

        context.vRouter.toSegments([
          "home",
          RouteConstants.projectRoute,
        ], isReplacement: true);
      } else {
        print(
            'Error while saving code ${response.statusCode} ${response.body}');
        Fluttertoast.showToast(
          msg:
              'Error while saving code ${response.statusCode} ${response.body}',
          backgroundColor: Colors.grey,
        );
        print("failedd");
      }
    }
  }

  Future<void> login() async {
    var responseJson;

    String username = emailController.text.toString();
    String password = passwordController.text.toString();
    // String username = "admin.crebos@gmail.com";
    // String password = "Crebos@123";
    print(username);
    print(password);
    if (username.isNotEmpty && password.isNotEmpty) {
      var response = await http.post(
        Uri.parse(AppUrl.login),
        body: jsonEncode({"email": username, "password": password}),
        headers: {
          "Content-Type": "application/json",
          "Content-Encoding": "gzip",
        },
      );

      print(response.body);
      print(response.statusCode);
      // ignore: unrelated_type_equality_checks
      if (response.statusCode == 200) {
        responseJson =
            jsonDecode(response.body.toString()) as Map<String, dynamic>;

        print("Login Data ------------------------------ ${responseJson}");

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        sharedPreferences.setString('login', responseJson['data']['token']);
        sharedPreferences.setString(
            'user_id', responseJson['data']['user']['id'].toString());
        if (!enableClickupLogin) {
          storage.write(isLogin, true);
          sharedPreferences.setBool('isLogin', true);
        }
        // storage.write("token", responseJson['data']['token']);
        // storage.write("user_id", responseJson['data']['user']['id'].toString());
        SmartDialog.dismiss();
        if (enableClickupLogin) {
          launchClickUpsUrl();
        } else {
          context.vRouter.toSegments([
            "home",
            RouteConstants.projectRoute,
          ], isReplacement: true);
        }
      } else {
        Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: 'Please check Email and Password',
          backgroundColor: Colors.grey,
        );
        print("failedd");
        SmartDialog.dismiss();
      }
    } else {
      SmartDialog.dismiss();
      _submit();
    }
  }

  // launch click ups url
  launchClickUpsUrl() async {
    final html.WindowBase windowBase =
        html.window.open(AppUrl.clickUpsUrl, "_self");
  }
}
