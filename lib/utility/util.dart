import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/user_module/login_screen/login.dart';
import 'package:zeus/utility/constant.dart';

class AppUtil {
  static Color getStatusContainerColor(String status) {
    if (status == onTrack) {
      return const Color(0xff334155);
    } else if (status == potentialRisk) {
      return const Color(0xff9A3412);
    } else if (status == risk) {
      return const Color(0xffB91C1C);
    } else if (status == updateRequested) {
      return const Color(0xff0E7490);
    } else if (status == designSentForApproval) {
      return const Color(0xff115E59);
    } else if (status == sentForApproval) {
      return const Color(0xff166534);
    } else if (status == live) {
      return const Color(0xff16A34A);
    } else if (status == newFeatureRequest) {
      return const Color(0xffA21CAF);
    } else {
      return const Color(0xff6D28D9);
    }
  }

  static String formattedDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      DateFormat dateFormat = DateFormat('d MMM');
      return dateFormat.format(dateTime).toString();
    } catch (e) {
      return date;
    }
  }

  static String formattedDateYear(String date) {
    if (date != "0000-00-00 00:00:00") {
      try {
        DateTime dateTime = DateTime.parse(date);
        DateFormat dateFormat = DateFormat('d MMM yyyy');
        return dateFormat.format(dateTime).toString();
      } catch (_) {
        return 'N/A';
      }
    } else {
      return 'N/A';
    }
  }

  static String formattedDateYear1(String date) {
    if (date != "0000-00-00 00:00:00") {
      try {
        DateTime dateTime = DateTime.parse(date);
        DateFormat dateFormat = DateFormat('d  MMM');
        return dateFormat.format(dateTime).toString();
      } catch (_) {
        return 'N/A';
      }
    } else {
      return 'N/A';
    }
  }

  static DateTime stringToDate(String date) {
    try {
      DateTime parseDate = DateFormat("dd/MM/yyyy").parse(date);
      return parseDate;
    } catch (e) {
      return DateTime.now();
    }
  }

  static String stringToDate1(String date) {
    try {
      print("jfdkffff");
      DateTime dateTime = DateTime.parse(date);
      DateFormat dateFormat = DateFormat('d MMM yyyy');
      print(dateFormat.format(dateTime).toString());
      return dateFormat.format(dateTime).toString();

      // DateTime parseDate = DateFormat("dd/MM").parse(date);
      // return parseDate;
    } catch (e) {
      print(e);
      return '';
    }
  }

  static dateToString(DateTime date) {
    try {
      DateFormat formatter = DateFormat('dd/MM/yyyy');
      String formatted = formatter.format(date);
      return formatted;
    } catch (e) {
      return date.toString();
    }
  }

  static dateToString1(DateTime date) {
    try {
      DateFormat formatter = DateFormat('MMM');
      String formatted = formatter.format(date);
      return formatted;
    } catch (e) {
      return date.toString();
    }
  }

  static getFormatedDate(_date) {
    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('yyyy-MM-dd HH:mm');
    return outputFormat.format(inputDate);
  }

  // show Anothrised Error Dialog
  static showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          backgroundColor: const Color(0xff0F172A),
          title: const Text("Error",
              style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 18.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold)),
          content: Padding(
            padding: EdgeInsets.only(left: 25, right: 25, top: 16, bottom: 10),
            child: Text(message,
                style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 16.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal)),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  context.vxNav.clearAndPush(Uri.parse(MyRoutes.loginRoute));
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(
                  //         builder: (context) => LoginScreen(
                  //               onSubmit: (String value) {},
                  //             )),
                  //     (Route<dynamic> route) => route is LoginScreen);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontSize: 14.0,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500),
                ))
          ],
        );
      },
    );
  }
}
