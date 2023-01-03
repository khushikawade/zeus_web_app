import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/helper_widget/responsive.dart';
import 'package:zeus/people_module/create_people/create_people_page.dart';
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
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
  final Function? onUpdateData;

  MyMenu(
      {required this.title,
      required this.alignment,
      this.peopleList,
      this.offset = const Offset(0, 48),
      this.data,
      required this.buildContext,
      this.returnValue,
      this.onUpdateData,
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
            onTap: () async {
              if (widget.data != null) {
                Navigator.pop(context);
                bool result = await showDialog(
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

                if (result != null && result) {
                  // widget.response =
                  Provider.of<PeopleHomeViewModel>(context, listen: false)
                      .getPeopleDataList(searchText: '');

                  setState(() {
                    try {
                      if (widget.onUpdateData != null) {
                        widget.onUpdateData!();
                      }
                    } catch (e) {
                      print(
                          "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<error>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
                      print(e);
                    }
                  });
                }
              }
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
                                          // margin: EdgeInsets.only(right: 56.sp),
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
                                      SizedBox(
                                        width: 46.w,
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

  Future<String?> getDepartment() async {
    if (storage.read("token") != null &&
        storage.read("token").toString().isNotEmpty) {
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
          AppUtil.showErrorDialog(
              context, 'Your Session has been expired, Please try again!');
        } else {
          print('department error===========>>>>>>>>');
          print("failed to much");
        }
        return value;
      }
      return null;
    }
  }

  Future<String?> getTimeline() async {
    if (storage.read("token") != null &&
        storage.read("token").toString().isNotEmpty) {
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
          AppUtil.showErrorDialog(
              context, 'Your Session has been expired, Please try again!');
        } else {
          print("failed to much");
        }
        return value;
      }
      return null;
    }
  }

  void getUsers() async {
    if (storage.read("token") != null &&
        storage.read("token").toString().isNotEmpty) {
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
        AppUtil.showErrorDialog(
            context, 'Your Session has been expired, Please try again!');
      } else {
        print("Error getting users.");
      }
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

  Future<String?> getCurrency() async {
    if (storage.read("token") != null &&
        storage.read("token").toString().isNotEmpty) {
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
          AppUtil.showErrorDialog(
              context, 'Your Session has been expired, Please try again!');
        } else {
          print("failed to much");
        }
        return value;
      }
      return null;
    }
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
