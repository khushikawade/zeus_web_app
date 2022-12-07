import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:get/get.dart';
import 'package:zeus/utility/constant.dart';
import '../DemoClass.dart';
import '../navigation/navigation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utility/colors.dart';

class LoginScreen extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  LoginScreen({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  var _message;
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

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQueryData.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: const Color(0xff0F172A),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 26.0, left: 0.0),
                child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'images/logo.svg',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 0.0, top: 42.0),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Welcome to",
                    style: TextStyle(
                        color: Color(0xff94A3B8),
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 0.0, top: 10.0),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Zestful Empowering Utilization System",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 20.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.40,
                  margin: const EdgeInsets.only(left: 0.0, top: 49.0),
                  decoration: BoxDecoration(
                    color: const Color(0xff1E293B),
                    //border: Border.all(color: const Color(0xff0E7490)),
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 0.0, top: 30.0),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 20.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.99,
                            margin: const EdgeInsets.only(
                                top: 40.0, left: 30.0, right: 30.0),
                            height: 56.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff334155),
                              //border: Border.all(color:  const Color(0xff1E293B)),
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xff475569),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ), //BoxShadow
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 16.0,
                                margin: const EdgeInsets.only(
                                    top: 50.0, left: 50.0),
                                child: const Text(
                                  "Email address",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xff64748B),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),

                              /*  Container(
                                alignment: Alignment.centerLeft,
                                height:20.0,
                                margin:
                                const EdgeInsets.only(top: 10.0, left: 2.0,bottom: 0.0),

                                child:
                              ),*/
                            ],
                          ),
                          TextFormField(
                            autocorrect: false,
                            controller: emailController,
                            cursorColor: const Color(0xffFFFFFF),
                            style: const TextStyle(color: Color(0xffFFFFFF)),
                            textAlignVertical: TextAlignVertical.bottom,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                //errorStyle: TextStyle(fontSize: 14, height: 0.20),
                                contentPadding: EdgeInsets.only(
                                  bottom: 0.0,
                                  top: 82.0,
                                  right: 10,
                                  left: 50.0,
                                ),
                                border: InputBorder.none,
                                hintText: 'Enter email address',
                                hintStyle: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xffFFFFFF),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400)),
                            autovalidateMode: _submitted
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            validator: (value) {
                              RegExp regex = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                              if (value!.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!regex.hasMatch(value)) {
                                return 'Enter valid Email';
                              }
                              if (regex.hasMatch(values)) {
                                return 'please enter valid email';
                              }
                              if (value.length > 50) {
                                return 'No more length 50';
                              }
                              return null;
                            },
                            onChanged: (text) => setState(() => _name = text),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.99,
                            margin: const EdgeInsets.only(
                                top: 24.0, left: 30.0, right: 30.0),
                            height: 56.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff334155),
                              //border: Border.all(color:  const Color(0xff1E293B)),
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xff475569),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ), //BoxShadow
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 16.0,
                                margin: const EdgeInsets.only(
                                    top: 33.0, left: 50.0),
                                child: const Text(
                                  "Password",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xff64748B),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),

                              /*  Container(
                                alignment: Alignment.centerLeft,
                                height:20.0,
                                margin:
                                const EdgeInsets.only(top: 10.0, left: 2.0,bottom: 0.0),

                                child:
                              ),*/
                            ],
                          ),
                          TextFormField(
                            autocorrect: false,
                            controller: passwordController,
                            obscureText: !_showPassword,
                            cursorColor: const Color(0xffFFFFFF),
                            style: const TextStyle(color: Color(0xffFFFFFF)),
                            textAlignVertical: TextAlignVertical.bottom,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                //errorStyle: TextStyle(fontSize: 14, height: 0.20),
                                contentPadding: EdgeInsets.only(
                                  bottom: 0.0,
                                  top: 66.0,
                                  right: 10,
                                  left: 50.0,
                                ),
                                border: InputBorder.none,
                                hintText: 'Enter password',
                                hintStyle: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xffFFFFFF),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400)),
                            autovalidateMode: _submitted
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            validator: (value) {
//  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              if (value!.isEmpty) {
                                return 'Please enter Password';
                              } else if (value.length < 5) {
                                return 'Minimum length 5';
                              }
                              return null;
                            },
                            onChanged: (text) => setState(() => _name = text),
                          ),
                        ],
                      ),
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
                            Future.delayed(const Duration(seconds: 2), () {
                              login();
                            });
                          }
                        },
                        onLongPress: () {
                          emailController.text = "vishal.zt@mailinator.com";
                          passwordController.text = "Password@123";
                          _submit();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 87,
                            //MediaQuery.of(context).size.width * 0.22,
                            margin: const EdgeInsets.only(
                              top: 25.0,
                              right: 30.0,
                            ),
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: const Color(0xff7DD3FC),
                              //border: Border.all(color:  const Color(0xff1E293B)),
                              borderRadius: BorderRadius.circular(
                                40.0,
                              ),
                            ),

                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: ColorSelect.black_color,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (route) => false);

        ///  Navigator.pushReplacementNamed(context, "/home");

        /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
            const DemoClass()));*/
      } else {
        Fluttertoast.showToast(
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
}
