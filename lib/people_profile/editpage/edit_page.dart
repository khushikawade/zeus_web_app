import 'dart:convert';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/helper_widget/delete_dialog.dart';
import 'package:zeus/helper_widget/responsive.dart';
import 'package:zeus/navigation/navigation.dart';
import 'package:zeus/people_profile/editpage/edit_profile_model.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/colors.dart';
import 'package:http/http.dart' as http;
// import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';
import '../../utility/upertextformate.dart';

class EditPage extends StatefulWidget {
  GlobalKey<FormState>? formKey = new GlobalKey<FormState>();
  EditPage({Key? key, this.formKey}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String dropdownvalue = 'Item 1';
  String? _depat, _account, _custome, _curren, _status, _time, _tag;
  // DateTime selectedDate = DateTime.now();
  DateTime? selectedDate;
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  String name_ = '';

  bool selectAccountablePerson = false;
  bool selectCurrency = false;
  bool selectStatus = false;
  bool selectCustomer = false;
  bool createButtonClick = false;
  bool selectDeliveryDate = false;

  //creatrptoject
  TextEditingController _projecttitle = TextEditingController();
  final TextEditingController _crmtask = TextEditingController();
  final TextEditingController _warkfolderId = TextEditingController();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _estimatehours = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  bool _submitted = true;
  bool _addSubmitted = false;
  List _accountableId = [];
  List _customerName = [];
  List _currencyName = [];
  List _statusList = [];
  List _timeline = [];
  List addTag = [];
  List<String> _tag1 = [];
  GlobalKey<ScaffoldState>? _key;
  bool? _isSelected;
  List<String>? _filters1 = [
    'User interface',
    'User interface',
    'User interface',
    'User interface',
    'User interface'
  ];
  List<String>? addTag1 = [];
  List<int> add1 = [1];
  bool imageavail = false;
  // XFile? webImage;
  var isIndex = 0;
  var isLoading = false;
  Future<void> _selectDate(setState) async {
    selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        lastDate: DateTime(5000),
        firstDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    selectDeliveryDate = true;
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
          _statusList = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
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
          _accountableId = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  Future<String?> getCustomer() async {
    String? value;
    if (value == null) {
      //    "Authorization": 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVlM2EwY2E0NmYyNmI1NzZkZDY0MTRhZDY0NTFlNjFjNjVlNTY2NzgxYjE1OWYxMzY5NDFmMjMwYmI5ZDVhODlhOGI4Y2QzMzBiNDg0NzMiLCJpYXQiOjE2NjM5NDMxMzUuNjY1NzY2LCJuYmYiOjE2NjM5NDMxMzUuNjY1NzY5LCJleHAiOjE2OTU0NzkxMzUuNjEyNTQ2LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.MQDtmzlqx5LkruPq7TwzFcPD2sClWNSioqOdZ4fnp3CoRL7gsELEv_nGZNR0ZjqcYCzQI0abz9PCVXQ6StgYNdN4ceGVTC2G004kaWj4edXGchTPQLLHnKQ73L47WZuqhwEOQ-0D6TITRczOScTuHuUC7VEwmQTsohzd3EAswGHSBBOiauRmgXiDEOTR9SPNvzH0b11AFcHeFjkPFG82LIJHI3h18ScWF2C4nKy2qnFgweCFhr7NwhYj1sNJKRqee-sa1BATvvkpXf7h4IQ5CEVIqrLEVoXviD958Nty1MC-gYsinaEQTWiyN-a6bb4o0RrHys8KPgVeSS4Ihe_FitaVjm7KPrV4LrEmvUhn2Fu_NJsV6n5toBJgHQ4_W6aR4fxMGMfmmx4mSfr7HdrDQNFeJ5BKhD88WYFuJPP3QyKuj6ps9w7wLK2DHHJ2VVKL06I8SIJq4R_-QNhT9_xSNKBWRWwbs4-Kp6xYtC0jSAcGhAIMmiEMxkt3cyCBwO9OcZEowWd7499nlTSMwSwYt8rwiX32ACBp3h2Sr8SdkBpBmuWQcAQEYPYteSWgV0OZkyAacHUg94xjDxF8dbNLEXab6ZNoL-uFmdzHXJxXENdAW6Gux_XejDgd4PgG6nD84nQIJPvhkDeIs5u_UZ3VUs8dO36FByLcKQNWNOUd15s'
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
          _customerName = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  @override
  void initState() {
    getSelectStatus();
    getAccountable();
    getCustomer();
    getCurrency();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.27,
          //height: 620, //MediaQuery.of(context).size.height * 0.75,
          child: ListView(
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 0.0, left: 10.0),
                      child: const Text(
                        'Create Project',
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 18.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                      )),
                  GestureDetector(
                      onTap: () {
                        //createProject();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 0.0, right: 10.0),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff1E293B),
                          border:
                              Border.all(color: Color(0xff334155), width: 0.6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            'images/cross.svg',
                          ),
                        ),
                      )
                      // child: Container(
                      //   margin: const EdgeInsets.only(
                      //       top: 30.0, left: 40.0, bottom: 10),
                      //   height: 28.0,
                      //   width: 40.0,
                      //   decoration: BoxDecoration(
                      //       border:
                      //           Border.all(color: Color(0xff334155), width: 0.6),
                      //       borderRadius:
                      //           const BorderRadius.all(Radius.circular(40))),
                      //   child: const Padding(
                      //       padding: EdgeInsets.all(6.0),
                      //       // child: SvgPicture.asset(
                      //       //   "images/cross.svg",
                      //       // ),
                      //       child: Icon(
                      //         Icons.close,
                      //         color: Colors.white,
                      //       )),
                      // ),
                      )
                ],
              ),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    margin: const EdgeInsets.only(
                        top: 15.0, left: 10.0, right: 10.0),
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff334155),
                      //border: Border.all(color:  const Color(0xff1E293B)),
                      borderRadius: BorderRadius.circular(
                        8.0,
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
                        ), //BoxShadow
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 24.0, left: 26.0),
                          child: const Text(
                            "Project title",
                            style: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xff64748B),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                  TextFormField(
                    maxLength: 20,
                    controller: _projecttitle,
                    inputFormatters: [UpperCaseTextFormatter()],
                    textCapitalization: TextCapitalization.characters,
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorColor: const Color(0xffFFFFFF),
                    style: const TextStyle(color: Color(0xffFFFFFF)),
                    textAlignVertical: TextAlignVertical.bottom,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.only(
                          bottom: 16.0,
                          top: 54.0,
                          right: 10,
                          left: 26.0,
                        ),
                        errorStyle: TextStyle(fontSize: 15.0, height: 0.20),
                        border: InputBorder.none,
                        // hintText: 'Project title',
                        hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xffFFFFFF),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500)),
                    //  autovalidate: _autoValidate ,
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,

                    validator: (value) {
                      //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter';
                      }
                      return null;
                    },
                    onChanged: (text) => setState(() => name_ = text),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // width: double.infinity / 2,
                          width: MediaQuery.of(context).size.width * 0.13,
                          margin: const EdgeInsets.only(top: 15.0, left: 10.0),
                          height: 60.0,
                          decoration: BoxDecoration(
                            color:
                                // Colors.red,
                                const Color(0xff334155),
                            //border: Border.all(color:  const Color(0xff1E293B)),
                            borderRadius: BorderRadius.circular(
                              8.0,
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
                              ), //BoxShadow
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(
                                        top: 4.0, left: 16.0),
                                    child: const Text(
                                      "AP",
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xff64748B),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    )),
                                StatefulBuilder(builder: (BuildContext context,
                                    StateSettersetState) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 4, top: 2),
                                    child: DropdownButtonHideUnderline(
                                        child: CustomDropdownButton(
                                      isDense: true,

                                      dropdownColor: Color(0xff0F172A),
                                      value: _account,
                                      underline: Container(),
                                      hint: const Text(
                                        "Select Accountable Person",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Color(0xffFFFFFF),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300),
                                      ),
                                      // isExpanded: true,
                                      icon: const Icon(
                                        // Add this
                                        Icons.arrow_drop_down, // Add this
                                        color: Color(0xff64748B),

                                        // Add this
                                      ),
                                      elevation: 12,
                                      items: _accountableId.map((items) {
                                        return DropdownMenuItem(
                                          value: items['id'].toString(),
                                          child: Text(
                                            items['name'],
                                            style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          //  validator: (value) => value == null ? 'field required' : null,
                                          //               onSaved: (value) => name = value,

                                          _account = newValue;
                                          print("account:$_account");
                                          selectAccountablePerson = true;
                                        });
                                      },
                                    )),
                                  );
                                }),
                                // CustomDropdownButton(
                                //   value: _account,
                                //   items: _accountableId.map((items) {
                                //     return DropdownMenuItem(
                                //       value: items['id'].toString(),
                                //       child: Text(
                                //         items['name'],
                                //         style: const TextStyle(
                                //             fontSize: 15.0,
                                //             color: Color(0xffFFFFFF),
                                //             fontFamily: 'Inter',
                                //             fontWeight: FontWeight.w500),
                                //       ),
                                //     );
                                //   }).toList(),
                                //   onChanged: ((value) {
                                //     setState(() {
                                //       //  validator: (value) => value == null ? 'field required' : null,
                                //       //               onSaved: (value) => name = value,

                                //       _account = value.toString();
                                //       print("account:$_account");
                                //       selectAccountablePerson = true;
                                //     });
                                //   }),
                                // ),
                              ]),
                        ),
                        createButtonClick
                            ? selectAccountablePerson
                                ? const Text(
                                    " ",
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      left: 26,
                                    ),
                                    child: errorWidget())
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // width: double.infinity / 2,
                          width: MediaQuery.of(context).size.width * 0.12,
                          margin: const EdgeInsets.only(top: 15.0, left: 10.0),
                          height: 60.0,
                          decoration: BoxDecoration(
                            color:
                                // Colors.red,
                                const Color(0xff334155),
                            //border: Border.all(color:  const Color(0xff1E293B)),
                            borderRadius: BorderRadius.circular(
                              8.0,
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
                              ), //BoxShadow
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(
                                        top: 4.0, left: 16.0),
                                    child: const Text(
                                      "Customer",
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xff64748B),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    )),
                                StatefulBuilder(builder: (BuildContext context,
                                    StateSettersetState) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 4, top: 2),
                                    child: DropdownButtonHideUnderline(
                                        child: CustomDropdownButton(
                                      isDense: true,
                                      dropdownColor: ColorSelect.class_color,
                                      value: _custome,
                                      underline: Container(),
                                      hint: const Text(
                                        "Select Customer",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Color(0xffFFFFFF),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300),
                                      ),
                                      // isExpanded: true,
                                      icon: const Icon(
                                        // Add this
                                        Icons.arrow_drop_down, // Add this
                                        color: Color(0xff64748B),

                                        // Add this
                                      ),
                                      items: _customerName.map((items) {
                                        return DropdownMenuItem(
                                          value: items['id'].toString(),
                                          child: Text(
                                            items['name'],
                                            style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _custome = newValue;
                                          print("account:$_custome");
                                          selectCustomer = true;
                                        });
                                      },
                                    )),
                                  );
                                })
                              ]),
                        ),
                        createButtonClick
                            ? selectAccountablePerson
                                ? const Text(
                                    " ",
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      left: 26,
                                    ),
                                    child: errorWidget())
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),

              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    margin: const EdgeInsets.only(
                        top: 24.0, left: 10.0, right: 10.0),
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff334155),
                      //border: Border.all(color:  const Color(0xff1E293B)),
                      borderRadius: BorderRadius.circular(
                        8.0,
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
                        ), //BoxShadow
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 33.0, left: 26.0),
                          child: const Text(
                            "CRM task ID",
                            style: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xff64748B),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                  TextFormField(
                    maxLength: 20,
                    controller: _crmtask,
                    cursorColor: const Color(0xffFFFFFF),
                    style: const TextStyle(color: Color(0xffFFFFFF)),
                    textAlignVertical: TextAlignVertical.bottom,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        counterText: "",
                        errorStyle: TextStyle(fontSize: 15.0, height: 0.20),
                        contentPadding: EdgeInsets.only(
                          bottom: 16.0,
                          top: 63.0,
                          right: 0,
                          left: 26.0,
                        ),
                        border: InputBorder.none,
                        // hintText: 'Project title',
                        hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xffFFFFFF),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500)),
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (value) {
                      //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter';
                      }
                      return null;
                    },
                    onChanged: (text) => setState(() => name_ = text),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    margin: const EdgeInsets.only(
                        top: 15.0, left: 10.0, right: 10.0),
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff334155),
                      //border: Border.all(color:  const Color(0xff1E293B)),
                      borderRadius: BorderRadius.circular(
                        8.0,
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
                        ), //BoxShadow
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 26.0, left: 26.0),
                          child: const Text(
                            "Work Folder ID:",
                            style: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xff64748B),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                  TextFormField(
                    maxLength: 20,
                    controller: _warkfolderId,
                    cursorColor: const Color(0xffFFFFFF),
                    style: const TextStyle(color: Color(0xffFFFFFF)),
                    textAlignVertical: TextAlignVertical.bottom,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        counterText: "",
                        errorStyle: TextStyle(fontSize: 15.0, height: 0.20),
                        contentPadding: EdgeInsets.only(
                          bottom: 16.0,
                          top: 55.0,
                          right: 0,
                          left: 26.0,
                        ),
                        border: InputBorder.none,
                        //  hintText: 'Project title',
                        hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xffFFFFFF),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500)),
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (value) {
                      //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter';
                      }
                      return null;
                    },
                    onChanged: (text) => setState(() => name_ = text),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        Container(
                          //width: MediaQuery.of(context).size.width * 0.10,
                          margin: const EdgeInsets.only(top: 15.0, left: 10.0),
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff334155),
                            //border: Border.all(color:  const Color(0xff1E293B)),
                            borderRadius: BorderRadius.circular(
                              8.0,
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
                              ), //BoxShadow
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 26.0, left: 26.0),
                                child: const Text(
                                  "Budget",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Color(0xff64748B),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                )),
                          ],
                        ),
                        TextFormField(
                          maxLength: 8,
                          controller: _budget,
                          cursorColor: const Color(0xffFFFFFF),
                          style: const TextStyle(color: Color(0xffFFFFFF)),
                          textAlignVertical: TextAlignVertical.bottom,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              counterText: "",
                              errorStyle:
                                  TextStyle(fontSize: 15.0, height: 0.20),
                              contentPadding: EdgeInsets.only(
                                bottom: 18.0,
                                top: 55.0,
                                right: 0,
                                left: 26.0,
                              ),
                              border: InputBorder.none,
                              //hintText: 'Project title',
                              hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  color: Color(0xffFFFFFF),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500)),
                          autovalidateMode: _submitted
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          validator: (value) {
                            //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            if (value!.isEmpty) {
                              return 'Please enter';
                            }
                            return null;
                          },
                          onChanged: (text) => setState(() => name_ = text),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          // width: MediaQuery.of(context).size.width * 0.07,
                          margin: const EdgeInsets.only(
                              left: 0.0, top: 16.0, bottom: 8.0),
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff334155),
                            //border: Border.all(color:  const Color(0xff1E293B)),
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                          ),
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 12.0, right: 5.0),
                              // padding: const EdgeInsets.all(2.0),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSettersetState) {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      dropdownColor: ColorSelect.class_color,
                                      value: _curren,
                                      underline: Container(),
                                      hint: const Text(
                                        "Select",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xffFFFFFF),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300),
                                      ),
                                      // isExpanded: true,
                                      icon: const Icon(
                                        // Add this
                                        Icons.arrow_drop_down,
                                        // Add this
                                        color: Color(0xff64748B),

                                        // Add this
                                      ),
                                      items: _currencyName.map((items) {
                                        return DropdownMenuItem(
                                          value: items['id'].toString(),
                                          child: Text(
                                            items['currency']['symbol'],
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        StateSettersetState(() {
                                          _curren = newValue;
                                          setState(() {
                                            selectCurrency = true;
                                          });
                                        });
                                      },
                                    ),
                                  );
                                },
                              )),
                        ),
                        createButtonClick
                            ? selectCurrency
                                ? const Text(
                                    " ",
                                  )
                                : const Padding(
                                    padding: EdgeInsets.only(left: 13),
                                    child: Text("Please Select ",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 221, 49, 60),
                                            fontSize: 14)),
                                  )
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 7,
                    child: Stack(
                      children: [
                        Container(
                          // width: MediaQuery.of(context).size.width * 0.19,
                          margin: const EdgeInsets.only(top: 15.0, right: 10.0),
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff334155),
                            //border: Border.all(color:  const Color(0xff1E293B)),
                            borderRadius: BorderRadius.circular(
                              8.0,
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
                              ), //BoxShadow
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 26.0, left: 16.0),
                                child: const Text(
                                  "Estimated hours",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: Color(0xff64748B),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                )),
                          ],
                        ),
                        TextFormField(
                          maxLength: 10,
                          controller: _estimatehours,
                          cursorColor: const Color(0xffFFFFFF),
                          style: const TextStyle(color: Color(0xffFFFFFF)),
                          textAlignVertical: TextAlignVertical.bottom,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              counterText: "",
                              errorStyle: TextStyle(
                                  fontSize: 14.0,
                                  // ScreenUtil().setSp(ScreenUtil().setSp(14.0)),
                                  height: 0.20),
                              contentPadding: EdgeInsets.only(
                                bottom: 18.0,
                                top: 55.0,
                                right: 0,
                                left: 17.0,
                              ),
                              border: InputBorder.none,
                              //   hintText: 'Project title',
                              hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  // ScreenUtil().setSp(ScreenUtil().setSp(14.0)),
                                  color: Color(0xffFFFFFF),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500)),
                          autovalidateMode: _submitted
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          validator: (value) {
                            //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            if (value!.isEmpty) {
                              return 'Please enter';
                            }
                            return null;
                          },
                          onChanged: (text) => setState(() => name_ = text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.13,
                        margin: const EdgeInsets.only(top: 15.0, left: 10.0),
                        height: 56.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff334155),
                          //border: Border.all(color:  const Color(0xff1E293B)),
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                        ),
                        child: Container(
                            margin:
                                const EdgeInsets.only(left: 16.0, right: 20.0),
                            // padding: const EdgeInsets.all(2.0),
                            child: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSettersetState) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    dropdownColor: ColorSelect.class_color,
                                    value: _status,
                                    underline: Container(),
                                    hint: const Text(
                                      "Select Status",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Color(0xffFFFFFF),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w300),
                                    ),
                                    //  isExpanded: true,
                                    icon: const Icon(
                                      // Add this
                                      Icons.arrow_drop_down, // Add this
                                      color: Color(0xff64748B),

                                      // Add this
                                    ),
                                    items: _statusList.map((items) {
                                      return DropdownMenuItem(
                                        value: items['id'].toString(),
                                        child: Text(
                                          items['title'],
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              color: Color(0xffFFFFFF),
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _status = newValue;
                                        print('value of status' + _status!);
                                        selectStatus = true;
                                      });
                                    },
                                  ),
                                );
                              },
                            )),
                      ),
                      createButtonClick
                          ? selectStatus
                              ? const Text(
                                  " ",
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                    top: 8,
                                    left: 26,
                                  ),
                                  child: errorWidget())
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          margin: const EdgeInsets.only(top: 15.0, right: 10.0),
                          height: 56.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff334155),
                            //border: Border.all(color:  const Color(0xff1E293B)),
                            borderRadius: BorderRadius.circular(
                              8.0,
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
                              ), //BoxShadow
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _selectDate(setState);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 13.0),
                                  // height: 22.0,
                                  // width: 20.0,
                                  child: Image.asset(
                                    'images/date.png',
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 20.0,
                                      ),
                                      child: const Text(
                                        "Delivery Date",
                                        style: TextStyle(
                                            fontSize: 15, //18.w,
                                            overflow: TextOverflow.fade,
                                            color: Color(0xff64748B),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      )),
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        _selectDate(setState);
                                        // selectDeliveryDate = true;
                                      });
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                          top: 3.0,
                                          left: 20.0,
                                        ),
                                        child: selectedDate == null
                                            ? const Text(
                                                'Select Date',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    overflow: TextOverflow.fade,
                                                    color: Color(0xffFFFFFF),
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              )
                                            : Text(
                                                '${selectedDate!.day} / ${selectedDate!.month} / ${selectedDate!.year}',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    overflow: TextOverflow.fade,
                                                    color: Color(0xffFFFFFF),
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedDate = null;
                                      selectDeliveryDate = false;
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
                        createButtonClick
                            ? selectDeliveryDate
                                ? const Text(
                                    " ",
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      left: 20,
                                    ),
                                    child: errorWidget())
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              ///-----------------------------Description----------------------------
              // Stack(
              //   children: [
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.99,
              //   margin: const EdgeInsets.only(
              //       top: 15.0, left: 10.0, right: 10.0),
              //   height: 120.0,
              //   decoration: BoxDecoration(
              //     color: const Color(0xff334155),
              //     //border: Border.all(color:  const Color(0xff1E293B)),
              //     borderRadius: BorderRadius.circular(
              //       8.0,
              //     ),
              //     boxShadow: const [
              //       BoxShadow(
              //         color: Color(0xff475569),
              //         offset: Offset(
              //           0.0,
              //           2.0,
              //         ),
              //         blurRadius: 0.0,
              //         spreadRadius: 0.0,
              //       ), //BoxShadow
              //     ],
              //   ),
              // ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Container(
              //         margin: const EdgeInsets.only(top: 24.0, left: 26.0),
              //         child: const Text(
              //           "Description",
              //           style: TextStyle(
              //               fontSize: 13.0,
              //               color: Color(0xff64748B),
              //               fontFamily: 'Inter',
              //               fontWeight: FontWeight.w500),
              //         )),
              //   ],
              // ),
              // TextFormField(
              //   controller: descriptionController,
              //   maxLines: 5,
              //   cursorColor: const Color(0xffFFFFFF),
              //   style: const TextStyle(color: Color(0xffFFFFFF)),
              //   textAlignVertical: TextAlignVertical.bottom,
              //   keyboardType: TextInputType.text,
              //   decoration: const InputDecoration(
              //       errorStyle: TextStyle(
              //           fontSize: 14.0,
              //           // ScreenUtil().setSp(ScreenUtil().setSp(14.0)),
              //           height: 0.20),
              //       contentPadding: EdgeInsets.only(
              //         bottom: 16.0,
              //         top: 54.0,
              //         right: 10,
              //         left: 26.0,
              //       ),
              //       border: InputBorder.none,
              //       //   hintText: 'Project title',
              //       hintStyle: TextStyle(
              //           fontSize: 14.0,
              //           // ScreenUtil().setSp(ScreenUtil().setSp(14.0)),
              //           color: Color(0xffFFFFFF),
              //           fontFamily: 'Inter',
              //           fontWeight: FontWeight.w500)),
              //   autovalidateMode: _submitted
              //       ? AutovalidateMode.onUserInteraction
              //       : AutovalidateMode.disabled,
              //   validator: (value) {
              //     //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
              //     if (value!.isEmpty) {
              //       return 'Please enter';
              //     }
              //     return null;
              //   },
              //   onChanged: (text) => setState(() => name_ = text),
              // ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 97, //MediaQuery.of(context).size.width * 0.22,
                      margin: const EdgeInsets.only(
                        top: 16.0,
                      ),
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff334155),
                        //border: Border.all(color:  const Color(0xff1E293B)),
                        borderRadius: BorderRadius.circular(
                          40.0,
                        ),
                      ),

                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ColorSelect.white_color,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        createButtonClick = true;
                      });
                      if (widget.formKey!.currentState!.validate()) {
                        if (selectAccountablePerson == true &&
                            selectCustomer == true &&
                            selectCurrency == true &&
                            selectStatus == true &&
                            selectDeliveryDate == true) {
                          SmartDialog.showLoading(
                            msg:
                                "Your request is in progress please wait for a while...",
                          );

                          Future.delayed(const Duration(seconds: 2), () {
                            createProject(context);
                          });
                          print(
                              "after -------------------------check validation");
                        }
                      }
                    },
                    child: Container(
                      width: 97.0, //MediaQuery.of(context).size.width * 0.22,
                      margin: const EdgeInsets.only(
                        top: 16.0,
                        //bottom: 10.0,
                        right: 10.0,
                      ),
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff7DD3FC),
                        //border: Border.all(color:  const Color(0xff1E293B)),
                        borderRadius: BorderRadius.circular(
                          40.0,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Create",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: ColorSelect.black_color,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Create project Api
  createProject(BuildContext context) async {
    var responseJson;
    var token = 'Bearer ' + storage.read("token");
    try {
      var response = await http.post(
        Uri.parse(AppUrl.create_project),
        body: jsonEncode({
          "title": _projecttitle.text.toString(),
          // "accountable_person_id": _account,
          "accountable_person_id": _account,
          "customer_id": _custome,
          "crm_task_id": _crmtask.text.toString(),
          "work_folder_id": _warkfolderId.text.toString(),
          "budget": _budget.text.toString(),
          "currency": _curren,
          "estimation_hours": _estimatehours.text.toString(),
          "status": _status,
          "delivery_date": selectedDate.toString(),
          "description": descriptionController.text.toString()
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      // ignore: unrelated_type_equality_checks
      print("----------------------------------");
      print(response.statusCode);

      if (response.statusCode == 200) {
        responseJson =
            jsonDecode(response.body.toString()) as Map<String, dynamic>;
        final stringRes = JsonEncoder.withIndent('').convert(responseJson);
        SmartDialog.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      onSubmit: (String value) {},
                      adOnSubmit: (String value) {},
                    )),
            (Route<dynamic> route) => false);
      }else if (response.statusCode == 401) {
        SmartDialog.dismiss();
        AppUtil.showErrorDialog(context);
      } else {
        SmartDialog.dismiss();
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (route) => false);

        Fluttertoast.showToast(
          msg: 'Something Went Wrong',
          backgroundColor: Colors.grey,
        );
      }
    } catch (e) {
      // print('error caught: $e');
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
          _currencyName = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  Future<String?> getTagpeople() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/skills"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          // addSkills = mdata;
          // _addtag = addSkills;
          // print('ghjhjhjh' + _addtag.length.toString());
        });
        print("yes to much");
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  Future<String?> getAddpeople() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/tags"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          addTag = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
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
}
