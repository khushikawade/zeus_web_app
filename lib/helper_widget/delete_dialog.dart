import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/popup_projectbutton.dart';
import 'package:zeus/navigator_tabs/idle/data/project_detail_data/ProjectDetailData.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../navigation/navigation.dart';
import '../navigator_tabs/idle/project_detail_model/project_detail_response.dart';
import '../utility/app_url.dart';
import '../utility/colors.dart';

showDailogfPopup(BuildContext context, String title) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          backgroundColor: ColorSelect.peoplelistbackgroundcolor,
          content: Container(
            height: 70.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 45, 72, 116)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        color: ColorSelect.white_color),
                  ),
                ),
              ],
            ),
            //MediaQueryx.of(context).size.height * 0.85,
          ),
        );
      });
}
