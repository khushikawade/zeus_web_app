import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:zeus/helper_widget/custom_datepicker.dart';
import 'package:zeus/helper_widget/custom_form_field.dart';
import 'package:zeus/helper_widget/custom_search_dropdown.dart';
import 'package:zeus/home_module/home_page.dart';
import 'package:zeus/project_module/create_project/create_project.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  String name_ = '';

  bool selectAccountablePerson = false;
  bool selectCurrency = false;
  bool selectStatus = false;
  bool selectCustomer = false;
  bool createButtonClick = false;
  bool selectDeliveryDate = false;
  bool createProjectValidate = true;
  final TextEditingController _projecttitle = TextEditingController();
  final TextEditingController _crmtask = TextEditingController();
  final TextEditingController _warkfolderId = TextEditingController();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _estimatehours = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final ScrollController verticalScroll = ScrollController();
  var myFormat = DateFormat('d MMM yyyy');

  List<DropdownModel>? currencyList = [];
  List<DropdownModel>? accountablePersonList = [];
  List<DropdownModel>? consumerList = [];
  List<DropdownModel>? projectStatusList = [];

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
        try {
          projectStatusList!.clear();

          projectStatusList!
              .add(DropdownModel(element['id'].toString(), element['title']));

          // _accountableId.map((result) {
          //   print("<<<<<<<<<<<<<<<<<<<<<<result>>>>>>>>>>>>>>>>>>>>>>");
          //   print(result);
          //   accountablePersonList!.add(result['name']);
          // });
        } catch (e) {
          print(e);
        }
        if (element['title'] == widget.response.data!.status) {
          _status = element['id'].toString();
        }
      });
    }

    if (widget.accountableId.isNotEmpty) {
      widget.accountableId.asMap().forEach((index, element) {
        try {
          accountablePersonList!.clear();
          accountablePersonList!
              .add(DropdownModel(element['id'].toString(), element['name']));
        } catch (e) {
          print(e);
        }
        if (element['id'].toString() ==
            widget.response.data!.accountablePersonId.toString()) {
          _account = element['id'].toString();
        }
      });
    }

    if (widget.customerName.isNotEmpty) {
      widget.customerName.asMap().forEach((index, element) {
        try {
          consumerList!.clear();
          consumerList!
              .add(DropdownModel(element['id'].toString(), element['name']));
        } catch (e) {
          print(e);
        }
        // if (element['id'].toString() ==
        //     widget.response.data!.accountablePersonId.toString()) {
        //   _account = element['id'].toString();
        // }
      });
    }

    if (widget.currencyList.isNotEmpty) {
      widget.currencyList.asMap().forEach((index, element) {
        if (element['id'].toString() == widget.response.data!.currency) {
          _curren = element['id'].toString();
          try {
            currencyList!.clear();
            if (!currencyList!.contains(element['currency']['symbol'])) {
              currencyList!.add(DropdownModel(
                  element['id'].toString(), element['currency']['symbol']));
            }
          } catch (e) {
            print(e);
          }
          print("(_curren--------------------------------${_curren}");
          print(_curren!.length);
        }
      });
    } else {
      print("-----------------------------------------------------.");
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
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
                colorScheme: ColorScheme.light(primary: const Color(0xff0F172A))
                    .copyWith(secondary: const Color(0xff0F172A))),
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
    return oldDialog();
  }

  newResponsiveDialog() {
    return Container(
      width: 523.w,
      child: RawScrollbar(
        controller: verticalScroll,
        thumbColor: const Color(0xff4b5563),
        crossAxisMargin: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        thickness: 8,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView(
            controller: verticalScroll,
            padding: EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Text(
                    'Create Project',
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 18.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700),
                  )),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 30.sp,
                        height: 30.sp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff1E293B),
                          border:
                              Border.all(color: Color(0xff334155), width: 0.6),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'images/cross.svg',
                            height: 13.8.sp,
                            width: 13.18.sp,
                          ),
                        ),
                      ))
                ],
              ),
              SizedBox(height: 32.w),
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
                children: [
                  Expanded(
                      child: CustomSearchDropdown(
                    label: 'AP',
                    hint: 'Select Accountable Person',
                    errorText: createButtonClick &&
                            (_account == null || _account!.isEmpty)
                        ? 'Please Select this field'
                        : '',
                    items: accountablePersonList!,
                    onChange: ((DropdownModel value) {
                      setState(() {
                        _account = value.id;
                        print("account:${_account}");
                        selectAccountablePerson = true;
                      });
                    }),
                  )),
                  SizedBox(
                    width: 16.w,
                  ),
                  Expanded(
                      child: CustomSearchDropdown(
                    label: 'Customer',
                    hint: 'Select Customer',
                    errorText: createButtonClick &&
                            (_custome == null || _custome!.isEmpty)
                        ? 'Please Select this field'
                        : '',
                    items: consumerList!,
                    onChange: ((value) {
                      setState(() {
                        _custome = value.id;
                        print("account:$_custome");
                        selectCustomer = true;
                      });
                    }),
                  )),
                ],
              ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 9,
                    child: CustomFormField(
                      controller: _budget,
                      hint: '',
                      label: "Budget",
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
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                      flex: 8,
                      child: CustomSearchDropdown(
                        hint: 'Select',
                        label: "AB",
                        errorText: createButtonClick &&
                                (_curren == null || _curren!.isEmpty)
                            ? 'Please Select this field'
                            : '',
                        items: currencyList!,
                        onChange: ((value) {
                          _curren = value.id;
                          setState(() {
                            selectCurrency = true;
                          });
                        }),
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    flex: 18,
                    child: CustomFormField(
                      controller: _estimatehours,
                      hint: '',
                      label: "Estimated hours",
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
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: CustomSearchDropdown(
                    hint: 'Select Status',
                    label: "",
                    errorText: createButtonClick &&
                            (_status == null || _status!.isEmpty)
                        ? 'Please Select this field'
                        : '',
                    items: projectStatusList!,
                    onChange: ((value) {
                      setState(() {
                        _status = value.id;
                        print('value of status' + _status!);
                        selectStatus = true;
                      });
                    }),
                  )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    flex: 1,
                    child: CustomDatePicker(
                      hint: 'Select Date',
                      label: 'Delivery Date',
                      onChange: (date) {
                        setState(() {
                          deliveryDate = date;
                        });
                      },
                      onCancel: () {
                        setState(() {
                          deliveryDate = null;
                        });
                      },
                      errorText: (createButtonClick && deliveryDate == null)
                          ? 'Please select this field'
                          : "",
                      validator: (value) {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
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
                      if (await _formKey.currentState!.validate()) {
                        Future.delayed(const Duration(microseconds: 500), () {
                          if (createProjectValidate) {
                            if (selectAccountablePerson == true &&
                                selectCustomer == true &&
                                selectCurrency == true &&
                                selectStatus == true &&
                                deliveryDate != null) {
                              SmartDialog.showLoading(
                                msg:
                                    "Your request is in progress please wait for a while...",
                              );
                              editProject(context);
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
    );
  }

  oldDialog() {
    return Center(
      child: PopupMenuButton<int>(
        tooltip: "",
        // offset: widget.offset,
        // color: const Color(0xFF0F172A),
        // position: PopupMenuPosition.under,
        constraints: const BoxConstraints.expand(width: 140, height: 120),
        // padding: EdgeInsets.only(left: 50, right: 50),
        offset: const Offset(-30, 0),
        position: PopupMenuPosition.under,
        color: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),

        child: Container(
          margin:
              const EdgeInsets.only(right: 0.0, top: 0.0, bottom: 38, left: 80),
          height: 38,
          width: 38,
          decoration: BoxDecoration(
              color: const Color(0xff334155),
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
                          // scrollable: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: const Color(0xff1E293B),
                          content: Form(
                              key: _formKey,
                              child: CreateProjectPage(
                                formKey: _formKey,
                                response: widget.response,
                              )),
                        ),
                      );
                    });
              },
              child: Container(
                height: 50,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, top: 15),
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
                                    "Do you want to delete this project_detail ?",
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
                                    "Once deleted, you will not find this project in the list. ",
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
                                        Container(
                                          margin: const EdgeInsets.only(
                                              right: 35.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
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
                                        InkWell(
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
                                                color: Color(0xffEF4444)),
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
                  padding: EdgeInsets.only(left: 20, top: 15),
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
          Uri.parse('${AppUrl.baseUrl}/project/${widget.id}/update'),
          body: map,
          headers: {
            "Accept": "application/json",
            "Authorization": token,
          },
        );
        // ignore: unrelated_type_equality_checks
        print(response.statusCode);
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
