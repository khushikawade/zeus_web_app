import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/helper_widget/search_view.dart';
import 'package:zeus/helper_widget/milstoneList.dart';
import 'package:zeus/helper_widget/select_datefield.dart';
import 'package:zeus/helper_widget/subTaskList.dart';
import 'package:zeus/helper_widget/textformfield.dart';
import 'package:zeus/services/api.dart';
import 'package:zeus/services/model/mileston_model.dart';
import 'package:zeus/services/model/phase_details.dart';
import 'package:zeus/services/model/resourcedata.dart';
import 'package:zeus/services/model/resources_needed.dart';
import 'package:zeus/services/model/subtask_model.dart';
import 'package:zeus/services/response_model/create_phase_resp.dart';
import 'package:zeus/services/response_model/get_phase_details_resp.dart';
import 'package:zeus/services/response_model/update_phase_resp.dart';
import 'package:zeus/utility/colors.dart';
import 'package:zeus/utility/util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewPhase extends StatefulWidget {
  String id;
  int type; // type==0 new, type ==1 edit
  NewPhase(this.id, this.type, {Key? key}) : super(key: key);

  @override
  State<NewPhase> createState() => _NewPhaseState();
}

class _NewPhaseState extends State<NewPhase> {
  PhaseDetails phaseDetails =
      PhaseDetails(sub_tasks: [], resource: [], milestone: []);
  TextEditingController controller_next_phase = TextEditingController();
  TextEditingController controllerMilestoneTitle = TextEditingController();
  TextEditingController controller_phase_type = TextEditingController();
  ResourceNeededModel? resourceNeededModel;
  GetPhaseDetails? getPhaseDetails;
  static List<Details> users = <Details>[];
  static List<Details> resourceSuggestions = <Details>[];
  bool loading = true;
  bool startloading = false;
  dynamic? _depat;
  String? selectUser, subtaskDepat;
  List _department = [];
  Api api = Api();
  // DateTime startDates = DateTime.now().subtract(Duration(days: 40));
  // DateTime endDates = DateTime.now().add(Duration(days: 40));
  DateTime selectedDate = DateTime.now();
  String dropdownvalue = 'Type';
  bool clickedAddMileStone = false;
  bool clickAddSubTask = false;
  bool saveButtonClick = false;
  bool saveButtonClickForSubtask = false;
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

  String mileStoneTitle = "";
  String mileStoneDate = AppUtil.dateToString(DateTime.now());

  String subTaskStartDate = AppUtil.dateToString(DateTime.now());
  String subTaskEndDate = AppUtil.dateToString(DateTime.now());
  String subTaskResourceName = "";

  bool allValidate = true;
  bool savePhaseClick = false;
  bool saveSubtaskClick = false;

  bool addMilestoneBtnClick = false;
  bool addSubtaskBtnClick = false;

  TypeAheadFormField? searchTextField;
  TypeAheadFormField? subTaskResourcesSearchTextField;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _subTaskResourcesController =
      TextEditingController();

  checkFormStatus() {
    setState(() {
      allValidate = false;
    });
  }

