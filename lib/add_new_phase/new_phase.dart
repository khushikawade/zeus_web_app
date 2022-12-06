import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/DemoContainer.dart';
import 'package:zeus/add_new_phase/model/mileston_model.dart';
import 'package:zeus/add_new_phase/model/phase_details.dart';
import 'package:zeus/add_new_phase/model/resourcedata.dart';
import 'package:zeus/add_new_phase/model/resources_needed.dart';
import 'package:zeus/add_new_phase/model/resources_needed.dart'
    as resourceNeeded;
import 'package:zeus/add_new_phase/model/subtask_model.dart';
import 'package:zeus/helper_widget/dropdown_textfield.dart';
import 'package:zeus/helper_widget/labeltextfield.dart';
import 'package:zeus/helper_widget/milstoneList.dart';
import 'package:zeus/helper_widget/select_datefield.dart';
import 'package:zeus/helper_widget/subTaskList.dart';
import 'package:zeus/helper_widget/textfield_milestone.dart';
import 'package:zeus/helper_widget/textformfield.dart';
import 'package:zeus/navigator_tabs/idle/project_detail_model/project_detail_response.dart';
import 'package:zeus/services/api.dart';
import 'package:zeus/services/responce_model/create_phase_resp.dart';
import 'package:zeus/services/responce_model/get_phase_details_resp.dart';
import 'package:zeus/services/responce_model/update_phase_resp.dart';
import 'package:zeus/utility/colors.dart';
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';
import 'package:zeus/utility/validations.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewPhase extends StatefulWidget {
  String id;
  int type; // type==0 new, type ==1 edit
  NewPhase(this.id, this.type, {Key? key}) : super(key: key);

  @override
  State<NewPhase> createState() => _NewPhaseState();
}

class _NewPhaseState extends State<NewPhase> {
  PhaseDetails _phaseDetails =
      PhaseDetails(sub_tasks: [], resource: [], milestone: []);
  TextEditingController controller_next_phase = TextEditingController();
  TextEditingController controllerMilestoneTitle = TextEditingController();
  TextEditingController controller_phase_type = TextEditingController();
  AutoCompleteTextField? searchTextField;
  AutoCompleteTextField? subTaskResourcesSearchTextField;
  ResourceNeededModel? resourceNeededModel;
  GetPhaseDetails? getPhaseDetails;
  List<String> abc = [];
  static List<Details> users = <Details>[];
  static List<Details> resourceSuggestions = <Details>[];
  bool loading = true;
  bool startloading = false;
  dynamic? _depat;
  String? selectUser, subtaskDepat;
  List _department = [];
  Api api = Api();
  DateTime startDate = DateTime.now().subtract(Duration(days: 40));
  DateTime endDate = DateTime.now().add(Duration(days: 40));
  DateTime selectedDate = DateTime.now();
  String dropdownvalue = 'Type';
  bool clickedAddMileStone = false;
  bool clickAddSubTask = false;
  bool saveButtonClick = false;
  bool saveButtonClickForSubtask = false;
  GlobalKey<AutoCompleteTextFieldState<Details>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Details>> subtaskKey = new GlobalKey();
  List<String> selectedSource = [];
  List<PhasesSortedResources> listResource = [];
  List<ResourceData> selectedSubTaskSource = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _mileStoneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _subtaskFormKey = GlobalKey<FormState>();

  String mileStoneAction = '';
  int mileStoneEditIndex = 0;

  String subtaskActionType = '';
  int subTaskEditIndex = 0;

  //VS --------------------------------------------------------------------------------
  String mileStoneTitle = "";
  String mileStoneDate = AppUtil.dateToString(DateTime.now());

  String subTaskStartDate = AppUtil.dateToString(DateTime.now());
  String subTaskEndDate = AppUtil.dateToString(DateTime.now());
  String subTaskResourceName = "";

  bool allValidate = true;
  bool savePhaseClick = false;
  bool saveSubtaskClick = false;

  //VS --------------------------------------------------------------------------------

  checkFormStatus() {
    setState(() {
      allValidate = false;
    });
  }

