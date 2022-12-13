
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomFormField extends StatefulWidget {
  TextEditingController? controller;
  String? label;
  String? hint;

  CustomFormField({this.controller, this.label, this.hint});

  @override
  State<StatefulWidget> createState() {
    return CustomFormFieldState();
  }
}

class CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff334155),
        borderRadius:
        BorderRadius.circular(
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
          ),
        ],
      ),

      padding: EdgeInsets.all(10),
      // child: TextFormField(
      //   controller: widget.controller??TextEditingController(text: "HII"),
      //   decoration: InputDecoration(
      //     border: InputBorder.none,
      //     labelText:widget.label??'Name',
      //     hintText: widget.hint??'Enter Name',
      //
      //
      //   ),
      //
      // ),
      child:  Column(
        children: [
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 30.0, right: 25.0),
                height: 56.0,
                decoration: BoxDecoration(
                  color: const Color(0xff334155),
                  borderRadius:
                  BorderRadius.circular(
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
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 45,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text('validateValue',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 221, 49, 60),
                            fontSize: 14)),
                  )

                ],
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 11.0,
              left: 45.0,
            ),
            child: const Text(
              "Name",
              style: TextStyle(
                  fontSize: 11.0,
                  letterSpacing: 0.5,
                  color: Color(0xff64748B),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextFormField(
            controller: widget.controller,
            cursorColor: const Color(0xffFFFFFF),
            style: const TextStyle(
                color: Color(0xffFFFFFF)),
            textAlignVertical:
            TextAlignVertical.bottom,
            keyboardType: TextInputType.text,
            minLines: 1,
            maxLength: 30,
            decoration: const InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.only(
                  bottom: 16.0,
                  top: 36.0,
                  right: 10,
                  left: 45.0,
                ),
                errorStyle: TextStyle(
                    fontSize: 14, height: 0.20),
                border: InputBorder.none,
                hintText: 'Enter name',
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 0.25,
                    color: Color(0xffFFFFFF),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400)),
            //autovalidateMode:  AutovalidateMode.disabled,
            validator: (value) {
              RegExp regex = RegExp(r'^[a-z A-Z]+$',
                  caseSensitive: false);
              if (value!.isEmpty) {
                return 'Please enter';
              } else if (!regex.hasMatch(value)) {
                return 'Please enter valid name';
              }
              return null;
            },
            onChanged: (text) {}
                //setStateView(() => name1 = text),
          ),
        ],
      ),
    );
  }
}