  phaseInitialData() {
    if (getPhaseDetails != null &&
        getPhaseDetails!.statusCode == 200 &&
        getPhaseDetails!.status == true) {
      phaseDetails.statusCode = 200;
      if (getPhaseDetails!.data != null) {
        setState(() {
          phaseDetails.start_date = getPhaseDetails?.data?.startDate ?? "";
          phaseDetails.end_date = getPhaseDetails?.data?.endDate ?? "";
        });

        phaseDetails.phase_type = getPhaseDetails?.data?.phaseType ?? "";
        controller_phase_type.text = getPhaseDetails?.data?.phaseType ?? "";
        controller_next_phase.text = getPhaseDetails?.data?.title ?? "";
        phaseDetails.title = getPhaseDetails?.data?.title ?? "";
        if (getPhaseDetails!.data!.assignedResources != null &&
            getPhaseDetails!.data!.assignedResources!.isNotEmpty) {
          getPhaseDetails!.data!.assignedResources!.forEach((element) {
            listResource.add(PhasesSortedResources(
                details: Details(
                    id: element.resourceId ?? 0,
                    name: element.resource?.name ?? "",
                    departmentId: element.departmentId,
                    departmentName: element.department?.name ?? '',
                    image: element.resource?.image ?? ""),
                department: element.department?.name ?? ""));

            selectedSource.add(element.resource?.name ?? "");

            phaseDetails.resource!.add(ResourceData(
                department_id: element.departmentId ?? 0,
                resource_id: element.resourceId ?? 0,
                resource_name: element.resource?.name ?? ''));
          });
        }

        if (getPhaseDetails!.data!.milestone != null &&
            getPhaseDetails!.data!.milestone!.isNotEmpty) {
          saveButtonClick = true;
          getPhaseDetails!.data!.milestone!.forEach((element) {
            phaseDetails.milestone!
                .add(Milestones(title: element.title, m_date: element.mDate));
          });
        }

        if (getPhaseDetails!.data!.subTasks != null &&
            getPhaseDetails!.data!.subTasks!.isNotEmpty) {
          saveButtonClickForSubtask = true;
          getPhaseDetails!.data!.subTasks!.forEach((element) {
            phaseDetails.sub_tasks!.add(SubTasksModel(
                end_date: element.startDate,
                start_date: element.endDate,
                resource: ResourceData(
                    department_id: element.assignResource?.departmentId ?? 0,
                    resource_id: element.assignResource?.resourceId ?? 0,
                    resource_name: element.assignResource?.resource?.name ?? '',
                    department_name:
                        element.assignResource?.department?.name ?? '',
                    profileImage:
                        element.assignResource?.resource?.image ?? '')));
          });
          print(phaseDetails);
        }
      }
    }
  }