  phaseInitialData() {
    if (getPhaseDetails != null &&
        getPhaseDetails!.statusCode == 200 &&
        getPhaseDetails!.status == true) {
      _phaseDetails.statusCode = 200;
      if (getPhaseDetails!.data != null) {
        _phaseDetails.start_date = getPhaseDetails?.data?.startDate ?? "";
        _phaseDetails.end_date = getPhaseDetails?.data?.endDate ?? "";
        _phaseDetails.phase_type = getPhaseDetails?.data?.phaseType ?? "";
        controller_phase_type.text = getPhaseDetails?.data?.phaseType ?? "";
        controller_next_phase.text = getPhaseDetails?.data?.title ?? "";
        _phaseDetails.title = getPhaseDetails?.data?.title ?? "";
        if (getPhaseDetails!.data!.assignedResources != null &&
            getPhaseDetails!.data!.assignedResources!.isNotEmpty) {
          getPhaseDetails!.data!.assignedResources!.forEach((element) {
            listResource.add(PhasesSortedResources(
                details: Details(
                  id: element.resourceId ?? 0,
                  name: element.resource?.name ?? "",
                  departmentId: element.departmentId,
                ),
                department: element.department?.name ?? ""));

            selectedSource.add(element.resource?.name ?? "");


            _phaseDetails.resource!.add(ResourceData(
                department_id: element.departmentId ?? 0,
                resource_id: element.resourceId ?? 0,
                resource_name: element.resource?.name ?? ''));
          });
        }


        // get milestone data form details API
        if (getPhaseDetails!.data!.milestone != null &&
            getPhaseDetails!.data!.milestone!.isNotEmpty) {
          saveButtonClick = true;
          getPhaseDetails!.data!.milestone!.forEach((element) {
            _phaseDetails.milestone!
                .add(Milestones(title: element.title, m_date: element.mDate,id: element.id));
          });
        }

        // get Task data form details API
        if (getPhaseDetails!.data!.subTasks != null &&
            getPhaseDetails!.data!.subTasks!.isNotEmpty) {
          saveButtonClickForSubtask = true;
          getPhaseDetails!.data!.subTasks!.forEach((element) {
            _phaseDetails.sub_tasks!.add(SubTasksModel(
                end_date: element.startDate,
                start_date: element.endDate,
                resource: ResourceData(
                    department_id: element.assignResource?.departmentId ?? 0,
                    resource_id: element.assignResource?.resourceId ?? 0,
                    resource_name:
                        element.assignResource?.resource?.name ?? '')));
          });
        }
      }
    }
  }

