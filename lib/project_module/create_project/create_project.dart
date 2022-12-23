import 'dart:convert';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/custom_datepicker.dart';
import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/helper_widget/custom_form_field.dart';
import 'package:zeus/helper_widget/custom_search_dropdown.dart';
import 'package:zeus/home_module/home_page.dart';
import 'package:zeus/services/response_model/project_detail_response.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/colors.dart';
import 'package:http/http.dart' as http;
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateProjectPage extends StatefulWidget {
  ProjectDetailResponse? response;
  GlobalKey<FormState>? formKey = new GlobalKey<FormState>();

  CreateProjectPage({Key? key, this.formKey, this.response}) : super(key: key);

  @override
  State<CreateProjectPage> createState() => _EditPageState();
}

class _EditPageState extends State<CreateProjectPage> {
  String? _account, _custome, _curren, _status;
  DateTime? selectedDate;
  String name_ = '';

  bool createButtonClick = false;
  bool createProjectValidate = true;
  bool dataLoading = false;

  TextEditingController _projecttitle = TextEditingController();
  final TextEditingController _crmtask = TextEditingController();
  final TextEditingController _warkfolderId = TextEditingController();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _estimatehours = TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController(text: '');

  final ScrollController verticalScroll = ScrollController();

  List<DropdownModel>? accountablePersonList = [];
  List<DropdownModel>? consumerList = [];
  List<DropdownModel>? projectStatusList = [];

  List<DropdownModel>? currencyList = [];

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

  // update Controller Value
  updateControllerValue() {
    _projecttitle.text = widget.response!.data != null &&
            widget.response!.data!.title != null &&
            widget.response!.data!.title!.isNotEmpty
        ? widget.response!.data!.title!
        : '';

    _crmtask.text = widget.response!.data != null &&
            widget.response!.data!.crmTaskId != null &&
            widget.response!.data!.crmTaskId!.isNotEmpty
        ? widget.response!.data!.crmTaskId!
        : '';

    _warkfolderId.text = widget.response!.data != null &&
            widget.response!.data!.workFolderId != null &&
            widget.response!.data!.workFolderId!.isNotEmpty
        ? widget.response!.data!.workFolderId!
        : '';

    _budget.text =
        widget.response!.data != null && widget.response!.data!.budget != null
            ? widget.response!.data!.budget!.toString()
            : '';

    _estimatehours.text = widget.response!.data != null &&
            widget.response!.data!.estimationHours != null &&
            widget.response!.data!.estimationHours!.isNotEmpty
        ? widget.response!.data!.estimationHours!.toString()
        : '';

    _custome = widget.response!.data != null &&
            widget.response!.data!.customerId != null
        ? widget.response!.data!.customerId.toString()
        : '';

    _account = widget.response!.data != null &&
            widget.response!.data!.accountablePersonId != null
        ? widget.response!.data!.accountablePersonId.toString()
        : '';

    _status =
        widget.response!.data != null && widget.response!.data!.status != null
            ? widget.response!.data!.status.toString()
            : '';

    _curren =
        widget.response!.data != null && widget.response!.data!.currency != null
            ? widget.response!.data!.currency.toString()
            : '';

    try {
      DropdownModel? result = getAllInitialValue(projectStatusList, _status);
      if (result != null) {
        _status = result.id;
      } else {
        _status = null;
      }
    } catch (e) {}

    if (widget.response!.data != null &&
        widget.response!.data!.deliveryDate != null &&
        widget.response!.data!.deliveryDate!.isNotEmpty) {
      selectedDate = AppUtil.stringToDate(widget.response!.data!.deliveryDate!);
    }
  }

  @override
  void initState() {
    callAllApi();

    super.initState();
  }

