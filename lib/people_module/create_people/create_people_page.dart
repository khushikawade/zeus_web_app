import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:zeus/helper_widget/custom_datepicker.dart';
import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/helper_widget/custom_form_field.dart';
import 'package:zeus/helper_widget/custom_search_dropdown.dart';
import 'package:zeus/helper_widget/time_range_data.dart';
import 'package:zeus/home_module/home_page.dart';
import 'package:zeus/services/model/model_class.dart';
import 'package:zeus/services/response_model/project_detail_response.dart';
import 'package:zeus/services/response_model/skills_model/skills_response.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/colors.dart';
import 'package:http/http.dart' as http;
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';

class CreatePeoplePage extends StatefulWidget {
  PeopleData? response;
  GlobalKey<FormState>? formKey = new GlobalKey<FormState>();
  bool? isEdit;

  CreatePeoplePage({Key? key, this.formKey, this.response, this.isEdit})
      : super(key: key);

  @override
  State<CreatePeoplePage> createState() => _EditPageState();
}

class _EditPageState extends State<CreatePeoplePage> {
  String? _account,
      _custome,
      _curren,
      _status,
      _time = "",
      _day = "",
      _shortday = "";
  DateTime? selectedDate;
  String name_ = '';

  bool createButtonClick = false;
  bool createPeopleValidate = true;
  bool dataLoading = false;
  bool loading = true;

  List<DropdownModel>? departmentlist = [];

  TypeAheadFormField? searchTextField;
  final TextEditingController _typeAheadController = TextEditingController();

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
  final ScrollController verticalScroll = ScrollController();

  List<DropdownModel>? accountablePersonList = [];
  List<DropdownModel>? consumerList = [];
  List<DropdownModel>? projectStatusList = [];
  List<String> abc = [];
  List<DropdownModel>? selecTimeZoneList = [];
  List _department = [];

  List<String> selectedDaysList = List.empty(growable: true);
  static List<Datum> users = <Datum>[];

  List<DropdownModel>? currencyList = [];

  List<DropdownModel>? selectDaysList = [];

  bool imageavail = false;

  var items1 = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  var finalTime;

  bool? _isSelected = false;

  bool selectDepartment = false;
  bool selectSalary = false;
  bool selectDays = false;
  bool selectSkill = false;
  bool selectTime = false;
  bool selectTimeZone = false;
  bool selectImage = false;
  List<int>? _selectedFile;
  List _timeline = [];

  String? _depat;

  var startTime1;
  var endTime2;

  var startTime;
  var endTime;

  Image? image;
  Uint8List? webImage;

  List<Datum> getSuggestions(String query) {
    List<Datum> matches = List.empty(growable: true);
    matches.addAll(users);
    matches.retainWhere(
        (s) => s.title!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Future<String?> getSelectStatus() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/status"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          try {
            projectStatusList!.clear();

            mdata.forEach((element) {
              projectStatusList!.add(
                  DropdownModel(element['id'].toString(), element['title']));
            });

            // _accountableId.map((result) {
            //   print("<<<<<<<<<<<<<<<<<<<<<<result>>>>>>>>>>>>>>>>>>>>>>");
            //   print(result);
            //   accountablePersonList!.add(result['name']);
            // });
          } catch (e) {
            print(e);
          }
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

  Future<String?> getAccountable() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse(AppUrl.accountable_person),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          try {
            accountablePersonList!.clear();

            mdata.forEach((element) {
              accountablePersonList!.add(
                  DropdownModel(element['id'].toString(), element['name']));
            });

            // _accountableId.map((result) {
            //   print("<<<<<<<<<<<<<<<<<<<<<<result>>>>>>>>>>>>>>>>>>>>>>");
            //   print(result);
            //   accountablePersonList!.add(result['name']);
            // });
          } catch (e) {
            print(e);
          }
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

  Future<String?> getCustomer() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/customer"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          try {
            consumerList!.clear();

            mdata.forEach((element) {
              if (!currencyList!.contains(element)) {
                consumerList!.add(
                    DropdownModel(element['id'].toString(), element['name']));
              }
            });
          } catch (e) {
            print(e);
          }
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

  // // update Controller Value
  // updateControllerValue() {
  //   _projecttitle.text = widget.response!.data != null &&
  //           widget.response!.data!.title != null &&
  //           widget.response!.data!.title!.isNotEmpty
  //       ? widget.response!.data!.title!
  //       : '';

  //   _crmtask.text = widget.response!.data != null &&
  //           widget.response!.data!.crmTaskId != null &&
  //           widget.response!.data!.crmTaskId!.isNotEmpty
  //       ? widget.response!.data!.crmTaskId!
  //       : '';

  //   _warkfolderId.text = widget.response!.data != null &&
  //           widget.response!.data!.workFolderId != null &&
  //           widget.response!.data!.workFolderId!.isNotEmpty
  //       ? widget.response!.data!.workFolderId!
  //       : '';

  //   _budget.text =
  //       widget.response!.data != null && widget.response!.data!.budget != null
  //           ? widget.response!.data!.budget!.toString()
  //           : '';

