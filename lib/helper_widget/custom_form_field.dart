import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

class CustomFormField extends StatefulWidget {
  TextEditingController? controller;
  String? label;
  String? hint;
  Function(String val)? validator;
  Function(String value)? onChange;
  Function(String value)? onFieldSubmitted;
  double? hintTextHeight;
  EdgeInsets? contentpadding;
  int? maxline;
  double? fontSizeForLabel;
  int? maxLength;

  CustomFormField(
      {this.controller,
      this.label,
      this.hint,
      this.validator,
      this.onChange,
      this.onFieldSubmitted,
      this.hintTextHeight,
      this.contentpadding,
      this.maxline,
      this.fontSizeForLabel,
      this.maxLength});

  @override
  State<StatefulWidget> createState() {
    return CustomFormFieldState();
  }
}

class CustomFormFieldState extends State<CustomFormField> {
  String? errorText = "";

  validateMethodCall(String val) {
    Future.delayed(const Duration(microseconds: 300), () {
      setState(() {
        errorText = widget.validator!(val);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 9),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff334155),
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
                ),
              ],
            ),
            padding: EdgeInsets.only(bottom: 3),
            child: TextFormField(
              maxLines: widget.maxline ?? 1,
              maxLength: widget.maxLength ?? null,
              cursorColor: const Color(0xffFFFFFF),
              style: const TextStyle(color: Color(0xffFFFFFF)),
              controller: widget.controller ?? TextEditingController(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (widget.validator != null) {
                  validateMethodCall(value!);
                }
                return null;
              },
              onChanged: (value) {
                if (widget.onChange != null) {
                  widget.onChange!(value);
                }
              },
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                labelText: widget.label ?? '',
                labelStyle: TextStyle(
                  fontSize: widget.fontSizeForLabel ?? 11.0,
                  color: Color(0xff64748B),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
                hintText: widget.hint ?? '',
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 0.25,
                    height: widget.hintTextHeight ?? 2,
                    color: Color(0xffFFFFFF),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                floatingLabelStyle: TextStyle(
                    fontSize: 11.0,
                    color: Color(0xff64748B),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500),
                contentPadding: widget.contentpadding ?? EdgeInsets.all(10),
                alignLabelWithHint: true,
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 15),
                child: Text(errorText ?? '',
                    style: TextStyle(
                        fontSize: 12, height: 0.20, color: Colors.red)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
