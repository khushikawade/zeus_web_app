import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeus/login_screen/login.dart';
import 'package:zeus/utility/constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    DateTime dateTime = DateTime.parse(date);
    DateFormat dateFormat = DateFormat('d MMM');
    return dateFormat.format(dateTime).toString();
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

  static Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
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

  static dateToString(DateTime date) {
    try {
      DateFormat formatter = DateFormat('dd/MM/yyyy');
      String formatted = formatter.format(date);
      return formatted;
    } catch (e) {
      return date.toString();
    }
  }

  // show Anothrised Error Dialog
  static showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          //buttonPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          backgroundColor: const Color(0xff0F172A),
          title: const Text("Error",
              style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 18.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold)),
          content: const Padding(
            padding: EdgeInsets.only(left: 25, right: 25, top: 16,bottom: 10),
            child: Text('Your Session has been expired, Please try again!',
                style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 16.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal)),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => LoginScreen(
                                onSubmit: (String value) {},
                              )),
                      (Route<dynamic> route) => route is LoginScreen);
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
    // SmartDialog.show(builder: (context) {
    //   return Container(
    //     height: 150,
    //     width: MediaQuery.of(context).size.width / 4,
    //     padding: const EdgeInsets.all(16),
    //     decoration: BoxDecoration(
    //       color: Colors.black,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     alignment: Alignment.center,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       // ignore: prefer_const_literals_to_create_immutables
    //       children: [
    //         const Text('Your Session has been expired, Please try again!',
    //             style: TextStyle(
    //                 color: Color(0xffFFFFFF),
    //                 fontSize: 18.0,
    //                 fontFamily: 'Inter',
    //                 fontWeight: FontWeight.normal)),
    //                 const SizedBox(
    //                   height: 30,
    //                 ),
    //         TextButton(
    //             onPressed: () {},
    //             child: const Text(
    //               'Ok',
    //               style: TextStyle(
    //                   color: Color(0xffFFFFFF),
    //                   fontSize: 16.0,
    //                   fontFamily: 'Inter',
    //                   fontWeight: FontWeight.w500),
    //             ))
    //       ],
    //     ),
    //   );
    // });
  }
}