  //   _estimatehours.text = widget.response!.data != null &&
  //           widget.response!.data!.estimationHours != null &&
  //           widget.response!.data!.estimationHours!.isNotEmpty
  //       ? widget.response!.data!.estimationHours!.toString()
  //       : '';

  //   _custome = widget.response!.data != null &&
  //           widget.response!.data!.customerId != null
  //       ? widget.response!.data!.customerId.toString()
  //       : '';

  //   _account = widget.response!.data != null &&
  //           widget.response!.data!.accountablePersonId != null
  //       ? widget.response!.data!.accountablePersonId.toString()
  //       : '';

  //   _status =
  //       widget.response!.data != null && widget.response!.data!.status != null
  //           ? widget.response!.data!.status.toString()
  //           : '';

  //   _curren =
  //       widget.response!.data != null && widget.response!.data!.currency != null
  //           ? widget.response!.data!.currency.toString()
  //           : '';

  //   try {
  //     DropdownModel? result = getAllInitialValue(projectStatusList, _status);
  //     if (result != null) {
  //       _status = result.id;
  //     } else {
  //       _status = null;
  //     }
  //   } catch (e) {}

  //   if (widget.response!.data != null &&
  //       widget.response!.data!.deliveryDate != null &&
  //       widget.response!.data!.deliveryDate!.isNotEmpty) {
  //     selectedDate = AppUtil.stringToDate(widget.response!.data!.deliveryDate!);
  //   }
  // }

  @override
  void initState() {
    items1.forEach((element) {
      selectDaysList!.add(DropdownModel('', element));
    });
    callAllApi();

    super.initState();
  }

  callAllApi() async {
    setState(() {
      if (widget.response != null) {
        dataLoading = true;
      }
    });

    await getUsers();

    await getDepartment();
    await getCustomer();
    await getCurrency();
    await getTimeline();
    if (widget.response != null) {
      await updateControllerValue();
    }
    setState(() {
      dataLoading = false;
    });
  }

  // update controller value
  updateControllerValue() {
    _name.text =
        widget.response!.name != null && widget.response!.name!.isNotEmpty
            ? widget.response!.name!
            : '';
    _nickName.text = widget.response!.resource != null
        ? widget.response!.resource!.nickname != null &&
                widget.response!.resource!.nickname!.isNotEmpty
            ? widget.response!.resource!.nickname!
            : ''
        : '';

    _bio.text = widget.response!.resource != null
        ? widget.response!.resource!.bio != null &&
                widget.response!.resource!.bio!.isNotEmpty
            ? widget.response!.resource!.bio!
            : ''
        : '';

    _designation.text = widget.response!.resource != null
        ? widget.response!.resource!.designation != null &&
                widget.response!.resource!.designation!.isNotEmpty
            ? widget.response!.resource!.designation!
            : ''
        : '';

    _association.text = widget.response!.resource != null
        ? widget.response!.resource!.associate != null &&
                widget.response!.resource!.associate!.isNotEmpty
            ? widget.response!.resource!.associate!
            : ''
        : '';

    _salary.text = widget.response!.resource != null
        ? widget.response!.resource!.salary != null
            ? widget.response!.resource!.salary!.toString()
            : ''
        : '';

    _availableDay.text = widget.response!.resource != null
        ? widget.response!.resource!.availibiltyDay != null &&
                widget.response!.resource!.availibiltyDay!.isNotEmpty
            ? widget.response!.resource!.availibiltyDay!
            : ''
        : '';

    final splitNames = _availableDay.text.split(", ");

    for (int i = 0; i < splitNames.length; i++) {
      selectedDaysList.add(splitNames[i]);
    }

    // _availableTime.text = widget.response!.resource != null
    //     ? widget.response!.resource!.availibiltyTime != null &&
    //             widget.response!.resource!.availibiltyTime!.isNotEmpty
    //         ? widget.response!.resource!.availibiltyTime!
    //         : ''
    //     : '';

    widget.response!.resource!.availibiltyTime != null
        ? finalTime = widget.response!.resource!.availibiltyTime!
        : " ";

    finalTime.toString().trim();
    if (finalTime != null && finalTime.contains("-")) {
      print("here");
      List<String> splitedList = finalTime!.split("-");
      startTime1 = splitedList[0].trim();
      endTime2 = splitedList[1].trim();
    } else {}

    if (widget.response!.resource != null) {
      _country.text = widget.response!.resource!.country != null &&
              widget.response!.resource!.country!.isNotEmpty
          ? widget.response!.resource!.country!
          : '';
    }

    if (widget.response!.resource != null) {
      _enterCity.text = widget.response!.resource!.city != null &&
              widget.response!.resource!.city!.isNotEmpty
          ? widget.response!.resource!.city!
          : '';
    }

    _phoneNumber.text = widget.response!.phoneNumber != null &&
            widget.response!.phoneNumber!.isNotEmpty
        ? widget.response!.phoneNumber!
        : '';

    _emailAddress.text =
        widget.response!.email != null && widget.response!.email!.isNotEmpty
            ? widget.response!.email!
            : '';

    if (widget.response!.resource != null) {
      _depat = widget.response!.resource!.department!.name!.isNotEmpty
          ? widget.response!.resource!.departmentId.toString()
          : '';
    }

    _time = widget.response!.resource != null &&
            widget.response!.resource!.timeZone!.name!.isNotEmpty
        ? widget.response!.resource!.timeZone!.id.toString()
        : '';

    if (widget.response!.resource != null) {
      _curren = widget.response!.resource!.salaryCurrency != null &&
              widget.response!.resource!.salaryCurrency!.isNotEmpty
          ? widget.response!.resource!.salaryCurrency!
          : '';

      if (widget.response!.resource!.skills!.isNotEmpty) {
        widget.response!.resource!.skills!.forEach((element) {
          if (abc.isNotEmpty) {
            if (abc.contains(element.title!)) {
            } else {
              abc.add(element.title!.toString());
            }
          } else {
            abc.add(element.title!.toString());
          }
          // abc.add(element.title!);
        });
      }
    }
  }

