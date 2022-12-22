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
  bool? obsecqureText;

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
      this.maxLength,
      this.obsecqureText});

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
      margin: EdgeInsets.only(bottom: 18.h),
      child: Column(
        children: [
          SizedBox(
            height: 56.h,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff334155),
                borderRadius: BorderRadius.circular(
                  8.r,
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
              padding: EdgeInsets.only(bottom: 3.sp),
              child: TextFormField(
                maxLines: widget.maxline ?? 1,
                maxLength: widget.maxLength ?? null,
                obscureText: widget.obsecqureText ?? false,
                cursorColor: const Color(0xffFFFFFF),
                style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.sp),
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
                  hintText: widget.hint ?? '',
                  labelStyle: TextStyle(
                    fontSize: 15.sp,
                    
                    overflow: TextOverflow.fade,
                    color: Color(0xff64748B),
                    fontFamily: 'Inter-Medium',
                    letterSpacing: 0.5,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: TextStyle(
                      fontSize: 14.sp,
                      letterSpacing: 0.25,
                      height: widget.hintTextHeight ?? 2,
                      color: Color(0xffFFFFFF),
                      fontFamily: 'Inter-Medium',
                      fontWeight: FontWeight.w400),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  floatingLabelStyle: TextStyle(
                      fontSize: 13.sp,
                      overflow: TextOverflow.fade,
                      color: Color(0xff64748B),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500),
                  contentPadding:
                      widget.contentpadding ?? EdgeInsets.all(10.sp),
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ),
          errorText != null && errorText!.isNotEmpty
              ? Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.sp, top: 4.sp),
                      child: Text(errorText ?? '',
                          style: TextStyle(
                              fontSize: 12.sp,
                              //height: 0.20.h,
                              color: Colors.red)),
                    ),
                  ],
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
