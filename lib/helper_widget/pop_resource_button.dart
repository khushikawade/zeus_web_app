import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';

import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/helper_widget/responsive.dart';
import 'package:zeus/people_module/create_people/create_people_page.dart';
import 'package:zeus/services/model/model_class.dart';
import 'package:zeus/utility/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/utility/constant.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:zeus/utility/upertextformate.dart';
import 'package:zeus/utility/util.dart';
import 'search_view.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeus/utility/app_url.dart';

class MyMenu extends StatefulWidget {
  final List<PeopleData>? peopleList;
  final String title;
  final Alignment alignment;
  final Offset offset;
  PeopleData? data;
  BuildContext buildContext;
  final Function? returnValue;

  MyMenu(
      {required this.title,
      required this.alignment,
      this.peopleList,
      this.offset = const Offset(0, 48),
      this.data,
      required this.buildContext,
      this.returnValue,
      Key? key})
      : super(key: key);

  @override
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> with SingleTickerProviderStateMixin {
  String _value = "";
  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Datum>> key = new GlobalKey();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static List<Datum> users = <Datum>[];
  List<String> selectedDaysList = List.empty(growable: true);
  List _timeline = [];
  String? _depat, _curren, _time, _day, _shortday;

  var startTime;
  var endTime;
  var finalTime;
  var startTime2;
  String? Time1;
  String? Time2;

  var startTime1;
  var endTime2;
  String token = "";
  var dataPeople = 'people_data';
  bool imageavail = false;
  bool selectedColor = false;
  var postion;
  SharedPreferences? sharedPreferences;
  GlobalKey<FormState> _addFormKey = new GlobalKey<FormState>();

  List<int>? _selectedFile;
  var name;
  String name1 = '';
  List _department = [];
  List _currencyName = [];
  List<String> abc = [];
  Uint8List? webImage;

  var items1 = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  bool _addSubmitted = true;
  bool loading = true;

  bool? _isSelected;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _nickName = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _designation = TextEditingController();
  final TextEditingController _association = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  final TextEditingController _salaryCurrency = TextEditingController();
  final TextEditingController _availableDay = TextEditingController();
  final TextEditingController _availableTime = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _enterCity = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();

  @override
  void initState() {
    _isSelected = false;
    getUsers();
    getDepartment();
    getCurrency();
    getTimeline();
    super.initState();
  }

  getformattedTime(TimeOfDay time) {
    DateTime tempDate = DateFormat("hh:mm")
        .parse(time.hour.toString() + ":" + time.minute.toString());
    var dateFormat = DateFormat("h:mm a");
    print(dateFormat.format(tempDate));
    return dateFormat.format(tempDate);
  }

  TimeOfDay? stringToTimeOfDay(String tod) {
    DateFormat? format;
    if (tod.contains(":")) {
      format = DateFormat("h:mm a");
    } else {
      format = DateFormat("hha");
    }

    TimeOfDay? result;
    try {
      result = TimeOfDay.fromDateTime(format.parse(tod));
    } catch (e) {
      print(e);
    }
    print(result);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: "",
      constraints: BoxConstraints.expand(width: 140.w, height: 120.h),
      padding: EdgeInsets.only(left: 50.sp, right: 50.sp),
      offset: Offset(-15.sp, 12.sp),
      position: PopupMenuPosition.under,
      color: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      child: Container(
        // color: Colors.red,
        // margin: const EdgeInsets.only(right: 12.0, top: 16.0),
        height: 40.h,
        width: 40.w,
        decoration: BoxDecoration(
            color: const Color(0xff334155),
            border: Border.all(
              color: ColorSelect.box_decoration,
            ),
            shape: BoxShape.circle),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: SvgPicture.asset(
              "images/edit.svg",
              height: 16.h,
              width: 4.w,
            ),
          ),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 1,
          child: InkWell(
            hoverColor: Color(0xff1e293b),
            onTap: () {
              if (widget.data != null) {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: EdgeInsets.zero,
                          backgroundColor: const Color(0xff1E293B),
                          content: Form(
                              key: _formKey,
                              child: CreatePeoplePage(
                                formKey: _formKey,
                                response: widget.data,
                                isEdit: true,
                              )),
                        ),
                      );
                    });
              }
              // if (widget.data != null) {
              //   setState(() {
              //     selectedColor = true;
              //     final splitNames =
              //         widget.data!.resource!.availibiltyDay!.split(", ");

              //     for (int i = 0; i < splitNames.length; i++) {
              //       selectedDaysList.add(splitNames[i]);
              //     }

              //     widget.data!.resource!.availibiltyTime != null
              //         ? finalTime = widget.data!.resource!.availibiltyTime!
              //         : " ";

              //     var names;

              //     print("--------------------------");
              //     finalTime.toString().trim();
              //     if (finalTime.contains("-")) {
              //       print("here");
              //       List<String> splitedList = finalTime!.split("-");
              //       Time1 = splitedList[0].trim();
              //       Time2 = splitedList[1].trim();
              //       print(Time1);
              //       print(Time2);
              //       setState(() {});
              //     } else {}

              //     _name.text =
              //         widget.data!.name != null && widget.data!.name!.isNotEmpty
              //             ? widget.data!.name!
              //             : '';

              //     _nickName.text = widget.data!.resource != null
              //         ? widget.data!.resource!.nickname != null &&
              //                 widget.data!.resource!.nickname!.isNotEmpty
              //             ? widget.data!.resource!.nickname!
              //             : ''
              //         : '';

              //     _bio.text = widget.data!.resource != null
              //         ? widget.data!.resource!.bio != null &&
              //                 widget.data!.resource!.bio!.isNotEmpty
              //             ? widget.data!.resource!.bio!
              //             : ''
              //         : '';

              //     _designation.text = widget.data!.resource != null
              //         ? widget.data!.resource!.designation != null &&
              //                 widget.data!.resource!.designation!.isNotEmpty
              //             ? widget.data!.resource!.designation!
              //             : ''
              //         : '';

              //     _association.text = widget.data!.resource != null
              //         ? widget.data!.resource!.associate != null &&
              //                 widget.data!.resource!.associate!.isNotEmpty
              //             ? widget.data!.resource!.associate!
              //             : ''
              //         : '';

              //     _salary.text = widget.data!.resource != null
              //         ? widget.data!.resource!.salary != null
              //             ? widget.data!.resource!.salary!.toString()
              //             : ''
              //         : '';

              //     _availableDay.text = widget.data!.resource != null
              //         ? widget.data!.resource!.availibiltyDay != null &&
              //                 widget.data!.resource!.availibiltyDay!.isNotEmpty
              //             ? widget.data!.resource!.availibiltyDay!
              //             : ''
              //         : '';

              //     _availableTime.text = widget.data!.resource != null
              //         ? widget.data!.resource!.availibiltyTime != null &&
              //                 widget.data!.resource!.availibiltyTime!.isNotEmpty
              //             ? widget.data!.resource!.availibiltyTime!
              //             : ''
              //         : '';

              //     if (widget.data!.resource != null) {
              //       _country.text = widget.data!.resource!.country != null &&
              //               widget.data!.resource!.country!.isNotEmpty
              //           ? widget.data!.resource!.country!
              //           : '';
              //     }

              //     if (widget.data!.resource != null) {
              //       _enterCity.text = widget.data!.resource!.city != null &&
              //               widget.data!.resource!.city!.isNotEmpty
              //           ? widget.data!.resource!.city!
              //           : '';
              //     }

              //     _phoneNumber.text = widget.data!.phoneNumber != null &&
              //             widget.data!.phoneNumber!.isNotEmpty
              //         ? widget.data!.phoneNumber!
              //         : '';

              //     _emailAddress.text = widget.data!.email != null &&
              //             widget.data!.email!.isNotEmpty
              //         ? widget.data!.email!
              //         : '';
              //     if (widget.data!.resource != null) {
              //       _depat = widget.data!.resource!.department!.name!.isNotEmpty
              //           ? widget.data!.resource!.departmentId.toString()
              //           : '';
              //     }

