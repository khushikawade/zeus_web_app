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
import 'package:zeus/utility/app_url.dart';

class ProjectEdit extends StatefulWidget {
  String title;
  Alignment alignment;
  Offset offset;
  ProjectDetailResponse response;
  BuildContext buildContext;
  List statusList;
  List currencyList;
  List accountableId;
  List customerName;
  String? id;
  ProjectEdit(
      {required this.title,
      required this.alignment,
      this.offset = const Offset(0, 0),
      required this.accountableId,
      required this.currencyList,
      required this.customerName,
      required this.id,
      required this.statusList,
      required this.response,
      required this.buildContext,
      Key? key})
      : super(key: key);

  @override
  State<ProjectEdit> createState() => _ProjectEditState();
}

class _ProjectEditState extends State<ProjectEdit>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  String? _account, _custome, _curren, _status;

  // var _id = widget.id;
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  // var status = widget.response.data!.status; //response.data!.status;
  bool _submitted = true;

  final TextEditingController _projecttitle = TextEditingController();
  final TextEditingController _crmtask = TextEditingController();
  final TextEditingController _warkfolderId = TextEditingController();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _estimatehours = TextEditingController();
  final TextEditingController _description = TextEditingController();
  var myFormat = DateFormat('d MMM yyyy');

  //Add description and time api
  Future<void> addDescriptionProject() async {
    var token = 'Bearer ' + storage.read("token");
    try {
      var response = await http.put(
        Uri.parse('${AppUrl.baseUrl}/project/project-dates/${widget.id}'),
        body: jsonEncode({
          "description": _description.text.toString(),
          //"cost": dropdownvalue,
          "working_days": '12', //dropdownvalue ,
          "deadline_date": myFormat.format(selectedDate),
          "reminder_date": myFormat.format(selectedDate),
          "delivery_date": myFormat.format(selectedDate),
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      // ignore: unrelated_type_equality_checks
      if (response.statusCode == 200) {
        var responseJson =
            jsonDecode(response.body.toString()) as Map<String, dynamic>;
        final stringRes = JsonEncoder.withIndent('').convert(responseJson);
      } else {
        print("failuree");
      }
    } catch (e) {
      // print('error caught: $e');
    }
  }

  // update Controller Value
  updateControllerValue() {
    _projecttitle.text = widget.response.data != null &&
            widget.response.data!.title != null &&
            widget.response.data!.title!.isNotEmpty
        ? widget.response.data!.title!
        : '';

    _crmtask.text = widget.response.data != null &&
            widget.response.data!.crmTaskId != null &&
            widget.response.data!.crmTaskId!.isNotEmpty
        ? widget.response.data!.crmTaskId!
        : '';

    _warkfolderId.text = widget.response.data != null &&
            widget.response.data!.workFolderId != null &&
            widget.response.data!.workFolderId!.isNotEmpty
        ? widget.response.data!.workFolderId!
        : '';

    _budget.text =
        widget.response.data != null && widget.response.data!.budget != null
            ? widget.response.data!.budget!.toString()
            : '';

    _estimatehours.text = widget.response.data != null &&
            widget.response.data!.estimationHours != null &&
            widget.response.data!.estimationHours!.isNotEmpty
        ? widget.response.data!.budget!.toString()
        : '';

    _custome =
        widget.response.data != null && widget.response.data!.customerId != null
            ? widget.response.data!.customerId.toString()
            : '';

    _description.text = widget.response.data != null &&
            widget.response.data!.description != null
        ? widget.response.data!.description.toString()
        : '';
    // _status = response.data != null &&
    //         response.data!.status != null &&
    //         response.data!.status!.isNotEmpty
    //     ? response.data!.status.toString()
    //     : '';

    if (widget.statusList != null && widget.statusList.isNotEmpty) {
      widget.statusList.asMap().forEach((index, element) {
        if (element['title'] == widget.response.data!.status) {
          _status = element['id'].toString();
        }
      });
    }

    if (widget.accountableId != null && widget.accountableId.isNotEmpty) {
      widget.accountableId.asMap().forEach((index, element) {
        if (element['id'].toString() ==
            widget.response.data!.accountablePersonId.toString()) {
          _account = element['id'].toString();
        }
      });
    }

    if (widget.currencyList != null && widget.currencyList.isNotEmpty) {
      widget.currencyList.asMap().forEach((index, element) {
        if (element['id'].toString() == widget.response.data!.currency) {
          _curren = element['id'].toString();
        }
      });
    }
  }

  Future<void> _selectDate(setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: const Color(0xff0F172A),
                accentColor: const Color(0xff0F172A),
                colorScheme:
                    ColorScheme.light(primary: const Color(0xff0F172A)),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary)),
            child: child!,
          );
        },
        initialDate: selectedDate,
        firstDate: new DateTime.now().subtract(new Duration(days: 0)),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  getformattedTime(TimeOfDay time) {
    // return '${time.hour}:${time.minute} ${time.period.toString().split('.')[1]}';
    DateTime tempDate = DateFormat("hh:mm")
        .parse(time.hour.toString() + ":" + time.minute.toString());
    var dateFormat = DateFormat("h:mm a"); // you can change the format here
    print(dateFormat.format(tempDate));
    return dateFormat.format(tempDate);
  }

  @override
  Widget build(BuildContext context) {
    updateControllerValue();
    return PopupMenuButton<int>(
      offset: widget.offset,
      color: Color(0xFF0F172A),
      child: Container(
        margin: const EdgeInsets.only(right: 12.0, top: 16.0),
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
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: const Color(0xff1E293B),
                        content: Form(
                          key: _formKey,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            // height:
                            //     620.0, //MediaQuery.of(context).size.height * 0.85,
                            child: ListView(
                              shrinkWrap: true,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: 0.0, left: 10.0),
                                        child: const Text(
                                          'Edit Project',
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
                                        margin: const EdgeInsets.only(
                                            top: 0.0, right: 10.0),
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xff1E293B),
                                          border: Border.all(
                                              color: Color(0xff334155),
                                              width: 0.6),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SvgPicture.asset(
                                            'images/cross.svg',
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.99,
                                      margin: const EdgeInsets.only(
                                          top: 25.0, left: 10.0, right: 10.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                top: 30.0, left: 26.0),
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
                                      controller: _projecttitle,
                                      autocorrect: false,
                                      cursorColor: const Color(0xffFFFFFF),
                                      style: const TextStyle(
                                          color: Color(0xffFFFFFF)),
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          //counterText: '',
                                          // errorStyle: TextStyle(fontSize: 14, height: 0.20),
                                          contentPadding: EdgeInsets.only(
                                            bottom: 16.0,
                                            top: 57.0,
                                            right: 10,
                                            left: 26.0,
                                          ),
                                          border: InputBorder.none,
                                          hintText: '',
                                          hintStyle: TextStyle(
                                              fontSize: 14.0,
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
                                      //  onChanged: (text) => setState(() => name_ = text),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 240.0,
                                        margin: const EdgeInsets.only(
                                            top: 20.0, left: 10.0),
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
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 6.0, left: 16.0),
                                                child: const Text(
                                                  "AP",
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color(0xff64748B),
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0, left: 0.0),
                                              height: 20.0,
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 15.0, right: 20.0),
                                                  // padding: const EdgeInsets.all(2.0),
                                                  child: StatefulBuilder(
                                                    builder: (BuildContext
                                                            context,
                                                        StateSettersetState) {
                                                      return DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                          dropdownColor:
                                                              ColorSelect
                                                                  .class_color,
                                                          value: _account,
                                                          underline:
                                                              Container(),
                                                          hint: const Text(
                                                            "Select Accountable Persons",
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Color(
                                                                    0xffFFFFFF),
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          isExpanded: true,
                                                          icon: const Icon(
                                                            // Add this
                                                            Icons
                                                                .arrow_drop_down, // Add this
                                                            color: Color(
                                                                0xff64748B),

                                                            // Add this
                                                          ),
                                                          items: widget
                                                              .accountableId
                                                              .map((items) {
                                                            return DropdownMenuItem(
                                                              value: items['id']
                                                                  .toString(),
                                                              child: Text(
                                                                items['name'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Color(
                                                                        0xffFFFFFF),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              _account =
                                                                  newValue;
                                                              print(
                                                                  "account:$_account");
                                                            });
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  )),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    Container(
                                        width: 240,
                                        margin: const EdgeInsets.only(
                                            top: 20.0, right: 10.0),
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
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 6.0, left: 16.0),
                                                child: const Text(
                                                  "Customer",
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color(0xff64748B),
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5.0,
                                                    right: 18.0,
                                                    left: 15.0),
                                                height: 20.0,
                                                child: StatefulBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          StateSettersetState) {
                                                    return DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        dropdownColor:
                                                            ColorSelect
                                                                .class_color,
                                                        value: _custome,
                                                        underline: Container(),
                                                        hint: const Text(
                                                          "Select Customer",
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              color: Color(
                                                                  0xffFFFFFF),
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        isExpanded: true,
                                                        icon: const Icon(
                                                          // Add this
                                                          Icons
                                                              .arrow_drop_down, // Add this
                                                          color:
                                                              Color(0xff64748B),

                                                          // Add this
                                                        ),
                                                        items: widget
                                                            .customerName
                                                            .map((items) {
                                                          return DropdownMenuItem(
                                                            value: items['id']
                                                                .toString(),
                                                            child: Text(
                                                              items['name'],
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Color(
                                                                      0xffFFFFFF),
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            _custome = newValue;
                                                            print(
                                                                "account:$_custome");
                                                          });
                                                        },
                                                      ),
                                                    );
                                                  },
                                                )),
                                          ],
                                        )),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.99,
                                      margin: const EdgeInsets.only(
                                          top: 20.0, left: 10.0, right: 10.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                top: 30.0, left: 26.0),
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
                                      controller: _crmtask,
                                      cursorColor: const Color(0xffFFFFFF),
                                      style: const TextStyle(
                                          color: Color(0xffFFFFFF)),
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                              fontSize: 14, height: 0.20),
                                          contentPadding: const EdgeInsets.only(
                                            bottom: 16.0,
                                            top: 57.0,
                                            right: 16,
                                            left: 26.0,
                                          ),
                                          border: InputBorder.none,
                                          hintText: '',
                                          hintStyle: const TextStyle(
                                              fontSize: 14.0,
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
                                      //  onChanged: (text) => setState(() => name_ = text),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.99,
                                      margin: const EdgeInsets.only(
                                          top: 20.0, left: 10.0, right: 10.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                top: 30.0, left: 26.0),
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
                                      controller: _warkfolderId,
                                      cursorColor: const Color(0xffFFFFFF),
                                      style: const TextStyle(
                                          color: Color(0xffFFFFFF)),
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                              fontSize: 14, height: 0.20),
                                          contentPadding: const EdgeInsets.only(
                                            bottom: 16.0,
                                            top: 57.0,
                                            right: 10,
                                            left: 26.0,
                                          ),
                                          border: InputBorder.none,
                                          hintText: '',
                                          hintStyle: const TextStyle(
                                              fontSize: 14.0,
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
                                      // onChanged: (text) => setState(() => name_ = text),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.10,
                                            margin: const EdgeInsets.only(
                                                top: 20.0, left: 10.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 30.0, left: 26.0),
                                                  child: const Text(
                                                    "Budget",
                                                    style: TextStyle(
                                                        fontSize: 13.0,
                                                        color:
                                                            Color(0xff64748B),
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )),
                                            ],
                                          ),
                                          TextFormField(
                                            controller: _budget,
                                            cursorColor:
                                                const Color(0xffFFFFFF),
                                            style: const TextStyle(
                                                color: Color(0xffFFFFFF)),
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                errorStyle: TextStyle(
                                                    fontSize: 14, height: 0.20),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  bottom: 16.0,
                                                  top: 57.0,
                                                  right: 10,
                                                  left: 26.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: '',
                                                hintStyle: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Color(0xffFFFFFF),
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            autovalidateMode: _submitted
                                                ? AutovalidateMode
                                                    .onUserInteraction
                                                : AutovalidateMode.disabled,
                                            validator: (value) {
                                              //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                              if (value!.isEmpty) {
                                                return 'Please enter';
                                              }
                                              return null;
                                            },
                                            // onChanged: (text) => setState(() => name_ = text),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        margin:
                                            const EdgeInsets.only(top: 13.0),
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
                                          //border: Border.all(color:  const Color(0xff1E293B)),
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 13.0, right: 18.0),
                                            // padding: const EdgeInsets.all(2.0),
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
                                                      "€",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    isExpanded: true,
                                                    icon: const Icon(
                                                      // Add this
                                                      Icons
                                                          .arrow_drop_down, // Add this
                                                      color: Color(0xff64748B),

                                                      // Add this
                                                    ),
                                                    items: widget.currencyList
                                                        .map((items) {
                                                      return DropdownMenuItem(
                                                        value: items['id']
                                                            .toString(),
                                                        child: Text(
                                                          items['currency']
                                                              ['symbol'],
                                                          style: const TextStyle(
                                                              fontSize: 14.0,
                                                              color: Color(
                                                                  0xffFFFFFF),
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        _curren = newValue;
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 18.0,
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 235,
                                            margin: const EdgeInsets.only(
                                                top: 20.0, right: 10.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 30.0, left: 26.0),
                                                  child: const Text(
                                                    "Estimated hours",
                                                    style: TextStyle(
                                                        fontSize: 13.0,
                                                        color:
                                                            Color(0xff64748B),
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )),
                                            ],
                                          ),
                                          TextFormField(
                                            controller: _estimatehours,
                                            cursorColor:
                                                const Color(0xffFFFFFF),
                                            style: const TextStyle(
                                                color: Color(0xffFFFFFF)),
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                errorStyle: TextStyle(
                                                    fontSize: 14, height: 0.20),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  bottom: 16.0,
                                                  top: 57.0,
                                                  right: 10,
                                                  left: 26.0,
                                                ),
                                                border: InputBorder.none,
                                                hintText: '',
                                                hintStyle: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Color(0xffFFFFFF),
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            autovalidateMode: _submitted
                                                ? AutovalidateMode
                                                    .onUserInteraction
                                                : AutovalidateMode.disabled,
                                            validator: (value) {
                                              //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                              if (value!.isEmpty) {
                                                return 'Please enter';
                                              }
                                              return null;
                                            },
                                            // onChanged: (text) => setState(() => name_ = text),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 240,
                                      margin: const EdgeInsets.only(
                                          top: 20.0, left: 10.0),
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        //border: Border.all(color:  const Color(0xff1E293B)),
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 16.0, right: 20.0),
                                          // padding: const EdgeInsets.all(2.0),
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
                                                        fontSize: 14.0,
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  isExpanded: true,
                                                  icon: const Icon(
                                                    // Add this
                                                    Icons
                                                        .arrow_drop_down, // Add this
                                                    color: Color(0xff64748B),

                                                    // Add this
                                                  ),
                                                  items: widget.statusList
                                                      .map((items) {
                                                    return DropdownMenuItem(
                                                      value: items['id']
                                                          .toString(),
                                                      child: Text(
                                                        items['title'],
                                                        style: const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    print(
                                                        "On Changed value ------------------------ ${newValue}");
                                                    setState(() {
                                                      _status = newValue;
                                                    });
                                                  },
                                                ),
                                              );
                                            },
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    Container(
                                        width: 240.0,
                                        margin: const EdgeInsets.only(
                                            top: 20.0, right: 10.0),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _selectDate(setState);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 13.0),
                                                height: 22.0,
                                                width: 20.0,
                                                child: Image.asset(
                                                    'images/date.png'),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 20.0),
                                                    child: const Text(
                                                      "Delivery Date",
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color:
                                                              Color(0xff64748B),
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                GestureDetector(
                                                  onTap: () async {
                                                    _selectDate(setState);
                                                  },
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 3.0,
                                                              left: 20.0),
                                                      child: Text(
                                                        '${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}',
                                                        style: const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0, right: 10.0),
                                              height: 20.0,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: SvgPicture.asset(
                                                      'images/cross.svg')),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                //description---------------------------------------------//
                                // Stack(
                                //   children: [
                                //     Container(
                                //       width: MediaQuery.of(context).size.width *
                                //           0.99,
                                //       margin: const EdgeInsets.only(
                                //           top: 15.0, left: 10.0, right: 10.0),
                                //       height: 120.0,
                                //       decoration: BoxDecoration(
                                //         color: const Color(0xff334155),
                                //         //border: Border.all(color:  const Color(0xff1E293B)),
                                //         borderRadius: BorderRadius.circular(
                                //           8.0,
                                //         ),
                                //         boxShadow: const [
                                //           BoxShadow(
                                //             color: Color(0xff475569),
                                //             offset: Offset(
                                //               0.0,
                                //               2.0,
                                //             ),
                                //             blurRadius: 0.0,
                                //             spreadRadius: 0.0,
                                //           ), //BoxShadow
                                //         ],
                                //       ),
                                //     ),
                                //     Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         Container(
                                //             margin: const EdgeInsets.only(
                                //                 top: 24.0, left: 26.0),
                                //             child: const Text(
                                //               "Description",
                                //               style: TextStyle(
                                //                   fontSize: 13.0,
                                //                   color: Color(0xff64748B),
                                //                   fontFamily: 'Inter',
                                //                   fontWeight: FontWeight.w500),
                                //             )),
                                //       ],
                                //     ),
                                //     TextFormField(
                                //       controller: _description,
                                //       maxLines: 5,
                                //       cursorColor: const Color(0xffFFFFFF),
                                //       style: const TextStyle(
                                //           color: Color(0xffFFFFFF)),
                                //       textAlignVertical:
                                //           TextAlignVertical.bottom,
                                //       keyboardType: TextInputType.text,
                                //       decoration: const InputDecoration(
                                //           errorStyle: TextStyle(
                                //               fontSize: 14.0,
                                //               // ScreenUtil().setSp(ScreenUtil().setSp(14.0)),
                                //               height: 0.20),
                                //           contentPadding: EdgeInsets.only(
                                //             bottom: 16.0,
                                //             top: 54.0,
                                //             right: 10,
                                //             left: 26.0,
                                //           ),
                                //           border: InputBorder.none,
                                //           //   hintText: 'Project title',
                                //           hintStyle: TextStyle(
                                //               fontSize: 14.0,
                                //               // ScreenUtil().setSp(ScreenUtil().setSp(14.0)),
                                //               color: Color(0xffFFFFFF),
                                //               fontFamily: 'Inter',
                                //               fontWeight: FontWeight.w500)),
                                //       autovalidateMode: _submitted
                                //           ? AutovalidateMode.onUserInteraction
                                //           : AutovalidateMode.disabled,
                                //       validator: (value) {
                                //         //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                //         if (value!.isEmpty) {
                                //           return 'Please enter';
                                //         }
                                //         return null;
                                //       },
                                //       onChanged: (text) => setState(() {}),
                                //     ),
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
                                        width:
                                            97, //MediaQuery.of(context).size.width * 0.22,
                                        margin: const EdgeInsets.only(
                                            top: 15.0, bottom: 0.0),
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
                                                fontSize: 14.0,
                                                color: ColorSelect.white_color,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          SmartDialog.showLoading(
                                            msg:
                                                "Your request is in progress please wait for a while...",
                                          );

                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            editProject(context);
                                          });
                                        }
                                      },
                                      child: Container(
                                        width:
                                            97.0, //MediaQuery.of(context).size.width * 0.22,
                                        margin: const EdgeInsets.only(
                                          top: 15.0,
                                          bottom: 0.0,
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
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                                fontSize: 14.0,
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
                    );
                  });
            },
            child: Container(
              height: 20,
              width: 50,
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
                                  "Do you want to delete this project?",
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
                                  "Once deleted,you will not find this project in the list ",
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
                                            deleteProject(
                                                widget.id, widget.buildContext);
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

  deleteProject(String? peopleId, BuildContext buildContext) async {
    var response;
    var url = '${AppUrl.deleteForProject}${peopleId}';
    var token = 'Bearer ' + storage.read("token");

    // var userId = storage.read("user_id");
    response = await http.delete(
      Uri.parse(url),
      headers: {"Accept": "application/json", "Authorization": token},
    );

    if (response.statusCode == 200) {
      print("sucess");

      SmartDialog.dismiss();

      try {
        Navigator.of(buildContext).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      onSubmit: (String value) {},
                      adOnSubmit: (String value) {},
                    )),
            (Route<dynamic> route) => false);
      } catch (e) {
        print(buildContext.widget);
        print("Error in navigating ------------------------------");
        print(e);
      }
    } else {
      var user = userFromJson(response.body);
      Fluttertoast.showToast(
        msg: user.message != null ? user.message! : 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
      SmartDialog.dismiss();
    }
  }

  //Edit project api
  editProject(BuildContext context) async {
    print("-----------------------------");
    print(widget.id);
    var response;
    var token = 'Bearer ' + storage.read("token");
    try {
      var map = new Map<String, dynamic>();

      map['title'] = _projecttitle.text.toString();
      map['accountable_person_id'] = _account;
      map['customer_id'] = _custome;
      map['crm_task_id'] = _crmtask.text.toString();
      map['work_folder_id'] = _warkfolderId.text.toString();
      map['budget'] = _budget.text.toString();
      map['currency'] = _curren;
      map['estimation_hours'] = _estimatehours.text.toString();
      map['status'] = _status;
      map['description'] = _description.text.toString();
      map['delivery_date'] = selectedDate.toString();

      // delivery_date

      try {
        var response = await http.post(
          Uri.parse('${AppUrl.baseUrl}/project/${widget.id}/update'),
          body: map,
          headers: {
            "Accept": "application/json",
            "Authorization": token,
          },
        );
        // ignore: unrelated_type_equality_checks

        if (response.statusCode == 200) {
          var responseJson =
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
        } else {
          SmartDialog.dismiss();
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: 'Something Went Wrong',
            backgroundColor: Colors.grey,
          );
        }
      } catch (e) {
        SmartDialog.dismiss();
        Navigator.pop(context);
        print('error caught: $e');
        Fluttertoast.showToast(
          msg: 'Something Went Wrong',
          backgroundColor: Colors.grey,
        );
      }
    } catch (e) {
      SmartDialog.dismiss();
      Navigator.pop(context);
      print('error caught: $e');

      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.grey,
      );
    }

    // var response;
    // setState(() {
    //   loadingEditeddata = true;
    // });
    // var token = 'Bearer ' + storage.read("token");
    // try {
    //   response = await http.put(
    //     Uri.parse('${AppUrl.baseUrl}/project/${widget.id}'),
    //     body: jsonEncode({
    //       "title": _projecttitle.text.toString(),
    //       // "accountable_person_id": _account,
    //       "accountable_person_id": "1",
    //       "customer_id": _custome,
    //       "crm_task_id": _crmtask.text.toString(),
    //       "work_folder_id": _warkfolderId.text.toString(),
    //       "budget": _budget.text.toString(),
    //       "currency": _curren,
    //       "estimation_hours": _estimatehours.text.toString(),
    //       "status": _status,
    //     }),
    //     headers: {
    //       "Content-Type": "application/json",
    //       "Authorization": token,
    //     },
    //   );
    //   // ignore: unrelated_type_equality_checks
    //   if (response.statusCode == 200) {
    //     var responseJson =
    //         jsonDecode(response.body.toString()) as Map<String, dynamic>;
    //     final stringRes = JsonEncoder.withIndent('').convert(responseJson);
    //     // ignore: use_build_context_synchronously
    //     setState(() {
    //       loadingEditeddata = false;
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => MyHomePage(
    //                     onSubmit: (String value) {},
    //                     adOnSubmit: (String value) {},
    //                   )));
    //     });
    //   } else {
    //     setState(() {
    //       loadingEditeddata = false;
    //     });
    //     print("failuree");
    //     Fluttertoast.showToast(
    //       msg: 'Something Went Wrong',
    //       backgroundColor: Colors.grey,
    //     );
    //   }
    // } catch (e) {
    //   setState(() {
    //     loadingEditeddata = false;
    //   });
    //   print('error caught: $e');

    //   var user = userFromJson(response.body.toString());
    //   Fluttertoast.showToast(
    //     msg: user.message ?? 'Something Went Wrong',
    //     backgroundColor: Colors.grey,
    //   );
    //   return loadingEditeddata;
    // }
  }
}
