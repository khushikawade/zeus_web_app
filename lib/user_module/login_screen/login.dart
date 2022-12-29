import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/helper_widget/custom_form_field.dart';
import 'package:zeus/helper_widget/responsive.dart';
import 'package:zeus/helper_widget/textformfield.dart';
import 'package:zeus/home_module/home_page.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/colors.dart';
import 'package:zeus/utility/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  var _formKey = GlobalKey<FormState>();

  // TextEditingController emailController =
  //     TextEditingController(text: 'omkar@omkar.com');
  // TextEditingController passwordController =
  //     TextEditingController(text: 'Password@123');

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _submit() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_name);
    }
  }

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
        storage.write(isLogin, true);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      onSubmit: (String value) {},
                      adOnSubmit: (String value) {},
                    )),
            (Route<dynamic> route) => route is MyHomePage);
      } else {
        print(
            'Error while saving code ${response.statusCode} ${response.body}');
        Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg:
              'Error while saving code ${response.statusCode} ${response.body}',
          backgroundColor: Colors.grey,
        );
        print("failedd");
      }
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
    return MediaQuery(
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
                          left: 25.sp, right: 25.sp, top: 40.sp, bottom: 30.sp),
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
                    // Center(
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width * 0.35, //0.30
                    //     margin: const EdgeInsets.only(
                    //       top: 49.0,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: const Color(0xff1E293B),
                    //       borderRadius: BorderRadius.circular(
                    //         8.0,
                    //       ),
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Container(
                    //           margin: const EdgeInsets.only(
                    //             left: 0.0,
                    //             top: 30.0,
                    //           ),
                    //           child: const Align(
                    //             alignment: Alignment.center,
                    //             child: Text(
                    //               "Login",
                    //               style: TextStyle(
                    //                   color: Color(0xffFFFFFF),
                    //                   fontSize: 20.0,
                    //                   fontFamily: 'Inter',
                    //                   fontWeight: FontWeight.w700),
                    //             ),
                    //           ),
                    //         ),
                    //         Stack(
                    //           children: [
                    //             Container(
                    //               width: MediaQuery.of(context).size.width * 0.99,
                    //               margin: const EdgeInsets.only(
                    //                 top: 40.0,
                    //                 left: 20.0,
                    //                 right: 20.0,
                    //               ),
                    //               height: 56.0,
                    //               decoration: BoxDecoration(
                    //                 color: const Color(0xff334155),
                    //                 //border: Border.all(color:  const Color(0xff1E293B)),
                    //                 borderRadius: BorderRadius.circular(
                    //                   8.0,
                    //                 ),
                    //                 boxShadow: const [
                    //                   BoxShadow(
                    //                     color: Color(0xff475569),
                    //                     offset: Offset(
                    //                       0.0,
                    //                       2.0,
                    //                     ),
                    //                     blurRadius: 0.0,
                    //                     spreadRadius: 0.0,
                    //                   ), //BoxShadow
                    //                 ],
                    //               ),
                    //             ),
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Container(
                    //                   height: 16.0,
                    //                   margin: const EdgeInsets.only(
                    //                       top: 50.0, left: 35.0),
                    //                   child: const Text(
                    //                     "Email address",
                    //                     style: TextStyle(
                    //                         fontSize: 11.0,
                    //                         color: Color(0xff64748B),
                    //                         fontFamily: 'Inter-Medium',
                    //                         fontStyle: FontStyle.normal,
                    //                         fontWeight: FontWeight.w500),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             TextFormField(
                    //               autocorrect: false,
                    //               controller: emailController,
                    //               cursorColor: const Color(0xffFFFFFF),
                    //               style: TextStyle(
                    //                   fontSize: 14.0,
                    //                   fontStyle: FontStyle.normal,
                    //                   color: Color(0xffFFFFFF),
                    //                   letterSpacing: 0.25,
                    //                   fontFamily: 'Inter-Regular',
                    //                   fontWeight: FontWeight.w400),
                    //               textAlignVertical: TextAlignVertical.bottom,
                    //               keyboardType: TextInputType.text,
                    //               decoration: const InputDecoration(
                    //                   //errorStyle: TextStyle(fontSize: 14, height: 0.20),
                    //                   contentPadding: EdgeInsets.only(
                    //                     bottom: 0.0,
                    //                     top: 80.0,
                    //                     right: 10,
                    //                     left: 35.0,
                    //                   ),
                    //                   border: InputBorder.none,
                    //                   hintText: 'Enter email address',
                    //                   hintStyle: TextStyle(
                    //                       fontSize: 14.0,
                    //                       fontStyle: FontStyle.normal,
                    //                       color: Color(0xffFFFFFF),
                    //                       letterSpacing: 0.25,
                    //                       fontFamily: 'Inter-Regular',
                    //                       fontWeight: FontWeight.w400)),
                    //               autovalidateMode: _submitted
                    //                   ? AutovalidateMode.onUserInteraction
                    //                   : AutovalidateMode.disabled,
                    //               validator: (value) {
                    //                 RegExp regex = RegExp(
                    //                     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                    //                 if (value!.isEmpty) {
                    //                   return 'Please enter email';
                    //                 }
                    //                 if (!regex.hasMatch(value)) {
                    //                   return 'Enter valid Email';
                    //                 }
                    //                 if (regex.hasMatch(values)) {
                    //                   return 'please enter valid email';
                    //                 }
                    //                 if (value.length > 50) {
                    //                   return 'No more length 50';
                    //                 }
                    //                 return null;
                    //               },
                    //               onChanged: (text) =>
                    //                   setState(() => _name = text),
                    //             ),
                    //           ],
                    //         ),
                    //         Stack(
                    //           children: [
                    //             Container(
                    //               width: MediaQuery.of(context).size.width * 0.99,
                    //               margin: const EdgeInsets.only(
                    //                   top: 24.0, left: 20.0, right: 20.0),
                    //               height: 56.0,
                    //               decoration: BoxDecoration(
                    //                 color: const Color(0xff334155),
                    //                 //border: Border.all(color:  const Color(0xff1E293B)),
                    //                 borderRadius: BorderRadius.circular(
                    //                   8.0,
                    //                 ),
                    //                 boxShadow: const [
                    //                   BoxShadow(
                    //                     color: Color(0xff475569),
                    //                     offset: Offset(
                    //                       0.0,
                    //                       2.0,
                    //                     ),
                    //                     blurRadius: 0.0,
                    //                     spreadRadius: 0.0,
                    //                   ), //BoxShadow
                    //                 ],
                    //               ),
                    //             ),
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Container(
                    //                   height: 16.0,
                    //                   margin: const EdgeInsets.only(
                    //                       top: 33.0, left: 35.0),
                    //                   child: const Text(
                    //                     "Password",
                    //                     style: TextStyle(
                    //                         fontSize: 11.0,
                    //                         color: Color(0xff64748B),
                    //                         fontFamily: 'Inter-Medium',
                    //                         fontStyle: FontStyle.normal,
                    //                         fontWeight: FontWeight.w500),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             TextFormField(
                    //               autocorrect: false,
                    //               controller: passwordController,
                    //               obscureText: !_showPassword,
                    //               cursorColor: const Color(0xffFFFFFF),
                    //               style: TextStyle(
                    //                   fontSize: 14.0,
                    //                   fontStyle: FontStyle.normal,
                    //                   color: Color(0xffFFFFFF),
                    //                   letterSpacing: 0.25,
                    //                   fontFamily: 'Inter-Regular',
                    //                   fontWeight: FontWeight.w400),
                    //               textAlignVertical: TextAlignVertical.bottom,
                    //               keyboardType: TextInputType.text,
                    //               decoration: const InputDecoration(
                    //                 //errorStyle: TextStyle(fontSize: 14, height: 0.20),
                    //                 contentPadding: EdgeInsets.only(
                    //                   bottom: 0.0,
                    //                   top: 63.0,
                    //                   right: 10,
                    //                   left: 35.0,
                    //                 ),
                    //                 border: InputBorder.none,
                    //                 hintText: 'Enter password',
                    //                 hintStyle: TextStyle(
                    //                     fontSize: 14.0,
                    //                     fontStyle: FontStyle.normal,
                    //                     color: Color(0xffFFFFFF),
                    //                     letterSpacing: 0.25,
                    //                     fontFamily: 'Inter-Regular',
                    //                     fontWeight: FontWeight.w400),
                    //               ),
                    //               autovalidateMode: _submitted
                    //                   ? AutovalidateMode.onUserInteraction
                    //                   : AutovalidateMode.disabled,
                    //               validator: (value) {
                    //                 //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    //                 if (value!.isEmpty) {
                    //                   return 'Please enter Password';
                    //                 } else if (value.length < 5) {
                    //                   return 'Minimum length 5';
                    //                 }
                    //                 return null;
                    //               },
                    //               onChanged: (text) =>
                    //                   setState(() => _name = text),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: 35,
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.only(right: 20),
                    //           child: Align(
                    //             alignment: Alignment.bottomRight,
                    //             child: InkWell(
                    //               onTap: () {
                    //                 if (emailController.text.isEmpty &&
                    //                     passwordController.text.isEmpty) {
                    //                   _submit();
                    //                 } else {
                    //                   SmartDialog.showLoading(
                    //                     msg:
                    //                         "Your request is in progress please wait for a while...",
                    //                   );
                    //                   Future.delayed(const Duration(seconds: 2),
                    //                       () {
                    //                     login();
                    //                   });
                    //                 }
                    //               },
                    //               child: Container(
                    //                 width: 87,
                    //                 height: 40.0,
                    //                 decoration: BoxDecoration(
                    //                   color: const Color(0xff7DD3FC),
                    //                   borderRadius: BorderRadius.circular(
                    //                     40.0,
                    //                   ),
                    //                 ),
                    //                 child: const Align(
                    //                   alignment: Alignment.center,
                    //                   child: Text(
                    //                     "Login",
                    //                     style: TextStyle(
                    //                         fontSize: 14.0,
                    //                         color: ColorSelect.black_color,
                    //                         fontFamily: 'Inter',
                    //                         fontWeight: FontWeight.w700),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 25,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

        sharedPreferences.setBool('isLogin', true);
        sharedPreferences.setString('login', responseJson['data']['token']);
        sharedPreferences.setString(
            'user_id', responseJson['data']['user']['id'].toString());
        storage.write(isLogin, true);
        storage.write("token", responseJson['data']['token']);
        storage.write("user_id", responseJson['data']['user']['id'].toString());
        // await sharedPreferences.setString('user',responseJson['name']);
        //  ==========edited sayyamyadav
        //Navigator.pushNamed(context, "/home");
        SmartDialog.dismiss();
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil("/home", (route) => false);

        ///  Navigator.pushReplacementNamed(context, "/home");

        /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
            const DemoClass()));*/

        //launchClickUpsUrl();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      onSubmit: (String value) {},
                      adOnSubmit: (String value) {},
                    )),
            (Route<dynamic> route) => route is MyHomePage);
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

  launchClickUpsUrl() async {
    final html.WindowBase windowBase =
        html.window.open(AppUrl.clickUpsUrl, "_self");
  }
}
