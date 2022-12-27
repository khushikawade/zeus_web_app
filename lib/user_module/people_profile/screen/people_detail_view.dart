import 'dart:typed_data';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/daysList.dart';
import 'package:zeus/helper_widget/pop_resource_button.dart' as pop;
import 'package:zeus/project_module/project_home/project_home_view_model.dart';
import 'package:zeus/services/model/model_class.dart';
import 'package:zeus/services/response_model/skills_model/skills_response.dart';
import 'package:zeus/services/response_model/tag_model/tag_user.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/colors.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';

class ProfileDetail extends StatefulWidget {
  PeopleData list;
  int index;

  ProfileDetail({Key? key, required this.list, required this.index});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState(list);
}

class _ProfileDetailState extends State<ProfileDetail> {
  _ProfileDetailState(this.list);
  PeopleData list;

  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Datum>> key = new GlobalKey();
  static List<Datum> users = <Datum>[];
  List _department = [];
  List _timeline = [];
  Future? _getTag;

  List _currencyName = [];
  List<int>? _selectedFile;
  Image? image;
  Uint8List? webImage;
  List<String> abc = [];
  bool imageavail = false;
  bool? _isSelected;
  bool loading = true;
  //final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();
  final double width = 20;

  List<int> daysCountList = [1, 2, 3, 4, 5, 6, 7];

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

