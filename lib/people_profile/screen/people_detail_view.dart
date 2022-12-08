// ignore_for_file: depend_on_referenced_packages
import 'dart:typed_data';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/daysList.dart';
import 'package:zeus/helper_widget/pop_resource_button.dart';
import 'package:zeus/utility/colors.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:zeus/utility/util.dart';
import '../../DemoContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../navigation/tag_model/tag_user.dart';
import '../../navigator_tabs/idle/data/project_detail_data/ProjectDetailData.dart';
import '../../navigator_tabs/people_idle/model/model_class.dart';
import '../../utility/app_url.dart';
import '../../utility/constant.dart';
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
  //var listdata=list.resource!.city;
  List _currencyName = [];
  List<int>? _selectedFile;
  Image? image;
  Uint8List? webImage;
  List<String> abc = [];
  bool imageavail = false;
  bool? _isSelected;
  bool loading = true;
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();
  final double width = 20;

  List<int> daysCountList = [1, 2, 3, 4, 5, 6, 7];

  final ScrollController editPeoplehorizontalScroll = ScrollController();

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
      // print('Users: ${users.length}');
      setState(() {
        loading = false;
      });
    }else if (response.statusCode == 401) {
       
        AppUtil.showErrorDialog(context);
      } else {
      print("Error getting users.");
      // print(response.body);
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
    // request.fields['skills'] =abc;

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
    }else if (response.statusCode == 401) {
     
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

  Future<void> _selectDate(setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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
    return Provider.of<ProjectDetail>(context, listen: false).changeProfile();
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
    if (list.resource != null && list.resource!.capacity != null) {
      capacity = list.resource!.capacity;
      // Character.isDigit(val)
      // RegExp regex = RegExp(r'^[a-z A-Z]+$');
      // capacity = list.resource!.capacity!.contains(regex)
      //     ? list.resource!.capacity
      //     : list.resource!.capacity!
      //         .replaceAll(RegExp(r'^[a-z A-Z]+$'), ' hour/week');
    } else {
      capacity = 'TBD';
    }

    if (list.resource != null) {
      nickname = list.resource!.nickname!;
    } else {
      nickname = 'TBD';
    }

    List<String> commaSepratedList = [];
    String availibiltyDaySeprated = '';

    List<DaysList>? daysList = <DaysList>[];

    if (list.resource != null &&
        list.resource!.availibiltyDay != null &&
        list.resource!.availibiltyDay!.isNotEmpty) {
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
    final mediaQueryData = MediaQuery.of(context);

    print(
        "Width --------------------------------------------------- ${MediaQuery.of(context).size.width}");

    return AdaptiveScrollbar(
      underSpacing: EdgeInsets.only(bottom: 10),
      controller: verticalScroll,
      width: 10,
      position: ScrollbarPosition.right,
      sliderDecoration: const BoxDecoration(
          color: Color(0xff4B5563),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      sliderActiveDecoration: const BoxDecoration(
          color: Color.fromRGBO(206, 206, 206, 100),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      underColor: Colors.transparent,
      child: MediaQuery(
        data: mediaQueryData.copyWith(textScaleFactor: 1),
        child: Scaffold(
          backgroundColor: ColorSelect.class_color,
          body: SingleChildScrollView(
            controller: horizontalScroll,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              // controller: verticalScroll,
              // scrollDirection: Axis.vertical,
              child: Container(
                width: MediaQuery.of(context).size.width < 950
                    ? MediaQuery.of(context).size.width * 2
                    : MediaQuery.of(context).size.width - 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 60),
                            // width: MediaQuery.of(context).size.width * 0.89,
                            // height: MediaQuery.of(context).size.height * 0.40,
                            //width: double.infinity,
                            margin: const EdgeInsets.only(
                                left: 59.0,
                                right: 32.0,
                                bottom: 0.0,
                                top: 35.0),
                            decoration: BoxDecoration(
                              color:
                                  // Colors.red,
                                  const Color(0xff1E293B),
                              border: Border.all(
                                  color: ColorSelect.peoplelistbackgroundcolor),
                              borderRadius: BorderRadius.circular(
                                12.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 40.0,
                                      margin: const EdgeInsets.only(
                                          left: 16.0, top: 16.0),
                                      decoration: BoxDecoration(
                                        color: ColorSelect.box_decoration,
                                        //border: Border.all(color: const Color(0xff0E7490)),
                                        borderRadius: BorderRadius.circular(
                                          55.0,
                                        ),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 10.0,
                                              bottom: 10.0),
                                          child: Text(
                                            "OCCUPIED",
                                            style: TextStyle(
                                                color:
                                                    ColorSelect.boxtext_color,
                                                fontSize: 14.0,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 134.0,
                                            height: 134.0,
                                            margin: const EdgeInsets.only(
                                                left: 0.0, top: 35.0),
                                            decoration: BoxDecoration(
                                              //color: const Color(0xff334155),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                40.0,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 110,
                                              backgroundImage:
                                                  NetworkImage(list.image!),
                                            )),

                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 0.0, top: 25.0),
                                          child: Text(
                                            "@$nickname",
                                            // list.resource != null
                                            //     ? list.resource!.nickname != null &&
                                            //             list.resource!.nickname!
                                            //                 .isNotEmpty
                                            //         ? list.resource!.nickname
                                            //             .toString()
                                            //         : 'TBD'
                                            //     : 'TBD',
                                            style: const TextStyle(
                                                color: ColorSelect.white_color,
                                                fontSize: 22.0,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        //  "$name\n$designation,$associate",

                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 10.0,
                                                right: 0.0,
                                              ),
                                              child: Text(
                                                list.resource != null
                                                    ? list.resource!.designation !=
                                                                null &&
                                                            list
                                                                .resource!
                                                                .designation!
                                                                .isNotEmpty
                                                        ? list.resource!
                                                            .designation
                                                            .toString()
                                                        : 'TBD'
                                                    : 'TBD',
                                                style: const TextStyle(
                                                    color: ColorSelect
                                                        .profile_color,
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 13.0,
                                                left: 8.0,
                                              ),
                                              height: 6.0,
                                              width: 6.0,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xff64748B),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 8.0,
                                                right: 0.0,
                                              ),
                                              child: Text(
                                                list.resource != null
                                                    ? list.resource!.department!
                                                                    .name !=
                                                                null &&
                                                            list
                                                                .resource!
                                                                .department!
                                                                .name!
                                                                .isNotEmpty
                                                        ? list.resource!
                                                            .department!.name
                                                            .toString()
                                                        : 'TBD'
                                                    : 'TBD',
                                                style: const TextStyle(
                                                    color: ColorSelect
                                                        .profile_color,
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 13.0,
                                                left: 8.0,
                                              ),
                                              height: 6.0,
                                              width: 6.0,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xff64748B),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 8.0,
                                                right: 0.0,
                                              ),
                                              child: Text(
                                                "Associated with:",
                                                style: const TextStyle(
                                                    color: ColorSelect
                                                        .profile_color,
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 8.0,
                                                right: 0.0,
                                              ),
                                              child: Text(
                                                list.resource != null
                                                    ? list.resource!.associate !=
                                                                null &&
                                                            list
                                                                .resource!
                                                                .associate!
                                                                .isNotEmpty
                                                        ? list
                                                            .resource!.associate
                                                            .toString()
                                                        : 'TBD'
                                                    : 'TBD',
                                                style: const TextStyle(
                                                    color: ColorSelect
                                                        .profile_color,
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Container(
                                              width: 20.0,
                                              height: 18.0,
                                              margin: const EdgeInsets.only(
                                                top: 10.0,
                                                left: 16.0,
                                                right: 0.0,
                                              ),
                                              child: SvgPicture.asset(
                                                "images/location_icon.svg",
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 0.0, top: 10.0),
                                              child: Text(
                                                list.resource != null
                                                    ? list.resource!.city !=
                                                                null &&
                                                            list.resource!.city!
                                                                .isNotEmpty
                                                        ? list.resource!.city
                                                            .toString()
                                                        : 'TBD'
                                                    : 'TBD',
                                                style: TextStyle(
                                                    color: ColorSelect
                                                        .profile_color,
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 0.0, top: 10.0),
                                              child: const Text(
                                                ", ",
                                                style: TextStyle(
                                                    color: ColorSelect
                                                        .profile_color,
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 0.0, top: 10.0),
                                              child: Text(
                                                list.resource != null
                                                    ? list.resource!.country !=
                                                                null &&
                                                            list
                                                                .resource!
                                                                .country!
                                                                .isNotEmpty
                                                        ? list.resource!.country
                                                            .toString()
                                                        : 'TBD'
                                                    : 'TBD',
                                                style: TextStyle(
                                                    color: ColorSelect
                                                        .profile_color,
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 13.0,
                                                left: 8.0,
                                              ),
                                              height: 6.0,
                                              width: 6.0,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xff64748B),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                            // Container(
                                            //   margin: const EdgeInsets.only(
                                            //       left: 0.0, top: 10.0),
                                            //   child: const Text(
                                            //     ".",
                                            //     style: TextStyle(
                                            //         color: ColorSelect.profile_color,
                                            //         fontSize: 14.0,
                                            //         fontFamily: 'Inter',
                                            //         fontWeight: FontWeight.w400),
                                            //   ),
                                            // ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10.0, top: 10.0),
                                              child: Text(
                                                list.resource != null
                                                    ? list.resource!
                                                                    .timeZone !=
                                                                null &&
                                                            list
                                                                    .resource!
                                                                    .timeZone!
                                                                    .offset !=
                                                                null &&
                                                            list
                                                                .resource!
                                                                .timeZone!
                                                                .offset!
                                                                .isNotEmpty
                                                        ? list.resource!
                                                            .timeZone!.offset
                                                            .toString()
                                                        : 'TBD'
                                                    : 'TBD',
                                                style: TextStyle(
                                                    color: ColorSelect
                                                        .profile_color,
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, bottom: 10),
                                      child: MyMenu(
                                          data: list,
                                          title: 'Menu at bottom',
                                          alignment: Alignment.topRight,
                                          buildContext: context,
                                          returnValue: () {
                                            Navigator.pop(context, true);
                                          }),
                                    ),
                                  ],
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(bottom: 0.0),
                                //   child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.center,
                                //       children: [

                                //       ]),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 175.0, top: 0.0),
                          child: const Text(
                            "About me",
                            style: TextStyle(
                                color: ColorSelect.text_color,
                                fontSize: 20.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 126.0, top: 55.0),
                                child: Text(
                                  list.name != null && list.name!.isNotEmpty
                                      ? list.name.toString()
                                      : 'TBD',
                                  style: TextStyle(
                                      color: ColorSelect.white_color,
                                      fontSize: 16.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                //width: 700.0,
                                height: 50.0,
                                margin: const EdgeInsets.only(
                                  left: 126.0,
                                  top: 8.0,
                                ),
                                child: Text(
                                  list.resource != null
                                      ? list.resource!.bio != null &&
                                              list.resource!.bio!.isNotEmpty
                                          ? list.resource!.bio.toString()
                                          : 'TBD'
                                      : 'TBD',
                                  style: TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 16.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 175.0, top: 20.0),
                          child: const Text(
                            "Availability",
                            style: TextStyle(
                                color: ColorSelect.text_color,
                                fontSize: 20.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 118.0, top: 42),
                              child: Text(
                                // "Mon - Fri | 10:00 AM - 7:00 PM | $timezome$timeoffset/$city",

                                list.resource != null
                                    ? startDay == endDay
                                        ? "${startDay} | ${list.resource!.availibiltyTime} | $timeoffset$timezome"
                                        : "${startDay} - ${endDay} | ${list.resource!.availibiltyTime} | $timeoffset$timezome"
                                    : 'TBD',
                                style: const TextStyle(
                                    color: ColorSelect.white_color,
                                    fontSize: 16.0,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              // width: 700.0,
                              margin: const EdgeInsets.only(
                                top: 8.0,
                                left: 118.0,
                              ),
                              child: Text(
                                // "$salary hours/week",
                                "$capacity"
                                " hours/week",
                                style: const TextStyle(
                                    color: ColorSelect.text_color,
                                    fontSize: 16.0,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 175.0, top: 40.0),
                          child: const Text(
                            "Skills",
                            style: TextStyle(
                                color: ColorSelect.text_color,
                                fontSize: 20.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        list.resource != null
                            ? SizedBox(
                                height: 65,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 160.0, top: 30.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: list.resource!.skills!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        //PeopleData _peopleListSkills = data.peopleList!.data![index];
                                        Skills _skills =
                                            list.resource!.skills![index];
                                        var skill = _skills.title;
                                        // postion=index;
                                        return Container(
                                          height: 32.0,
                                          margin: const EdgeInsets.only(
                                              left: 5.0, top: 5.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff334155),
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0,
                                                  right: 12.0,
                                                  top: 6.0,
                                                  bottom: 6.0),
                                              child: Text(
                                                skill != null &&
                                                        skill.isNotEmpty
                                                    ? '$skill'
                                                    : 'TBD',
                                                style: const TextStyle(
                                                    color:
                                                        ColorSelect.white_color,
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                  top: 15.0,
                                ),
                                child: SizedBox(
                                  height: 65,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 160.0, top: 35.0),
                                    child: const Text('TBD',
                                        style: TextStyle(
                                            color: ColorSelect.white_color,
                                            fontSize: 14.0,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
        //var res = response.body;
        //  print('helloDepartment' + res);
        //  DepartmentResponce peopleList = DepartmentResponce.fromJson(json.decode(res));
        // return peopleList;

        // final stringRes = JsonEncoder.withIndent('').convert(res);
        //  print(stringRes);
      }else if (response.statusCode == 401) {
      
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
      }else if (response.statusCode == 401) {
      
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
      }else if (response.statusCode == 401) {
      
      AppUtil.showErrorDialog(context);
    } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }
}
