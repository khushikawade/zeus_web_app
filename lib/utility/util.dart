import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    try{
      DateFormat formatter = DateFormat('dd/MM/yyyy');
      String formatted = formatter.format(date);
      return formatted;
    }
    catch(e){
      return date.toString();
    }

  }
}