  Future<void> getUpdatePeople() async {
    var token = 'Bearer ' + storage.read("token");
    var userId = storage.read("user_id");
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
    request.fields['department_id'] = list.resource != null
        ? _depat ?? list.resource!.department!.id.toString()
        : '';
    request.fields['associate'] = _association.text.toString();
    request.fields['salary'] = _salary.text.toString();
    request.fields['salary_currency'] = _salaryCurrency.text.toString();
    request.fields['availibilty_day'] = _availableDay.text.toString();
    request.fields['availibilty_time'] = _availableTime.text.toString();
    request.fields['country'] = _country.text.toString();
    request.fields['city'] = _enterCity.text.toString();
    request.fields['time_zone'] = list.resource != null
        ? _time ?? list.resource!.timeZone!.diffFromGtm.toString()
        : '';

    if (!imageavail) {
    } else {
      _selectedFile = webImage;
      request.files.add(await http.MultipartFile.fromBytes(
          'image', _selectedFile!,
          contentType: MediaType('application', 'octet-stream'),
          filename: "file_up"));
    }
    if (list.resource != null) {
      for (int i = 0; i < list.resource!.skills!.length; i++) {
        request.fields['skills[$i]'] = '${list.resource!.skills![i]}';
      }
    }

    print("Request Data ---------------------------------- ${request}");

    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final decodedMap = json.decode(responseString);

      print(decodedMap);

      final stringRes = JsonEncoder.withIndent('').convert(decodedMap);
      print(stringRes);
      print("yes");
      print("===============================???UPdated Successfully");
    } else if (response.statusCode == 401) {
      AppUtil.showErrorDialog(context);
    } else {
      print(responseString);
      print("failed");
    }
  }

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

  String? _depat, _curren, _time;

  var name;
  int selectedIndex = 0;
  String dropdownvalue = 'Item 1';
  DateTime selectedDate = DateTime.now();
  var selectedItem = '';

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  Future? getProject() {
    return Provider.of<TagDetail>(context, listen: false).getTagData();
  }

  Future? getList;
  Future getListData1() {
    return Provider.of<ProjectHomeViewModel>(context, listen: false)
        .changeProfile();
  }

  @override
  void didChangeDependencies() {
    print('hello people profile');
    getList = getListData1();
    super.didChangeDependencies();
  }

  void change() async {
    print("lkdfglkdsghklshglksdhgldjlhsgk;;lgjh;");
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('val', 'r');
    print("After calling-----------------------");
  }

  @override
  void initState() {
    _getTag = getProject();
    change();
    _isSelected = false;
    getUsers();
    getDepartment();
    getCurrency();
    getTimeline();

    print("List Object --------------------------------- ");
    print(json.encode(list));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var timezome;
    var timeoffset;
    var city;
    var salary;
    var capacity;
    var nickname;
    if (list.resource != null) {
      timezome = list.resource!.timeZone!.name;
    } else {
      timezome = 'TBD';
    }
    if (list.resource != null) {
      timeoffset = list.resource!.timeZone!.offset;
    } else {
      timeoffset = 'TBD';
    }
    if (list.resource != null) {
      city = list.resource!.city != null && list.resource!.city!.isNotEmpty
          ? list.resource!.city
          : 'TBD';
    } else {
      city = 'TBD';
    }
    if (list.resource != null) {
      salary = list.resource!.salary;
    } else {
      salary = 'TBD';
    }

    if (list.resource != null) {
      nickname = list.resource!.nickname!;
    } else {
      nickname = 'TBD';
    }

    final mediaQueryData = MediaQuery.of(context);

    return RawScrollbar(
      controller: verticalScroll,
      thumbColor: const Color(0xff4b5563),
      crossAxisMargin: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      thickness: 8,
      child: MediaQuery(
        data: mediaQueryData.copyWith(textScaleFactor: 1),
        child: Scaffold(
          backgroundColor: ColorSelect.class_color,
          body: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 60.sp),
                        margin: EdgeInsets.only(
                            left: 40.sp, right: 30.sp, bottom: 0.0, top: 35.sp),
                        decoration: BoxDecoration(
                          color: const Color(0xff1E293B),
                          border: Border.all(
                              color: ColorSelect.peoplelistbackgroundcolor),
                          borderRadius: BorderRadius.circular(
                            12.r,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40.h,
                                    padding: EdgeInsets.all(8.sp),
                                    margin: EdgeInsets.only(
                                        left: 16.sp, top: 16.sp),
                                    decoration: BoxDecoration(
                                      color: Color(0xff263143),
                                      borderRadius: BorderRadius.circular(
                                        55.r,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "OCCUPIED",
                                        style: TextStyle(
                                            color: ColorSelect.boxtext_color,
                                            fontSize: 14.sp,
                                            letterSpacing: 0.25,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: 'Inter-Regular',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    width: 134.w,
                                    height: 134.h,
                                    margin:
                                        EdgeInsets.only(left: 0.0, top: 35.sp),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      radius: 110.r,
                                      backgroundImage:
                                          NetworkImage(list.image!),
                                    )),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 0.0, top: 25.sp),
                                  child: Text(
                                    "@$nickname",
                                    style: TextStyle(
                                        color: ColorSelect.white_color,
                                        fontSize: 22.sp,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: 0.1,
                                        fontFamily: 'Inter-Bold',
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10.sp,
                                        right: 0.0,
                                      ),
                                      child: Text(
                                        list.resource != null
                                            ? list.resource!.designation !=
                                                        null &&
                                                    list.resource!.designation!
                                                        .isNotEmpty
                                                ? list.resource!.designation
                                                    .toString()
                                                : 'N/A'
                                            : 'N/A',
                                        style: TextStyle(
                                            color: ColorSelect.profile_color,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter-Regular',
                                            letterSpacing: 0.25,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 13.sp,
                                        left: 8.sp,
                                      ),
                                      height: 6.sp,
                                      width: 6.sp,
                                      decoration: BoxDecoration(
                                          color: Color(0xff64748B),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.r))),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10.sp,
                                        left: 8.sp,
                                        right: 0.0,
                                      ),
                                      child: Text(
                                        list.resource != null
                                            ? list.resource!.department!.name !=
                                                        null &&
                                                    list.resource!.department!
                                                        .name!.isNotEmpty
                                                ? list
                                                    .resource!.department!.name
                                                    .toString()
                                                : 'N/A'
                                            : 'N/A',
                                        style: TextStyle(
                                            color: ColorSelect.profile_color,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter-Regular',
                                            letterSpacing: 0.25,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 13.sp,
                                        left: 8.sp,
                                      ),
                                      height: 6.sp,
                                      width: 6.sp,
                                      decoration: BoxDecoration(
                                          color: Color(0xff64748B),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.r))),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10.sp,
                                        left: 8.sp,
                                        right: 0.0,
                                      ),
                                      child: Text(
                                        "Associated with:",
                                        style: TextStyle(
                                            color: ColorSelect.profile_color,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter-Regular',
                                            letterSpacing: 0.25,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10.sp,
                                        left: 8.sp,
                                        right: 0.0,
                                      ),
                                      child: Text(
                                        list.resource != null
                                            ? list.resource!.associate !=
                                                        null &&
                                                    list.resource!.associate!
                                                        .isNotEmpty
                                                ? list.resource!.associate
                                                    .toString()
                                                : 'N/A'
                                            : 'N/A',
                                        style: TextStyle(
                                            color: ColorSelect.profile_color,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter-Regular',
                                            letterSpacing: 0.25,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 20.sp,
                                      height: 18.sp,
                                      margin: EdgeInsets.only(
                                        top: 10.sp,
                                        left: 0.0,
                                        right: 0.0,
                                      ),
                                      child: SvgPicture.asset(
                                        "images/location_icon.svg",
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10.sp, top: 10.sp),
                                      child: Text(
                                        list.resource != null
                                            ? list.resource!.city != null &&
                                                    list.resource!.city!
                                                        .isNotEmpty
                                                ? list.resource!.city.toString()
                                                : 'N/A'
                                            : 'N/A',
                                        style: TextStyle(
                                            color: ColorSelect.profile_color,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter-Regular',
                                            letterSpacing: 0.25,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 0.0, top: 10.sp),
                                      child: Text(
                                        ", ",
                                        style: TextStyle(
                                            color: ColorSelect.profile_color,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter-Regular',
                                            letterSpacing: 0.25,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 0.0, top: 10.sp),
                                      child: Text(
                                        list.resource != null
                                            ? list.resource!.country != null &&
                                                    list.resource!.country!
                                                        .isNotEmpty
                                                ? list.resource!.country
                                                    .toString()
                                                : 'N/A'
                                            : 'N/A',
                                        style: TextStyle(
                                            color: ColorSelect.profile_color,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter-Regular',
                                            letterSpacing: 0.25,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 13.sp,
                                        left: 8.sp,
                                      ),
                                      height: 6.sp,
                                      width: 6.sp,
                                      decoration: BoxDecoration(
                                          color: Color(0xff64748B),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.r))),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10.sp, top: 10.sp),
                                      child: Text(
                                        list.resource != null
                                            ? list.resource!.timeZone != null &&
                                                    list.resource!.timeZone!
                                                            .offset !=
                                                        null &&
                                                    list.resource!.timeZone!
                                                        .offset!.isNotEmpty
                                                ? list
                                                    .resource!.timeZone!.offset
                                                    .toString()
                                                : 'N/A'
                                            : 'N/A',
                                        style: TextStyle(
                                            color: ColorSelect.profile_color,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter-Regular',
                                            letterSpacing: 0.25,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: 12.sp, top: 16.sp),
                                child: pop.MyMenu(
                                    data: list,
                                    title: 'Menu at bottom',
                                    alignment: Alignment.topRight,
                                    buildContext: context,
                                    returnValue: () {
                                      Navigator.pop(context, true);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 140.sp, right: 140.sp, top: 30.sp, bottom: 20.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      aboutMeWidget(),
                      SizedBox(
                        height: 45.h,
                      ),
                      availabilityWidget(),
                      SizedBox(
                        height: 45.h,
                      ),
                      skillsWidget(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Skills Widget
  Widget skillsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "Skills",
            style: TextStyle(
                color: ColorSelect.text_color,
                fontSize: 22.sp,
                fontStyle: FontStyle.normal,
                fontFamily: 'Inter-Medium',
                fontWeight: FontWeight.w500),
          ),
        ),
        list.resource != null &&
                list.resource!.skills != null &&
                list.resource!.skills!.isNotEmpty
            ? Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 32.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: list.resource!.skills!.length,
                        itemBuilder: (BuildContext context, int index) {
                          Skills _skills = list.resource!.skills![index];
                          var skill = _skills.title;

                          return Container(
                            height: 32.h,
                            margin: EdgeInsets.only(right: 8.sp),
                            decoration: BoxDecoration(
                              color: const Color(0xff334155),
                              borderRadius: BorderRadius.circular(
                                8.r,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 12.sp,
                                    right: 12.sp,
                                    top: 6.sp,
                                    bottom: 6.sp),
                                child: Text(
                                  skill != null && skill.isNotEmpty
                                      ? '$skill'
                                      : 'N/A',
                                  style: TextStyle(
                                      color: ColorSelect.white_color,
                                      fontSize: 14.sp,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Inter-Regular',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Text('N/A',
                style: TextStyle(
                    color: ColorSelect.white_color,
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500))
      ],
    );
  }

  // availibility Widget
  Widget availabilityWidget() {
    var timezome;
    var timeoffset;
    var capacity;

    if (list.resource != null) {
      timezome = list.resource!.timeZone!.name;
    } else {
      timezome = 'TBD';
    }
    if (list.resource != null) {
      timeoffset = list.resource!.timeZone!.offset;
    } else {
      timeoffset = 'TBD';
    }

    if (list.resource != null && list.resource!.capacity != null) {
      capacity = list.resource!.capacity;
    } else {
      capacity = 'TBD';
    }

    List<String> commaSepratedList = [];
    String availibiltyDaySeprated = '';

    List<DaysList>? daysList = <DaysList>[];

    if (list.resource != null &&
        list.resource!.availibiltyDay != null &&
        list.resource!.availibiltyDay!.isNotEmpty) {
      print("-------------------------------------------");
      print(list.resource!.availibiltyDay);
      commaSepratedList = list.resource!.availibiltyDay!.split(", ");

      commaSepratedList.forEach((element) {
        DaysList object = DaysList("", 0);
        if (element == "Mon") {
          object.day = element;
          object.dayNumber = 1;
          daysList.add(object);
        } else if (element == "Tue") {
          object.day = element;
          object.dayNumber = 2;
          daysList.add(object);
        } else if (element == "Wed") {
          object.day = element;
          object.dayNumber = 3;
          daysList.add(object);
        } else if (element == "Thu") {
          object.day = element;
          object.dayNumber = 4;
          daysList.add(object);
        } else if (element == "Fri") {
          object.day = element;
          object.dayNumber = 5;
          daysList.add(object);
        } else if (element == "Sat") {
          object.day = element;
          object.dayNumber = 6;
          daysList.add(object);
        } else if (element == "Sun") {
          object.day = element;
          object.dayNumber = 7;
          daysList.add(object);
        } else {}
      });
    }

    daysList.sort((a, b) => a.dayNumber!.compareTo((b.dayNumber!)));
    var startDay = daysList[0].day;
    var endDay = daysList[daysList.length - 1].day;

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    name = arguments;
    print('jsonData');
    print(list);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "Availability",
            style: TextStyle(
                color: ColorSelect.text_color,
                fontSize: 22.sp,
                fontStyle: FontStyle.normal,
                fontFamily: 'Inter-Medium',
                fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  list.resource != null && list.resource!.availibiltyDay != null
                      ? "${list.resource!.availibiltyDay} | ${list.resource!.availibiltyTime} | $timeoffset  $timezome"
                      // startDay == endDay
                      //     ? "${startDay} | ${list.resource!.availibiltyTime} | $timeoffset  $timezome"
                      //     : "${startDay}  -  ${endDay} | ${list.resource!.availibiltyTime} | $timeoffset  $timezome"
                      : 'N/A',
                  style: TextStyle(
                      color: ColorSelect.white_color,
                      fontSize: 16.sp,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Inter-SemiBold',
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  "$capacity"
                  " hours/week",
                  style: TextStyle(
                      color: ColorSelect.text_color,
                      fontSize: 16.sp,
                      letterSpacing: 0.5,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Inter-Regular',
                      fontWeight: FontWeight.w400),
                ),
              ],
            ))
      ],
    );
  }

  // Make about me widget
  Widget aboutMeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "About me",
            style: TextStyle(
                color: ColorSelect.text_color,
                fontSize: 22.sp,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.1,
                fontFamily: 'Inter-Medium',
                fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  list.name != null && list.name!.isNotEmpty
                      ? list.name.toString()
                      : 'TBD',
                  style: TextStyle(
                      color: ColorSelect.white_color,
                      fontSize: 16.sp,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Inter-SemiBold',
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  list.resource != null
                      ? list.resource!.bio != null &&
                              list.resource!.bio!.isNotEmpty
                          ? list.resource!.bio.toString()
                          : 'N/A'
                      : 'N/A',
                  style: TextStyle(
                      color: ColorSelect.text_color,
                      fontSize: 16.sp,
                      letterSpacing: 0.5,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Inter-Regular',
                      fontWeight: FontWeight.w400),
                ),
              ],
            ))
      ],
    );
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
        print("failed to much");
      }
      return value;
    }
    return null;
  }
}
