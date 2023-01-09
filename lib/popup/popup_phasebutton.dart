import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:zeus/services/response_model/project_detail_response.dart';
import 'package:zeus/utility/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/utility/constant.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:zeus/utility/util.dart';
import '../helper_widget/search_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:zeus/utility/app_url.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuPhase extends StatefulWidget {
  int index;
  ProjectDetailResponse response;
  final String title;
  final Alignment alignment;
  final Offset offset;
  Phase? data;
  BuildContext buildContext;
  StateSetter setState;
  final Function? returnValue;
  VoidCallback onDeleteSuccess;
  VoidCallback? onEditClick;

  MenuPhase(
      {required this.index,
      required this.title,
      required this.alignment,
      required this.response,
      required this.onDeleteSuccess,
      this.offset = const Offset(0, 0),
      this.data,
      required this.buildContext,
      required this.setState,
      this.onEditClick,
      this.returnValue,
      Key? key})
      : super(key: key);

  @override
  State<MenuPhase> createState() => _MenuPhaseState();
}

class _MenuPhaseState extends State<MenuPhase>
    with SingleTickerProviderStateMixin {
  String _value = "";
  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Datum>> key = new GlobalKey();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static List<Datum> users = <Datum>[];
  List<String> selectedDaysList = List.empty(growable: true);
  List _timeline = [];
  String? _depat,
      _account,
      _custome,
      _curren,
      _status,
      _time,
      _tag,
      _day,
      _shortday;

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
  Future? _getList;
  var postion;
  SharedPreferences? sharedPreferences;
  GlobalKey<FormState> _addFormKey = new GlobalKey<FormState>();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
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

  // bool saveButtonClick = false;
  bool? _isSelected;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _nickName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _designation = TextEditingController();
  final TextEditingController _association = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  final TextEditingController _salaryCurrency = TextEditingController();
  final TextEditingController _availableDay = TextEditingController();
  final TextEditingController _availableTime = TextEditingController();
  final TextEditingController _search = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _enterCity = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();

  @override
  void initState() {
    _isSelected = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: "",
      // tooltip: null,
      // offset: widget.offset,
      // color: Color(0xFF0F172A),
      constraints: BoxConstraints.expand(width: 130.w, height: 120.h),
      // padding: EdgeInsets.only(left: 50, right: 50),
      offset: const Offset(-15, 12),
      position: PopupMenuPosition.under,
      color: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),

      child: Container(
        height: 28.0.w,
        width: 28.0.w,
        decoration: BoxDecoration(
            color: const Color(0xff334155),
            border: Border.all(
              color: ColorSelect.box_decoration,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: SvgPicture.asset(
              "images/edit.svg",
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
              widget.onEditClick!();
            },
            // child: Container(
            //   width: 30,
            //   child: const Text(
            //     "Edit",
            //     style: TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w500,
            //         fontFamily: 'Inter',
            //         color: ColorSelect.white_color),
            //   ),
            // ),
            child: Container(
              width: double.infinity,
              height: 50.h,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0.sp, top: 15.sp),
                child: Text(
                  "Edit",
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
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
                          borderRadius: BorderRadius.circular(28.0.r),
                        ),
                        backgroundColor: ColorSelect.peoplelistbackgroundcolor,
                        content: Container(
                          height: 110.0.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20.0),
                                child: Text(
                                  "Do you want to delete this phase ?",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                      color: ColorSelect.white_color),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15.0),
                                child: Text(
                                  "Once deleted, you will not find this phase in phase list.",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                      color: ColorSelect.delete),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 30.0.sp),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Inter',
                                                color: ColorSelect.delete_text),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 35.w),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          SmartDialog.showLoading(
                                            msg:
                                                "Your request is in progress please wait for a while...",
                                          );
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            deletePeople(
                                                widget.data!.id,
                                                widget.buildContext,
                                                setState,
                                                widget.index);
                                          });
                                        },
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Inter',
                                              color: Color(0xffEB4444)),
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
                      color: ColorSelect.white_color),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _editSubmit() {
    setState(() {
      _addSubmitted = true;
    });
    if (_addFormKey.currentState!.validate()) {
      Navigator.pushNamed(context, "/home");
    }
  }

  getUpdatePeople(String userId, BuildContext context) async {}

  deletePeople(int? peopleId, BuildContext buildContext, StateSetter setState,
      int indexs) async {
    var url = '${AppUrl.deleteForphase}${peopleId}';
    var token = 'Bearer ' + storage.read("token");

    var response = await http.delete(
      Uri.parse(url),
      headers: {"Accept": "application/json", "Authorization": token},
    );

    if (response.statusCode == 200) {
      print("sucess");
      print(indexs);
      widget.onDeleteSuccess();

      SmartDialog.dismiss();

      widget.returnValue!();
    } else if (response.statusCode == 401) {
      SmartDialog.dismiss();
      AppUtil.showErrorDialog(
          context, 'Your Session has been expired, Please try again!');
    } else if (response.statusCode == 401) {
      SmartDialog.dismiss();
      AppUtil.showErrorDialog(
          context, 'Your Session has been expired, Please try again!');
    } else {
      var user = userFromJson(response.body);
      Fluttertoast.showToast(
        timeInSecForIosWeb: 5,
        msg: user.message != null ? user.message! : 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
      SmartDialog.dismiss();
    }
  }

  errorWidget() {
    return Text('Please Select this field',
        style:
            TextStyle(color: Color.fromARGB(255, 221, 49, 60), fontSize: 14));
  }

  handleAllerrorWidget() {
    return Row(
      children: [
        const SizedBox(width: 45),
        Padding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 0,
            ),
            child: errorWidget())
      ],
    );
  }
}