              //     _time = widget.data!.resource != null &&
              //             widget.data!.resource!.timeZone!.name!.isNotEmpty
              //         ? widget.data!.resource!.timeZone!.id.toString()
              //         : '';
              //     if (widget.data!.resource != null) {
              //       _salaryCurrency
              //           .text = widget.data!.resource!.salaryCurrency != null &&
              //               widget.data!.resource!.salaryCurrency!.isNotEmpty
              //           ? widget.data!.resource!.salaryCurrency!
              //           : '';
              //     }

              //     var image = widget.data!.image;

              //     if (widget.data!.resource!.skills!.isNotEmpty) {
              //       widget.data!.resource!.skills!.forEach((element) {
              //         if (abc.isNotEmpty) {
              //           if (abc.contains(element.title!)) {
              //           } else {
              //             abc.add(element.title!.toString());
              //           }
              //         } else {
              //           abc.add(element.title!.toString());
              //         }
              //         // abc.add(element.title!);
              //       });
              //     }
              //   });
              // }
              // showAddPeople(context);
              // Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              height: 50.h,
              child: Padding(
                padding: EdgeInsets.only(left: 20.sp, top: 15.sp),
                child: Text(
                  "Edit",
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.1,
                      color: ColorSelect.white_color),
                ),
              ),
            ),
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 2,
          child: InkWell(
            hoverColor: Color(0xff1e293b),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        backgroundColor: ColorSelect.peoplelistbackgroundcolor,
                        content: Container(
                          height: 110.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20.sp),
                                child: Text(
                                  "Do you want to delete @${widget.data!.resource!.nickname!} ?",
                                  style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.1,
                                      color: ColorSelect.white_color),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15.sp),
                                child: Text(
                                  "Once deleted, you will not find this person in people list anymore.",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.1,
                                      color: ColorSelect.delete),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 30.sp),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 56.sp),
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Inter',
                                                fontStyle: FontStyle.normal,
                                                letterSpacing: 0.1,
                                                color: ColorSelect.delete_text),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          SmartDialog.showLoading(
                                            msg:
                                                "Your request is in progress please wait for a while...",
                                          );

                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            deletePeople(widget.data!.id,
                                                widget.buildContext);
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(right: 10.sp),
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Inter',
                                                fontStyle: FontStyle.normal,
                                                letterSpacing: 0.1,
                                                color: ColorSelect.red_color),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: Container(
              width: double.infinity,
              height: 50.h,
              child: Padding(
                padding: EdgeInsets.only(left: 20.sp, top: 15.sp),
                child: Text(
                  "Delete",
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.1,
                      color: ColorSelect.white_color),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  // showAddPeople(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(
  //           builder: (context, setState) => AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16.r),
  //             ),
  //             contentPadding: EdgeInsets.zero,
  //             backgroundColor: const Color(0xff1E293B),
  //             content: Form(
  //               key: _addFormKey,
  //               child: SizedBox(
  //                 width: MediaQuery.of(context).size.width * 0.99,
  //                 height: MediaQuery.of(context).size.height * 0.99,
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Container(
  //                           height: MediaQuery.of(context).size.height * 0.11,
  //                           width: MediaQuery.of(context).size.width * 0.99,
  //                           decoration: const BoxDecoration(
  //                             color: Color(0xff283345),
  //                             borderRadius: BorderRadius.only(
  //                               topRight: Radius.circular(16.0),
  //                               topLeft: Radius.circular(16.0),
  //                             ),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Color(0x26000000),
  //                                 offset: Offset(
  //                                   0.0,
  //                                   1.0,
  //                                 ),
  //                                 blurRadius: 0.0,
  //                                 spreadRadius: 0.0,
  //                               ),
  //                             ],
  //                           ),
  //                           child: Row(
  //                             children: [
  //                               Container(
  //                                 margin: const EdgeInsets.only(
  //                                     left: 30.0, top: 10.0, bottom: 10.0),
  //                                 child: const Text(
  //                                   "Edit People",
  //                                   style: TextStyle(
  //                                       color: Color(0xffFFFFFF),
  //                                       fontSize: 18.0,
  //                                       fontFamily: 'Inter',
  //                                       fontWeight: FontWeight.w700),
  //                                 ),
  //                               ),
  //                               Spacer(),
  //                               Container(
  //                                 width: 97.0,
  //                                 margin: const EdgeInsets.only(
  //                                     top: 10.0, bottom: 10.0),
  //                                 height: 40.0,
  //                                 decoration: BoxDecoration(
  //                                   color: const Color(0xff334155),
  //                                   borderRadius: BorderRadius.circular(
  //                                     40.0,
  //                                   ),
  //                                 ),
  //                                 child: InkWell(
  //                                   onTap: () {
  //                                     Navigator.of(context).pop();
  //                                   },
  //                                   child: const Align(
  //                                     alignment: Alignment.center,
  //                                     child: Text(
  //                                       "Cancel",
  //                                       style: TextStyle(
  //                                           fontSize: 14.0,
  //                                           color: Color(0xffFFFFFF),
  //                                           fontFamily: 'Inter',
  //                                           fontWeight: FontWeight.w700),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               const SizedBox(
  //                                 width: 16,
  //                               ),
  //                               InkWell(
  //                                 onTap: () {
  //                                   if (_addFormKey.currentState!.validate()) {
  //                                     if (selectedDaysList.length > 0 &&
  //                                         abc.length > 0) {
  //                                       SmartDialog.showLoading(
  //                                         msg:
  //                                             "Your request is in progress please wait for a while...",
  //                                       );

  //                                       Future.delayed(
  //                                           const Duration(seconds: 2), () {
  //                                         getUpdatePeople(
  //                                             widget.data!.id.toString(),
  //                                             context);
  //                                       });
  //                                     }
  //                                   }
  //                                 },
  //                                 child: Container(
  //                                   width: 97,
  //                                   margin: const EdgeInsets.only(
  //                                       top: 10.0, right: 20.0, bottom: 10.0),
  //                                   height: 40.0,
  //                                   decoration: BoxDecoration(
  //                                     color: const Color(0xff7DD3FC),
  //                                     borderRadius: BorderRadius.circular(
  //                                       40.0,
  //                                     ),
  //                                   ),
  //                                   child: const Align(
  //                                     alignment: Alignment.center,
  //                                     child: Text(
  //                                       "Save",
  //                                       style: TextStyle(
  //                                           fontSize: 14.0,
  //                                           color: Color(0xff000000),
  //                                           fontFamily: 'Inter',
  //                                           fontWeight: FontWeight.w700),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           )),
  //                       ResponsiveWidget(
  //                         largeScreen: getDesktopView(setState),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  // Widget getDesktopView(StateSetter setState) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         flex: 1,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 Container(
  //                     width: 134.0,
  //                     height: 134.0,
  //                     margin: const EdgeInsets.only(left: 27.0, top: 28.0),
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xff334155),
  //                       borderRadius: BorderRadius.circular(
  //                         110.0,
  //                       ),
  //                     ),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(110.0),
  //                       child: imageavail
  //                           ? Image.memory(
  //                               webImage!,
  //                               fit: BoxFit.fill,
  //                             )
  //                           : Image.network(
  //                               widget.data!.image!,
  //                               fit: BoxFit.fill,
  //                             ),
  //                     )),
  //                 InkWell(
  //                   onTap: () async {
  //                     final image = await ImagePickerWeb.getImageAsBytes();
  //                     setState(() {
  //                       imageavail = true;
  //                       webImage = image!;
  //                     });
  //                   },
  //                   child: Container(
  //                     height: 35.0,
  //                     width: MediaQuery.of(context).size.width * 0.11,
  //                     margin: const EdgeInsets.only(left: 48.0, top: 20.0),
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xff334155),
  //                       borderRadius: BorderRadius.circular(
  //                         40.0,
  //                       ),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           margin: const EdgeInsets.only(left: 16.0),
  //                           child: SvgPicture.asset('images/camera_pic.svg'),
  //                         ),
  //                         Container(
  //                           margin: const EdgeInsets.only(left: 11.0),
  //                           child: const Text(
  //                             "Upload new",
  //                             style: TextStyle(
  //                                 color: Color(0xffFFFFFF),
  //                                 fontSize: 14.0,
  //                                 fontFamily: 'Inter',
  //                                 fontWeight: FontWeight.w700),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               margin: const EdgeInsets.only(left: 30.0, top: 20.0),
  //               child: const Text(
  //                 "About you",
  //                 style: TextStyle(
  //                     color: Color(0xffFFFFFF),
  //                     fontSize: 14.0,
  //                     fontFamily: 'Inter',
  //                     fontWeight: FontWeight.w700),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 8.0,
  //             ),
  //             Stack(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.99,
  //                   margin: const EdgeInsets.only(left: 30.0, right: 25.0),
  //                   height: 56.0,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff334155),
  //                     borderRadius: BorderRadius.circular(
  //                       8.0,
  //                     ),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         color: Color(0xff475569),
  //                         offset: Offset(
  //                           0.0,
  //                           2.0,
  //                         ),
  //                         blurRadius: 0.0,
  //                         spreadRadius: 0.0,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   margin: const EdgeInsets.only(top: 6.0, left: 45.0),
  //                   child: const Text(
  //                     "Name",
  //                     style: TextStyle(
  //                         fontSize: 11.0,
  //                         color: Color(0xff64748B),
  //                         fontFamily: 'Inter',
  //                         fontWeight: FontWeight.w500),
  //                   ),
  //                 ),
  //                 TextFormField(
  //                   controller: _name,
  //                   cursorColor: const Color(0xffFFFFFF),
  //                   style: const TextStyle(color: Color(0xffFFFFFF)),
  //                   textAlignVertical: TextAlignVertical.bottom,
  //                   keyboardType: TextInputType.text,
  //                   minLines: 1,
  //                   maxLength: 30,
  //                   decoration: const InputDecoration(
  //                       counterText: "",
  //                       contentPadding: EdgeInsets.only(
  //                         bottom: 16.0,
  //                         top: 35.0,
  //                         right: 10,
  //                         left: 45.0,
  //                       ),
  //                       errorStyle: TextStyle(fontSize: 14, height: 0.20),
  //                       border: InputBorder.none,
  //                       hintText: 'Enter name',
  //                       hintStyle: TextStyle(
  //                           fontSize: 14.0,
  //                           color: Color(0xffFFFFFF),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500)),
  //                   autovalidateMode: _addSubmitted
  //                       ? AutovalidateMode.onUserInteraction
  //                       : AutovalidateMode.disabled,
  //                   validator: (value) {
  //                     RegExp regex = RegExp(r'^[a-z A-Z]+$');
  //                     if (value!.isEmpty) {
  //                       return 'Please enter';
  //                     } else if (!regex.hasMatch(value)) {
  //                       return 'Please enter valid name';
  //                     }
  //                     return null;
  //                   },
  //                   onChanged: (text) => setState(() => name1 = text),
  //                 ),
  //               ],
  //             ),
  //             Stack(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.99,
  //                   margin: const EdgeInsets.only(
  //                       left: 30.0, top: 16.0, right: 25.0),
  //                   height: 56.0,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff334155),
  //                     borderRadius: BorderRadius.circular(
  //                       8.0,
  //                     ),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         color: Color(0xff475569),
  //                         offset: Offset(
  //                           0.0,
  //                           2.0,
  //                         ),
  //                         blurRadius: 0.0,
  //                         spreadRadius: 0.0,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                     margin: const EdgeInsets.only(top: 22.0, left: 45.0),
  //                     child: const Text(
  //                       "Nickname",
  //                       style: TextStyle(
  //                           fontSize: 11.0,
  //                           color: Color(0xff64748B),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500),
  //                     )),
  //                 TextFormField(
  //                   controller: _nickName,
  //                   cursorColor: const Color(0xffFFFFFF),
  //                   style: const TextStyle(color: Color(0xffFFFFFF)),
  //                   textAlignVertical: TextAlignVertical.bottom,
  //                   keyboardType: TextInputType.text,
  //                   maxLength: 30,
  //                   decoration: const InputDecoration(
  //                       counterText: "",
  //                       contentPadding: EdgeInsets.only(
  //                         bottom: 16.0,
  //                         top: 52.0,
  //                         right: 10,
  //                         left: 45.0,
  //                       ),
  //                       errorStyle: TextStyle(fontSize: 14, height: 0.20),
  //                       border: InputBorder.none,
  //                       hintText: 'Enter nickname',
  //                       hintStyle: TextStyle(
  //                           fontSize: 14.0,
  //                           color: Color(0xffFFFFFF),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500)),
  //                   autovalidateMode: _addSubmitted
  //                       ? AutovalidateMode.onUserInteraction
  //                       : AutovalidateMode.disabled,
  //                   validator: (value) {
  //                     if (value!.isEmpty) {
  //                       return 'Please enter';
  //                     }
  //                     return null;
  //                   },
  //                   onChanged: (text) => setState(() => name1 = text),
  //                 ),
  //               ],
  //             ),
  //             Stack(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.99,
  //                   margin: const EdgeInsets.only(
  //                       left: 30.0, top: 16.0, right: 25.0),
  //                   height: 110.0,
  //                   decoration: const BoxDecoration(
  //                     color: Color(0xff334155),
  //                     borderRadius: BorderRadius.only(
  //                       topRight: Radius.circular(8.0),
  //                       topLeft: Radius.circular(8.0),
  //                     ),
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Color(0xff475569),
  //                         offset: Offset(
  //                           0.0,
  //                           2.0,
  //                         ),
  //                         blurRadius: 0.0,
  //                         spreadRadius: 0.0,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                     margin: const EdgeInsets.only(
  //                         top: 22.0, left: 45.0, bottom: 20),
  //                     child: const Text(
  //                       "Your bio",
  //                       style: TextStyle(
  //                           fontSize: 11.0,
  //                           color: Color(0xff64748B),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500),
  //                     )),
  //                 TextFormField(
  //                   maxLines: 5,
  //                   controller: _bio,
  //                   cursorColor: const Color(0xffFFFFFF),
  //                   style: const TextStyle(color: Color(0xffFFFFFF)),
  //                   textAlignVertical: TextAlignVertical.bottom,
  //                   keyboardType: TextInputType.text,
  //                   decoration: const InputDecoration(
  //                       counterText: "",
  //                       errorStyle: TextStyle(fontSize: 14, height: 0.20),
  //                       contentPadding: EdgeInsets.only(
  //                           top: 47.0, right: 40, left: 45.0, bottom: 50),
  //                       border: InputBorder.none,
  //                       hintText: 'Enter your bio',
  //                       hintStyle: TextStyle(
  //                           fontSize: 14.0,
  //                           color: Color(0xffFFFFFF),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500)),
  //                   autovalidateMode: _addSubmitted
  //                       ? AutovalidateMode.onUserInteraction
  //                       : AutovalidateMode.disabled,
  //                   validator: (value) {
  //                     if (value!.isEmpty) {
  //                       return 'Please enter';
  //                     }
  //                     return null;
  //                   },
  //                   onChanged: (text) => setState(() => name1 = text),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Expanded(
  //                   flex: 1,
  //                   child: Stack(
  //                     children: [
  //                       Container(
  //                         width: MediaQuery.of(context).size.width * 0.12,
  //                         margin: const EdgeInsets.only(
  //                             left: 30.0, top: 16.0, right: 16.0),
  //                         height: 56.0,
  //                         decoration: BoxDecoration(
  //                           color: const Color(0xff334155),
  //                           borderRadius: BorderRadius.circular(
  //                             8.0,
  //                           ),
  //                           boxShadow: const [
  //                             BoxShadow(
  //                               color: Color(0xff475569),
  //                               offset: Offset(
  //                                 0.0,
  //                                 2.0,
  //                               ),
  //                               blurRadius: 0.0,
  //                               spreadRadius: 0.0,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                           margin:
  //                               const EdgeInsets.only(top: 23.0, left: 45.0),
  //                           child: const Text(
  //                             "Designation",
  //                             style: TextStyle(
  //                                 fontSize: 11.0,
  //                                 color: Color(0xff64748B),
  //                                 fontFamily: 'Inter',
  //                                 fontWeight: FontWeight.w500),
  //                           )),
  //                       TextFormField(
  //                         controller: _designation,
  //                         inputFormatters: [UpperCaseTextFormatter()],
  //                         maxLength: 18,
  //                         cursorColor: const Color(0xffFFFFFF),
  //                         style: const TextStyle(color: Color(0xffFFFFFF)),
  //                         textAlignVertical: TextAlignVertical.bottom,
  //                         keyboardType: TextInputType.text,
  //                         decoration: const InputDecoration(
  //                             counterText: "",
  //                             errorStyle: TextStyle(fontSize: 14, height: 0.20),
  //                             contentPadding: EdgeInsets.only(
  //                               bottom: 16.0,
  //                               top: 53.0,
  //                               right: 10,
  //                               left: 45.0,
  //                             ),
  //                             border: InputBorder.none,
  //                             hintText: 'Enter',
  //                             hintStyle: TextStyle(
  //                                 fontSize: 14.0,
  //                                 color: Color(0xffFFFFFF),
  //                                 fontFamily: 'Inter',
  //                                 fontWeight: FontWeight.w500)),
  //                         autovalidateMode: _addSubmitted
  //                             ? AutovalidateMode.onUserInteraction
  //                             : AutovalidateMode.disabled,
  //                         validator: (value) {
  //                           if (value!.isEmpty) {
  //                             return 'Please enter';
  //                           }
  //                           return null;
  //                         },
  //                         onChanged: (text) => setState(() => name1 = text),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 1,
  //                   child: Container(
  //                     width: MediaQuery.of(context).size.width * 0.13,
  //                     margin: const EdgeInsets.only(top: 10.0, right: 30),
  //                     height: 56.0,
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xff334155),
  //                       borderRadius: BorderRadius.circular(
  //                         8.0,
  //                       ),
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Container(
  //                             margin:
  //                                 const EdgeInsets.only(top: 6.0, left: 16.0),
  //                             child: const Text(
  //                               "Department",
  //                               style: TextStyle(
  //                                   fontSize: 13.0,
  //                                   color: Color(0xff64748B),
  //                                   fontFamily: 'Inter',
  //                                   fontWeight: FontWeight.w500),
  //                             )),
  //                         Container(
  //                           margin:
  //                               const EdgeInsets.only(left: 16.0, right: 16.0),
  //                           height: 20.0,
  //                           child: Container(child: StatefulBuilder(
  //                             builder:
  //                                 (BuildContext context, StateSettersetState) {
  //                               return DropdownButtonHideUnderline(
  //                                 child: CustomDropdownButton(
  //                                   dropdownColor: ColorSelect.class_color,
  //                                   value: _depat,
  //                                   underline: Container(),
  //                                   hint: const Text(
  //                                     "Select",
  //                                     style: TextStyle(
  //                                         fontSize: 14.0,
  //                                         color: Color(0xffFFFFFF),
  //                                         fontFamily: 'Inter',
  //                                         fontWeight: FontWeight.w500),
  //                                   ),
  //                                   icon: const Icon(
  //                                     Icons.arrow_drop_down,
  //                                     color: Color(0xff64748B),
  //                                   ),
  //                                   items: _department.map((items) {
  //                                     return DropdownMenuItem(
  //                                       value: items['id'].toString(),
  //                                       child: Text(
  //                                         items['name'],
  //                                         style: const TextStyle(
  //                                             fontSize: 14.0,
  //                                             color: Color(0xffFFFFFF),
  //                                             fontFamily: 'Inter',
  //                                             fontWeight: FontWeight.w400),
  //                                       ),
  //                                     );
  //                                   }).toList(),
  //                                   onChanged: (String? newValue) {
  //                                     setState(() {
  //                                       _depat = newValue;
  //                                     });
  //                                   },
  //                                 ),
  //                               );
  //                             },
  //                           )),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Stack(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.99,
  //                   margin: const EdgeInsets.only(
  //                       left: 30.0, top: 16.0, right: 26.0),
  //                   height: 56.0,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff334155),
  //                     borderRadius: BorderRadius.circular(
  //                       8.0,
  //                     ),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         color: Color(0xff475569),
  //                         offset: Offset(
  //                           0.0,
  //                           2.0,
  //                         ),
  //                         blurRadius: 0.0,
  //                         spreadRadius: 0.0,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                     margin: const EdgeInsets.only(top: 22.0, left: 45.0),
  //                     child: const Text(
  //                       "Associated with",
  //                       style: TextStyle(
  //                           fontSize: 11.0,
  //                           color: Color(0xff64748B),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500),
  //                     )),
  //                 TextFormField(
  //                   controller: _association,
  //                   cursorColor: const Color(0xffFFFFFF),
  //                   style: const TextStyle(color: Color(0xffFFFFFF)),
  //                   textAlignVertical: TextAlignVertical.bottom,
  //                   keyboardType: TextInputType.text,
  //                   maxLength: 30,
  //                   decoration: const InputDecoration(
  //                       counterText: "",
  //                       contentPadding: EdgeInsets.only(
  //                         bottom: 16.0,
  //                         top: 52.0,
  //                         right: 10,
  //                         left: 45.0,
  //                       ),
  //                       errorStyle: TextStyle(fontSize: 14, height: 0.20),
  //                       border: InputBorder.none,
  //                       hintText: 'Enter team name',
  //                       hintStyle: TextStyle(
  //                           fontSize: 14.0,
  //                           color: Color(0xffFFFFFF),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500)),
  //                   autovalidateMode: _addSubmitted
  //                       ? AutovalidateMode.onUserInteraction
  //                       : AutovalidateMode.disabled,
  //                   validator: (value) {
  //                     if (value!.isEmpty) {
  //                       return 'Please enter';
  //                     }
  //                     return null;
  //                   },
  //                   onChanged: (text) => setState(() => name1 = text),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               margin: const EdgeInsets.only(left: 30.0, top: 16.0),
  //               child: const Text(
  //                 "Salary",
  //                 style: TextStyle(
  //                     color: Color(0xffFFFFFF),
  //                     fontSize: 18.0,
  //                     fontFamily: 'Inter',
  //                     fontWeight: FontWeight.w700),
  //               ),
  //             ),
  //             Row(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.07,
  //                   margin: const EdgeInsets.only(
  //                       left: 30.0, top: 16.0, bottom: 16.0),
  //                   height: 56.0,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff334155),
  //                     borderRadius: BorderRadius.circular(
  //                       8.0,
  //                     ),
  //                   ),
  //                   child: Container(
  //                       margin: const EdgeInsets.only(left: 13.0, right: 18.0),
  //                       child: StatefulBuilder(
  //                         builder: (BuildContext context, StateSettersetState) {
  //                           return DropdownButtonHideUnderline(
  //                             child: DropdownButton(
  //                               dropdownColor: ColorSelect.class_color,
  //                               value: _curren,
  //                               underline: Container(),
  //                               hint: const Text(
  //                                 "€",
  //                                 style: TextStyle(
  //                                     fontSize: 14.0,
  //                                     color: Color(0xffFFFFFF),
  //                                     fontFamily: 'Inter',
  //                                     fontWeight: FontWeight.w500),
  //                               ),
  //                               isExpanded: true,
  //                               icon: Icon(
  //                                 Icons.arrow_drop_down,
  //                                 color: Color(0xff64748B),
  //                               ),
  //                               items: _currencyName.map((items) {
  //                                 return DropdownMenuItem(
  //                                   value: items['id'].toString(),
  //                                   child: Text(
  //                                     items['currency']['symbol'],
  //                                     style: const TextStyle(
  //                                         fontSize: 14.0,
  //                                         color: Color(0xffFFFFFF),
  //                                         fontFamily: 'Inter',
  //                                         fontWeight: FontWeight.w400),
  //                                   ),
  //                                 );
  //                               }).toList(),
  //                               onChanged: (String? newValue) {
  //                                 setState(() {
  //                                   _curren = newValue;
  //                                 });
  //                               },
  //                             ),
  //                           );
  //                         },
  //                       )),
  //                 ),
  //                 const SizedBox(
  //                   width: 8.0,
  //                 ),
  //                 Expanded(
  //                   child: Stack(
  //                     children: [
  //                       Container(
  //                         width: MediaQuery.of(context).size.width * 0.10,
  //                         margin:
  //                             const EdgeInsets.only(top: 16.0, bottom: 16.0),
  //                         height: 56.0,
  //                         decoration: BoxDecoration(
  //                           color: const Color(0xff334155),
  //                           borderRadius: BorderRadius.circular(
  //                             8.0,
  //                           ),
  //                           boxShadow: const [
  //                             BoxShadow(
  //                               color: Color(0xff475569),
  //                               offset: Offset(
  //                                 0.0,
  //                                 2.0,
  //                               ),
  //                               blurRadius: 0.0,
  //                               spreadRadius: 0.0,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                           margin:
  //                               const EdgeInsets.only(top: 23.0, left: 15.0),
  //                           child: const Text(
  //                             "Monthly Salary",
  //                             style: TextStyle(
  //                                 fontSize: 11.0,
  //                                 color: Color(0xff64748B),
  //                                 fontFamily: 'Inter',
  //                                 fontWeight: FontWeight.w500),
  //                           )),
  //                       TextFormField(
  //                         maxLength: 15,
  //                         controller: _salary,
  //                         cursorColor: const Color(0xffFFFFFF),
  //                         style: const TextStyle(color: Color(0xffFFFFFF)),
  //                         textAlignVertical: TextAlignVertical.bottom,
  //                         keyboardType: TextInputType.text,
  //                         decoration: const InputDecoration(
  //                             counterText: "",
  //                             errorStyle: TextStyle(fontSize: 14, height: 0.20),
  //                             contentPadding: EdgeInsets.only(
  //                               bottom: 16.0,
  //                               top: 52.0,
  //                               right: 10,
  //                               left: 15.0,
  //                             ),
  //                             border: InputBorder.none,
  //                             hintText: '0.00',
  //                             hintStyle: TextStyle(
  //                                 fontSize: 14.0,
  //                                 color: Color(0xffFFFFFF),
  //                                 fontFamily: 'Inter',
  //                                 fontWeight: FontWeight.w500)),
  //                         autovalidateMode: _addSubmitted
  //                             ? AutovalidateMode.onUserInteraction
  //                             : AutovalidateMode.disabled,
  //                         validator: (value) {
  //                           RegExp regex = RegExp(r'^\D+|(?<=\d),(?=\d)');

  //                           if (value!.isEmpty) {
  //                             return 'Please enter';
  //                           } else if (regex.hasMatch(value)) {
  //                             return 'Please enter valid salary';
  //                           }
  //                           return null;
  //                         },
  //                         onChanged: (text) => setState(() => name1 = text),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       Container(
  //           height: MediaQuery.of(context).size.height * 0.99,
  //           child: const VerticalDivider(
  //             color: Color(0xff94A3B8),
  //             thickness: 0.2,
  //           )),
  //       Expanded(
  //         flex: 1,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               margin: const EdgeInsets.only(left: 30.0, top: 27.0),
  //               child: const Text(
  //                 "Availabilty",
  //                 style: TextStyle(
  //                     color: Color(0xffFFFFFF),
  //                     fontSize: 18.0,
  //                     fontFamily: 'Inter',
  //                     fontWeight: FontWeight.w700),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 8.0,
  //             ),
  //             Stack(
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       width: MediaQuery.of(context).size.width * 0.26,
  //                       margin: const EdgeInsets.only(left: 30.0),
  //                       height: 56.0,
  //                       decoration: BoxDecoration(
  //                         color: const Color(0xff334155),
  //                         borderRadius: BorderRadius.circular(
  //                           8.0,
  //                         ),
  //                         boxShadow: const [
  //                           BoxShadow(
  //                             color: Color(0xff475569),
  //                             offset: Offset(
  //                               0.0,
  //                               2.0,
  //                             ),
  //                             blurRadius: 0.0,
  //                             spreadRadius: 0.0,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     selectedDaysList.length == 0
  //                         ? handleAllerrorWidget()
  //                         : Text('')
  //                   ],
  //                 ),
  //                 Container(
  //                     margin: const EdgeInsets.only(top: 6.0, left: 45.0),
  //                     child: const Text(
  //                       "Select days",
  //                       style: TextStyle(
  //                           fontSize: 11.0,
  //                           color: Color(0xff64748B),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500),
  //                     )),
  //                 Container(
  //                   margin:
  //                       const EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
  //                   height: 20.0,
  //                   child: Container(child: StatefulBuilder(
  //                     builder: (BuildContext context, StateSettersetState) {
  //                       return Padding(
  //                         padding: const EdgeInsets.only(left: 16, right: 70),
  //                         child: DropdownButtonHideUnderline(
  //                           child: DropdownButton(
  //                             dropdownColor: ColorSelect.class_color,
  //                             underline: Container(),
  //                             hint: const Text(
  //                               "Select",
  //                               style: TextStyle(
  //                                   fontSize: 14.0,
  //                                   color: Color(0xffFFFFFF),
  //                                   fontFamily: 'Inter',
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                             isExpanded: true,
  //                             icon: const Icon(
  //                               Icons.arrow_drop_down,
  //                               color: Color(0xff64748B),
  //                             ),
  //                             items: items1.map((String items1) {
  //                               return DropdownMenuItem(
  //                                 value: items1,
  //                                 child: Text(items1,
  //                                     style: (const TextStyle(
  //                                         color: Colors.white))),
  //                               );
  //                             }).toList(),
  //                             onChanged: (String? newValue) {
  //                               setState(() {
  //                                 _day = newValue;
  //                                 _shortday = _day!.substring(0, 3);
  //                                 if (selectedDaysList.isNotEmpty) {
  //                                   if (selectedDaysList.contains(_shortday)) {
  //                                   } else {
  //                                     selectedDaysList
  //                                         .add(_shortday!.toString());
  //                                   }
  //                                 } else {
  //                                   selectedDaysList.add(_shortday!.toString());
  //                                 }
  //                               });
  //                             },
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   )),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 55,
  //               child: Padding(
  //                 padding: EdgeInsets.only(left: 26),
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   scrollDirection: Axis.horizontal,
  //                   itemCount: selectedDaysList.length,
  //                   itemBuilder: (context, index) {
  //                     return Container(
  //                       margin: const EdgeInsets.only(left: 12.0),
  //                       child: InputChip(
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(8))),
  //                         deleteIcon: Icon(
  //                           Icons.close,
  //                           color: Colors.white,
  //                           size: 20,
  //                         ),
  //                         backgroundColor: Color(0xff334155),
  //                         visualDensity: VisualDensity.compact,
  //                         materialTapTargetSize:
  //                             MaterialTapTargetSize.shrinkWrap,
  //                         label: Text(
  //                           selectedDaysList[index],
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                         selected: _isSelected!,
  //                         onSelected: (bool selected) {
  //                           setState(() {
  //                             _isSelected = selected;
  //                             print(
  //                                 "_isSelected--------------------------${_isSelected}");
  //                           });
  //                         },
  //                         onDeleted: () {
  //                           setState(() {
  //                             selectedDaysList.removeAt(index);
  //                           });
  //                         },
  //                         showCheckmark: false,
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //             Stack(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.26,
  //                   margin: const EdgeInsets.only(left: 30.0, top: 16.0),
  //                   height: 56.0,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff334155),
  //                     borderRadius: BorderRadius.circular(
  //                       8.0,
  //                     ),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         color: Color(0xff475569),
  //                         offset: Offset(
  //                           0.0,
  //                           2.0,
  //                         ),
  //                         blurRadius: 0.0,
  //                         spreadRadius: 0.0,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                     margin: const EdgeInsets.only(top: 22.0, left: 45.0),
  //                     child: const Text(
  //                       "Select time",
  //                       style: TextStyle(
  //                           fontSize: 11.0,
  //                           color: Color(0xff64748B),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500),
  //                     )),
  //                 Container(
  //                     margin: const EdgeInsets.only(
  //                       bottom: 16.0,
  //                       top: 50.0,
  //                       right: 10,
  //                       left: 45.0,
  //                     ),
  //                     child: Text(
  //                       finalTime != null ? finalTime : " ",
  //                       style: TextStyle(
  //                           fontSize: 11.0,
  //                           color: Colors.white,
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500),
  //                     )),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 16, right: 16),
  //               child: TimeRange(
  //                 fromTitle: const Text(
  //                   'From',
  //                   style: TextStyle(fontSize: 14, color: Colors.white),
  //                 ),
  //                 toTitle: const Text(
  //                   'To',
  //                   style: TextStyle(fontSize: 14, color: Colors.white),
  //                 ),
  //                 titlePadding: 16,
  //                 textStyle: const TextStyle(
  //                     fontWeight: FontWeight.normal, color: Colors.white),
  //                 activeTextStyle: const TextStyle(
  //                     fontWeight: FontWeight.bold, color: Colors.white),
  //                 borderColor: Colors.white,
  //                 backgroundColor: Colors.transparent,
  //                 activeBackgroundColor: Colors.green,
  //                 firstTime: TimeOfDay(hour: 8, minute: 30),
  //                 lastTime: TimeOfDay(hour: 20, minute: 00),
  //                 timeStep: 10,
  //                 timeBlock: 10,
  //                 initialRange: Time1 != null && Time2 != null
  //                     ? TimeRangeResult(stringToTimeOfDay(Time1!)!,
  //                         stringToTimeOfDay(Time2!)!)
  //                     : null,
  //                 onRangeCompleted: (range) => setState(() {
  //                   print("time-------------------------------------");
  //                   setState(() {
  //                     startTime = range!.start;
  //                     endTime = range.end;
  //                     startTime1 = getformattedTime(startTime);
  //                     endTime2 = getformattedTime(endTime);
  //                     Time1 = getformattedTime(startTime);
  //                     Time2 = getformattedTime(endTime);

  //                     finalTime = '$startTime1 - $endTime2';
  //                   });
  //                 }),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 25.0,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Container(
  //                   margin: const EdgeInsets.only(left: 30.0, top: 27.0),
  //                   child: const Text(
  //                     "Skills",
  //                     style: TextStyle(
  //                         color: Color(0xffFFFFFF),
  //                         fontSize: 18.0,
  //                         fontFamily: 'Inter',
  //                         fontWeight: FontWeight.w700),
  //                   ),
  //                 ),
  //                 Container(
  //                     width: 40.0,
  //                     height: 40.0,
  //                     margin: const EdgeInsets.only(right: 20.0, top: 25.0),
  //                     decoration: const BoxDecoration(
  //                       color: Color(0xff334155),
  //                       shape: BoxShape.circle,
  //                     ),
  //                     child: Container(
  //                       child: Padding(
  //                           padding: const EdgeInsets.all(10.0),
  //                           child: SvgPicture.asset('images/tag_new.svg')),
  //                     )),
  //               ],
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   padding: EdgeInsets.only(left: 5, right: 5),
  //                   width: MediaQuery.of(context).size.width * 0.26,
  //                   margin: const EdgeInsets.only(left: 30.0, top: 16.0),
  //                   height: 50.0,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff334155),
  //                     borderRadius: BorderRadius.circular(
  //                       48.0,
  //                     ),
  //                   ),
  //                   child: Column(
  //                     children: [
  //                       searchTextField = AutoCompleteTextField<Datum>(
  //                         clearOnSubmit: false,
  //                         key: key,
  //                         cursorColor: Colors.white,
  //                         decoration: const InputDecoration(
  //                           contentPadding: EdgeInsets.only(top: 15.0),
  //                           prefixIcon: Padding(
  //                               padding: EdgeInsets.only(
  //                                   top: 4.0, left: 27.0, right: 21),
  //                               child: Icon(
  //                                 Icons.search,
  //                                 color: Color(0xff64748B),
  //                               )),
  //                           hintText: 'Search',
  //                           hintStyle: TextStyle(
  //                               fontSize: 14.0,
  //                               color: Color(0xff64748B),
  //                               fontFamily: 'Inter',
  //                               fontWeight: FontWeight.w400),
  //                           border: InputBorder.none,
  //                         ),
  //                         suggestions: users,
  //                         keyboardType: TextInputType.text,
  //                         style: TextStyle(color: Colors.white, fontSize: 14.0),
  //                         itemFilter: (item, query) {
  //                           return item.title!
  //                               .toLowerCase()
  //                               .startsWith(query.toLowerCase());
  //                         },
  //                         itemSorter: (a, b) {
  //                           return a.title!.compareTo(b.title!);
  //                         },
  //                         itemSubmitted: (item) {
  //                           setState(() {
  //                             searchTextField!.textField!.controller!.text = '';
  //                             if (abc.isNotEmpty) {
  //                               if (abc.contains(item.title!)) {
  //                               } else {
  //                                 abc.add(item.title!.toString());
  //                               }
  //                             } else {
  //                               abc.add(item.title!.toString());
  //                             }
  //                           });
  //                         },
  //                         itemBuilder: (context, item) {
  //                           return row(item);
  //                         },
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 abc.length == 0 ? handleAllerrorWidget() : Text('')
  //               ],
  //             ),
  //             widget.data!.resource != null
  //                 ? SizedBox(
  //                     height: 55,
  //                     child: Padding(
  //                       padding: EdgeInsets.only(left: 28.0),
  //                       child: ListView.builder(
  //                         shrinkWrap: true,
  //                         scrollDirection: Axis.horizontal,
  //                         itemCount: abc.length,
  //                         itemBuilder: (context, index) {
  //                           return Container(
  //                             height: 32.0,
  //                             margin: const EdgeInsets.only(left: 12.0),
  //                             child: InputChip(
  //                               shape: const RoundedRectangleBorder(
  //                                   borderRadius:
  //                                       BorderRadius.all(Radius.circular(8))),
  //                               deleteIcon: const Icon(
  //                                 Icons.close,
  //                                 color: Colors.white,
  //                                 size: 20,
  //                               ),
  //                               backgroundColor: const Color(0xff334155),
  //                               visualDensity: VisualDensity.compact,
  //                               materialTapTargetSize:
  //                                   MaterialTapTargetSize.shrinkWrap,
  //                               label: Text(
  //                                 abc[index],
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                               selected: _isSelected!,
  //                               onSelected: (bool selected) {
  //                                 setState(() {
  //                                   _isSelected = selected;
  //                                 });
  //                               },
  //                               onDeleted: () {
  //                                 setState(() {
  //                                   abc.removeAt(index);
  //                                 });
  //                               },
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   )
  //                 : Container(),
  //           ],
  //         ),
  //       ),
  //       Container(
  //           height: MediaQuery.of(context).size.height * 0.99,
  //           child: const VerticalDivider(
  //             color: Color(0xff94A3B8),
  //             thickness: 0.2,
  //           )),
  //       Expanded(
  //         flex: 1,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               margin: const EdgeInsets.only(left: 30.0, top: 27.0),
  //               child: const Text(
  //                 "Contact info",
  //                 style: TextStyle(
  //                     color: Color(0xffFFFFFF),
  //                     fontSize: 18.0,
  //                     fontFamily: 'Inter',
  //                     fontWeight: FontWeight.w700),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 8.0,
  //             ),
  //             Stack(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.26,
  //                   margin: const EdgeInsets.only(left: 30.0),
  //                   height: 56.0,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff334155),
  //                     borderRadius: BorderRadius.circular(
  //                       8.0,
  //                     ),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         color: Color(0xff475569),
  //                         offset: Offset(
  //                           0.0,
  //                           2.0,
  //                         ),
  //                         blurRadius: 0.0,
  //                         spreadRadius: 0.0,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                     margin: const EdgeInsets.only(top: 6.0, left: 45.0),
  //                     child: const Text(
  //                       "Country",
  //                       style: TextStyle(
  //                           fontSize: 11.0,
  //                           color: Color(0xff64748B),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500),
  //                     )),
  //                 TextFormField(
  //                   maxLength: 20,
  //                   controller: _country,
  //                   cursorColor: const Color(0xffFFFFFF),
  //                   style: const TextStyle(color: Color(0xffFFFFFF)),
  //                   textAlignVertical: TextAlignVertical.bottom,
  //                   keyboardType: TextInputType.text,
  //                   decoration: const InputDecoration(
  //                       counterText: "",
  //                       errorStyle: TextStyle(fontSize: 14, height: 0.20),
  //                       contentPadding: EdgeInsets.only(
  //                         bottom: 16.0,
  //                         top: 35.0,
  //                         right: 10,
  //                         left: 45.0,
  //                       ),
  //                       border: InputBorder.none,
  //                       hintText: 'Enter country',
  //                       hintStyle: TextStyle(
  //                           fontSize: 14.0,
  //                           color: Color(0xffFFFFFF),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500)),
  //                   autovalidateMode: _addSubmitted
  //                       ? AutovalidateMode.onUserInteraction
  //                       : AutovalidateMode.disabled,
  //                   validator: (value) {
  //                     RegExp regex = RegExp(r'^[a-z A-Z]+$');
  //                     if (value!.isEmpty) {
  //                       return 'Please enter';
  //                     } else if (!regex.hasMatch(value)) {
  //                       return 'Please enter valid  country name';
  //                     }
  //                     return null;
  //                   },
  //                   onChanged: (text) => setState(() => name1 = text),
  //                 ),
  //               ],
  //             ),
  //             Stack(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.26,
  //                   margin: const EdgeInsets.only(left: 30.0, top: 16.0),
  //                   height: 56.0,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff334155),
  //                     borderRadius: BorderRadius.circular(
  //                       8.0,
  //                     ),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         color: Color(0xff475569),
  //                         offset: Offset(
  //                           0.0,
  //                           2.0,
  //                         ),
  //                         blurRadius: 0.0,
  //                         spreadRadius: 0.0,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                     margin: const EdgeInsets.only(top: 22.0, left: 45.0),
  //                     child: const Text(
  //                       "City",
  //                       style: TextStyle(
  //                           fontSize: 11.0,
  //                           color: Color(0xff64748B),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500),
  //                     )),
  //                 TextFormField(
  //                   maxLength: 20,
  //                   controller: _enterCity,
  //                   cursorColor: const Color(0xffFFFFFF),
  //                   style: const TextStyle(color: Color(0xffFFFFFF)),
  //                   textAlignVertical: TextAlignVertical.bottom,
  //                   keyboardType: TextInputType.text,
  //                   decoration: const InputDecoration(
  //                       counterText: "",
  //                       errorStyle: TextStyle(fontSize: 14, height: 0.20),
  //                       contentPadding: EdgeInsets.only(
  //                         bottom: 16.0,
  //                         top: 50.0,
  //                         right: 10,
  //                         left: 45.0,
  //                       ),
  //                       border: InputBorder.none,
  //                       hintText: 'Enter city',
  //                       hintStyle: TextStyle(
  //                           fontSize: 14.0,
  //                           color: Color(0xffFFFFFF),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500)),
  //                   autovalidateMode: _addSubmitted
  //                       ? AutovalidateMode.onUserInteraction
  //                       : AutovalidateMode.disabled,
  //                   validator: (value) {
  //                     RegExp regex = RegExp(r'^[a-z A-Z]+$');
  //                     if (value!.isEmpty) {
  //                       return 'Please enter';
  //                     } else if (!regex.hasMatch(value)) {
  //                       return 'Please enter valid  city name';
  //                     }
  //                     return null;
  //                   },
  //                   onChanged: (text) => setState(() => name1 = text),
  //                 ),
  //               ],
  //             ),
  //             Stack(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.26,
  //                   margin: const EdgeInsets.only(left: 30.0, top: 16.0),
  //                   height: 56.0,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff334155),
  //                     borderRadius: BorderRadius.circular(
  //                       8.0,
  //                     ),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         color: Color(0xff475569),
  //                         offset: Offset(
  //                           0.0,
  //                           2.0,
  //                         ),
  //                         blurRadius: 0.0,
  //                         spreadRadius: 0.0,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                     margin: const EdgeInsets.only(top: 22.0, left: 45.0),
  //                     child: const Text(
  //                       "Phone number",
  //                       style: TextStyle(
  //                           fontSize: 11.0,
  //                           color: Color(0xff64748B),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500),
  //                     )),
  //                 TextFormField(
  //                   maxLength: 10,
  //                   controller: _phoneNumber,
  //                   cursorColor: const Color(0xffFFFFFF),
  //                   style: const TextStyle(color: Color(0xffFFFFFF)),
  //                   textAlignVertical: TextAlignVertical.bottom,
  //                   keyboardType: TextInputType.text,
  //                   decoration: const InputDecoration(
  //                       counterText: "",
  //                       errorStyle: TextStyle(fontSize: 14, height: 0.20),
  //                       contentPadding: EdgeInsets.only(
  //                         bottom: 16.0,
  //                         top: 50.0,
  //                         right: 10,
  //                         left: 45.0,
  //                       ),
  //                       border: InputBorder.none,
  //                       hintText: 'Enter number',
  //                       hintStyle: TextStyle(
  //                           fontSize: 14.0,
  //                           color: Color(0xffFFFFFF),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500)),
  //                   autovalidateMode: _addSubmitted
  //                       ? AutovalidateMode.onUserInteraction
  //                       : AutovalidateMode.disabled,
  //                   validator: (value) {
  //                     String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
  //                     RegExp regExp = new RegExp(pattern);

  //                     if (value!.isEmpty) {
  //                       return 'Please enter';
  //                     } else if (!regExp.hasMatch(value)) {
  //                       return 'Please enter valid mobile number';
  //                     }

  //                     return null;
  //                   },
  //                   onChanged: (text) => setState(() => name1 = text),
  //                 ),
  //               ],
  //             ),
  //             Stack(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.26,
  //                   margin: const EdgeInsets.only(left: 30.0, top: 16.0),
  //                   height: 56.0,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff334155),
  //                     borderRadius: BorderRadius.circular(
  //                       8.0,
  //                     ),
  //                     boxShadow: const [
  //                       BoxShadow(
  //                         color: Color(0xff475569),
  //                         offset: Offset(
  //                           0.0,
  //                           2.0,
  //                         ),
  //                         blurRadius: 0.0,
  //                         spreadRadius: 0.0,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                     margin: const EdgeInsets.only(top: 22.0, left: 45.0),
  //                     child: const Text(
  //                       "Email address",
  //                       style: TextStyle(
  //                           fontSize: 11.0,
  //                           color: Color(0xff64748B),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500),
  //                     )),
  //                 TextFormField(
  //                   maxLength: 20,
  //                   controller: _emailAddress,
  //                   cursorColor: const Color(0xffFFFFFF),
  //                   style: const TextStyle(color: Color(0xffFFFFFF)),
  //                   textAlignVertical: TextAlignVertical.bottom,
  //                   keyboardType: TextInputType.text,
  //                   decoration: const InputDecoration(
  //                       counterText: "",
  //                       errorStyle: TextStyle(fontSize: 14, height: 0.20),
  //                       contentPadding: EdgeInsets.only(
  //                         bottom: 16.0,
  //                         top: 50.0,
  //                         right: 10,
  //                         left: 45.0,
  //                       ),
  //                       border: InputBorder.none,
  //                       hintText: 'Enter email address',
  //                       hintStyle: TextStyle(
  //                           fontSize: 14.0,
  //                           color: Color(0xffFFFFFF),
  //                           fontFamily: 'Inter',
  //                           fontWeight: FontWeight.w500)),
  //                   autovalidateMode: _addSubmitted
  //                       ? AutovalidateMode.onUserInteraction
  //                       : AutovalidateMode.disabled,
  //                   validator: (value) {
  //                     RegExp regex = RegExp(
  //                         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //                     if (value!.isEmpty) {
  //                       return 'Please enter email';
  //                     }
  //                     if (!regex.hasMatch(value)) {
  //                       return 'Enter valid Email';
  //                     }
  //                     if (regex.hasMatch(values)) {
  //                       return 'please enter valid email';
  //                     }
  //                     if (value.length > 50) {
  //                       return 'No more length 50';
  //                     }
  //                     return null;
  //                   },
  //                   onChanged: (text) => setState(() => name1 = text),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               width: MediaQuery.of(context).size.width * 0.26,
  //               margin: const EdgeInsets.only(top: 20.0, left: 30.0),
  //               height: 56.0,
  //               decoration: BoxDecoration(
  //                 color: const Color(0xff334155),
  //                 borderRadius: BorderRadius.circular(
  //                   8.0,
  //                 ),
  //               ),
  //               child: Container(
  //                   margin: const EdgeInsets.only(left: 16.0, right: 20.0),
  //                   child: StatefulBuilder(
  //                     builder: (BuildContext context, StateSettersetState) {
  //                       return DropdownButtonHideUnderline(
  //                         child: DropdownButton(
  //                           dropdownColor: ColorSelect.class_color,
  //                           value: _time,
  //                           underline: Container(),
  //                           hint: const Text(
  //                             "Select TimeZone",
  //                             style: TextStyle(
  //                                 fontSize: 14.0,
  //                                 color: Color(0xffFFFFFF),
  //                                 fontFamily: 'Inter',
  //                                 fontWeight: FontWeight.w500),
  //                           ),
  //                           isExpanded: true,
  //                           icon: Icon(
  //                             Icons.arrow_drop_down,
  //                             color: Color(0xff64748B),
  //                           ),
  //                           items: _timeline.map((items) {
  //                             return DropdownMenuItem(
  //                               value: items['id'].toString(),
  //                               child: Text(
  //                                 items['name'] + ', ' + items['diff_from_gtm'],
  //                                 style: const TextStyle(
  //                                     fontSize: 14.0,
  //                                     color: Color(0xffFFFFFF),
  //                                     fontFamily: 'Inter',
  //                                     fontWeight: FontWeight.w400),
  //                               ),
  //                             );
  //                           }).toList(),
  //                           onChanged: (String? newValue) {
  //                             setState(() {
  //                               _time = newValue;
  //                               print("account:$_time");
  //                             });
  //                           },
  //                         ),
  //                       );
  //                     },
  //                   )),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Future<String?> getDepartment() async {
    String? value;
    var token = 'Bearer ' + storage.read("token");
    if (value == null) {
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/departments"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _department = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print('department error===========>>>>>>>>');
        print("failed to much");
      }
      return value;
    }
    return null;
  }

  Future<String?> getTimeline() async {
    String? value;
    var token = 'Bearer ' + storage.read("token");
    if (value == null) {
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/time-zone/list"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _timeline = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }

  void getUsers() async {
    var token = 'Bearer ' + storage.read("token");

    var response = await http.get(
      Uri.parse(AppUrl.tags_search),
      headers: {"Accept": "application/json", "Authorization": token},
    );

    if (response.statusCode == 200) {
      print("sucess");

      var user = userFromJson(response.body);

      users = user.data!;

      setState(() {
        loading = false;
      });
    } else if (response.statusCode == 401) {
      AppUtil.showErrorDialog(context);
    } else {
      print("Error getting users.");
    }
  }

  getUpdatePeople(String userId, BuildContext context) async {
    var decodedMap;
    var responseString;

    String commaSepratedString = selectedDaysList.join(", ");

    var token = 'Bearer ' + storage.read("token");

    var request = http.MultipartRequest(
        'POST', Uri.parse('${AppUrl.baseUrl}/resource/update'));
    request.headers
        .addAll({"Content-Type": "application/json", "Authorization": token});
    request.fields['user_id'] = userId;
    request.fields['name'] = _name.text.toString();
    request.fields['nickname'] = _nickName.text.toString();
    request.fields['email'] = _emailAddress.text.toString();
    request.fields['phone_number'] = _phoneNumber.text.toString();
    request.fields['password'] = 'Nirmaljeet@123';
    request.fields['bio'] = _bio.text.toString();
    request.fields['designation'] = _designation.text.toString();
    request.fields['department_id'] =
        _depat ?? widget.data!.resource!.department!.id.toString();
    request.fields['associate'] = _association.text.toString();
    request.fields['salary'] = _salary.text.toString();
    request.fields['salary_currency'] = _salaryCurrency.text.toString();
    request.fields['availibilty_day'] = commaSepratedString;
    request.fields['availibilty_time'] = finalTime;
    request.fields['country'] = _country.text.toString();
    request.fields['city'] = _enterCity.text.toString();
    request.fields['time_zone'] =
        _time ?? widget.data!.resource!.timeZone!.diffFromGtm.toString();

    if (!imageavail) {
    } else {
      _selectedFile = webImage;
      request.files.add(await http.MultipartFile.fromBytes(
          'image', _selectedFile!,
          contentType: MediaType('application', 'octet-stream'),
          filename: "file_up"));
    }

    for (int i = 0; i < abc.length; i++) {
      request.fields['skills[$i]'] = '${abc[i]}';
    }

    print(
        "Request Data ------------------------------------------------ ${request.fields}");

    var response = await request.send();
    responseString = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      decodedMap = json.decode(responseString);

      SmartDialog.dismiss();
      try {
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }

      widget.returnValue!();
    } else if (response.statusCode == 401) {
      SmartDialog.dismiss();
      AppUtil.showErrorDialog(context);
    } else {
      SmartDialog.dismiss();

      Fluttertoast.showToast(
        msg: 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
    }
  }

  deletePeople(int? peopleId, BuildContext buildContext) async {
    var url = '${AppUrl.delete}${peopleId}';
    var token = 'Bearer ' + storage.read("token");

    var response = await http.delete(
      Uri.parse(url),
      headers: {"Accept": "application/json", "Authorization": token},
    );

    if (response.statusCode == 200) {
      print("sucess");

      SmartDialog.dismiss();

      widget.returnValue!();
    } else if (response.statusCode == 401) {
      AppUtil.showErrorDialog(context);
    } else {
      var user = userFromJson(response.body);
      Fluttertoast.showToast(
        msg: user.message != null ? user.message! : 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
      SmartDialog.dismiss();
    }
  }

  Future<String?> getCurrency() async {
    String? value;
    var token = 'Bearer ' + storage.read("token");
    if (value == null) {
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/currencies"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _currencyName = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }

  errorWidget() {
    return Text('Please Select this field',
        style: TextStyle(
            color: Color.fromARGB(255, 221, 49, 60), fontSize: 14.sp));
  }

  handleAllerrorWidget() {
    return Row(
      children: [
        SizedBox(width: 45.w),
        Padding(
            padding: EdgeInsets.only(
              top: 8.sp,
              left: 0,
            ),
            child: errorWidget())
      ],
    );
  }
}
