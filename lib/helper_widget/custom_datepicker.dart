import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';

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
  DateTime? initialDate;
  DateTime? endDate;

  CustomDatePicker(
      {this.initialDate,
      this.controller,
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
      this.errorText,
      this.endDate});

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
  void initState() {
    if (widget.initialDate != null) {
      selectedDate = widget.initialDate;
    }
    super.initState();
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
                                  top: 8.0.h,
                                  left: 12.0.w,
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
                                  left: 12.0.w,
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
                    padding: EdgeInsets.only(right: 16.w),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (widget.onCancel != null) {
                            selectedDate = null;
                            widget.onCancel!();
                          }
                        });
                      },
                      // child: Icon(
                      //   Icons.close,
                      //   size: 13.sp,
                      //   color: Colors.white,
                      // ),

                      child: SvgPicture.asset(
                        'images/cross.svg',
                        height: 13.18.sp,
                        width: 13.18.sp,
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
                padding: EdgeInsets.only(left: 10.w, top: 4.h),
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
    selectedDate = widget.initialDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        // builder: (context, child) {
        //   return Theme(
        //     data: Theme.of(context).copyWith(
        //       dialogBackgroundColor: Color(0xff1E293B),
        //       textTheme: TextTheme(
        //           // days
        //           ),
        //       colorScheme: Theme.of(context).colorScheme.copyWith(
        //             // Title, selected date and day selection background (dark and light mode)
        //             surface: Color(0xff1E293B),
        //             primary: Color(0xff1E293B),
        //             // Title, selected date and month/year picker color (dark and light mode)
        //             onSurface: Colors.white,
        //             onPrimary: Colors.white,
        //           ),
        //       // Buttons
        //       textButtonTheme: TextButtonThemeData(
        //         style: TextButton.styleFrom(
        //             textStyle: TextStyle(color: Colors.white),
        //             primary: Colors.white),
        //       ),
        //       // Input
        //       inputDecorationTheme: InputDecorationTheme(
        //         floatingLabelStyle: TextStyle(color: Colors.white),
        //         hintStyle: TextStyle(color: Colors.white),
        //         errorStyle: TextStyle(color: Colors.white),
        //         labelStyle: TextStyle(color: Colors.white),
        //         helperStyle: TextStyle(color: Colors.white),
        //         suffixStyle: TextStyle(color: Colors.white),
        //         counterStyle: TextStyle(color: Colors.white),
        //         prefixStyle: TextStyle(color: Colors.white),
        //       ),
        //     ),
        //     child: child!,
        //   );
        // },
        initialDate: selectedDate!,
        // lastDate: widget.endDate ?? DateTime(5000),
        lastDate: widget.endDate ?? DateTime(5000),
        firstDate: selectedDate ?? DateTime.now());
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
