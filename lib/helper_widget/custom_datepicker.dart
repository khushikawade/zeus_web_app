import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

class CustomDatePicker extends StatefulWidget {
  TextEditingController? controller;
  String? label;
  String? hint;
  String? errorText;
  Function(String val)? validator;
  Function(DateTime value)? onChange;
  Function()? onCancel;
  double? hintTextHeight;
  EdgeInsets? contentpadding;
  int? maxline;
  double? fontSizeForLabel;
  bool? obsecqureText;

  CustomDatePicker(
      {this.controller,
      this.label,
      this.hint,
      this.validator,
      this.onChange,
      this.onCancel,
      this.hintTextHeight,
      this.contentpadding,
      this.maxline,
      this.fontSizeForLabel,
      this.obsecqureText,
      this.errorText
      });

  @override
  State<StatefulWidget> createState() {
    return CustomDatePickerState();
  }
}

class CustomDatePickerState extends State<CustomDatePicker> {
  String? errorText = "";
  DateTime? selectedDate;

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
      margin: EdgeInsets.only(bottom: 9.sp),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _selectDate();
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 13.sp),
                          child: Image.asset(
                            'images/date.png',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                  top: 8.0.sp,
                                  left: 20.0.sp,
                                ),
                                child: Text(
                                  widget.label ?? "",
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      overflow: TextOverflow.fade,
                                      color: Color(0xff64748B),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                  top: 3.0.h,
                                  left: 20.0.w,
                                ),
                                child: selectedDate == null
                                    ? Text(
                                        widget.hint ?? "",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            overflow: TextOverflow.fade,
                                            color: Color(0xffFFFFFF),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300),
                                      )
                                    : Text(
                                        '${selectedDate!.day} / ${selectedDate!.month} / ${selectedDate!.year}',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            overflow: TextOverflow.fade,
                                            color: Color(0xffFFFFFF),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (widget.onCancel != null) {
                            selectedDate = null;
                            widget.onCancel!();
                          }
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Padding(
          padding: EdgeInsets.only(left: 10.w, top: 4.h, bottom: 9.h),
          child: Text(widget.errorText ?? '',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 12.sp,
                  //height: 0.20.h,
                  color: Colors.red)),
        )
      ],
          )
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        lastDate: DateTime(5000),
        firstDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (widget.onChange != null) {
          widget.onChange!(selectedDate!);
        }
      });
    }
  }
}
