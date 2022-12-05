import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';
import 'package:zeus/helper_widget/delete_dialog.dart';
import 'package:zeus/helper_widget/responsive.dart';
import 'package:zeus/navigation/navigation.dart';
import 'package:zeus/navigator_tabs/idle/project_detail_model/project_detail_response.dart';
import 'package:zeus/navigator_tabs/people_idle/model/model_class.dart';
import 'package:zeus/people_profile/screen/people_detail_view.dart';
import 'package:zeus/utility/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/pop_resource_button.dart';
import 'package:zeus/helper_widget/searchbar.dart';
import 'package:zeus/navigation/tag_model/tag_user.dart';
import 'package:zeus/navigation/tag_model/tagresponse.dart';
import 'package:zeus/people_profile/editpage/edit_page.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/dropdrowndata.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:zeus/utility/upertextformate.dart';
import '../DemoContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/scrollbar_helper_widget.dart';
import 'package:zeus/utility/app_url.dart';

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
    // _getTag = getProject();
    // change();

    _isSelected = false;
    getUsers();
    getDepartment();
    getCurrency();
    getTimeline();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      offset: widget.offset,
      color: Color(0xFF0F172A),
      // icon: const Padding(
      //   padding: EdgeInsets.only(bottom: 15.0),
      //   child: Icon(
      //     Icons.more_vert,
      //     color: Colors.white,
      //   ),
      // ),
      // icon: SvgPicture.asset(
      //   "images/edit.svg",
      // ),
      child: Container(
        margin: const EdgeInsets.only(right: 12.0, top: 7.0),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            border: Border.all(
              color: ColorSelect.box_decoration,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "images/edit.svg",
              // height: 30,
              // width: 30,
            ),
          ),
        ),
      ),

      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: InkWell(
            // hoverColor: Colors.red,
            onTap: () {

              //Navigator.pop(context);
              widget.onEditClick!();
            },
            child: Container(
              width: 30,
              // color: ColorSelect.backgroundColor,
              child: const Text(
                "Edit",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: ColorSelect.white_color),
              ),
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                        backgroundColor: ColorSelect.peoplelistbackgroundcolor,
                        content: Container(
                          height: 110.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20.0),
                                child: const Text(
                                  "Do you want to delete this person?",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                      color: ColorSelect.white_color),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15.0),
                                child: const Text(
                                  "Once deleted,you will not find this person in project list ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                      color: ColorSelect.delete),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 30.0),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 35.0),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Inter',
                                                color: ColorSelect.delete_text),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
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
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Inter',
                                              color: ColorSelect.delete_text),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          //MediaQueryx.of(context).size.height * 0.85,
                        ),
                      ),
                    );
                  });
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  color: ColorSelect.white_color),
            ),
          ),
        )
      ],
      // child: Text(widget.title),
    );
  }

  _editSubmit() {
    setState(() {
      _addSubmitted = true;
    });
    if (_addFormKey.currentState!.validate()) {
      // widget.adOnSubmit!(name1);
      // getAddPeople();
      Navigator.pushNamed(context, "/home");
    }
  }

  Future<String?> getDepartment() async {
    String? value;
    var token = 'Bearer ' + storage.read("token");
    if (value == null) {
      var response = await http.get(
        Uri.parse("https://zeus-api.zehntech.net/api/v1/departments"),
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
      } else {
        print('department error===========>>>>>>>>');
        print("failed to much");
      }
      return value;
    }
  }

  Future<String?> getTimeline() async {
    String? value;
    var token = 'Bearer ' + storage.read("token");
    if (value == null) {
      var response = await http.get(
        Uri.parse("https://zeus-api.zehntech.net/api/v1/time-zone/list"),
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
      } else {
        print("failed to much");
      }
      return value;
    }
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

      // print('Users: ${users.length}');

      setState(() {
        loading = false;
      });
    } else {
      print("Error getting users.");

      // print(response.body);

    }
  }

  getUpdatePeople(String userId, BuildContext context) async {}

  deletePeople(int? peopleId, BuildContext buildContext, StateSetter setState,
      int indexs) async {
    var url = '${AppUrl.deleteForphase}${peopleId}';
    var token = 'Bearer ' + storage.read("token");

    // var userId = storage.read("user_id");
    var response = await http.delete(
      Uri.parse(url),
      headers: {"Accept": "application/json", "Authorization": token},
    );

    if (response.statusCode == 200) {
      print("sucess");
      print(indexs);
      widget.onDeleteSuccess();
      // print(widget.response.data!.phase!.length);
      // setState() {
      //   for (int i = 0; i < widget.response.data!.phase!.length; i++) {
      //     // ignore: unrelated_type_equality_checks
      //     if (widget.response.data!.phase![i] == indexs) {
      //       widget.response.data!.phase!.removeAt(i);
      //     }
      //   }
      // }

      SmartDialog.dismiss();

      widget.returnValue!();

      // ignore: use_build_context_synchronously
      //Navigator.pop(context, true);
      // Navigator.of(buildContext).pushReplacement(
      //   MaterialPageRoute(
      //       builder: (context) => MyHomePage(
      //             onSubmit: (String value) {},
      //             adOnSubmit: (String value) {},
      //           )),
      // );
      //(Route<dynamic> route) => false);
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
        Uri.parse("https://zeus-api.zehntech.net/api/v1/currencies"),
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
      } else {
        print("failed to much");
      }
      return value;
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
