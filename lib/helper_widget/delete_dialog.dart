import 'package:flutter/material.dart';
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