  callAllApi() async {
    setState(() {
      if (widget.response != null) {
        dataLoading = true;
      }
    });

    await getSelectStatus();
    await getAccountable();
    await getCustomer();
    await getCurrency();
    if (widget.response != null) {
      await updateControllerValue();
    }
    setState(() {
      dataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [createProjectView()],
    );
  }

  Widget createProjectView() {
    return Container(
      width: 523.w,
      child: dataLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RawScrollbar(
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
                            child: Text(
                          widget.response != null
                              ? 'Edit Project'
                              : 'Create Project',
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 18.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700),
                        )),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 35.sp,
                              height: 35.sp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff1E293B),
                                border: Border.all(
                                    color: Color(0xff334155), width: 0.6),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'images/cross.svg',
                                  height: 13.18.sp,
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
                          initialValue: getAllInitialValue(
                              accountablePersonList, _account),
                          errorText: createButtonClick &&
                                  (_account == null || _account!.isEmpty)
                              ? 'Please Select this field'
                              : '',
                          items: accountablePersonList!,
                          onChange: ((DropdownModel value) {
                            setState(() {
                              _account = value.id;
                              print("account:${_account}");
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
                          initialValue:
                              getAllInitialValue(consumerList, _custome) ??
                                  null,
                          errorText: createButtonClick &&
                                  (_custome == null || _custome!.isEmpty)
                              ? 'Please Select this field'
                              : '',
                          items: consumerList!,
                          onChange: ((value) {
                            setState(() {
                              _custome = value.id;
                              print("account:$_custome");
                            });
                          }),
                        ))
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
                              initialValue:
                                  getAllInitialValue(currencyList, _curren),
                              errorText: createButtonClick &&
                                      (_curren == null || _curren!.isEmpty)
                                  ? 'Please Select this field'
                                  : '',
                              items: currencyList!,
                              onChange: ((value) {
                                _curren = value.id;
                                setState(() {});
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
                          initialValue:
                              getAllInitialValue(projectStatusList, _status),
                          errorText: createButtonClick &&
                                  (_status == null || _status!.isEmpty)
                              ? 'Please Select this field'
                              : '',
                          items: projectStatusList!,
                          onChange: ((value) {
                            setState(() {
                              _status = value.id;
                              print('value of status' + _status!);
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
                            initialDate: selectedDate,
                            onChange: (date) {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                            onCancel: () {
                              setState(() {
                                selectedDate = null;
                              });
                            },
                            errorText:
                                (createButtonClick && selectedDate == null)
                                    ? 'Please select this field'
                                    : "",
                            validator: (value) {},
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 97.w,
                            margin: EdgeInsets.only(
                              top: 16.0.h,
                            ),
                            height: 40.0.h,
                            decoration: BoxDecoration(
                              color: const Color(0xff334155),
                              borderRadius: BorderRadius.circular(
                                40.0.r,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 15.0.sp,
                                    color: ColorSelect.white_color,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              createProjectValidate = true;
                              createButtonClick = true;
                            });
                            if (await widget.formKey!.currentState!
                                .validate()) {
                              Future.delayed(const Duration(microseconds: 500),
                                  () {
                                if (_account != null &&
                                    _account!.isNotEmpty &&
                                    _custome != null &&
                                    _custome!.isNotEmpty &&
                                    _curren != null &&
                                    _curren!.isNotEmpty &&
                                    _status != null &&
                                    _status!.isNotEmpty &&
                                    selectedDate != null) {
                                  SmartDialog.showLoading(
                                    msg:
                                        "Your request is in progress please wait for a while...",
                                  );
                                  createProject(context);
                                }
                              });
                            }
                          },
                          child: Container(
                            width: 97.0.w,
                            margin: EdgeInsets.only(
                              top: 16.0.h,
                              right: 10.0.w,
                            ),
                            height: 40.0.h,
                            decoration: BoxDecoration(
                              color: const Color(0xff7DD3FC),
                              borderRadius: BorderRadius.circular(
                                40.0.r,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.response != null ? "Save" : "Create",
                                style: TextStyle(
                                    fontSize: 15.0.sp,
                                    color: ColorSelect.black_color,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ),
    );
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

  //Create project_detail Api
  createProject(BuildContext context) async {
    var responseJson;
    var token = 'Bearer ' + storage.read("token");
    try {
      var response = await http.post(
        widget.response != null
            ? Uri.parse(
                '${AppUrl.baseUrl}/project/${widget.response?.data?.id ?? 0}/update')
            : Uri.parse(AppUrl.create_project),
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
      print('error caught: $e');
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