  @override
  void initState() {
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
          child: RawScrollbar(
            thumbColor: const Color(0xff4b5563),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            thickness: 8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      // height: MediaQuery.of(context).size.height * 0.11,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xff283345),
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
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: titleHeadlineWidget("New Phase", 22.0),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 97.0,
                                    margin: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
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
                                            fontSize: 14.0,
                                            color: Color(0xffFFFFFF),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                InkWell(
                                  child: Container(
                                    width: 97,
                                    margin: const EdgeInsets.only(
                                        top: 10.0, right: 20.0, bottom: 10.0),
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7DD3FC),
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
                          height: MediaQuery.of(context).size.height * 1.5,
                          child: const VerticalDivider(
                            color: Color(0xff94A3B8),
                            thickness: 0.2,
                          )),
                      mileStoneView(),
                      Container(
                          height: MediaQuery.of(context).size.height * 1.5,
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

  List<Details> getSuggestions(String query) {
    List<Details> matches = List.empty(growable: true);
    matches.addAll(users);
    matches.retainWhere(
        (s) => s.name!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<Details> getSuggestionsForSubTask(String query) {
    List<Details> matches = List.empty(growable: true);
    matches.addAll(resourceSuggestions);
    matches.retainWhere(
        (s) => s.name!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  // Phase view
  Widget phaseView() {
    return Expanded(
      flex: 1,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  titleHeadlineWidget("Phase details", 18.0),
                ],
              ),
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
                    phaseDetails.title = values;
                  });
                },
                validateCallback: (value) {
                  if (value.isEmpty) {
                    return 'Please enter phase title';
                  }
                  return null;
                }),
            const SizedBox(
              height: 10.0,
            ),
            formField(
                controller: controller_phase_type,
                labelText: "Phase Type",
                context: context,
                callback: (values) {
                  setState(() {
                    phaseDetails.phase_type = values;
                  });
                },
                validateCallback: (value) {
                  if (value.isEmpty) {
                    return 'Please enter phase type';
                  }
                  return null;
                }),
            const SizedBox(
              height: 10.0,
            ),
            DatePicker(
              subtitle: 'Start date',
              title: "Start date",
              callback: (value) {
                setState(() {
                  phaseDetails.start_date = value;
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
              height: 10.0,
            ),
            DatePicker(
              subtitle: 'end date',
              title: "End date",
              callback: (value) {
                setState(() {
                  phaseDetails.end_date = value;
                });
              },
              startDate: phaseDetails.sub_tasks!.isNotEmpty
                  ? DateTime.now().add(Duration(days: 10))
                  : DateTime.now(),
              validationCallBack: (String values) {
                if (values.isEmpty) {
                  checkFormStatus();
                  return 'Please enter end date';
                } else if (phaseDetails.end_date != null &&
                    phaseDetails.start_date != null) {
                  if ((AppUtil.stringToDate(phaseDetails.end_date!).isBefore(
                      (AppUtil.stringToDate(phaseDetails.start_date!))))) {
                    return 'End date must be greater then the start date';
                  }
                } else {
                  return null;
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: titleHeadlineWidget("Resources needed", 16.0),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.26,
              margin: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundColor: Color(0xff334155),
                            radius: 30,
                            child: Icon(
                              Icons.person_outline,
                              size: 35,
                              color: Color(0xffDADADA),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Color(0xff10B981),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                  child: Icon(Icons.add,
                                      color: Colors.white, size: 18)),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      width: (MediaQuery.of(context).size.width * 3),
                      height: 56.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff334155),
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        height: 20.0,
                        child: Container(child: StatefulBuilder(
                          builder: (BuildContext context, StateSettersetState) {
                            return DropdownButtonHideUnderline(
                              child: CustomDropdownButton(
                                dropdownColor: ColorSelect.class_color,
                                value: _depat,
                                underline: Container(),
                                hint: const Text(
                                  "Type",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xffFFFFFF),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                                // isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xff64748B),
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
                                      getResourcesNeeded(
                                          newValue['id'].toString());
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        )),
                      ),
                    ),
                  ),
                ],
              ),
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
                        height: 50.0,
                        width: MediaQuery.of(context).size.width * 0.22,
                        margin: const EdgeInsets.only(top: 16, left: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xff1E293B),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: const Color(0xff1E293B),
                          //     offset: Offset(0, 1),
                          //     spreadRadius: 1, //spread radius
                          //     blurRadius: 1, // blur radius
                          //   ),
                          //   //you can set more BoxShadow() here
                          // ],
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 2.0,
                                offset: Offset(0.0, 0.75))
                          ],
                          borderRadius: BorderRadius.circular(
                            6.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            searchTextField = TypeAheadFormField(
                              keepSuggestionsOnLoading: false,
                              suggestionsBoxVerticalOffset: 0.0,
                              suggestionsBoxDecoration:
                                  SuggestionsBoxDecoration(
                                      color: Color(0xff0F172A)),
                              hideOnLoading: true,
                              suggestionsCallback: (pattern) {
                                return getSuggestions(pattern);
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _typeAheadController,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.white,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  // border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(top: 15.0, left: 10),
                                  prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: Icon(
                                        Icons.search,
                                        color: Color(0xff64748B),
                                      )),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                ),
                              ),
                              itemBuilder: (context, item) {
                                return
                                    // Text(
                                    //   item.name.toString(),
                                    //   style: const TextStyle(
                                    //       fontSize: 16.0, color: Colors.white),
                                    // );
                                    // Text("khushi");
                                    rowResourceName(item);
                              },
                              transitionBuilder:
                                  (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected: (item) {
                                setState(() {
                                  searchTextField!.textFieldConfiguration
                                      .controller!.text = '';

                                  if (selectedSource.isNotEmpty) {
                                    if (selectedSource.contains(item.name)) {
                                    } else {
                                      phaseDetails.resource!.add(ResourceData(
                                          resource_name: item.name,
                                          resource_id: item.userId,
                                          department_name: item.departmentName,
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
                                    phaseDetails.resource!.add(ResourceData(
                                        resource_name: item.name,
                                        resource_id: item.userId,
                                        department_name: item.departmentName,
                                        department_id: item.departmentId ?? 0,
                                        profileImage: item.image));
                                    selectedSource.add(item.name!);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      )
                : Container(),
            selectedSource.isNotEmpty
                ? SizedBox(
                    height: 55,
                    child: Padding(
                        padding: EdgeInsets.only(left: 28.0),
                        child:
                            //  ListView.builder(
                            //   scrollDirection: Axis.horizontal,
                            //   itemCount: selectedSource.length,
                            //   itemBuilder: (context, index) {
                            //     return
                            Wrap(
                                spacing: 8,
                                children: List.generate(selectedSource.length,
                                    (index) {
                                  return Container(
                                    height: 32.0,
                                    margin: const EdgeInsets.only(left: 12.0),
                                    child: InputChip(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
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
                                      onSelected: (bool selected) {
                                        setState(() {});
                                      },
                                      onDeleted: () {
                                        setState(() {
                                          removeDuplicate();
                                          selectedSubTaskSource.removeWhere(
                                              (element) =>
                                                  element ==
                                                  selectedSource[index]);
                                          listResource.removeAt(index);
                                          selectedSource.removeAt(index);
                                        });
                                      },
                                      showCheckmark: false,
                                    ),
                                  );
                                }))
                        //   },
                        // ),
                        ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget mileStoneView() {
    return Expanded(
      flex: 1,
      child: Form(
        key: _mileStoneFormKey,
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [Text("Data1"), Text("Data1")],
        // )
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  clickedAddMileStone == false
                      ? titleHeadlineWidget("Milestones", 18.0)
                      : titleHeadlineWidget("Add Milestones", 18.0),
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
                                SizedBox(
                                  width: 10,
                                ),
                                titleSubHeadlineWidget("Add Milestone", 14.0),
                              ],
                            ),
                          )
                        : clickAddMileStone(),
                    onTap: () {
                      setState(() {
                        addMilestoneBtnClick = true;
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
            clickedAddMileStone
                ? Container(
                    // color: Colors.red,
                    child: formField(
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
                    ),
                  )
                : saveButtonClick
                    ? milestoneList(
                        context,
                        phaseDetails,
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
                    subtitle: 'Milestone',
                    title: "Milestone Date",
                    callback: (value) {
                      setState(() {
                        mileStoneDate = value.trim();
                        print(mileStoneDate);
                      });
                    },
                    startDate: widget.type == 0
                        ? null
                        : AppUtil.stringToDate(mileStoneDate),
                    validationCallBack: (String values) {
                      if (values.isEmpty) {
                        return 'Please enter milestone date';
                      } else {
                        return null;
                      }
                    },
                  ),
            savePhaseClick && phaseDetails.milestone!.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    margin: const EdgeInsets.only(left: 30.0, top: 03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }

  onDeleteMileStone(int index) {
    try {
      if (phaseDetails.milestone!.length >= index) {
        setState(() {
          phaseDetails.milestone!.removeAt(index);
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
              padding: const EdgeInsets.only(top: 9, bottom: 0, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  clickAddSubTask == false
                      ? titleHeadlineWidget("Subtasks", 18.0)
                      : titleHeadlineWidget("Add Subtasks", 18.0),
                  InkWell(
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: titleSubHeadlineWidget(
                                        "Add Subtasks", 14.0),
                                  )
                                ],
                              )
                            : clickAddSubtask()),
                    onTap: () {
                      setState(() {
                        savePhaseClick = true;
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
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            clickAddSubTask
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 15),
                    child: DatePicker(
                      subtitle: 'subTask',
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
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 8.0,
            ),
            clickAddSubTask
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DatePicker(
                      subtitle: 'subTask',
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
                    ),
                  )
                : Container(),
            clickAddSubTask
                ? Padding(
                    padding: EdgeInsets.only(left: 5, bottom: 10),
                    child: titleHeadlineWidget(
                        "Resources needed for the subtasks", 16),
                  )
                : Container(),
            clickAddSubTask && saveSubtaskClick && selectedSubTaskSource.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    margin: EdgeInsets.only(left: 0.0, top: 03),
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
                    ? Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: subTaskList(
                          context,
                          phaseDetails,
                          callback: (values, index, subTaskAction) {
                            if (subTaskAction == 'Delete') {
                              onDeleteSubtask(index);
                            } else if (subTaskAction == 'Edit') {
                              onEditSubtask(index, values);
                            } else {
                              setState(() {
                                mileStoneTitle =
                                    values.resource?.resource_name ?? '';
                              });
                            }
                          },
                        ),
                      )
                    : Container(),
            savePhaseClick && phaseDetails.sub_tasks!.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    margin: const EdgeInsets.only(left: 10.0, top: 03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }

  onDeleteSubtask(int index) {
    try {
      if (phaseDetails.sub_tasks!.length >= index) {
        setState(() {
          phaseDetails.sub_tasks!.removeAt(index);
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 15, right: 18),
          width: MediaQuery.of(context).size.width * 3,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        backgroundColor: Color(0xff334155),
                        radius: 30,
                        child: Icon(Icons.person_outline,
                            size: 35, color: Color(0xffDADADA)),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Color(0xff10B981),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                              child: Icon(Icons.add,
                                  color: Colors.white, size: 18)),
                        ))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20.0),
                  height: 56.0,
                  decoration: BoxDecoration(
                    // color:
                    // Colors.red,
                    color: const Color(0xff334155),
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    height: 20.0,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSettersetState) {
                        return DropdownButtonHideUnderline(
                          child: CustomDropdownButton(
                            dropdownColor: ColorSelect.class_color,
                            value: subtaskDepat,
                            underline: Container(),
                            hint: const Text(
                              "Type",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xffFFFFFF),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                            //  isExpanded: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xff64748B),
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
                                selectedSubTaskSource.clear();
                              });
                              setState(() {
                                resourceSuggestions.clear();
                                for (var element in listResource) {
                                  if (element.department!.toLowerCase() ==
                                      newValue.toString().toLowerCase()) {
                                    resourceSuggestions.add(element.details!);
                                  }
                                }
                                subtaskDepat = newValue.toString();
                                if (newValue != null) {}
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width * 0.24,
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: Color(0xff1E293B),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black38,
                    blurRadius: 2.0,
                    offset: Offset(0.0, 0.75))
              ],
              borderRadius: BorderRadius.circular(
                6.0,
              ),
            ),
            child: Column(
              children: [
                subTaskResourcesSearchTextField = TypeAheadFormField(
                  keepSuggestionsOnLoading: false,
                  suggestionsBoxVerticalOffset: 0.0,
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      color: const Color(0xff0F172A)),
                  hideOnLoading: true,
                  suggestionsCallback: (pattern) {
                    return getSuggestionsForSubTask(pattern);
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _subTaskResourcesController,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 14.0),
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white,
                    autofocus: true,
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
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400),
                      border: InputBorder.none,
                    ),
                  ),
                  itemBuilder: (context, item) {
                    return rowResourceName(item);
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (item) {
                    setState(() {
                      subTaskResourceName = item.name!;
                      _subTaskResourcesController.text = '';

                      selectedSubTaskSource.clear();
                      selectedSubTaskSource.add(ResourceData(
                          department_id: item.departmentId,
                          resource_id: item.userId,
                          resource_name: item.name,
                          profileImage: item.image,
                          department_name: item.departmentName));
                    });
                  },
                ),
              ],
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
                          onSelected: (bool selected) {
                            setState(() {});
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
      padding: const EdgeInsets.only(top: 12, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (mileStoneTitle.isNotEmpty && mileStoneDate.isNotEmpty) {
                  try {
                    setState(() {
                      if (mileStoneAction.isEmpty) {
                        phaseDetails.milestone!.add(Milestones(
                            title: mileStoneTitle, m_date: mileStoneDate));
                      } else {
                        phaseDetails.milestone![mileStoneEditIndex].title =
                            mileStoneTitle;
                        phaseDetails.milestone![mileStoneEditIndex].m_date =
                            mileStoneDate;
                      }

                      mileStoneEditIndex = 0;
                      mileStoneAction = '';

                      mileStoneDate = AppUtil.dateToString(DateTime.now());
                      mileStoneTitle = "";
                      controllerMilestoneTitle.text = "";
                      clickedAddMileStone = false;
                      saveButtonClick = true;
                    });
                  } catch (e) {
                    print(e);
                  }
                } else {
                  print('Add milestone date');
                }
              }
            },
          )
        ],
      ),
    );
  }

  clickAddSubtask() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 20),
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
                        phaseDetails.sub_tasks!.add(SubTasksModel(
                          resource: selectedSubTaskSource[0],
                          end_date: subTaskEndDate,
                          start_date: subTaskStartDate,
                        ));
                        subtaskActionType = '';
                      } else {
                        phaseDetails.sub_tasks![subTaskEditIndex] =
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
              });
            },
          )
        ],
      ),
    );
  }

  titleHeadlineWidget(String title, double i) {
    return Container(
      margin: title == "Resources needed" ||
              title == "Resources needed for the subtasks"
          ? const EdgeInsets.only(left: 10.0, top: 0.0, bottom: 10.0)
          : const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
            color: const Color(0xffFFFFFF),
            fontSize: i,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500),
      ),
    );
  }

  titleSubHeadlineWidget(String title, double i) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 14),
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
    phaseDetails.project_id = widget.id;
    allValidate = true;
    if (_formKey.currentState!.validate()) {
      if (allValidate && phaseDetails.milestone!.isNotEmpty) {
        if (phaseDetails.milestone!.isNotEmpty &&
            phaseDetails.sub_tasks!.isNotEmpty) {
          if (widget.type == 1) {
            updatePhaseApi();
          } else {
            addNewPhaseApi();
          }
        }
      }
    }
  }

  getDepartment() async {
    List department = [];
    department = await api.getDeparment(context);
    setState(() {
      _department = department;
    });
  }

  getPhaseDetailsByID(String id) async {
    try {
      SmartDialog.showLoading(
        msg: "Your request is in progress please wait for a while...",
      );
      getPhaseDetails = await api.getPhaseDetails(id, context);
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
      CreatePhaseResp createPhaseResp =
          await api.createNewPhase(json.encode(phaseDetails), context);
      if (createPhaseResp.status == true) {
        Navigator.pop(context, true);
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
      UpdatePhaseResp updatePhaseResp =
          await api.updatePhase(json.encode(phaseDetails), widget.id, context);
      if (updatePhaseResp.status == true) {
        Navigator.pop(context, true);
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
    setState(() {
      loading = true;
    });
    resourceNeededModel = await api.getResourceNeeded(newValue, context);
    if (resourceNeededModel != null && resourceNeededModel!.data != null) {
      if (resourceNeededModel!.data!.isNotEmpty) {
        users = resourceNeededModel!.data!;
      } else {}
    }
    setState(() {
      loading = false;
    });
  }

  List<PhasesSortedResources> removeDuplicate() {
    var seen = Set<String>();
    List<PhasesSortedResources> uniquelist =
        listResource.where((item) => seen.add(item.department!)).toList();

    return uniquelist;
  }

  beforeScreenLoad() {
    phaseDetails.start_date = AppUtil.dateToString(DateTime.now());
    phaseDetails.end_date = AppUtil.dateToString(DateTime.now());
    mileStoneDate = AppUtil.dateToString(DateTime.now());
    subTaskStartDate = AppUtil.dateToString(DateTime.now());
    subTaskEndDate = AppUtil.dateToString(DateTime.now());
  }

  void editPhaseApi() {}
}

class PhasesSortedResources {
  String? department;
  Details? details;

  PhasesSortedResources({required this.department, required this.details});
}
