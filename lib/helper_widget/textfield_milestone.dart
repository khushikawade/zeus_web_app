import 'package:flutter/material.dart';
import 'package:zeus/helper_widget/labeltextfield.dart';

Widget formFieldMilestone(
        {required String labelText, dynamic context, dynamic hintText}) =>
    Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.26,
          margin: const EdgeInsets.only(left: 30.0),
          height: 56.0,
          decoration: BoxDecoration(
            color:
                // Colors.red,
                const Color(0xff334155),
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
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        bottom: 10.0,
                        // top: 5.0,
                        // right: 10,
                        left: 15.0,
                      ),
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xffFFFFFF),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w100)),
                  onChanged: (value) {
                    //filterSearchResults(value);
                  },
                ),
              ),
            ],
          ),
        ));
