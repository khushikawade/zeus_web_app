import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeus/utility/constant.dart';

class AppUtil {
  static Color getStatusContainerColor(String status) {
    if (status == onTrack) {
      return const Color(0xff334155);
    } else if (status == updateRequested) {
      return const Color(0xff0E7490);
    } else if (status == potentialRisk) {
      return const Color(0xff9A3412);
    } else if (status == risk) {
      return const Color(0xffB91C1C);
    } else if (status == sentForApproval) {
      return const Color(0xff115E59);
    } else {
      return const Color(0xff16A34A);
    }
  }

  static String formattedDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat dateFormat = DateFormat('d MMM');
    return dateFormat.format(dateTime).toString();
  }
}
