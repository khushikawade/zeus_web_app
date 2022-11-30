import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'package:zeus/DemoContainer.dart';
import 'package:zeus/add_new_phase/new_phase.dart';
import 'package:zeus/helper_widget/popup_projectbutton.dart';
import 'package:zeus/navigation/skills_model/skills_response_project.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/colors.dart';
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';
import '../navigation/navigation.dart';
import '../navigator_tabs/idle/project_detail_model/project_detail_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';

showDailog(
    BuildContext context,
    ProjectDetailResponse response,
    List statusList,
    List currencyName,
    List accountableId,
    List customerName,
    String? id,
    List<SkillsData> skills) {
  //print('listdata'+statusList.length.toString());
  //print('datacomefast'+response.data!.phase!.length.toString());
  DateTime? selectedDate;
  DateTime? selectedDateReminder;
  DateTime? selectedDateDevlivery;
  DateTime? selectedDateDeadline;
  String? _account, _custome, _curren, _status;
  List<String> abc = [];
  final ValueChanged<String> onSubmit;
  var _id = id;
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  bool? _isSelected;
  var status = response.data!.status;
  bool _submitted = false;
  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState<SkillsData>> key = new GlobalKey();
  List<SkillsData> users = <SkillsData>[];
  String? setDate;
  users = skills;
  bool loading = true;
  final TextEditingController _projecttitle = TextEditingController();
  final TextEditingController _crmtask = TextEditingController();
  final TextEditingController _warkfolderId = TextEditingController();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _estimatehours = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  var myFormat = DateFormat('yyyy-MM-dd');

  //Edit project api
  Future<void> editProject() async {
    var token = 'Bearer ' + storage.read("token");
    try {
      var response = await http.put(
        Uri.parse('${AppUrl.baseUrl}/project/$_id'),
        body: jsonEncode({
          "title": _projecttitle.text.toString(),
          "accountable_person_id": _account,
          //"accountable_person_id": "1",
          "customer_id": _custome,
          "crm_task_id": _crmtask.text.toString(),
          "work_folder_id": _warkfolderId.text.toString(),
          "budget": _budget.text.toString(),
          "currency": _curren,
          "estimation_hours": _estimatehours.text.toString(),
          "status": _status,
          "delivery_date": selectedDateDevlivery != null
              ? myFormat.format(selectedDateDevlivery!)
              : "",
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
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      onSubmit: (String value) {},
                      adOnSubmit: (String value) {},
                    )),
            (Route<dynamic> route) => false);
      } else {
        print("failuree");
      }
    } catch (e) {
      // print('error caught: $e');
    }
  }

  //Edit project api

  Future<void> removeTagAPI(String tagId) async {
    var token = 'Bearer ' + storage.read("token");

    try {
      var response = await http.delete(
        Uri.parse('${AppUrl.baseUrl}/project/tags/${tagId}'),
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

        // ignore: use_build_context_synchronously

      } else {
        print("failuree");

        print(response.body);
      }
    } catch (e) {
      // print('error caught: $e');

    }
  }

  //Edit project api

  Future<void> saveTagApi(String projectId, String tagName) async {
    var token = 'Bearer ' + storage.read("token");

    try {
      // var map = new Map<String, dynamic>();

      // map['project_id'] = projectId;

      // map['name'] = tagName;

      var response = await http.post(
        Uri.parse('${AppUrl.baseUrl}/project/tags'),
        body: jsonEncode({
          "project_id": projectId,
          "name": tagName,
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

        // ignore: use_build_context_synchronously

      } else {
        print("failuree");

        print(response.body);
      }
    } catch (e) {
      // print('error caught: $e');

    }
  }

  //Add

  //Add description and time api
  Future<void> addDescriptionProject() async {
    var token = 'Bearer ' + storage.read("token");
    try {
      var apiResponse = await http.post(
        Uri.parse('${AppUrl.baseUrl}/project/project-dates/$_id'),
        //body: map,
        body: jsonEncode({
          "description": _description.text.toString(),
          "working_days":
              response.data != null && response.data!.workingDays != null
                  ? response.data!.workingDays.toString()
                  : '',
          "start_date":
              selectedDate != null ? myFormat.format(selectedDate!) : "",
          "deadline_date": selectedDateDeadline != null
              ? myFormat.format(selectedDateDeadline!)
              : "",
          "reminder_date": selectedDateReminder != null
              ? myFormat.format(selectedDateReminder!)
              : "",
          "delivery_date": selectedDateDevlivery != null
              ? myFormat.format(selectedDateDevlivery!)
              : "",
        }),
        headers: {
          "Content-type": "application/json",
          "Authorization": token,
        },
      );

      // ignore: unrelated_type_equality_checks
      if (apiResponse.statusCode == 200) {
        var responseJson =
            jsonDecode(apiResponse.body.toString()) as Map<String, dynamic>;
        final stringRes = JsonEncoder.withIndent('').convert(responseJson);
        print(stringRes);
        print("yes description");
        print(apiResponse.body);
      } else {
        print(apiResponse.body);
        var responseJson =
            jsonDecode(apiResponse.body.toString()) as Map<String, dynamic>;
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          msg: responseJson['message'],
          backgroundColor: Colors.grey,
        );

        print("failuree");
      }
    } catch (e) {
      // print('error caught: $e');
    }
  }

  // update Controller Value
  updateControllerValue() {
    _projecttitle.text = response.data != null &&
            response.data!.title != null &&
            response.data!.title!.isNotEmpty
        ? response.data!.title!
        : '';

    _crmtask.text = response.data != null &&
            response.data!.crmTaskId != null &&
            response.data!.crmTaskId!.isNotEmpty
        ? response.data!.crmTaskId!
        : '';

    _warkfolderId.text = response.data != null &&
            response.data!.workFolderId != null &&
            response.data!.workFolderId!.isNotEmpty
        ? response.data!.workFolderId!
        : '';

    _budget.text = response.data != null && response.data!.budget != null
        ? response.data!.budget!.toString()
        : '';

    _estimatehours.text = response.data != null &&
            response.data!.estimationHours != null &&
            response.data!.estimationHours!.isNotEmpty
        ? response.data!.estimationHours!.toString()
        : '';

    _custome = response.data != null && response.data!.customerId != null
        ? response.data!.customerId.toString()
        : '';

    _account =
        response.data != null && response.data!.accountablePersonId != null
            ? response.data!.accountablePersonId.toString()
            : '';

    if (response.data != null &&
        response.data!.reminderDate != null &&
        response.data!.reminderDate!.isNotEmpty &&
        response.data!.reminderDate != "0000-00-00 00:00:00") {
      selectedDateReminder =
          DateTime.parse(response.data!.reminderDate!.toString());

      //selectedDateReminder = DateTime.parse("2022-11-25 00:00:00");
    }

    if (response.data != null &&
        response.data!.deadlineDate != null &&
        response.data!.deadlineDate!.isNotEmpty &&
        response.data!.deadlineDate != "0000-00-00 00:00:00") {
      selectedDateDeadline =
          DateTime.parse(response.data!.deadlineDate!.toString());

      //selectedDateDeadline = DateTime.parse("2022-11-27 00:00:00");

    }

    if (response.data != null &&
        response.data!.deliveryDate != null &&
        response.data!.deliveryDate!.isNotEmpty &&
        response.data!.deliveryDate != "0000-00-00 00:00:00") {
      selectedDateDevlivery =
          DateTime.parse(response.data!.deliveryDate!.toString());

      //selectedDateDevlivery = DateTime.parse("2022-11-29 00:00:00");
    }

    if (response.data != null &&
        response.data!.startDate != null &&
        response.data!.startDate!.isNotEmpty &&
        response.data!.startDate != "0000-00-00 00:00:00") {
      // selectedDate = DateTime.parse("2022-11-29 00:00:00");
      selectedDate = DateTime.parse(response.data!.startDate!.toString());
    }

    _description.text =
        response.data != null && response.data!.description != null
            ? response.data!.description.toString()
            : '';

    if (response.data != null &&
        response.data!.tags != null &&
        response.data!.tags!.isNotEmpty) {
      response.data!.tags!.forEach((element) {
        abc.add(element.name!);
      });
    }
    // _status = response.data != null &&
    //         response.data!.status != null &&
    //         response.data!.status!.isNotEmpty
    //     ? response.data!.status.toString()
    //     : '';
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
        // initialDate: selectedDate,
        // initialDate:
        //      setDate == "5"
        //         ? selectedDateDeadline!
        //         : setDate == "4"
        //             ? selectedDateDevlivery!
        //             : setDate == "3"
        //                 ? selectedDateReminder!
        //                 : setDate == "2"
        //                     ? selectedDate!
        //                     : selectedDate!,

        initialDate: setDate == "5"
            ? selectedDateDeadline!
            : setDate == "4"
                ? selectedDateDevlivery!
                : setDate == "3"
                    ? selectedDateReminder!
                    : setDate == "2"
                        ? selectedDate!
                        : selectedDate!,

        // initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      setState(() {
        if (setDate == "2") {
          selectedDate = picked;
        } else if (setDate == "3") {
          selectedDateReminder = picked;
        } else if (setDate == "4") {
          selectedDateDevlivery = picked;
        } else if (setDate == "5") {
          selectedDateDeadline = picked;
        } else {
          selectedDate = picked;
        }
      });
      addDescriptionProject();
    }
  }

  //   print(projectDetail.projectDetailResponse!.data!.title);
  showDialog(
      context: context,
      builder: (context) {
        updateControllerValue();
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: EdgeInsets.zero,
            backgroundColor: const Color(0xff1E293B),
            content: Form(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.99,
                height: MediaQuery.of(context).size.height * 0.99,
                child: SingleChildScrollView(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.99,
                  height: MediaQuery.of(context).size.height * 0.99,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.99,
                        padding: EdgeInsets.only(),

                        //color: Colors.green,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 30.0, top: 30.0),
                                            child: Text(
                                              response.data?.title ?? '',
                                              style: const TextStyle(
                                                  color: Color(0xffFFFFFF),
                                                  fontSize: 22.0,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              if (status == "Open") ...[
                                                Container(
                                                  height: 32.0,
                                                  width: 82.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0,
                                                      right: 12.0,
                                                      top: 12.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff16A34A),
                                                    //border: Border.all(color: const Color(0xff0E7490)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0,
                                                          top: 6.0,
                                                          bottom: 6.0),
                                                      child: Text(
                                                        "Open",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 14.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ] else if (status ==
                                                  'On track') ...[
                                                Container(
                                                  height: 32.0,
                                                  width: 82.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0,
                                                      right: 12.0,
                                                      top: 12.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff16A34A),
                                                    //border: Border.all(color: const Color(0xff0E7490)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0,
                                                          top: 6.0,
                                                          bottom: 6.0),
                                                      child: Text(
                                                        "On track",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 14.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ] else if (status == 'Live') ...[
                                                Container(
                                                  height: 32.0,
                                                  width: 52.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0,
                                                      right: 12.0,
                                                      top: 12.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff16A34A),
                                                    //border: Border.all(color: const Color(0xff0E7490)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0,
                                                          top: 6.0,
                                                          bottom: 6.0),
                                                      child: Text(
                                                        "Live",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 14.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ] else if (status ==
                                                  "Design sent for approval") ...[
                                                Container(
                                                  height: 32.0,
                                                  width: 190.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0,
                                                      right: 12.0,
                                                      top: 12.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff115E59),
                                                    //border: Border.all(color: const Color(0xff0E7490)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0,
                                                          top: 6.0,
                                                          bottom: 6.0),
                                                      child: Text(
                                                        "Design sent for approval",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 14.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ] else if (status ==
                                                  "New features request") ...[
                                                Container(
                                                  height: 32.0,
                                                  width: 171.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0,
                                                      right: 12.0,
                                                      top: 12.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffA21CAF),
                                                    //border: Border.all(color: const Color(0xff0E7490)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0,
                                                          top: 6.0,
                                                          bottom: 6.0),
                                                      child: Text(
                                                        "New features request",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 14.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ] else if (status ==
                                                  "Update requested") ...[
                                                Container(
                                                  height: 32.0,
                                                  width: 147.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0,
                                                      right: 12.0,
                                                      top: 12.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff0E7490),
                                                    //border: Border.all(color: const Color(0xff0E7490)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0,
                                                          top: 6.0,
                                                          bottom: 6.0),
                                                      child: Text(
                                                        "Update requested",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 14.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ] else if (status ==
                                                  "Sent for approval") ...[
                                                Container(
                                                  height: 32.0,
                                                  width: 147.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0,
                                                      right: 12.0,
                                                      top: 12.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff166534),
                                                    //border: Border.all(color: const Color(0xff0E7490)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0,
                                                          top: 6.0,
                                                          bottom: 6.0),
                                                      child: Text(
                                                        "Sent for approval",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 14.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ] else if (status == 'Risk') ...[
                                                Container(
                                                  height: 32.0,
                                                  width: 53.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0,
                                                      right: 12.0,
                                                      top: 12.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffB91C1C),
                                                    //border: Border.all(color: const Color(0xff0E7490)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0,
                                                          top: 6.0,
                                                          bottom: 6.0),
                                                      child: Text(
                                                        "Risk",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 14.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ] else if (status ==
                                                  "Potential risk") ...[
                                                Container(
                                                  height: 32.0,
                                                  width: 113.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0,
                                                      right: 12.0,
                                                      top: 12.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff9A3412),
                                                    //border: Border.all(color: const Color(0xff0E7490)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0,
                                                          top: 6.0,
                                                          bottom: 6.0),
                                                      child: Text(
                                                        "Potential risk",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 14.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ] else ...[
                                                Container(
                                                  height: 32.0,
                                                  width: 53.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0,
                                                      right: 12.0,
                                                      top: 12.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffB91C1C),
                                                    //border: Border.all(color: const Color(0xff0E7490)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12.0,
                                                          right: 12.0,
                                                          top: 6.0,
                                                          bottom: 6.0),
                                                      child: Text(
                                                        "Risk",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 14.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 16.0, top: 12.0),
                                                width: 110,
                                                height: 32,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      top: 0,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: Image.network(
                                                          'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80',
                                                          width: 32,
                                                          height: 32,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 22,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: Image.network(
                                                          'https://media.istockphoto.com/photos/side-view-of-one-young-woman-picture-id1134378235?k=20&m=1134378235&s=612x612&w=0&h=0yIqc847atslcQvC3sdYE6bRByfjNTfOkyJc5e34kgU=',
                                                          width: 32,
                                                          height: 32,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 46.0,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: Container(
                                                          width: 32,
                                                          height: 32,
                                                          color:
                                                              Color(0xff334155),
                                                          child: Image.network(
                                                            'https://media.istockphoto.com/photos/side-view-of-one-young-woman-picture-id1134378235?k=20&m=1134378235&s=612x612&w=0&h=0yIqc847atslcQvC3sdYE6bRByfjNTfOkyJc5e34kgU=',
                                                            width: 32,
                                                            height: 32,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: 70.0,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: Container(
                                                          width: 32,
                                                          height: 32,
                                                          color:
                                                              Color(0xff334155),
                                                          child: Image.network(
                                                            'https://media.istockphoto.com/photos/side-view-of-one-young-woman-picture-id1134378235?k=20&m=1134378235&s=612x612&w=0&h=0yIqc847atslcQvC3sdYE6bRByfjNTfOkyJc5e34kgU=',
                                                            width: 32,
                                                            height: 32,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Stack(
                                              //   clipBehavior: Clip.none,
                                              //   children: [
                                              //     Container(
                                              //       margin:
                                              //           const EdgeInsets.only(
                                              //               left: 12.0,
                                              //               top: 8.0),
                                              //       child: SvgPicture.asset(
                                              //         'images/list_ceramony.svg',
                                              //         width: 19.06,
                                              //         height: 17.01,
                                              //       ),
                                              //     ),
                                              // Positioned(
                                              //   bottom: 10,
                                              //   left: 12,
                                              //   child: Center(
                                              //     child: Container(
                                              //       margin: const EdgeInsets
                                              //           .only(
                                              //         top: 13.0,
                                              //         left: 8.0,
                                              //       ),
                                              //       height: 16.0,
                                              //       width: 16.0,
                                              //       decoration: const BoxDecoration(
                                              //           color: Colors.red,
                                              //           borderRadius:
                                              //               BorderRadius
                                              //                   .all(Radius
                                              //                       .circular(
                                              //                           20))),
                                              //       child: const Align(
                                              //         alignment:
                                              //             Alignment.center,
                                              //         child: Text(
                                              //           "2",
                                              //           style: TextStyle(
                                              //               color: Color(
                                              //                   0xffFFFFFF),
                                              //               fontSize: 11.0,
                                              //               fontFamily:
                                              //                   'Inter',
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .w500),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      ProjectEdit(
                                        accountableId: accountableId,
                                        currencyList: currencyName,
                                        customerName: customerName,
                                        response: response,
                                        buildContext: context,
                                        id: id,
                                        statusList: statusList,
                                        title: 'Edit Project',
                                        alignment: Alignment.center,
                                        deliveryDate: selectedDateDevlivery,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 80.0,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    decoration: const BoxDecoration(),
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, top: 40.0),
                                              child: const Text(
                                                "Start date",
                                                style: TextStyle(
                                                    color: Color(0xff94A3B8),
                                                    fontSize: 11.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setDate = "2";
                                                _selectDate(setState);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  left: 20.0,
                                                  top: 6.0,
                                                ),
                                                child: Text(
                                                  AppUtil.formattedDateYear(
                                                      selectedDate
                                                          .toString()), // "$startDate",
                                                  style: const TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, top: 40.0),
                                              child: const Text(
                                                "Reminder date",
                                                style: TextStyle(
                                                    color: Color(0xff94A3B8),
                                                    fontSize: 11.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setDate = "3";
                                                _selectDate(setState);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20.0, top: 6.0),
                                                child: Text(
                                                  // reminderDate1 == null
                                                  //     ?
                                                  AppUtil.formattedDateYear(
                                                      selectedDateReminder
                                                          .toString()),
                                                  //   "${selectedDateReminder.day}${selectedDateReminder.month}${selectedDateReminder.year}",
                                                  // : "$reminderDate1",
                                                  style: const TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, top: 40.0),
                                              child: const Text(
                                                "Delivery date",
                                                style: TextStyle(
                                                    color: Color(0xff94A3B8),
                                                    fontSize: 11.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setDate = "4";
                                                _selectDate(setState);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20.0, top: 6.0),
                                                child: Text(
                                                  // deliveryDate == null
                                                  //     ?${selectedDateDevlivery.day} ${selectedDateDevlivery.month} ${selectedDateDevlivery.year}
                                                  AppUtil.formattedDateYear(
                                                      selectedDateDevlivery
                                                          .toString()),

                                                  // : "$deliveryDate",
                                                  style: const TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, top: 40.0),
                                              child: const Text(
                                                "Deadline",
                                                style: TextStyle(
                                                    color: Color(0xff94A3B8),
                                                    fontSize: 11.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setDate = "5";
                                                _selectDate(setState);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20.0, top: 6.0),
                                                child: Text(
                                                  // deadlineDate == null
                                                  //  ?
                                                  AppUtil.formattedDateYear(
                                                      selectedDateDeadline
                                                          .toString()),

                                                  // : '$deadlineDate',
                                                  style: const TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, top: 40.0),
                                              child: const Text(
                                                "Working days",
                                                style: TextStyle(
                                                    color: Color(0xff94A3B8),
                                                    fontSize: 11.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0, top: 6.0),
                                              child: Text(
                                                response.data != null &&
                                                        response.data!
                                                                .workingDays! !=
                                                            null &&
                                                        response
                                                            .data!
                                                            .workingDays!
                                                            .isNotEmpty
                                                    ? response
                                                        .data!.workingDays!
                                                    : 'N/A',
                                                style: const TextStyle(
                                                    color: Color(0xffFFFFFF),
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),

                                            // InkWell(
                                            //                          onTap: (){},

                                            //                         child: Container(
                                            //                           height: 18.0,
                                            //                           margin: const EdgeInsets.only(left: 20.0, top: 6.0),
                                            //                            child:    DropdownButtonHideUnderline(
                                            //                              child: DropdownButton(
                                            //                                dropdownColor:
                                            //                                ColorSelect.class_color,
                                            //                                // Initial Value
                                            //                                value: dropdownvalue,
                                            //                                hint:  Text(
                                            //                                  response!.data!.workingDays.toString(),
                                            //                                  style: const TextStyle(
                                            //                                      fontSize: 14.0,
                                            //                                      color: Color(0xffFFFFFF),
                                            //                                      fontFamily: 'Inter',
                                            //                                      fontWeight:
                                            //                                      FontWeight.w500),
                                            //                                ),

                                            //                                // Down Arrow Icon
                                            //                                icon: Visibility (visible:false, child: Icon(Icons.arrow_downward)),

                                            //                                // Array list of items
                                            //                                items: items.map((String items) {
                                            //                                  return DropdownMenuItem(
                                            //                                    value: items,
                                            //                                    child: Text(items,style: const TextStyle(
                                            //                                        fontSize: 14.0,
                                            //                                        color:
                                            //                                        Color(0xffFFFFFF),
                                            //                                        fontFamily: 'Inter',
                                            //                                        fontWeight:
                                            //                                        FontWeight.w400),),
                                            //                                  );
                                            //                                }).toList(),
                                            //                                // After selecting the desired option,it will
                                            //                                // change button value to selected value
                                            //                                onChanged: (String? newValue) {
                                            //                                  setState(() {
                                            //                                    dropdownvalue = newValue!;
                                            //                                  });
                                            //                                },
                                            //                              ),
                                            //                            ),
                                            //                         ),
                                            //                       ),
                                          ],
                                        ),

                                        // const Spacer(),

                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 30.0,
                                                left: 40.0,
                                                bottom: 10),
                                            height: 28.0,
                                            width: 40.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xff334155),
                                                    width: 0.6),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(40))),
                                            child: const Padding(
                                                padding: EdgeInsets.all(6.0),
                                                // child: SvgPicture.asset(
                                                //   "images/cross.svg",
                                                // ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                                height:
                                    30.0, //MediaQuery.of(context).size.height * 0.10,
                                width:
                                    MediaQuery.of(context).size.width * 100.0,
                                child: const Divider(
                                  color: Color(0xff94A3B8),
                                  thickness: 0.2,
                                )),
                          ],
                        ),
                      ),

                      Expanded(
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 32.0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: abc
                                                  .length, //response.data!.tags!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                // Tags tag=response.data!.tags![index];
                                                //var tagName=tag.name;

                                                return Container(
                                                  height: 32,
                                                  margin: const EdgeInsets.only(
                                                      left: 5.0, right: 5.0),
                                                  child: InputChip(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8))),
                                                    deleteIcon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 20,
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
                                                    // selected: _isSelected!,
                                                    //  selectedColor: Color(0xff334155),
                                                    onSelected:
                                                        (bool selected) {
                                                      setState(() {
                                                        _isSelected = selected;
                                                      });
                                                    },
                                                    onDeleted: () {
                                                      response.data!.tags!
                                                          .forEach(
                                                        (element) {
                                                          if (element.name ==
                                                              abc[index]) {
                                                            removeTagAPI(element
                                                                .id
                                                                .toString());
                                                          }
                                                        },
                                                      );

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
                                        ),
                                        // SizedBox(
                                        //   height: 32,
                                        //   child: Padding(
                                        //     padding:
                                        //         EdgeInsets.only(left: 26),
                                        //     child: ListView.builder(
                                        //       scrollDirection:
                                        //           Axis.horizontal,
                                        //       itemCount: abc.length,
                                        //       //.tagResponse!.data!.length,
                                        //       itemBuilder: (context, index) {
                                        //         return Container(
                                        //           margin:
                                        //               const EdgeInsets.only(
                                        //                   left: 5.0,
                                        //                   right: 5.0),
                                        //           child: InputChip(
                                        //             shape: RoundedRectangleBorder(
                                        //                 borderRadius:
                                        //                     BorderRadius.all(
                                        //                         Radius
                                        //                             .circular(
                                        //                                 8))),
                                        //             deleteIcon: Icon(
                                        //               Icons.close,
                                        //               color: Colors.white,
                                        //               size: 20,
                                        //             ),
                                        //             backgroundColor:
                                        //                 Color(0xff334155),
                                        //             visualDensity:
                                        //                 VisualDensity.compact,
                                        //             materialTapTargetSize:
                                        //                 MaterialTapTargetSize
                                        //                     .shrinkWrap,
                                        //             label: Text(
                                        //               abc[index],
                                        //               style: TextStyle(
                                        //                   color:
                                        //                       Colors.white),
                                        //             ),
                                        //             selected: _isSelected!,
                                        //             //  selectedColor: Color(0xff334155),
                                        //             onSelected:
                                        //                 (bool selected) {
                                        //               setState(() {
                                        //                 _isSelected =
                                        //                     selected;
                                        //               });
                                        //             },
                                        //             onDeleted: () {
                                        //               setState(() {
                                        //                 abc.removeAt(index);
                                        //               });
                                        //             },

                                        //             showCheckmark: false,
                                        //           ),
                                        //         );
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),

                                        GestureDetector(
                                          onTap: () async {
                                            await showMenu(
                                              context: context,
                                              color: ColorSelect.class_color,
                                              position:
                                                  new RelativeRect.fromLTRB(
                                                      160.0,
                                                      170.0,
                                                      160.0,
                                                      100.0),
                                              items: [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      //height: 100,
                                                      width: 400,

                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          searchTextField =
                                                              AutoCompleteTextField<
                                                                  SkillsData>(
                                                            clearOnSubmit:
                                                                false,
                                                            key: key,
                                                            cursorColor:
                                                                Colors.white,
                                                            decoration:
                                                                const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top:
                                                                          15.0),
                                                              prefixIcon:
                                                                  Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top:
                                                                              4.0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .search,
                                                                        color: Color(
                                                                            0xff64748B),
                                                                      )),
                                                              hintText:
                                                                  'Search',
                                                              hintStyle: TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Color(
                                                                      0xff64748B),
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            suggestions: users,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.0),
                                                            itemFilter:
                                                                (item, query) {
                                                              return item.name!
                                                                  .toLowerCase()
                                                                  .startsWith(query
                                                                      .toLowerCase());
                                                            },
                                                            itemSorter: (a, b) {
                                                              return a.name!
                                                                  .compareTo(
                                                                      b.name!);
                                                            },
                                                            itemSubmitted:
                                                                (item) {
                                                              searchTextField!
                                                                  .textField!
                                                                  .controller!
                                                                  .text = '';
                                                              if (!abc.contains(
                                                                  item.name)) {
                                                                abc.add(
                                                                    item.name!);

                                                                saveTagApi(
                                                                    response
                                                                        .data!
                                                                        .id
                                                                        .toString(),
                                                                    item.name!);
                                                              }
                                                              setState(() {});
                                                            },
                                                            itemBuilder:
                                                                (context,
                                                                    item) {
                                                              // ui for the autocompelete row
                                                              return rowProject(
                                                                  item);
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              elevation: 8.0,
                                            ).then((value) {
                                              if (value != null) print(value);
                                            });
                                          },
                                          child: Container(
                                              width: 35.0,
                                              height: 35.0,
                                              margin: const EdgeInsets.only(
                                                left: 15.0,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: Color(0xff334155),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Container(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: SvgPicture.asset(
                                                        'images/tag_new.svg')),
                                              )
                                              //SvgPicture.asset('images/list.svg'),
                                              ),
                                        ),
                                        Spacer(),
                                        Container(
                                          child: const Text(
                                            'Work folder',
                                            style: TextStyle(
                                                color:
                                                    ColorSelect.cermany_color,
                                                fontSize: 14.0,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, right: 35.0),
                                          child: SvgPicture.asset(
                                            'images/cermony.svg',
                                          ),
                                        ),
                                        Container(
                                          child: const Text(
                                            'CRM',
                                            style: TextStyle(
                                                color:
                                                    ColorSelect.cermany_color,
                                                fontSize: 14.0,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, right: 16.0),
                                          child: SvgPicture.asset(
                                            'images/cermony.svg',
                                          ),
                                        ),
                                      ],
                                    ),

                                    // TODO POTEN
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.99,
                                      margin: const EdgeInsets.only(
                                          left: 15.0, top: 16.0),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff1E293B),
                                        border: Border.all(
                                            color: const Color(0xff424D5F),
                                            width: 0.5),
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _description,
                                        cursorColor: const Color(0xffFFFFFF),
                                        style: const TextStyle(
                                            color: Color(0xffFFFFFF)),
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(
                                              bottom: 13.0,
                                              top: 14.0,
                                              right: 10,
                                              left: 14.0,
                                            ),
                                            border: InputBorder.none,
                                            hintText: '',
                                            hintStyle: const TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500)),
                                        onChanged: (value) {
                                          addDescriptionProject();
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 30.0, top: 20.0),
                                      child: const Text(
                                        "Potential roadblocks",
                                        style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 16.0,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.99,
                                      margin: const EdgeInsets.only(
                                          left: 30.0, top: 12.0),
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        // border: Border.all(color: const Color(0xff1E293B)),
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 15.0, top: 0.0),
                                            child: const Text(
                                              "Occurrence",
                                              style: TextStyle(
                                                  color: Color(0xff94A3B8),
                                                  fontSize: 14.0,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 40.0, top: 0.0),
                                            child: const Text(
                                              "Responsible",
                                              style: TextStyle(
                                                  color: Color(0xff94A3B8),
                                                  fontSize: 14.0,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 15.0, right: 30.0),
                                            child: const Text(
                                              "Date created",
                                              style: TextStyle(
                                                  color: Color(0xff94A3B8),
                                                  fontSize: 14.0,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: 13,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 45.0, top: 8.0),
                                                  height: 12.0,
                                                  width: 12.0,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color:
                                                              Color(0xffEF4444),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 16.0, top: 8.0),
                                                  child: const Text(
                                                    "Technology not define yet",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffE2E8F0),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Container(
                                                  height: 28.0,
                                                  width: 28.0,
                                                  margin: const EdgeInsets.only(
                                                      right: 98.0, top: 8.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff0F172A),
                                                        width: 3.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      30.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "RC",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          fontSize: 10.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 8.0, right: 50.0),
                                                  child: const Text(
                                                    "13 Jul",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff94A3B8),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          // margin: const EdgeInsets.only(left: 20.0, top: 40.0),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.99,
                                          decoration: const BoxDecoration(
                                            color: Color(0xff263143),
                                            //border: Border.all(color: const Color(0xff0E7490)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //   padding:const EdgeInsets.only(left: 10,right:10 ),
                                    //   decoration:const  BoxDecoration(boxShadow: [
                                    //     BoxShadow(
                                    //       color: Colors.black,
                                    //       spreadRadius: 0,
                                    //       blurRadius: 3,
                                    //       offset: Offset(
                                    //           0, -3), // changes position of shadow
                                    //     ),
                                    //   ], color: Color(0xff263143)),
                                    //   child: Center(
                                    //     child: TextFormField(
                                    //       controller: _commentController,
                                    //       autocorrect: false,
                                    //       cursorColor: const Color(0xffFFFFFF),
                                    //       style: const TextStyle(
                                    //           color: Color(0xffFFFFFF)),
                                    //       textAlignVertical: TextAlignVertical.bottom,
                                    //       keyboardType: TextInputType.text,
                                    //       decoration: const InputDecoration(
                                    //           //counterText: '',
                                    //           // errorStyle: TextStyle(fontSize: 14, height: 0.20),
                                    //           contentPadding: EdgeInsets.only(
                                    //             bottom: 16.0,
                                    //             top: 57.0,
                                    //             right: 10,
                                    //             left: 26.0,
                                    //           ),
                                    //           border: InputBorder.none,
                                    //           hintText: 'Write a comment',
                                    //           hintStyle: TextStyle(
                                    //               fontSize: 14.0,
                                    //               color: Color(0xff94A3B8),
                                    //               fontFamily: 'Inter',
                                    //               fontWeight: FontWeight.w400)),
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
                                    //       //  onChanged: (text) => setState(() => name_ = text),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //TODO VS
                      Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.99,
                        child: Column(
                          children: [
                            SizedBox(
                                height: 30.0,
                                width: MediaQuery.of(context).size.width,
                                child: const Divider(
                                  color: Color(0xff94A3B8),
                                  thickness: 0.2,
                                )),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 30.0, top: 0.0),
                                  child: const Text(
                                    "Timeline",
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontSize: 16.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 8.0, top: 0.0),
                                      child: SvgPicture.asset(
                                        'images/plus.svg',
                                        color: const Color(0xff93C5FD),
                                        width: 10.0,
                                        height: 10.0,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 45.0, top: 0.0),
                                      child: const Text(
                                        "Request resources",
                                        style: TextStyle(
                                            color: Color(0xff93C5FD),
                                            fontSize: 12.0,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: 8.0, top: 0.0),
                                        child: SvgPicture.asset(
                                          'images/plus.svg',
                                          color: const Color(0xff93C5FD),
                                          width: 10.0,
                                          height: 10.0,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: 80.0, top: 0.0),
                                        child: const Text(
                                          "New phase",
                                          style: TextStyle(
                                              color: Color(0xff93C5FD),
                                              fontSize: 12.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return NewPhase();
                                        });
                                  },
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.99,
                              margin: const EdgeInsets.only(
                                  left: 30.0, top: 12.0, right: 30.0),
                              height:
                                  40, //MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                // border: Border.all(color: const Color(0xff1E293B)),
                                borderRadius: BorderRadius.circular(
                                  12.0,
                                ),
                              ),

                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, top: 0.0),
                                    child: const Text(
                                      "Phase",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 14.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 40.0, top: 0.0),
                                    child: const Text(
                                      "From",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 14.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 50.0),
                                    child: const Text(
                                      "Till",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 14.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: response.data!.phase!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Phase phase = response.data!.phase![index];
                                  var title = phase.title;
                                  var phaseType = phase.phaseType;
                                  String name = title!.substring(0, 2);
                                  var date = phase.startDate;
                                  var endDate = phase.endDate;

                                  var inputDate = DateTime.parse(date!);
                                  var outputFormat = DateFormat('d MMM');
                                  var _date = outputFormat.format(inputDate);

                                  var _reminderdate = DateTime.parse(endDate!);
                                  var _remind = DateFormat('d MMM');
                                  var _endDate = _remind.format(_reminderdate);

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 25.0,
                                            width: 25.0,
                                            margin: const EdgeInsets.only(
                                                left: 45.0, top: 10.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30.0,
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "$name",
                                                style: const TextStyle(
                                                    color: Color(0xffFFFFFF),
                                                    fontSize: 10.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 16.0, top: 12.0),
                                            child: Text(
                                              "$phaseType",
                                              style: const TextStyle(
                                                  color: Color(0xffE2E8F0),
                                                  fontSize: 14.0,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 12.0, right: 42.0),
                                            child: Text(
                                              "$_date",
                                              style: const TextStyle(
                                                  color: Color(0xff94A3B8),
                                                  fontSize: 14.0,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 12.0, right: 52.0),
                                            child: Text(
                                              "$_endDate",
                                              style: const TextStyle(
                                                  color: Color(0xff94A3B8),
                                                  fontSize: 14.0,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              left: 30.0,
                                              right: 30.0,
                                              bottom: 0.0),
                                          //  height: 74.0,//MediaQuery.of(context).size.height * 0.10,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              100.0,
                                          child: const Divider(
                                            color: Color(0xff94A3B8),
                                            thickness: 0.1,
                                          )),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
              ),
            ),
          ),
        );
      });
}
