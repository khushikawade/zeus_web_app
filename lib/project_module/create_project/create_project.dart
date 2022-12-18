import 'dart:convert';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/helper_widget/custom_form_field.dart';
import 'package:zeus/home_module/home_page.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/colors.dart';
import 'package:http/http.dart' as http;
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/upertextformate.dart';
import 'package:zeus/utility/util.dart';

class CreateProjectPage extends StatefulWidget {
  GlobalKey<FormState>? formKey = new GlobalKey<FormState>();

  CreateProjectPage({Key? key, this.formKey}) : super(key: key);

  @override
  State<CreateProjectPage> createState() => _EditPageState();
}

class _EditPageState extends State<CreateProjectPage> {
  String dropdownvalue = 'Item 1';
  String? _depat, _account, _custome, _curren, _status, _time, _tag;
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
  bool createProjectValidate = true;

  TextEditingController _projecttitle = TextEditingController();
  final TextEditingController _crmtask = TextEditingController();
  final TextEditingController _warkfolderId = TextEditingController();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _estimatehours = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final ScrollController verticalScroll = ScrollController();

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
          _accountableId = mdata;
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
          _customerName = mdata;
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
          width: MediaQuery.of(context).size.width * 0.33,
          child: RawScrollbar(
            controller: verticalScroll,
            thumbColor: const Color(0xff4b5563),
            crossAxisMargin: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            thickness: 8,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView(
                controller: verticalScroll,
                padding: EdgeInsets.all(20),
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
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
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xff1E293B),
                              border: Border.all(
                                  color: Color(0xff334155), width: 0.6),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(
                                'images/cross.svg',
                              ),
                            ),
                          ))
                    ],
                  ),
                  SizedBox(height: 32),
                  CustomFormField(
                    controller: _projecttitle,
                    hint: '',
                    label: "Project title",
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          createProjectValidate = false;
                        });

                        return 'Please enter';
                      }
                      return null;
                    },
                    onChange: (text) => setState(() => name_ = text),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 0.0),
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
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
                                  ),
                                ],
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: 4.0, left: 14.0),
                                        child: const Text(
                                          "AP",
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Color(0xff64748B),
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        )),
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSettersetState) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 14, right: 0, top: 2),
                                        child: DropdownButtonHideUnderline(
                                            child: CustomDropdownButton(
                                          isDense: true,
                                          dropdownColor: Color(0xff0F172A),
                                          value: _account,
                                          underline: Container(),
                                          hint: const Text(
                                            "Select Accountable Person",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w300),
                                          ),
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Color(0xff64748B),
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
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _account = newValue;
                                              print("account:$_account");
                                              selectAccountablePerson = true;
                                            });
                                          },
                                        )),
                                      );
                                    }),
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
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 0, left: 0.0),
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
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
                                  ),
                                ],
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: 4.0, left: 14.0),
                                        child: const Text(
                                          "Customer",
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Color(0xff64748B),
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        )),
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSettersetState) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 14, right: 0, top: 2),
                                        child: DropdownButtonHideUnderline(
                                            child: CustomDropdownButton(
                                          isDense: true,
                                          dropdownColor:
                                              ColorSelect.class_color,
                                          value: _custome,
                                          underline: Container(),
                                          hint: const Text(
                                            "Select Customer",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w300),
                                          ),
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Color(0xff64748B),
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
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                ? selectCustomer
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
                  SizedBox(height: 24),
                  CustomFormField(
                    controller: _crmtask,
                    hint: '',
                    label: "CRM task ID",
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          createProjectValidate = false;
                        });
                        return 'Please enter';
                      }
                      return null;
                    },
                    onChange: (text) => setState(() => name_ = text),
                  ),
                  CustomFormField(
                    controller: _warkfolderId,
                    hint: '',
                    label: "Work Folder ID:",
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          createProjectValidate = false;
                        });
                        return 'Please enter';
                      }
                      return null;
                    },
                    onChange: (text) => setState(() => name_ = text),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomFormField(
                          controller: _budget,
                          hint: '',
                          label: "Budget",
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                createProjectValidate = false;
                              });
                              return 'Please enter';
                            }
                            return null;
                          },
                          onChange: (text) => setState(() => name_ = text),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 0.0, top: 0.0, bottom: 8.0),
                              height: 56.0,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ),
                              ),
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 12.0, right: 5.0),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSettersetState) {
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          dropdownColor:
                                              ColorSelect.class_color,
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
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Color(0xff64748B),
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
                                                    fontWeight:
                                                        FontWeight.w400),
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
                      Expanded(
                        flex: 5,
                        child: CustomFormField(
                          controller: _estimatehours,
                          hint: '',
                          label: "Estimated hours",
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                createProjectValidate = false;
                              });
                              return 'Please enter';
                            }
                            return null;
                          },
                          onChange: (text) => setState(() => name_ = text),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 0.0),
                              height: 56.0,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ),
                              ),
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 16.0, right: 0.0),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSettersetState) {
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          dropdownColor:
                                              ColorSelect.class_color,
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
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Color(0xff64748B),
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
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _status = newValue;
                                              print(
                                                  'value of status' + _status!);
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
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 0.0),
                              height: 56.0,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
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
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _selectDate(setState);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 13.0),
                                      child: Image.asset(
                                        'images/date.png',
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 20.0,
                                          ),
                                          child: const Text(
                                            "Delivery Date",
                                            style: TextStyle(
                                                fontSize: 15,
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
                                                        overflow:
                                                            TextOverflow.fade,
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  )
                                                : Text(
                                                    '${selectedDate!.day} / ${selectedDate!.month} / ${selectedDate!.year}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        color:
                                                            Color(0xffFFFFFF),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 97,
                          margin: const EdgeInsets.only(
                            top: 16.0,
                          ),
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff334155),
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
                      InkWell(
                        onTap: () async {
                          setState(() {
                            createProjectValidate = true;
                            createButtonClick = true;
                          });
                          if (await widget.formKey!.currentState!.validate()) {
                            Future.delayed(const Duration(microseconds: 500),
                                () {
                              if (createProjectValidate) {
                                if (selectAccountablePerson == true &&
                                    selectCustomer == true &&
                                    selectCurrency == true &&
                                    selectStatus == true &&
                                    selectDeliveryDate == true) {
                                  SmartDialog.showLoading(
                                    msg:
                                        "Your request is in progress please wait for a while...",
                                  );
                                  createProject(context);
                                }
                              }
                            });
                          }
                        },
                        child: Container(
                          width: 97.0,
                          margin: const EdgeInsets.only(
                            top: 16.0,
                            right: 10.0,
                          ),
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff7DD3FC),
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
          ),
        ),
      ],
    );
  }

  //Create project_detail Api
  createProject(BuildContext context) async {
    var responseJson;
    var token = 'Bearer ' + storage.read("token");
    try {
      var response = await http.post(
        Uri.parse(AppUrl.create_project),
        body: jsonEncode({
          "title": _projecttitle.text.toString(),
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
      print(response.statusCode);

      if (response.statusCode == 200) {
        responseJson =
            jsonDecode(response.body.toString()) as Map<String, dynamic>;
        final stringRes = JsonEncoder.withIndent('').convert(responseJson);
        SmartDialog.dismiss();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      onSubmit: (String value) {},
                      adOnSubmit: (String value) {},
                    )),
            (Route<dynamic> route) => false);
      } else if (response.statusCode == 401) {
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

        print("yes to much");
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
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
    return null;
  }

  errorWidget() {
    return Text('Please Select this field',
        style:
            TextStyle(color: Color.fromARGB(255, 221, 49, 60), fontSize: 14));
  }
}