  @override
  void initState() {
    // _getTag = getProject();
    // change();

    beforeScreenLoad();
    getDepartment();
    if (widget.type == 1) {
      getPhaseDetailsByID(widget.id);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.zero,
        backgroundColor: const Color(0xff1E293B),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.99,
          height: MediaQuery.of(context).size.height * 0.99,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xff283345),
                        //border: Border.all(color: const Color(0xff0E7490)),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          topLeft: Radius.circular(16.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x26000000),
                            offset: Offset(
                              0.0,
                              1.0,
                            ),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          titleHeadlineWidget("New Phase", 22.0),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 97.0,
                                  //MediaQuery.of(context).size.width * 0.22,
                                  margin: const EdgeInsets.only(
                                      top: 10.0, bottom: 10.0),
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
                                          color: Color(0xffFFFFFF),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                InkWell(
                                  child: Container(
                                    width: 97,
                                    //MediaQuery.of(context).size.width * 0.22,
                                    margin: const EdgeInsets.only(
                                        top: 10.0, right: 20.0, bottom: 10.0),
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
                                            color: Color(0xff000000),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      savePhaseClick = true;
                                    });
                                    Future.delayed(
                                        const Duration(microseconds: 500), () {
                                      createPhase();
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      phaseView(),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.99,
                          child: const VerticalDivider(
                            color: Color(0xff94A3B8),
                            thickness: 0.2,
                          )),
                      mileStoneView(),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.99,
                          child: const VerticalDivider(
                            color: Color(0xff94A3B8),
                            thickness: 0.2,
                          )),
                      subtaskView()
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // Phase view
  Widget phaseView() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              titleHeadlineWidget("Phases details", 18.0),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          formField(
              controller: controller_next_phase,
              context: context,
              labelText: "Phase Title",
              callback: (values) {
                setState(() {
                  _phaseDetails.title = values;
                });
              },
              validateCallback: (value) {
                if (value.isEmpty) {
                  return 'Please enter phase title';
                }
                return null;
              }),
          const SizedBox(
            height: 20.0,
          ),
          formField(
              controller: controller_phase_type,
              labelText: "Phase Type",
              context: context,
              callback: (values) {
                setState(() {
                  _phaseDetails.phase_type = values;
                });
              },
              validateCallback: (value) {
                if (value.isEmpty) {
                  return 'Please enter phase type';
                }
                return null;
              }),
          const SizedBox(
            height: 20.0,
          ),
          DatePicker(
            title: "Start date",
            callback: (value) {
              setState(() {
                _phaseDetails.start_date = value;
              });
              setState(() {});
            },
            startDate: DateTime.now(),
            validationCallBack: (String values) {
              if (values.isEmpty) {
                checkFormStatus();
                return 'Please enter start date';
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 20.0,
          ),
          DatePicker(
            title: "End date",
            callback: (value) {
              setState(() {
                _phaseDetails.end_date = value;
              });
            },
            //  startDate: AppUtil.stringToDate(_1phaseDetails.start_date ?? ""),
            startDate: _phaseDetails.sub_tasks!.isNotEmpty
                ? DateTime.now().add(Duration(days: 10))
                : DateTime.now(),

            validationCallBack: (String values) {
              if (values.isEmpty) {
                checkFormStatus();
                return 'Please enter end date';
              } else if (_phaseDetails.end_date != null &&
                  _phaseDetails.start_date != null) {
                if ((AppUtil.stringToDate(_phaseDetails.end_date!).isBefore(
                    (AppUtil.stringToDate(_phaseDetails.start_date!))))) {
                  return 'End date must be greater then the start date';
                }
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 20.0,
          ),
          titleHeadlineWidget("Resources needed", 16.0),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 7),
                child: CircleAvatar(
                  backgroundColor: Color(0xff334155),
                  radius: 30,
                  child: Icon(Icons.person_outline),
                  // SvgPicture.asset(
                  //   'images/photo.svg',
                  //   width: 24.0,
                  //   height: 24.0,
                  // ),
                ),
              ),
              Container(
                // width: 305, //MediaQuery.of(context).size.width * 0.22,

                margin: const EdgeInsets.only(left: 30.0),
                height: 56.0,
                width: (MediaQuery.of(context).size.width * 0.22),
                //width: MediaQuery.of(context).size.width * 0.20,
                // margin: const EdgeInsets.only(right: 30.0),
                decoration: BoxDecoration(
                  color: const Color(0xff334155),
                  //border: Border.all(color:  const Color(0xff1E293B)),
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  height: 20.0,
                  child: Container(

                      // padding: const EdgeInsets.all(2.0),
                      child: StatefulBuilder(
                    builder: (BuildContext context, StateSettersetState) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: ColorSelect.class_color,
                          value: _depat,
                          underline: Container(),
                          hint: const Text(
                            "Select",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xffFFFFFF),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ),
                          isExpanded: true,
                          icon: const Icon(
                            // Add this
                            Icons.arrow_drop_down,
                            // Add this
                            color: Color(0xff64748B),

                            // Add this
                          ),
                          items: _department.map((items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items['name'],
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xffFFFFFF),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                          onChanged: (dynamic newValue) {
                            setState(() {
                              print(newValue);

                              print(newValue);
                              _depat = newValue;
                              print(newValue);

                              if (newValue != null) {
                                startloading = true;
                                getResourcesNeeded(newValue['id'].toString());
                              }
                            });
                          },
                        ),
                      );
                    },
                  )),
                ),
              ),
            ],
          ),
          savePhaseClick && selectedSource.isEmpty
              ? Container(
                  width: MediaQuery.of(context).size.width * 0.26,
                  margin: EdgeInsets.only(left: 30.0, top: 03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please select resources',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.red,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
          startloading == true
              ? loading == true
                  ? Center(child: const CircularProgressIndicator())
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.26,
                      margin: const EdgeInsets.only(top: 16, left: 30),
                      decoration: BoxDecoration(),
                      child: Expanded(
                        child: Container(
                          //padding: EdgeInsets.only(left: 5, right: 5),
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff334155),
                            //border: Border.all(color:  const Color(0xff1E293B)),

                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              searchTextField = AutoCompleteTextField<Details>(
                                clearOnSubmit: false,
                                key: key,
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 15.0),
                                  prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: Icon(
                                        Icons.search,
                                        color: Color(0xff64748B),
                                      )),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xff64748B),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                ),
                                suggestions: users,
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                                itemFilter: (item, query) {
                                  return item.name!
                                      .toLowerCase()
                                      .startsWith(query.toLowerCase());
                                },
                                itemSorter: (a, b) {
                                  return a.name!.compareTo(b.name!);
                                },
                                itemSubmitted: (item) {
                                  setState(() {
                                    //print(item.title);

                                    searchTextField!
                                        .textField!.controller!.text = '';
                                    if (selectedSource.isNotEmpty) {
                                      if (selectedSource.contains(item.name)) {
                                      } else {
                                        _phaseDetails.resource!.add(
                                            ResourceData(
                                                resource_name: item.name,
                                                resource_id: item.userId,
                                                department_id:
                                                    item.departmentId ?? 0));
                                        listResource.add(PhasesSortedResources(
                                            department: _depat['name'],
                                            details: item));
                                        selectedSource.add(item.name!);
                                      }
                                    } else {
                                      listResource.add(PhasesSortedResources(
                                          department: _depat['name'],
                                          details: item));
                                      _phaseDetails.resource!.add(ResourceData(
                                          resource_name: item.name,
                                          resource_id: item.userId,
                                          department_id:
                                              item.departmentId ?? 0));
                                      selectedSource.add(item.name!);
                                    }
                                  });
                                },
                                itemBuilder: (context, item) {
                                  // ui for the autocompelete row
                                  return rowResourceName(item);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
              : Container(),
          selectedSource.isNotEmpty
              ? SizedBox(
                  height: 55,
                  child: Padding(
                    padding: EdgeInsets.only(left: 28.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedSource.length,
                      itemBuilder: (context, index) {
                        // Skills _skills =
                        //     widget.data!.resource!.skills![index];
                        // var tag = _skills.title;
                        return Container(
                          height: 32.0,
                          margin: const EdgeInsets.only(left: 12.0),
                          child: InputChip(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            deleteIcon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                            backgroundColor: const Color(0xff334155),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            label: Text(
                              selectedSource[index],
                              style: TextStyle(color: Colors.white),
                            ),
                            //  selected: _isSelected!,
                            onSelected: (bool selected) {
                              setState(() {
                                //    _isSelected = selected;
                              });
                            },
                            onDeleted: () {
                              setState(() {
                                removeDuplicate();
                                selectedSubTaskSource.removeWhere((element) =>
                                    element == selectedSource[index]);
                                listResource.removeAt(index);
                                selectedSource.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget mileStoneView() {
    return Form(
      key: _mileStoneFormKey,
      child: Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  clickedAddMileStone == false
                      ? titleHeadlineWidget("Milestones", 18.0)
                      : titleHeadlineWidget(" Add Milestones", 18.0),
                  InkWell(
                    child: clickedAddMileStone == false
                        ? Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Color(0xff93C5FD),
                                ),
                                titleSubHeadlineWidget("Add Milestone", 14.0),
                              ],
                            ),
                          )
                        : clickAddMileStone(),
                    onTap: () {
                      setState(() {
                        savePhaseClick = true;
                      });
                      Future.delayed(const Duration(microseconds: 500), () {
                        if (_formKey.currentState!.validate()) {
                          if (allValidate && selectedSource.isNotEmpty) {
                            setState(() {
                              clickedAddMileStone = true;
                            });
                          }
                        }
                      });
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            savePhaseClick && _phaseDetails.milestone!.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    margin: const EdgeInsets.only(left: 30.0, top: 03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please add milestone',
                          style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.red,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            clickedAddMileStone
                ? formField(
                    controller: controllerMilestoneTitle,
                    context: context,
                    labelText: "Milestone Title",
                    validateCallback: (values) {
                      if (values.isEmpty) {
                        return 'Please enter milestone title';
                      } else {
                        return null;
                      }
                    },
                    callback: (values) {
                      setState(() {
                        mileStoneTitle = values;
                      });
                    },
                  )
                : saveButtonClick
                    ? milestoneList(
                        context,
                        _phaseDetails,
                        callback: (values, index, action) {
                          setState(() {
                            if (action == "Delete") {
                              onDeleteMileStone(index);
                            } else if (action == "Edit") {
                              onEditMileStone(index, values);
                            } else {
                              mileStoneTitle = values.title ?? '';
                            }
                          });
                        },
                      )
                    : Container(),
            const SizedBox(
              height: 8.0,
            ),
            clickedAddMileStone == false
                ? Container()
                : DatePicker(
                    title: "Milestone Date",
                    callback: (value) {
                      setState(() {
                        mileStoneDate = value.trim();
                        print(mileStoneDate);
                      });
                    },
                    startDate: AppUtil.stringToDate(mileStoneDate),
                    validationCallBack: (String values) {
                      if (values.isEmpty) {
                        // checkFormStatus();
                        return 'Please enter milestone date';
                      } else {
                        return null;
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }

  onDeleteMileStone(int index) {
    try {
      if (_phaseDetails.milestone!.length >= index) {
        setState(() {
          _phaseDetails.milestone!.removeAt(index);
        });
      }
    } catch (e) {}
  }

  onEditMileStone(int index, Milestones values) {
    setState(() {
      mileStoneEditIndex = index;
      mileStoneAction = "Edit";
      clickedAddMileStone = true;
      controllerMilestoneTitle.text = values.title ?? "";
      mileStoneTitle = values.title ?? "";
      mileStoneDate = values.m_date ?? AppUtil.dateToString(DateTime.now());
    });
  }

  Widget subtaskView() {
    return Expanded(
      flex: 1,
      child: Form(
        key: _subtaskFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 9, bottom: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  clickAddSubTask == false
                      ? titleHeadlineWidget("Subtasks", 18.0)
                      : titleHeadlineWidget(" Add Subtasks", 18.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      child: Container(
                          child: clickAddSubTask == false
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Color(0xff93C5FD),
                                    ),
                                    titleSubHeadlineWidget(
                                        "Add Subtasks", 14.0),
                                  ],
                                )
                              : clickAddSubtask()),
                      onTap: () {
                        setState(() {
                          setState(() {
                            savePhaseClick = true;
                          });
                          Future.delayed(const Duration(microseconds: 500), () {
                            if (_formKey.currentState!.validate()) {
                              if (allValidate && selectedSource.isNotEmpty) {
                                setState(() {
                                  clickAddSubTask = true;
                                });
                              }
                            }
                          });
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            savePhaseClick && _phaseDetails.sub_tasks!.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    margin: const EdgeInsets.only(left: 30.0, top: 03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please add subtask',
                          style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.red,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            const SizedBox(
              height: 8.0,
            ),
            Column(
              children: [],
            ),
            clickAddSubTask
                ? DatePicker(
                    title: "Start date",
                    callback: (value) {
                      subTaskStartDate = value;
                    },
                    startDate: DateTime.now(),
                    validationCallBack: (String values) {
                      if (values.isEmpty) {
                        return 'Please enter start date';
                      } else {
                        return null;
                      }
                    },
                  )
                : Container(),
            const SizedBox(
              height: 8.0,
            ),
            clickAddSubTask
                ? DatePicker(
                    title: "End date",
                    callback: (value) {
                      subTaskEndDate = value;
                    },
                    startDate: AppUtil.stringToDate(subTaskStartDate),
                    validationCallBack: (String values) {
                      if (values.isEmpty) {
                        checkFormStatus();
                        return 'Please enter end date';
                      } else if (subTaskStartDate.isNotEmpty &&
                          subTaskEndDate.isNotEmpty) {
                        if ((AppUtil.stringToDate(subTaskEndDate).isBefore(
                            (AppUtil.stringToDate(subTaskStartDate))))) {
                          return 'End date must be greater then the start date';
                        }
                      } else {
                        return null;
                      }
                    },
                  )
                : Container(),
            const SizedBox(
              height: 8.0,
            ),
            clickAddSubTask
                ? titleHeadlineWidget("Resources need for subtask", 16)
                : Container(),
            saveSubtaskClick && selectedSubTaskSource.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    margin: EdgeInsets.only(left: 30.0, top: 03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Please select resource',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.red,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            clickAddSubTask
                ? subTaskResourcesView()
                : saveButtonClickForSubtask
                    ? subTaskList(
                        context,
                        _phaseDetails,
                        callback: (values, index, subTaskAction) {
                          if (subTaskAction == 'Delete') {
                            onDeleteSubtask(index);
                          } else if (subTaskAction == 'Edit') {
                            onEditSubtask(index, values);
                          } else {
                            setState(() {
                              mileStoneTitle =
                                  values?.resource?.resource_name ?? '';
                            });
                          }
                        },
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }

  onDeleteSubtask(int index) {
    try {
      if (_phaseDetails.sub_tasks!.length >= index) {
        setState(() {
          _phaseDetails.sub_tasks!.removeAt(index);
          subTaskStartDate = AppUtil.dateToString(DateTime.now());
          subTaskEndDate = AppUtil.dateToString(DateTime.now());
        });
      }
    } catch (e) {}
  }

  onEditSubtask(
    int index,
    SubTasksModel values,
  ) {
    setState(() {
      subTaskEditIndex = index;
      subtaskActionType = "Edit";
      clickAddSubTask = true;
      selectedSubTaskSource.add(values.resource!);
      subTaskEndDate = values.start_date!;
      subTaskEndDate = values.end_date!;
    });
  }

  Widget subTaskResourcesView() {
    return Column(
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 7),
              child: CircleAvatar(
                backgroundColor: Color(0xff334155),
                radius: 30,
                child: Icon(Icons.person_outline),
                // SvgPicture.asset(
                //   'images/photo.svg',
                //   width: 24.0,
                //   height: 24.0,
                // ),
              ),
            ),
            Container(
              // width: 305, //MediaQuery.of(context).size.width * 0.22,

              margin: const EdgeInsets.only(left: 30.0),
              height: 56.0,
              width: (MediaQuery.of(context).size.width * 0.22),
              //width: MediaQuery.of(context).size.width * 0.20,
              // margin: const EdgeInsets.only(right: 30.0),
              decoration: BoxDecoration(
                color: const Color(0xff334155),
                //border: Border.all(color:  const Color(0xff1E293B)),
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                height: 20.0,
                child: Container(
                    // padding: const EdgeInsets.all(2.0),
                    child: StatefulBuilder(
                  builder: (BuildContext context, StateSettersetState) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton(
                        dropdownColor: ColorSelect.class_color,
                        value: subtaskDepat,
                        underline: Container(),
                        hint: const Text(
                          "Select",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xffFFFFFF),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          // Add this
                          Icons.arrow_drop_down,
                          // Add this
                          color: Color(0xff64748B),

                          // Add this
                        ),
                        items: removeDuplicate().map((items) {
                          return DropdownMenuItem(
                            value: items.department,
                            child: Text(
                              items.department!,
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xffFFFFFF),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            resourceSuggestions.clear();
                            for (var element in listResource) {
                              if (element.department!.toLowerCase() ==
                                  newValue.toString().toLowerCase()) {
                                resourceSuggestions.add(element.details!);
                              }
                            }

                            subtaskDepat = newValue.toString();
                            if (newValue != null) {
                              // startloading = true;
                              //getResourcesNeeded(newValue);
                            }
                          });
                        },
                      ),
                    );
                  },
                )),
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.26,
          margin: const EdgeInsets.only(top: 16, left: 30),
          decoration: BoxDecoration(),
          child: Expanded(
            child: Container(
              //padding: EdgeInsets.only(left: 5, right: 5),
              height: 50.0,
              decoration: BoxDecoration(
                color: const Color(0xff334155),
                //border: Border.all(color:  const Color(0xff1E293B)),

                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
              child: Column(
                children: [

                  Container(
                      width: MediaQuery.of(context).size.width * 0.26,
                    child: subTaskResourcesSearchTextField = AutoCompleteTextField<Details>(
                      clearOnSubmit: false,
                      suggestionsAmount: 100,
                      key: subtaskKey,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15.0),
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Icon(
                              Icons.search,
                              color: Color(0xff64748B),
                            )),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff64748B),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                      ),
                      suggestions: resourceSuggestions,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.white, fontSize: 14.0),
                      itemFilter: (item, query) {
                        return item.name!
                            .toLowerCase()
                            .startsWith(query.toLowerCase());
                      },
                      itemSorter: (a, b) {
                        return a.name!.compareTo(b.name!);
                      },
                      itemSubmitted: (item) {
                        setState(() {
                          subTaskResourceName = item.name!;
                          subTaskResourcesSearchTextField!
                              .textField!.controller!.text = '';

                          selectedSubTaskSource.clear();
                          selectedSubTaskSource.add(ResourceData(
                              department_id: item.departmentId,
                              resource_id: item.userId,
                              resource_name: item.name));

                          //
                          // if (selectedSubTaskSource.isNotEmpty) {
                          //   if (selectedSubTaskSource.contains(item.name)) {
                          //   } else {
                          //     selectedSubTaskSource.add(item.name!);
                          //   }
                          // } else {
                          //   selectedSubTaskSource.add(item.name!);
                          // }
                        });
                      },
                      itemBuilder: (context, item) {
                        // ui for the autocompelete row
                        return rowResourceName(item);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        selectedSubTaskSource.isNotEmpty
            ? SizedBox(
                height: 55,
                child: Padding(
                  padding: EdgeInsets.only(left: 28.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedSubTaskSource.length,
                    itemBuilder: (context, index) {
                      // Skills _skills =
                      //     widget.data!.resource!.skills![index];
                      // var tag = _skills.title;
                      return Container(
                        height: 32.0,
                        margin: const EdgeInsets.only(left: 12.0),
                        child: InputChip(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          deleteIcon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          backgroundColor: const Color(0xff334155),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          label: Text(
                            selectedSubTaskSource[index].resource_name ?? '',
                            style: TextStyle(color: Colors.white),
                          ),
                          //  selected: _isSelected!,
                          onSelected: (bool selected) {
                            setState(() {
                              //    _isSelected = selected;
                            });
                          },
                          onDeleted: () {
                            setState(() {
                              selectedSubTaskSource.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  clickAddMileStone() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            child: const Text(
              "Cancel",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xffFFFFFF),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300),
            ),
            onTap: () {
              setState(() {
                mileStoneDate = AppUtil.dateToString(DateTime.now());
                mileStoneTitle = "";
                controllerMilestoneTitle.text = "";
                clickedAddMileStone = false;
                saveButtonClick = true;
              });
            },
          ),
          const SizedBox(
            width: 16,
          ),
          InkWell(
            child: const Text(
              "Save",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xff93C5FD),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              if (_mileStoneFormKey.currentState!.validate()) {
                setState(() {
                  if (mileStoneTitle.isNotEmpty && mileStoneDate.isNotEmpty) {
                    try {
                      if (mileStoneAction.isEmpty) {
                        _phaseDetails.milestone!.add(Milestones(
                            title: mileStoneTitle, m_date: mileStoneDate));
                      } else {
                        _phaseDetails.milestone![mileStoneEditIndex].title =
                            mileStoneTitle;
                        _phaseDetails.milestone![mileStoneEditIndex].m_date =
                            mileStoneDate;
                      }

                      mileStoneEditIndex = 0;
                      mileStoneAction = '';

                      mileStoneDate = AppUtil.dateToString(DateTime.now());
                      mileStoneTitle = "";
                      controllerMilestoneTitle.text = "";
                      clickedAddMileStone = false;
                      saveButtonClick = true;
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    print('Add milestone date');
                  }

                  // clickedAddMileStone = ;
                });
              }
            },
          )
        ],
      ),
    );
  }

  clickAddSubtask() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            child: Text(
              "Cancel",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xffFFFFFF),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300),
            ),
            onTap: () {
              setState(() {
                selectedSubTaskSource.clear();
                subTaskEndDate = "";
                subTaskEndDate = "";
                clickAddSubTask = false;
                saveButtonClickForSubtask = true;
              });
            },
          ),
          const SizedBox(
            width: 16,
          ),
          InkWell(
            child: const Text(
              "Save",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xff93C5FD),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              setState(() {
                saveSubtaskClick = true;
                if (_subtaskFormKey.currentState!.validate()) {
                  if (selectedSubTaskSource.isNotEmpty &&
                      subTaskEndDate.isNotEmpty &&
                      subTaskEndDate.isNotEmpty) {
                    try {
                      if (subtaskActionType.isEmpty) {
                        _phaseDetails.sub_tasks!.add(SubTasksModel(
                            resource: selectedSubTaskSource[0],
                            end_date: subTaskEndDate,
                            start_date: subTaskStartDate));
                        subtaskActionType = '';
                      } else {
                        _phaseDetails.sub_tasks![subTaskEditIndex] =
                            SubTasksModel(
                                resource: selectedSubTaskSource[0],
                                end_date: subTaskEndDate,
                                start_date: subTaskStartDate);
                        subtaskActionType = '';
                      }

                      selectedSubTaskSource.clear();
                      subTaskEndDate = "";
                      subTaskEndDate = "";
                      clickAddSubTask = false;
                      saveButtonClickForSubtask = true;
                      saveSubtaskClick = false;
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    print('Enter sub task data');
                  }
                }

                // clickedAddMileStone = ;
              });
            },
          )
        ],
      ),
    );
  }

  titleHeadlineWidget(String title, double i) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, top: 10.0, bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
            color: const Color(0xffFFFFFF),
            fontSize: i,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700),
      ),
    );
  }

  titleSubHeadlineWidget(String title, double i) {
    return Container(
      margin:
          const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0, right: 20),
      child: Text(
        title,
        style: TextStyle(
            color: const Color(0xff93C5FD),
            fontSize: i,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700),
      ),
    );
  }

  createPhase() {
    _phaseDetails.project_id = widget.id;
    allValidate = true;
    if (_formKey.currentState!.validate()) {
      if (allValidate && _phaseDetails.milestone!.isNotEmpty) {
        if (widget.type == 1) {
          updatePhaseApi();
        } else {
          addNewPhaseApi();
        }
      }
    }
  }

  getDepartment() async {
    List department = [];
    department = await api.getDeparment();
    if (department != null) {
      setState(() {
        _department = department;
      });
    }
  }

  getPhaseDetailsByID(String id) async {
    try {
      SmartDialog.showLoading(
        msg: "Your request is in progress please wait for a while...",
      );
      getPhaseDetails = await api.getPhaseDetails(id);
      if (getPhaseDetails!.status == true &&
          getPhaseDetails!.statusCode == 200) {
        setState(() {
          phaseInitialData();
        });
      } else {
        print('');
      }
      SmartDialog.dismiss();
    } catch (e) {
      SmartDialog.dismiss();
      print(e);
    }
  }

  addNewPhaseApi() async {
    SmartDialog.showLoading(
      msg: "Your request is in progress please wait for a while...",
    );
    try {
      //CreatePhaseResp createPhaseResp = await api.createNewPhase(phaseDetailsToJson(_phaseDetails));
      CreatePhaseResp createPhaseResp =
          await api.createNewPhase(json.encode(_phaseDetails));
      if (createPhaseResp.status == true) {
        Navigator.pop(context);
      }
      SmartDialog.dismiss();
    } catch (e) {
      SmartDialog.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.grey,
      );
      print(e);
    }
  }

  updatePhaseApi() async {
    SmartDialog.showLoading(
      msg: "Your request is in progress please wait for a while...",
    );
    try {
      //CreatePhaseResp createPhaseResp = await api.createNewPhase(phaseDetailsToJson(_phaseDetails));
      UpdatePhaseResp updatePhaseResp =
          await api.updatePhase(json.encode(_phaseDetails), widget.id);
      if (updatePhaseResp.status == true) {
        Navigator.pop(context);
      }
      SmartDialog.dismiss();
    } catch (e) {
      SmartDialog.dismiss();
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.grey,
      );
      print(e);
    }
  }

  getResourcesNeeded(String newValue) async {
    abc.clear();
    setState(() {
      loading = true;
    });
    resourceNeededModel = await api.getResourceNeeded(newValue);
    if (resourceNeededModel != null && resourceNeededModel!.data != null) {
      if (resourceNeededModel!.data!.isNotEmpty) {
        users = resourceNeededModel!.data!;
        for (int i = 0; i < resourceNeededModel!.data!.length; i++) {
          abc.add(resourceNeededModel!.data![i].name.toString());
        }
      } else {}
    }
    setState(() {
      loading = false;
    });
    print(abc);
    print(abc);
  }

  List<PhasesSortedResources> removeDuplicate() {
    var seen = Set<String>();
    List<PhasesSortedResources> uniquelist =
        listResource.where((item) => seen.add(item.department!)).toList();

    // return listResource
    //     .map((f) => f.toString())
    //     .toSet()
    //     .toList()
    //     .map((f) => json.decode(f) as List<dynamic>)
    //     .toList();
    return uniquelist;
  }

  beforeScreenLoad() {
    _phaseDetails.start_date = AppUtil.dateToString(DateTime.now());
    _phaseDetails.end_date = AppUtil.dateToString(DateTime.now());
    mileStoneDate = AppUtil.dateToString(DateTime.now());
    subTaskStartDate = AppUtil.dateToString(DateTime.now());
    subTaskEndDate = AppUtil.dateToString(DateTime.now());
  }


}

class PhasesSortedResources {
  String? department;
  Details? details;

  PhasesSortedResources({required this.department, required this.details});
}