  Future<String?> getTimeline() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
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

          try {
            selecTimeZoneList = [];
            _timeline.forEach((element) {
              print(element);
              selecTimeZoneList!.add(DropdownModel(element['id'].toString(),
                  '${element['name'] + ', ' + element['diff_from_gtm']}'));
            });
          } catch (e) {
            print(e);
          }
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

  Future<String?> getDepartment() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
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
          print(_department);
          print(_department);
          try {
            departmentlist = []; //!.clear();
            _department.forEach((element) {
              print(element);
              departmentlist!.add(
                  DropdownModel(element['id'].toString(), element['name']));
            });
            // _department.forEach((element) {
            //   print(element);
            //   print(element);
            //   if (!departmentlist!.contains(element["id"])) {
            //     departmentlist!
            //         .add(DropdownModel(element["id"], element["id"]));
            //   }
            // });
          } catch (e) {
            print(e);
          }
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

  Future<String?> getUsers() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse(AppUrl.tags_search),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        print("skills sucess");
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
      return value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return createPeopleView();
  }

  Widget createPeopleView() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.99,
      height: MediaQuery.of(context).size.height * 0.99,
      child: dataLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RawScrollbar(
              controller: verticalScroll,
              thumbColor: const Color(0xff4b5563),
              crossAxisMargin: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              thickness: 8,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView(
                  controller: verticalScroll,
                  shrinkWrap: true,
                  children: [
                    Container(
                        height: 87.h,
                        decoration: BoxDecoration(
                          color: Color(0xff283345),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.r),
                            topLeft: Radius.circular(16..r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x26000000),
                              offset: Offset(
                                0.0,
                                1.0,
                              ),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 30.sp, top: 10.sp, bottom: 10.sp),
                              child: Text(
                                widget.isEdit! ? "Edit People" : "Add People",
                                style: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontStyle: FontStyle.normal,
                                    fontSize: 22.sp,
                                    letterSpacing: 0.1,
                                    fontFamily: 'Inter-Bold',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 97.h,
                              margin:
                                  EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                borderRadius: BorderRadius.circular(
                                  40.r,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  _name.clear();
                                  _nickName.clear();
                                  _bio.clear();
                                  _password.clear();
                                  _designation.clear();
                                  _association.clear();
                                  _salary.clear();
                                  _salaryCurrency.clear();
                                  _availableDay.clear();
                                  _availableTime.clear();
                                  _search.clear();
                                  _country.clear();
                                  _enterCity.clear();
                                  _phoneNumber.clear();
                                  _emailAddress.clear();
                                  _depat = null;
                                  _curren = null;
                                  _time = null;
                                  startTime1 = null;
                                  endTime2 = null;
                                  webImage = null;

                                  selectImage = false;
                                  selectTimeZone = false;
                                  selectSalary = false;
                                  selectSkill = false;
                                  selectDepartment = false;
                                  selectDays = false;
                                  selectTime = false;

                                  if (selectDepartment == false ||
                                      selectSalary == false ||
                                      selectSkill == false ||
                                      selectTimeZone == false ||
                                      selectImage == false ||
                                      selectDays == false ||
                                      selectTime == false) {}
                                  Navigator.of(context).pop();
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontSize: 14.sp,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: 0.1,
                                        fontFamily: 'Inter-Bold',
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.sp, right: 30.sp, bottom: 10.sp),
                              child: InkWell(
                                onTap: () {
                                  String availabilityTime = "";
                                  if (startTime1 != null && endTime2 != null) {
                                    availabilityTime =
                                        '${startTime1}-${endTime2}';
                                  } else {
                                    availabilityTime = '';
                                  }

                                  setState(() {
                                    createPeopleValidate = true;
                                    createButtonClick = true;

                                    if (abc == null || abc.isEmpty) {
                                      selectSkill = true;
                                    }

                                    if (availabilityTime == null ||
                                        availabilityTime.isEmpty) {
                                      selectTime = true;
                                    }
                                  });

                                  if (widget.formKey!.currentState!
                                          .validate() &&
                                      !selectSkill &&
                                      !selectTime) {
                                    Future.delayed(
                                        const Duration(microseconds: 500), () {
                                      if (createPeopleValidate) {
                                        SmartDialog.showLoading(
                                          msg:
                                              "Your request is in progress please wait for a while...",
                                        );

                                        createPeople(context);
                                        // if (selectImage == true &&
                                        //     selectDepartment == true &&
                                        //     selectDays == true &&
                                        //     selectSalary == true &&
                                        //     selectSkill == true &&
                                        //     selectTime == true &&
                                        //     selectTimeZone == true) {
                                        //   SmartDialog.showLoading(
                                        //     msg:
                                        //         "Your request is in progress please wait for a while...",
                                        //   );

                                        //   createPeople(context);
                                        // }
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  width: 97.w,
                                  margin: const EdgeInsets.only(),
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7DD3FC),
                                    borderRadius: BorderRadius.circular(
                                      40.r,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.isEdit! ? "Update" : "Save",
                                      style: TextStyle(
                                          color: Color(0xff000000),
                                          fontSize: 14.sp,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 0.1,
                                          fontFamily: 'Inter-Bold',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 27.sp,
                                right: 27.sp,
                                top: 27.sp,
                                bottom: 27.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.sp),
                                        child: Container(
                                            width: 134.w,
                                            height: 134.w,
                                            decoration: BoxDecoration(
                                                color: const Color(0xff334155),
                                                shape: BoxShape.circle),
                                            child: ClipRect(
                                              child: imageavail
                                                  ? Image.memory(
                                                      webImage!,
                                                      fit: BoxFit.fill,
                                                      height: 134.h,
                                                      width: 134.w,
                                                    )
                                                  : widget.response != null &&
                                                          widget.response!
                                                                  .image !=
                                                              null &&
                                                          widget.response!
                                                              .image!.isNotEmpty
                                                      ? Image.network(
                                                          widget
                                                              .response!.image!,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  49.sp),
                                                          child:
                                                              SvgPicture.asset(
                                                            'images/photo.svg',
                                                            height: 36.0.h,
                                                            width: 36.0.w,
                                                          )),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final image = await ImagePickerWeb
                                            .getImageAsBytes();
                                        setState(() {
                                          webImage = image!;
                                          imageavail = true;
                                          selectImage = true;
                                        });
                                      },
                                      child: Container(
                                        height: 35.h,
                                        width: 148.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
                                          //color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            40.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt,
                                                size: 18.sp,
                                                color: Color(0xffFFFFFF)),
                                            SizedBox(
                                              width: 9.w,
                                            ),
                                            Text(
                                              "Upload new",
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  color: Color(0xffFFFFFF),
                                                  fontSize: 14.sp,
                                                  fontStyle: FontStyle.normal,
                                                  letterSpacing: 0.1,
                                                  fontFamily: 'Inter-Bold',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 23.sp),
                                      child: Text(
                                        "About you",
                                        style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 18.sp,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: 'Inter-Bold',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                CustomFormField(
                                  controller: _name,
                                  hint: 'Enter name',
                                  label: 'Name',
                                  fontSizeForLabel: 14.sp,
                                  contentpadding: EdgeInsets.only(
                                      left: 16.sp,
                                      bottom: 10.sp,
                                      right: 10.sp,
                                      top: 10.sp),
                                  hintTextHeight: 1.7.sp,
                                  validator: (value) {
                                    RegExp regex = RegExp(r'^[a-z A-Z]+$',
                                        caseSensitive: false);
                                    if (value.isEmpty) {
                                      setState(() {
                                        createPeopleValidate = false;
                                      });

                                      return 'Please enter';
                                    } else if (!regex.hasMatch(value)) {
                                      setState(() {
                                        createPeopleValidate = false;
                                      });
                                      return 'Please enter valid name';
                                    }
                                    return null;
                                  },
                                  onChange: (text) =>
                                      setState(() => name_ = text),
                                ),
                                CustomFormField(
                                  controller: _nickName,
                                  hint: 'Enter nickname',
                                  label: 'Nickname',
                                  fontSizeForLabel: 14.sp,
                                  contentpadding: EdgeInsets.only(
                                      left: 16.sp,
                                      bottom: 10.sp,
                                      right: 10.sp,
                                      top: 10.sp),
                                  hintTextHeight: 1.7.h,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        createPeopleValidate = false;
                                      });

                                      return 'Please enter';
                                    }
                                    return null;
                                  },
                                  onChange: (text) =>
                                      setState(() => name_ = text),
                                ),
                                CustomFormField(
                                  controller: _bio,
                                  maxline: 4,
                                  height: 110.h,
                                  fontSizeForLabel: 14.sp,
                                  hint: 'Enter your bio',
                                  label: 'Your bio',
                                  contentpadding: EdgeInsets.only(
                                      left: 16.sp,
                                      bottom: 10.sp,
                                      right: 10.sp,
                                      top: 10.sp),
                                  hintTextHeight: 1.7.h,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        createPeopleValidate = false;
                                      });

                                      return 'Please enter';
                                    }
                                    return null;
                                  },
                                  onChange: (text) =>
                                      setState(() => name_ = text),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CustomFormField(
                                        controller: _designation,
                                        maxLength: 20,
                                        fontSizeForLabel: 14.sp,
                                        hint: 'Enter ',
                                        label: 'Designation',
                                        contentpadding: EdgeInsets.only(
                                            left: 16.sp,
                                            bottom: 10.sp,
                                            right: 10.sp,
                                            top: 10.sp),
                                        hintTextHeight: 1.7.h,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            setState(() {
                                              createPeopleValidate = false;
                                            });

                                            return 'Please enter';
                                          }
                                          return null;
                                        },
                                        onChange: (text) =>
                                            setState(() => name_ = text),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: CustomSearchDropdown(
                                        hint: 'Select',
                                        label: "Department",
                                        initialValue: getAllInitialValue(
                                                departmentlist, _depat) ??
                                            null,
                                        errorText: createButtonClick == true &&
                                                (_depat == null ||
                                                    _depat!.isEmpty)
                                            ? 'Please Select this field'
                                            : '',
                                        items: departmentlist!,
                                        onChange: ((value) {
                                          // _curren = value.id;
                                          _depat = value.id;
                                          setState(() {
                                            selectDepartment = true;
                                          });
                                        }),
                                      ),
                                    )
                                  ],
                                ),
                                CustomFormField(
                                  controller: _association,
                                  maxLength: 30,
                                  hint: 'Enter team name',
                                  label: "Associated with",
                                  fontSizeForLabel: 14.sp,
                                  contentpadding: EdgeInsets.only(
                                      left: 16.sp,
                                      bottom: 10.sp,
                                      right: 10.sp,
                                      top: 10.sp),
                                  hintTextHeight: 1.7.h,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        createPeopleValidate = false;
                                      });

                                      return 'Please enter';
                                    }
                                    return null;
                                  },
                                  onChange: (text) =>
                                      setState(() => name_ = text),
                                ),
                                Text(
                                  "Salary",
                                  style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 18.sp,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.1,
                                      fontFamily: 'Inter-Bold',
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CustomSearchDropdown(
                                        hint: 'Select',
                                        label: "A",
                                        initialValue: getAllInitialValue(
                                                currencyList, _curren) ??
                                            null,
                                        errorText: createButtonClick &&
                                                (_curren == null ||
                                                    _curren!.isEmpty)
                                            ? 'Please Select this field'
                                            : '',
                                        items: currencyList!,
                                        onChange: ((value) {
                                          _curren = value.id;
                                          setState(() {
                                            selectSalary = true;
                                          });
                                        }),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: CustomFormField(
                                        controller: _salary,
                                        maxLength: 15,
                                        hint: '0.00',
                                        label: "Monthly Salary",
                                        fontSizeForLabel: 14.sp,
                                        contentpadding: EdgeInsets.only(
                                            left: 16.sp,
                                            bottom: 10.sp,
                                            right: 10.sp,
                                            top: 10.sp),
                                        hintTextHeight: 1.7.h,
                                        validator: (value) {
                                          RegExp regex =
                                              RegExp(r'^\D+|(?<=\d),(?=\d)');
                                          if (value.isEmpty) {
                                            setState(() {
                                              createPeopleValidate = false;
                                            });

                                            return 'Please enter';
                                          } else if (regex.hasMatch(value)) {
                                            setState(() {
                                              createPeopleValidate = false;
                                            });
                                            return 'Please enter valid salary';
                                          }
                                          return null;
                                        },
                                        onChange: (text) =>
                                            setState(() => name_ = text),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 56,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height * 1.1,
                            child: const VerticalDivider(
                              color: Color(0xff94A3B8),
                              thickness: 0.2,
                            )),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 29.sp,
                                right: 29.sp,
                                top: 18.sp,
                                bottom: 18.sp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Availability",
                                  style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 18.sp,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 0.1,
                                      fontFamily: 'Inter-Bold',
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Stack(
                                  children: [
                                    CustomSearchDropdown(
                                      hint: 'Select days',
                                      label: "Select",
                                      errorText: selectedDaysList.isEmpty &&
                                              createButtonClick &&
                                              (_day == null || _day!.isEmpty)
                                          ? 'Please Select this field'
                                          : '',
                                      items: selectDaysList!,
                                      onChange: ((value) {
                                        setState(() {
                                          _day = value.item;
                                          _shortday = _day!.substring(0, 3);
                                          if (selectedDaysList.isNotEmpty) {
                                            if (selectedDaysList
                                                .contains(_shortday)) {
                                            } else {
                                              selectedDaysList
                                                  .add(_shortday!.toString());
                                              selectDays = true;
                                            }
                                          } else {
                                            selectedDaysList
                                                .add(_shortday!.toString());
                                            selectDays = true;
                                          }
                                        });
                                      }),
                                    ),
                                  ],
                                ),
                                selectedDaysList != null &&
                                        selectedDaysList.isNotEmpty
                                    ? SizedBox(
                                        height: 30.h,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: selectedDaysList.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: InputChip(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.r))),
                                                deleteIcon: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 20.sp,
                                                ),
                                                backgroundColor:
                                                    Color(0xff334155),
                                                visualDensity:
                                                    VisualDensity.compact,
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                label: Text(
                                                  selectedDaysList[index],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                selected: _isSelected!,
                                                onSelected: (bool selected) {
                                                  setState(() {
                                                    _isSelected = selected;
                                                    print(
                                                        "_isSelected--------------------------${_isSelected}");
                                                  });
                                                },
                                                onDeleted: () {
                                                  setState(() {
                                                    selectedDaysList
                                                        .removeAt(index);
                                                  });
                                                },
                                                showCheckmark: false,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container(),
                                selectedDaysList.isNotEmpty
                                    ? SizedBox(
                                        height: 15.h,
                                      )
                                    : Container(),
                                Container(
                                  height: 57.h,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 9.sp),
                                          child: Text(
                                            startTime1 != null &&
                                                    startTime1.isNotEmpty &&
                                                    endTime2 != null &&
                                                    endTime2.isNotEmpty
                                                ? "$startTime1 - $endTime2"
                                                : "Select time",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Inter',
                                                color: Colors.white,
                                                fontStyle: FontStyle.normal),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                selectTime
                                    ? handleAllerrorWidget(selectTime)
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                                // Text(
                                //   startTime1 != null &&
                                //           startTime1.isNotEmpty &&
                                //           endTime2 != null &&
                                //           endTime2.isNotEmpty
                                //       ? "$startTime1 - $endTime2"
                                //       : '',
                                //   style: TextStyle(
                                //       fontSize: 14.sp,
                                //       color: Colors.white,
                                //       fontFamily: 'Inter-Bold',
                                //       letterSpacing: 0.1,
                                //       fontStyle: FontStyle.normal,
                                //       fontWeight: FontWeight.w500),
                                // ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                TimeRange(
                                    initialRange:
                                        startTime1 != null && endTime2 != null
                                            ? TimeRangeResult(
                                                stringToTimeOfDay(startTime1!)!,
                                                stringToTimeOfDay(endTime2!)!)
                                            : null,
                                    fromTitle: Text(
                                      'From',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Inter-Medium',
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.1,
                                          fontSize: 14.sp,
                                          color: Colors.white),
                                    ),
                                    toTitle: Text(
                                      'To',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Inter-Medium',
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.1,
                                          fontSize: 14.sp,
                                          color: Colors.white),
                                    ),
                                    titlePadding: 16.sp,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                    activeTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    borderColor: Colors.white,
                                    backgroundColor: Colors.transparent,
                                    activeBackgroundColor: Colors.green,
                                    firstTime: TimeOfDay(hour: 8, minute: 30),
                                    lastTime: TimeOfDay(hour: 20, minute: 00),
                                    timeStep: 10,
                                    timeBlock: 30,
                                    onRangeCompleted: (range) {
                                      setState(() {
                                        startTime = range!.start;
                                        endTime = range.end;
                                        startTime1 =
                                            getformattedTime(startTime);
                                        endTime2 = getformattedTime(endTime);
                                        selectTime = false;
                                      });
                                    }),
                                SizedBox(
                                  height: 16.sp,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Skills",
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 18.sp,
                                          fontFamily: 'Inter-Bold',
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 0.1,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                        width: 40.w,
                                        height: 40.h,
                                        decoration: const BoxDecoration(
                                          color: Color(0xff334155),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          child: Padding(
                                              padding: EdgeInsets.all(10.sp),
                                              child: SvgPicture.asset(
                                                  'images/tag_new.svg')),
                                        )),
                                  ],
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 5.sp,
                                        right: 5.sp,
                                      ),
                                      margin: EdgeInsets.only(top: 16.sp),
                                      height: 49.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        borderRadius: BorderRadius.circular(
                                          48.r,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          searchTextField = TypeAheadFormField(
                                            keepSuggestionsOnLoading: false,
                                            suggestionsBoxVerticalOffset: 0.0,
                                            suggestionsBoxDecoration:
                                                SuggestionsBoxDecoration(
                                                    color: Color(0xff0F172A)),
                                            hideOnLoading: true,
                                            suggestionsCallback: (pattern) {
                                              return getSuggestions(pattern);
                                            },
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              controller: _typeAheadController,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp),
                                              keyboardType: TextInputType.text,
                                              cursorColor: Colors.white,
                                              autofocus: false,
                                              decoration: InputDecoration(
                                                // border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    top: 14.sp, left: 10.sp),
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  color: Color(0xff64748B),
                                                ),
                                                hintText: 'Search',

                                                hintStyle: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Color(0xff64748B),
                                                    fontFamily: 'Inter-Medium',
                                                    letterSpacing: 0.1,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                            itemBuilder: (context, item) {
                                              return Padding(
                                                padding: EdgeInsets.all(8.sp),
                                                child: Text(
                                                  item.title.toString(),
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.white),
                                                ),
                                              );
                                              // Text("khushi");
                                              // rowResourceName(item);
                                            },
                                            transitionBuilder: (context,
                                                suggestionsBox, controller) {
                                              return suggestionsBox;
                                            },
                                            onSuggestionSelected: (item) {
                                              setState(() {
                                                searchTextField!
                                                    .textFieldConfiguration
                                                    .controller!
                                                    .text = '';

                                                if (abc.isNotEmpty) {
                                                  if (abc
                                                      .contains(item.title)) {
                                                  } else {
                                                    abc.add(item.title!);
                                                  }
                                                } else {
                                                  abc.add(item.title!);
                                                }
                                                selectSkill = false;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    selectSkill
                                        ? handleAllerrorWidget(selectSkill)
                                        : Container(
                                            height: 0,
                                            width: 0,
                                          ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Wrap(
                                      spacing: 5.sp,
                                      runSpacing: 5.sp,
                                      children: List.generate(
                                        abc.length,
                                        (index) {
                                          return Container(
                                            height: 32.h,
                                            child: InputChip(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8.r))),
                                              deleteIcon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20.sp,
                                              ),
                                              backgroundColor:
                                                  Color(0xff334155),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              label: Text(
                                                abc[index],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onSelected: (bool selected) {
                                                setState(() {
                                                  _isSelected = selected;
                                                });
                                              },
                                              onDeleted: () {
                                                setState(() {
                                                  abc.removeAt(index);
                                                });
                                              },
                                              showCheckmark: false,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height * 1.1,
                            child: const VerticalDivider(
                              color: Color(0xff94A3B8),
                              thickness: 0.2,
                            )),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 29.sp,
                                right: 29.sp,
                                top: 18.sp,
                                bottom: 18.sp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Contact info",
                                  style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 18.sp,
                                      fontFamily: 'Inter-Bold',
                                      letterSpacing: 0.1,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Column(
                                  children: [
                                    CustomFormField(
                                      maxLength: 20,
                                      controller: _country,
                                      hint: 'Enter country',
                                      label: "Country",
                                      fontSizeForLabel: 14.sp,
                                      contentpadding: EdgeInsets.only(
                                          left: 16.sp,
                                          bottom: 10.sp,
                                          right: 10.sp,
                                          top: 10.sp),
                                      hintTextHeight: 1.7.h,
                                      validator: (value) {
                                        RegExp regex = RegExp(r'^[a-z A-Z]+$');
                                        if (value.isEmpty) {
                                          setState(() {
                                            createPeopleValidate = false;
                                          });

                                          return 'Please enter';
                                        } else if (!regex.hasMatch(value)) {
                                          setState(() {
                                            createPeopleValidate = false;
                                          });

                                          return 'Please enter valid  country name';
                                        }
                                        return null;
                                      },
                                      onChange: (text) =>
                                          setState(() => name_ = text),
                                    ),
                                    CustomFormField(
                                      maxLength: 20,
                                      controller: _enterCity,
                                      hint: 'Enter city',
                                      label: "City",
                                      fontSizeForLabel: 14.sp,
                                      contentpadding: EdgeInsets.only(
                                          left: 16.sp,
                                          bottom: 10.sp,
                                          right: 10.sp,
                                          top: 10.sp),
                                      hintTextHeight: 1.7.h,
                                      validator: (value) {
                                        RegExp regex = RegExp(r'^[a-z A-Z]+$');
                                        if (value.isEmpty) {
                                          setState(() {
                                            createPeopleValidate = false;
                                          });

                                          return 'Please enter';
                                        } else if (!regex.hasMatch(value)) {
                                          setState(() {
                                            createPeopleValidate = false;
                                          });

                                          return 'Please enter valid  city name';
                                        }
                                        return null;
                                      },
                                      onChange: (text) =>
                                          setState(() => name_ = text),
                                    ),
                                    CustomFormField(
                                      maxLength: 10,
                                      controller: _phoneNumber,
                                      hint: 'Enter number',
                                      label: "Phone number",
                                      fontSizeForLabel: 14.sp,
                                      contentpadding: EdgeInsets.only(
                                          left: 16.sp,
                                          bottom: 10.sp,
                                          right: 10.sp,
                                          top: 10.sp),
                                      hintTextHeight: 1.7.h,
                                      validator: (value) {
                                        String pattern =
                                            r'(^(?:[+0]9)?[0-9]{10}$)';
                                        RegExp regExp = new RegExp(pattern);
                                        if (value.isEmpty) {
                                          setState(() {
                                            createPeopleValidate = false;
                                          });

                                          return 'Please enter';
                                        } else if (!regExp.hasMatch(value)) {
                                          setState(() {
                                            createPeopleValidate = false;
                                          });

                                          return 'Please enter valid mobile number';
                                        }
                                        return null;
                                      },
                                      onChange: (text) =>
                                          setState(() => name_ = text),
                                    ),
                                    CustomFormField(
                                      //maxLength: 20,
                                      controller: _emailAddress,
                                      hint: 'Enter email address',
                                      label: "Email address",
                                      fontSizeForLabel: 14.sp,
                                      contentpadding: EdgeInsets.only(
                                          left: 16.sp,
                                          bottom: 10.sp,
                                          right: 10.sp,
                                          top: 10.sp),
                                      hintTextHeight: 1.7.h,
                                      validator: (value) {
                                        RegExp regex = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                        if (value.isEmpty) {
                                          setState(() {
                                            createPeopleValidate = false;
                                          });

                                          return 'Please enter email';
                                        } else if (!regex.hasMatch(value)) {
                                          setState(() {
                                            createPeopleValidate = false;
                                          });

                                          return 'Enter valid Email';
                                        }
                                        if (regex.hasMatch(values)) {
                                          setState(() {
                                            createPeopleValidate = false;
                                          });
                                          return 'please enter valid email';
                                        }
                                        if (value.length > 50) {
                                          setState(() {
                                            createPeopleValidate = false;
                                          });
                                          return 'No more length 50';
                                        }
                                        return null;
                                      },
                                      onChange: (text) =>
                                          setState(() => name_ = text),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    CustomSearchDropdown(
                                      hint: "Select timezone",
                                      label: "Select",
                                      initialValue: getAllInitialValue(
                                              selecTimeZoneList, _time) ??
                                          null,
                                      errorText: createButtonClick &&
                                              (_time == null || _time!.isEmpty)
                                          ? 'Please Select this field'
                                          : '',
                                      items: selecTimeZoneList!,
                                      onChange: ((value) {
                                        setState(() {
                                          _time = value.id;
                                          print("account:$_time");
                                          selectTimeZone = true;
                                        });
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  handleAllerrorWidget(bool selectTesting) {
    return createButtonClick
        ? !selectTesting
            ? const Text(
                " ",
              )
            : Padding(
                padding: EdgeInsets.only(
                  top: 4.sp,
                  left: 12.sp,
                ),
                child: errorWidget())
        : Text('');
  }

  errorWidget() {
    return Text('Please Select this field',
        style: TextStyle(color: Colors.red, fontSize: 12.sp));
  }

  DropdownModel? getAllInitialValue(List<DropdownModel>? list, String? id) {
    if (widget.response != null && list!.isNotEmpty) {
      try {
        DropdownModel? result = list.firstWhere(
            (o) => o.id == id || o.item == id,
            orElse: () => DropdownModel("", ""));
        if (result.id.isEmpty) {
          return null;
        } else {
          return result;
        }
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  getformattedTime(TimeOfDay time) {
    DateTime tempDate = DateFormat("hh:mm")
        .parse(time.hour.toString() + ":" + time.minute.toString());
    var dateFormat = DateFormat("h:mm a"); // you can change the format here
    print(dateFormat.format(tempDate));
    return dateFormat.format(tempDate);
  }

  //Add people Api
  createPeople(BuildContext context) async {
    String commaSepratedString = selectedDaysList.join(", ");

    print("add People---------------------------------------------------");
    var token = 'Bearer ' + storage.read("token");

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(widget.isEdit!
            ? '${AppUrl.baseUrl}/resource/update'
            : '${AppUrl.baseUrl}/resource'));
    request.headers.addAll({
      "Content-Type": "application/json",
      "Authorization": token,
    });
    if (widget.response != null && widget.response!.id != null) {
      request.fields['user_id'] = widget.response!.id.toString();
    }

    request.fields['name'] = _name.text.toString();
    request.fields['nickname'] = _nickName.text.toString();
    request.fields['email'] = _emailAddress.text.toString();
    request.fields['phone_number'] = _phoneNumber.text.toString();
    request.fields['password'] = 'Nirmaljeet@123';
    request.fields['bio'] = _bio.text.toString();
    request.fields['designation'] = _designation.text.toString();
    request.fields['department_id'] = _depat!;
    request.fields['associate'] = _association.text;
    request.fields['salary'] = _salary.text;
    request.fields['salary_currency'] = _curren!;
    request.fields['availibilty_day'] = commaSepratedString;
    request.fields['availibilty_time'] = '${startTime1}-${endTime2}';
    request.fields['country'] = _country.text;
    request.fields['city'] = _enterCity.text;
    request.fields['time_zone'] = _time!;

    for (int i = 0; i < abc.length; i++) {
      request.fields['skills[$i]'] = '${abc[i]}';
    }

    _selectedFile = webImage;
    print(_selectedFile);

    if (_selectedFile != null) {
      request.files.add(await http.MultipartFile.fromBytes(
          'image', _selectedFile!,
          contentType: new MediaType('application', 'octet-stream'),
          filename: "file_up"));
    } else {
      //request.fields['image'] = widget.response!.image!;
    }

    print("requestData ----------------------------------------- ${request}");

    var response = await request.send();
    print("------------------response.statusCode---------------------");
    print(response.statusCode);

    var responseString = await response.stream.bytesToString();
    print("Response Data ------------------------------- ${responseString}");
    if (response.statusCode == 200) {
      SmartDialog.dismiss();

      //setState(() {

      //clearContoller();
      selectDays = false;
      selectSkill = false;
      selectTime = false;
      selectTimeZone = false;
      selectDepartment = false;
      selectSalary = false;
      selectImage = false;
      commaSepratedString = '';
      imageavail = false;

      _selectedFile = [];
      request.files.clear();
      // });

      Navigator.pop(context, true);

      print("add people created");
    } else if (response.statusCode == 401) {
      SmartDialog.dismiss();
      AppUtil.showErrorDialog(context);
    } else {
      Map<String, dynamic> responseJson = json.decode(responseString);
      print("Error response ------------------------ ${responseJson}");

      SmartDialog.dismiss();

      Fluttertoast.showToast(
        msg: responseJson['message'] ?? 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
    }
  }

  getCurrency() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
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
          try {
            currencyList!.clear();
            mdata.forEach((element) {
              if (!currencyList!.contains(element['currency']['symbol'])) {
                currencyList!.add(DropdownModel(
                    element['id'].toString(), element['currency']['symbol']));
              }
            });
          } catch (e) {
            print(e);
          }
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
  }
}
