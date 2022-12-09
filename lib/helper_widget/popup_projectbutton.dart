import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:zeus/home_module/home_page.dart';
import 'package:zeus/services/response_model/project_detail_response.dart';
import 'package:zeus/utility/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';
import 'search_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  DateTime? deliveryDate;

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
      required this.deliveryDate,
      Key? key})
      : super(key: key);

  @override
  State<ProjectEdit> createState() => _ProjectEditState();
}

class _ProjectEditState extends State<ProjectEdit>
    with SingleTickerProviderStateMixin {
  DateTime? deliveryDate;
  String? _account, _custome, _curren, _status;

  // var _id = widget.id;
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  // var status = widget.response.data!.status; //response.data!.status;
  bool _submitted = true;
  bool selectDeliveryDate = false;
  bool createButtonClick = false;

  final TextEditingController _projecttitle = TextEditingController();
  final TextEditingController _crmtask = TextEditingController();
  final TextEditingController _warkfolderId = TextEditingController();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _estimatehours = TextEditingController();
  final TextEditingController _description = TextEditingController();
  var myFormat = DateFormat('d MMM yyyy');

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
        ? widget.response.data!.estimationHours!.toString()
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

    if (widget.statusList.isNotEmpty) {
      widget.statusList.asMap().forEach((index, element) {
        if (element['title'] == widget.response.data!.status) {
          _status = element['id'].toString();
        }
      });
    }

    if (widget.accountableId.isNotEmpty) {
      widget.accountableId.asMap().forEach((index, element) {
        if (element['id'].toString() ==
            widget.response.data!.accountablePersonId.toString()) {
          _account = element['id'].toString();
        }
      });
    }

    if (widget.currencyList.isNotEmpty) {
      widget.currencyList.asMap().forEach((index, element) {
        if (element['id'].toString() == widget.response.data!.currency) {
          _curren = element['id'].toString();
        }
      });
    }
    if (widget.response.data != null &&
        widget.response.data!.deliveryDate!.isNotEmpty &&
        widget.response.data!.deliveryDate! != "0000-00-00 00:00:00") {
      deliveryDate =
          DateTime.parse(widget.response.data!.deliveryDate!.toString());

      //selectedDateReminder = DateTime.parse("2022-11-25 00:00:00");
    } else {
      deliveryDate = DateTime.now();
    }
  }

  Future<void> _selectDate(setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: const Color(0xff0F172A),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary), colorScheme: ColorScheme.light(primary: const Color(0xff0F172A)).copyWith(secondary: const Color(0xff0F172A))),
            child: child!,
          );
        },
        initialDate: deliveryDate!,
        firstDate: deliveryDate!,
        lastDate: DateTime(5000));

    if (picked != null && picked != deliveryDate) {
      setState(() {
        deliveryDate = picked;
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
    return Center(
      child: PopupMenuButton<int>(
        offset: widget.offset,
        color: const Color(0xFF0F172A),
        position: PopupMenuPosition.under,

        child: Container(
          margin:
              const EdgeInsets.only(right: 0.0, top: 0.0, bottom: 20, left: 80),
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
            padding: EdgeInsets.zero,
            value: 1,
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: const Color(0xff1E293B),
                          content: Form(
                            key: _formKey,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.27,
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
                                          width: 40,
                                          height: 40,
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.99,
                                        margin: const EdgeInsets.only(
                                            top: 25.0, left: 10.0, right: 10.0),
                                        height: 60.0,
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
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: TextFormField(
                                          maxLength: 20,
                                          controller: _projecttitle,
                                          autocorrect: false,
                                          cursorColor: const Color(0xffFFFFFF),
                                          style: const TextStyle(
                                              color: Color(0xffFFFFFF)),
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                              counterText: '',
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
                                          //  onChanged: (text) => setState(() => name_ = text),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          margin: const EdgeInsets.only(
                                              top: 15.0, left: 10.0),
                                          height: 60.0,
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
                                                        color:
                                                            Color(0xff64748B),
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )),
                                              StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSettersetState) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            right: 4,
                                                            top: 2),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        isDense: true,
                                                        dropdownColor:
                                                            ColorSelect
                                                                .class_color,
                                                        value: _account,
                                                        underline: Container(),
                                                        hint: const Text(
                                                          "Select Accountable Person",
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
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            _account = newValue;
                                                            print(
                                                                "account:$_account");
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            margin: const EdgeInsets.only(
                                                top: 15.0, right: 10.0),
                                            height: 60.0,
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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 6.0,
                                                            left: 16.0),
                                                    child: const Text(
                                                      "Customer",
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          color:
                                                              Color(0xff64748B),
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                StatefulBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          StateSettersetState) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 4,
                                                              top: 2),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                          isDense: true,
                                                          dropdownColor:
                                                              ColorSelect
                                                                  .class_color,
                                                          value: _custome,
                                                          underline:
                                                              Container(),
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
                                                            color: Color(
                                                                0xff64748B),

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
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              _custome =
                                                                  newValue;
                                                              print(
                                                                  "account:$_custome");
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.99,
                                        margin: const EdgeInsets.only(
                                            top: 20.0, left: 10.0, right: 10.0),
                                        height: 60.0,
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
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: TextFormField(
                                          maxLength: 20,
                                          controller: _crmtask,
                                          cursorColor: const Color(0xffFFFFFF),
                                          style: const TextStyle(
                                              color: Color(0xffFFFFFF)),
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                              counterText: "",
                                              errorStyle: TextStyle(
                                                  fontSize: 14, height: 0.20),
                                              contentPadding: EdgeInsets.only(
                                                bottom: 16.0,
                                                top: 57.0,
                                                right: 16,
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
                                          //  onChanged: (text) => setState(() => name_ = text),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.99,
                                        margin: const EdgeInsets.only(
                                            top: 20.0, left: 10.0, right: 10.0),
                                        height: 60.0,
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
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: TextFormField(
                                          maxLength: 20,
                                          controller: _warkfolderId,
                                          cursorColor: const Color(0xffFFFFFF),
                                          style: const TextStyle(
                                              color: Color(0xffFFFFFF)),
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                              counterText: "",
                                              errorStyle: TextStyle(
                                                  fontSize: 14, height: 0.20),
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
                                              height: 60.0,
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 30.0,
                                                            left: 26.0),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: TextFormField(
                                                maxLength: 10,
                                                controller: _budget,
                                                cursorColor:
                                                    const Color(0xffFFFFFF),
                                                style: const TextStyle(
                                                    color: Color(0xffFFFFFF)),
                                                textAlignVertical:
                                                    TextAlignVertical.bottom,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    const InputDecoration(
                                                        counterText: "",
                                                        errorStyle: TextStyle(
                                                            fontSize: 14,
                                                            height: 0.20),
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                          bottom: 16.0,
                                                          top: 57.0,
                                                          right: 10,
                                                          left: 26.0,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                        hintText: '',
                                                        hintStyle: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
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
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16.0,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08,
                                          margin:
                                              const EdgeInsets.only(top: 13.0),
                                          height: 60.0,
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
                                                      dropdownColor: ColorSelect
                                                          .class_color,
                                                      value: _curren,
                                                      underline: Container(),
                                                      hint: const Text(
                                                        "€",
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontFamily: 'Inter',
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
                                              height: 60.0,
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 30.0,
                                                            left: 26.0),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: TextFormField(
                                                maxLength: 10,
                                                controller: _estimatehours,
                                                cursorColor:
                                                    const Color(0xffFFFFFF),
                                                style: const TextStyle(
                                                    color: Color(0xffFFFFFF)),
                                                textAlignVertical:
                                                    TextAlignVertical.bottom,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    const InputDecoration(
                                                        counterText: "",
                                                        errorStyle: TextStyle(
                                                            fontSize: 14,
                                                            height: 0.20),
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                          bottom: 16.0,
                                                          top: 57.0,
                                                          right: 10,
                                                          left: 26.0,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                        hintText: '',
                                                        hintStyle: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.13,
                                        margin: const EdgeInsets.only(
                                            top: 15.0, left: 10.0),
                                        height: 60.0,
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
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.12,
                                                margin: const EdgeInsets.only(
                                                    top: 15.0, right: 10.0),
                                                height: 60.0,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff334155),
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
                                                        margin: const EdgeInsets
                                                            .only(left: 13.0),
                                                        // height: 22.0,
                                                        // width: 20.0,
                                                        child: Image.asset(
                                                            'images/date.png'),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0,
                                                                    left: 20.0),
                                                            child: const Text(
                                                              "Delivery Date",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.0,
                                                                  color: Color(
                                                                      0xff64748B),
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              if (deliveryDate ==
                                                                  null) {
                                                                deliveryDate =
                                                                    DateTime
                                                                        .now();
                                                                _selectDate(
                                                                    setState);
                                                              } else {
                                                                _selectDate(
                                                                    setState);
                                                              }

                                                              selectDeliveryDate =
                                                                  true;
                                                            });
                                                          },
                                                          child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 3.0,
                                                                      left:
                                                                          20.0),
                                                              child: deliveryDate ==
                                                                      null
                                                                  ? const Text(
                                                                      'Select Date',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color: Color(
                                                                              0xffFFFFFF),
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w500))
                                                                  : Text(
                                                                      '${deliveryDate!.day} / ${deliveryDate!.month} / ${deliveryDate!.year}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color: Color(
                                                                              0xffFFFFFF),
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    )),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(
                                                          () {
                                                            createButtonClick =
                                                                true;
                                                            deliveryDate = null;
                                                            selectDeliveryDate =
                                                                false;
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 5.0,
                                                            right: 10.0),
                                                        height: 20.0,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: SvgPicture.asset(
                                                                'images/cross.svg')),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            createButtonClick
                                                ? selectDeliveryDate
                                                    ? const Text(
                                                        " ",
                                                      )
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                  color:
                                                      ColorSelect.white_color,
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (selectDeliveryDate == true) {
                                              SmartDialog.showLoading(
                                                msg:
                                                    "Your request is in progress please wait for a while...",
                                              );

                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                editProject(context);
                                              });
                                            }
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
                                              "Save",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color:
                                                      ColorSelect.black_color,
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
                height: 50,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: Text(
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
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          backgroundColor:
                              ColorSelect.peoplelistbackgroundcolor,
                          content: Container(
                            height: 110.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 20.0),
                                  child: const Text(
                                    "Do you want to delete this project_detail?",
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
                                    "Once deleted,you will not find this project_detail in the list ",
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
                                                  color:
                                                      ColorSelect.delete_text),
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
                                              deleteProject(widget.id,
                                                  widget.buildContext);
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
              child: Container(
                width: double.infinity,
                height: 50,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        color: ColorSelect.white_color),
                  ),
                ),
              ),
            ),
          )
        ],
        // child: Text(widget.title),
      ),
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
    } else if (response.statusCode == 401) {
      SmartDialog.dismiss();
      AppUtil.showErrorDialog(context);
    } else if (response.statusCode == 401) {
      SmartDialog.dismiss();
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

  //Edit project_detail api
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
      map['delivery_date'] = deliveryDate.toString();

      // delivery_date

      try {
        var response = await http.post(
          Uri.parse('${AppUrl.baseUrl}/project_detail/${widget.id}/update'),
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
        } else if (response.statusCode == 401) {
          SmartDialog.dismiss();
          AppUtil.showErrorDialog(context);
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
  }

  errorWidget() {
    return Text('Please Select this field',
        style:
            TextStyle(color: Color.fromARGB(255, 221, 49, 60), fontSize: 14));
  }
}
