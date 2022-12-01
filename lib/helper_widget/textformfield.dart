import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zeus/helper_widget/labeltextfield.dart';

Widget formField(
        {required String labelText,
        required BuildContext context,
        dynamic hintText,
        required controller,
        required Function(String values) callback}) =>
    Container(
      width: MediaQuery.of(context).size.width * 0.26,
      margin: const EdgeInsets.only(left: 30.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 6.0, left: 16.0),
              child: fieldContent(labelText)),
          Container(
            margin: const EdgeInsets.only(top: 5.0, left: 0.0),
            height: 20.0,
            child: TextFormField(
              cursorColor: const Color(0xffFFFFFF),
              style: const TextStyle(color: Color(0xffFFFFFF)),
              textAlignVertical: TextAlignVertical.bottom,
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    bottom: 16.0,
                    top: 0.0,
                    right: 10,
                    left: 15.0,
                  ),
                  border: InputBorder.none,
                  hintText: hintText??labelText,
                  hintStyle:  const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xffFFFFFF),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400)),
              onChanged: (value) {
                //filterSearchResults(value);
                controller = value;
                callback(controller);
              },
              // onSaved: (value) {
              //   controller = value;
              //   callback(controller);
              // },
            ),
          ),
        ],
      ),
    );
