import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:zeus/helper_widget/custom_datepicker.dart';
import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/helper_widget/custom_form_field.dart';
import 'package:zeus/helper_widget/custom_search_dropdown.dart';
import 'package:zeus/helper_widget/custom_search_for_subtask.dart';
import 'package:zeus/helper_widget/search_view.dart';
import 'package:zeus/helper_widget/milstoneList.dart';
import 'package:zeus/helper_widget/select_datefield.dart';
import 'package:zeus/helper_widget/subTaskList.dart';
import 'package:zeus/helper_widget/textformfield.dart';
import 'package:zeus/phase_module/model/department_model.dart';
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
import 'package:zeus/utility/debouncer.dart';
import 'package:zeus/utility/util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  dynamic _depat;
  String? selectUser, subtaskDepat;
  List<DepartementData> _department = [];
  Api api = Api();
  // DateTime startDates = DateTime.now().subtract(Duration(days: 40));
  // DateTime endDates = DateTime.now().add(Duration(days: 40));
  DateTime selectedDate = DateTime.now();
  String dropdownvalue = 'Type';
  bool clickedAddMileStone = false;
  bool clickAddSubTask = false;
  bool saveButtonClick = false;
  bool saveButtonClickForSubtask = false;
  bool saveButtonClickForSubtask1 = false;
  bool saveButtonClickForMileStone = false;
  bool mileStoneDateCheck = true;
  bool subtaskdateCheck = true;
  bool createButtonClick = false;
  List<String> selectedSource = [];
  List<PhasesSortedResources> listResource = [];
  // List<ResourceData> selectedSubTaskSource = [];
  List<ResourceData> selectedSubTaskSource = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _mileStoneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _subtaskFormKey = GlobalKey<FormState>();

  String mileStoneAction = '';
  int mileStoneEditIndex = 0;

  String subtaskActionType = '';
  int subTaskEditIndex = 0;

  String mileStoneTitle = "";
  // String mileStoneDate = AppUtil.dateToString(DateTime.now());
  DateTime? mileStoneDate;

  String? subTaskStartDate = "";
  String? subTaskEndDate = "";
  String subTaskResourceName = "";
  DateTime? milestoneEndDate = DateTime.now();
  String? milestoneStartDate = "";

  bool allValidate = true;
  bool savePhaseClick = false;
  bool saveSubtaskClick = false;
  bool isEditDataLoading = false;

  bool addMilestoneBtnClick = false;
  bool addSubtaskBtnClick = false;

  bool savePhaseValidate = true;
  String name_ = '';
  List<DropdownModel> departmentlist = [];
  TypeAheadFormField? searchTextField;
  TypeAheadFormField? subTaskResourcesSearchTextField;
  TypeAheadFormField? searchTextFieldForLanguage;
  TypeAheadFormField? searchTextFieldForphaseLanguage;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _subTaskResourcesController =
      TextEditingController();
  final TextEditingController _subTaskLangugaeController =
      TextEditingController();
  final TextEditingController _phaseLangugaeController =
      TextEditingController();

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

        _depat = getPhaseDetails!.data!.assignedResources![0].departmentId;

        subtaskDepat = getPhaseDetails!
            .data!.subTasks![0].assignResource!.departmentId
            .toString();

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
                end_date: element.endDate,
                start_date: element.startDate,
                resource: ResourceData(
                    department_id: element.assignResource?.departmentId ?? 0,
                    resource_id: element.assignResource?.resourceId ?? 0,
                    resource_name: element.assignResource?.resource?.name ?? '',
                    department_name:
                        element.assignResource?.department?.name ?? '',
                    profileImage:
                        element.assignResource?.resource?.image ?? '')));
          });
          // listResorceDropDown = [];
          // phaseDetails.sub_tasks!.forEach(
          //   (element) {
          //     listResorceDropDown.add(DropdownModel(
          //         element.resource!.department_id,
          //         element.resource!.department_name.toString()));
          //   },
          // );
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
      isEditDataLoading = true;
      getPhaseDetailsByID(widget.id);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.zero,
        backgroundColor: const Color(0xff1E293B),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.99.w,
          height: double.infinity,
          child: RawScrollbar(
            thumbColor: const Color(0xff4b5563),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            thickness: 8,
            child: isEditDataLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(top: 15.sp, bottom: 15.sp),
                            // height: MediaQuery.of(context).size.height * 0.11,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Color(0xff283345),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16.0.r),
                                topLeft: Radius.circular(16.0.r),
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
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 30.sp, right: 30.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  titleHeadlineWidget("New Phase", 22.0.sp),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 97.0.w,
                                            margin: EdgeInsets.only(
                                                top: 10.0.sp, bottom: 10.0.sp),
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                40.0.r,
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontSize: 14.0.sp,
                                                    color: Color(0xffFFFFFF),
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16.w,
                                        ),
                                        InkWell(
                                          child: Container(
                                            width: 97.w,
                                            margin: EdgeInsets.only(
                                                top: 10.0.sp, bottom: 10.0.sp),
                                            height: 40.0.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff7DD3FC),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                40.0.r,
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                    fontSize: 14.0.sp,
                                                    color: Color(0xff000000),
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              savePhaseClick = true;
                                              createButtonClick = true;
                                            });

                                            Future.delayed(
                                                const Duration(
                                                    microseconds: 500), () {
                                              createPhase();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            phaseView(),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 1.2,
                                child: const VerticalDivider(
                                  color: Color(0xff94A3B8),
                                  thickness: 0.2,
                                )),
                            mileStoneView(),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 1.2,
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

  List<PhasesSortedResources> getSuggestionsForType(String query) {
    // List<Details> matches = List.empty(growable: true);
    // matches.addAll(users);
    // matches.retainWhere(
    //     (s) => s.name!.toLowerCase().contains(query.toLowerCase()));
    // return matches;
    var seen = Set<String>();
    List<PhasesSortedResources> uniquelist =
        listResource.where((item) => seen.add(item.department!)).toList();
    List<PhasesSortedResources> matches = List.empty(growable: true);
    matches.clear();
    matches.addAll(uniquelist);
    matches.retainWhere((element) =>
        element.department!.toLowerCase().contains(query.toLowerCase()));

    return matches;
  }

  List<DepartementData> getSuggestionsForPhaseType(String query) {
    List<DepartementData> matches = List.empty(growable: true);
    matches.addAll(_department);
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
            Padding(
              padding: EdgeInsets.only(left: 30.sp, top: 18.5.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  titleHeadlineWidget("Phase details", 18.0.sp),
                ],
              ),
            ),
            SizedBox(
              height: 8.0.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.sp, right: 62.5.sp, top: 24.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormField(
                    controller: controller_next_phase,
                    maxline: 1,
                    fontSizeForLabel: 14.sp,
                    label: 'Phase Title',
                    // contentpadding:
                    //     EdgeInsets.only(left: 16, bottom: 10, right: 10, top: 10),
                    // hintTextHeight: 1.7,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter phase title';
                      } else {
                        setState(() {
                          print(value);
                          phaseDetails.title = value;
                          //savePhaseValidate = false;
                        });
                      }

                      return null;
                    },
                    onChange: (text) => setState(() => name_ = text),
                  ),
                  CustomFormField(
                    controller: controller_phase_type,
                    maxline: 1,
                    fontSizeForLabel: 14.sp,
                    label: 'Phase Type',
                    // contentpadding:
                    //     EdgeInsets.only(left: 16, bottom: 10, right: 10, top: 10),
                    // hintTextHeight: 1.7,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter phase type';
                      } else {
                        setState(() {
                          print(value);
                          phaseDetails.phase_type = value;
                          //savePhaseValidate = false;
                        });
                      }
                      return null;
                    },
                    onChange: (text) => setState(() => name_ = text),
                  ),
                  CustomDatePicker(
                    hint: 'dd/mm/yyyy',
                    label: "Start date",
                    initialDate: widget.type == 0
                        ? null
                        : AppUtil.stringToDate(
                            phaseDetails.start_date.toString()),
                    onChange: (date) {
                      setState(() {
                        phaseDetails.start_date = date.toString();
                        milestoneStartDate = phaseDetails.start_date;
                      });
                    },
                    onCancel: () {
                      setState(() {
                        phaseDetails.start_date = null;
                      });
                    },
                    errorText:
                        (createButtonClick && phaseDetails.start_date == null)
                            ? 'Please enter start date'
                            : "",
                    validator: (value) {},
                  ),
                  CustomDatePicker(
                    hint: 'dd/mm/yyyy',
                    label: "End date",
                    initialDate: widget.type == 0
                        ? null
                        : AppUtil.stringToDate(
                            phaseDetails.end_date.toString()),
                    onChange: (date) {
                      setState(() {
                        phaseDetails.end_date = date.toString();
                        milestoneEndDate = date;
                      });
                    },
                    onCancel: () {
                      setState(() {
                        phaseDetails.end_date = null;
                      });
                    },
                    errorText: errorTexts(createButtonClick,
                        phaseDetails.end_date, phaseDetails.start_date),
                    validator: (value) {},
                  ),
                  titleHeadlineWidget("Resources needed", 16.0.sp),
                  SizedBox(
                    height: 12.h,
                  ),
                  Container(
                    // width: MediaQuery.of(context).size.width * 0.26,
                    // margin: EdgeInsets.only(left: 16.0.sp, right: 62.5.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(//left: 10.sp, top: 21.sp
                              ),
                          child: Container(
                            height: 45.h,
                            width: 45.w,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xff334155),
                                    radius: 30.r,
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 28.sp,
                                      color: Color(0xffDADADA),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 18.h,
                                      width: 18.w,
                                      padding: EdgeInsets.all(3.sp),
                                      decoration: BoxDecoration(
                                        color: Color(0xff10B981),
                                        borderRadius:
                                            BorderRadius.circular(100.r),
                                      ),
                                      child: Center(
                                          child: Icon(Icons.add,
                                              color: Colors.white,
                                              size: 10.sp)),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 18.w,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 7,
                                child: CustomSearchDropdown(
                                  hint: "Type",
                                  label: "",
                                  initialValue: getAllInitialValue(
                                          departmentlist, _depat.toString()) ??
                                      null,
                                  margin: EdgeInsets.all(0),
                                  showSearchBar: true,
                                  errorText: createButtonClick == true &&
                                          (_depat == null)
                                      ? 'Please select resources'
                                      : '',
                                  items: departmentlist,
                                  onChange: ((value) {
                                    // _curren = value.id;
                                    _depat = value.item;
                                    setState(() {
                                      startloading = true;
                                      getResourcesNeeded(value.id.toString());
                                    });
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  startloading == true
                      ? loading == true
                          ? Center(child: const CircularProgressIndicator())
                          : Container(
                              height: 48.h,
                              width: MediaQuery.of(context).size.width * 0.15.w,
                              decoration: BoxDecoration(
                                color: const Color(0xff1E293B),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 2.r,
                                      offset: Offset(0.0, 0.75))
                                ],
                                borderRadius: BorderRadius.circular(
                                  6.0.r,
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
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: _typeAheadController,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0.sp),
                                      keyboardType: TextInputType.text,
                                      cursorColor: Colors.white,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        // border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            top: 15.0.sp,
                                            left: 10.sp,
                                            bottom: 5.sp),
                                        prefixIcon: Padding(
                                            padding:
                                                EdgeInsets.only(top: 9.0.sp),
                                            child: Icon(
                                              Icons.search,
                                              color: Color(0xff64748B),
                                            )),
                                        hintText: 'Search',
                                        hintStyle: TextStyle(
                                            fontSize: 14.sp,
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
                                          // Text("khushi");milestone
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
                                          if (selectedSource
                                              .contains(item.name)) {
                                          } else {
                                            phaseDetails.resource!.add(
                                                ResourceData(
                                                    resource_name: item.name,
                                                    resource_id: item.userId,
                                                    department_name:
                                                        item.departmentName,
                                                    department_id:
                                                        item.departmentId ??
                                                            0));
                                            listResource.add(
                                                PhasesSortedResources(
                                                    department:
                                                        _depat, //_depat['name'],
                                                    details: item));

                                            selectedSource.add(item.name!);
                                          }
                                        } else {
                                          listResource.add(
                                              PhasesSortedResources(
                                                  department: _depat,
                                                  details: item));
                                          phaseDetails.resource!.add(
                                              ResourceData(
                                                  resource_name: item.name,
                                                  resource_id: item.userId,
                                                  department_name:
                                                      item.departmentName,
                                                  department_id:
                                                      item.departmentId ?? 0,
                                                  profileImage: item.image));
                                          selectedSource.add(item.name!);
                                          // listResorceDropDown
                                          //     .add(DropdownModel(_depat, item));
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                      : Container(),
                ],
              ),
            ),
            selectedSource.isNotEmpty
                ? SizedBox(
                    height: 30.h,
                    child: Padding(
                        padding: EdgeInsets.only(left: 28.0.sp),
                        child:
                            //  ListView.builder(
                            //   scrollDirection: Axis.horizontal,
                            //   itemCount: selectedSource.length,
                            //   itemBuilder: (context, index) {
                            //     return
                            Wrap(
                                spacing: 8.sp,
                                children: List.generate(selectedSource.length,
                                    (index) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          top: 16.sp, bottom: 2.sp, left: 5.sp),
                                      child: InputChip(
                                        labelPadding: EdgeInsets.only(
                                            left: 10.sp,
                                            top: 7.sp,
                                            bottom: 7.sp),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            13.r,
                                          ),
                                        )),
                                        side: BorderSide(
                                            color: Color(0xff334155)),
                                        deleteIcon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                        backgroundColor: Color(0xff334155),
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
                                      ));
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

  DropdownModel? getAllInitialValue(List<DropdownModel>? list, String? id) {
    //if (widget.response != null && list!.isNotEmpty) {
    try {
      DropdownModel? result = list!.firstWhere(
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
    // } else {
    //   return null;
    // }
  }

  PhasesSortedResources? getIntialValueForSubTask(
      List<PhasesSortedResources>? list, String? id) {
    //if (widget.response != null && list!.isNotEmpty) {
    try {
      PhasesSortedResources? result = list!.firstWhere(
          (o) =>
              o.details!.departmentId.toString() == id ||
              o.details!.departmentId.toString() == id,
          orElse: () => PhasesSortedResources(department: null, details: null));
      if (result.details == null) {
        return null;
      } else {
        return result;
      }
    } catch (e) {
      return null;
    }
    // } else {
    //   return null;
    // }
  }

  Widget mileStoneView() {
    return Expanded(
      flex: 1,
      child: Form(
        key: _mileStoneFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 29.5.sp, top: 18.5.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  clickedAddMileStone == false
                      ? titleHeadlineWidget("Milestones", 18.0.sp)
                      : titleHeadlineWidget("Add Milestones", 18.0.sp),
                  InkWell(
                    child: clickedAddMileStone == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.add,
                                size: 15.sp,
                                color: Color(0xff93C5FD),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 11.75.sp,
                                  right: 26.sp,
                                ),
                                child: titleSubHeadlineWidget(
                                    "Add Milestone", 14.0.sp),
                              )
                            ],
                          )
                        : clickAddMileStone(),
                    onTap: () {
                      setState(() {
                        addMilestoneBtnClick = true;
                        createButtonClick = true;
                        saveButtonClickForMileStone = false;
                      });
                      Future.delayed(const Duration(microseconds: 500), () {
                        if (_formKey.currentState!.validate()) {
                          if (allValidate && selectedSource.isNotEmpty) {
                            setState(() {
                              clickedAddMileStone = true;
                              // saveButtonClickForMileStone = true;
                            });
                          }
                        }
                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            clickedAddMileStone
                ? Padding(
                    padding: EdgeInsets.only(
                        left: 29.5.sp, right: 30.5.sp, top: 26.sp),
                    child: CustomFormField(
                      controller: controllerMilestoneTitle,
                      maxline: 1,
                      fontSizeForLabel: 14.sp,
                      label: 'Milestone Title',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter milestone title';
                        } else {
                          setState(() {
                            print(value);
                            mileStoneTitle = value;
                            //savePhaseValidate = false;
                          });
                        }
                        return null;
                      },
                      onChange: (text) => setState(() => name_ = text),
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
            clickedAddMileStone == false
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(
                        left: 29.5.sp, right: 30.5.sp, top: 20.sp),
                    child: CustomDatePicker(
                      hint: 'dd/mm/yyyy',
                      label: 'Milestone Date',
                      initialDate: widget.type == 0
                          ? null
                          : AppUtil.stringToDate(mileStoneDate.toString()),
                      endDate: milestoneEndDate != null
                          ? milestoneEndDate
                          : DateTime.now(),
                      onChange: (date) {
                        setState(() {
                          mileStoneDate = date;
                          print("Date---------------------");

                          print(mileStoneDate);
                        });
                      },
                      onCancel: () {
                        setState(() {
                          mileStoneDate = null;
                        });
                      },
                      errorText:
                          errorText(mileStoneDate, phaseDetails.end_date),
                      validator: (value) {},
                    ),
                  ),
            savePhaseClick && phaseDetails.milestone!.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    margin: EdgeInsets.only(left: 30.sp, top: 3.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Please add milestone',
                          style: TextStyle(
                              fontSize: 14.sp,
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
      mileStoneDate = AppUtil.stringToDate(values.m_date!) ??
          AppUtil.dateToString(DateTime.now());
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
              padding: EdgeInsets.only(top: 18.5.sp, left: 29.5.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  clickAddSubTask == false
                      ? titleHeadlineWidget("Subtasks", 18.0.sp)
                      : titleHeadlineWidget("Add Subtasks", 18.0.sp),
                  InkWell(
                    child: Container(
                        child: clickAddSubTask == false
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 20.sp,
                                    color: Color(0xff93C5FD),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 28.5.sp),
                                    child: titleSubHeadlineWidget(
                                        "Add Subtasks", 14.0.sp),
                                  )
                                ],
                              )
                            : clickAddSubtask()),
                    onTap: () {
                      setState(() {
                        savePhaseClick = true;
                        createButtonClick = true;
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
            SizedBox(
              height: 8.h,
            ),

            clickAddSubTask
                ? Padding(
                    padding: EdgeInsets.only(
                        left: 30.5.sp, right: 30.sp, top: 39.5.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDatePicker(
                          hint: 'dd/mm/yyyy',
                          label: "Start date",
                          initialDate: widget.type == 0
                              ? null
                              : AppUtil.stringToDateValidate(subTaskStartDate!),
                          endDate: milestoneEndDate,
                          onChange: (dates) {
                            print("------------Start date----------------");

                            setState(() {
                              subTaskStartDate = dates.toString();

                              print(
                                  "subTaskStartDate------------------$subTaskStartDate");
                            });
                            setState(() {});
                          },
                          onCancel: () {
                            setState(() {
                              subTaskStartDate = null;
                            });
                          },
                          // errorText: (saveButtonClickForSubtask1 &&
                          //         subTaskStartDate!.isEmpty)
                          //     ? 'Please enter start date'
                          //     : "",
                          errorText: errorTextForSubTaskStart(
                              subTaskStartDate, phaseDetails.end_date),
                          //     AppUtil.stringToDateValidate(subTaskStartDate!),
                          // phaseDetails.end_date),
                          validator: (value) {},
                        ),
                        CustomDatePicker(
                          hint: 'dd/mm/yyyy',
                          label: "End date",
                          initialDate: widget.type == 0
                              ? null
                              : AppUtil.stringToDateValidate(subTaskEndDate!),
                          endDate: milestoneEndDate,
                          onChange: (date) {
                            setState(() {
                              subTaskEndDate = date.toString();
                              print("end date-----------------$subTaskEndDate");

                              errorTextForSubtask(
                                  subTaskStartDate, subTaskEndDate);
                            });
                          },

                          onCancel: () {
                            setState(() {
                              subTaskEndDate = null;
                            });
                          },
                          // errorText: (saveButtonClickForSubtask1 &&
                          //         subTaskEndDate!.isEmpty)
                          //     ? 'Please enter end date'
                          //     : "",
                          errorText: errorTextForSubtask(
                              subTaskStartDate, subTaskEndDate),
                          validator: (value) {},
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        titleHeadlineWidget(
                            "Resources needed for the subtasks", 16.sp),
                      ],
                    ),
                  )
                : Container(),

            // clickAddSubTask
            //     ? Padding(
            //         padding: EdgeInsets.only(left: 30.5.sp),
            //         child: titleHeadlineWidget(
            //             "Resources needed for the subtasks", 16.sp),
            //       )
            //     : Container(),
            clickAddSubTask && saveSubtaskClick && selectedSubTaskSource.isEmpty
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    margin: EdgeInsets.only(left: 0.0, top: 3.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please select resource',
                          style: TextStyle(
                              fontSize: 14.sp,
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
                        padding: EdgeInsets.only(right: 6.sp),
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
                    margin: EdgeInsets.only(left: 10.sp, top: 3.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Please add subtask',
                          style: TextStyle(
                              fontSize: 14.sp,
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
      subTaskStartDate = values.start_date!;
      subTaskEndDate = values.end_date!;
    });
  }

  Widget subTaskResourcesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          // color: Colors.red,
          padding: EdgeInsets.only(
              // left: 30.5.sp,
              // right: 16.sp,
              ),
          width: MediaQuery.of(context).size.width * 3,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.sp, top: 21.sp),
                child: Container(
                  height: 45.h,
                  width: 45.w,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: Color(0xff334155),
                          radius: 30.r,
                          child: Icon(
                            Icons.person_outline,
                            size: 28.sp,
                            color: Color(0xffDADADA),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 18.w,
                            height: 18.h,
                            padding: EdgeInsets.all(3.sp),
                            decoration: BoxDecoration(
                              color: Color(0xff10B981),
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: Center(
                                child: Icon(Icons.add,
                                    color: Colors.white, size: 10.sp)),
                          ))
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 12.sp, right: 30.sp),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 16.sp,
                          ),
                          child: CustomSearchDropdownSubTask(
                            hint: "Type",
                            label: "",
                            margin: EdgeInsets.all(0),
                            initialValue: getIntialValueForSubTask(
                                    removeDuplicate(),
                                    subtaskDepat.toString()) ??
                                null,
                            showSearchBar: true,
                            errorText: saveButtonClickForSubtask1 == true &&
                                    (subtaskDepat == null ||
                                        subtaskDepat!.isEmpty)
                                ? 'Please select resources'
                                : '',
                            items: removeDuplicate(),
                            onChange: ((value) {
                              setState(() {
                                selectedSubTaskSource.clear();
                              });

                              setState(() {
                                resourceSuggestions.clear();

                                for (var element in listResource) {
                                  if (element.department!.toLowerCase() ==
                                      value.department
                                          .toString()
                                          .toLowerCase()) {
                                    resourceSuggestions.add(element.details!);
                                  }
                                }

                                subtaskDepat = value.department.toString();

                                if (value != null) {}
                              });
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 30.sp),
          child: Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width * 0.24,
            margin: EdgeInsets.only(top: 16.sp),
            decoration: BoxDecoration(
              color: Color(0xff1E293B),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black38,
                    blurRadius: 2.r,
                    offset: Offset(0.0, 0.75))
              ],
              borderRadius: BorderRadius.circular(
                6.r,
              ),
            ),
            child: Column(
              children: [
                subTaskResourcesSearchTextField = TypeAheadFormField(
                  keepSuggestionsOnLoading: false,
                  suggestionsBoxVerticalOffset: 0.0,
                  suggestionsBoxDecoration:
                      SuggestionsBoxDecoration(color: const Color(0xff0F172A)),
                  hideOnLoading: true,
                  suggestionsCallback: (pattern) {
                    return getSuggestionsForSubTask(pattern);
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _subTaskResourcesController,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white,
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15.sp),
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 4.sp),
                          child: Icon(
                            Icons.search,
                            color: Color(0xff64748B),
                          )),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                          fontSize: 14.sp,
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
                height: 65.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 28.sp),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedSubTaskSource.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.only(
                              top: 16.sp, bottom: 2.sp, left: 5.sp),
                          child: InputChip(
                              labelPadding: EdgeInsets.only(
                                  left: 10.sp, top: 5.sp, bottom: 7.sp),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10.r,
                                ),
                              )),
                              side: BorderSide(color: Color(0xff334155)),
                              deleteIcon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              backgroundColor: Color(0xff334155),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              label: Text(
                                selectedSubTaskSource[index].resource_name ??
                                    '',
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
                              showCheckmark: false));
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
      padding: EdgeInsets.only(top: 2.5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            child: Text(
              "Cancel",
              style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Color(0xffFFFFFF),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300),
            ),
            onTap: () {
              setState(() {
                // mileStoneDate = null;
                mileStoneTitle = "";
                controllerMilestoneTitle.text = "";
                clickedAddMileStone = false;
                saveButtonClick = true;
                saveButtonClickForMileStone = true;
              });
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(right: 36.5.sp, left: 26.sp),
              child: Text(
                "Save 1",
                style: TextStyle(
                    fontSize: 14.0.sp,
                    color: Color(0xff93C5FD),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500),
              ),
            ),
            onTap: () {
              setState(() {
                saveButtonClickForMileStone = true;
              });

              try {
                if (_mileStoneFormKey.currentState!.validate()
                    //&&
                    //!mileStoneDateCheck
                    ) {
                  if (mileStoneTitle.isNotEmpty && mileStoneDate != null) {
                    try {
                      setState(() {
                        if (mileStoneAction.isEmpty) {
                          phaseDetails.milestone!.add(Milestones(
                              title: mileStoneTitle,
                              m_date: mileStoneDate.toString()
                              // m_date: AppUtil.dateToString(mileStoneDate!)
                              ));
                        } else {
                          phaseDetails.milestone![mileStoneEditIndex].title =
                              mileStoneTitle;
                          phaseDetails.milestone![mileStoneEditIndex].m_date =
                              mileStoneDate.toString();
                        }
                        print("here11111-------------------");

                        mileStoneEditIndex = 0;
                        mileStoneAction = '';

                        // mileStoneDate = AppUtil.dateToString(DateTime.now());
                        mileStoneTitle = "";
                        controllerMilestoneTitle.text = "";
                        clickedAddMileStone = false;
                        saveButtonClick = true;
                        saveButtonClickForMileStone = true;
                      });
                    } catch (e) {
                      print(
                          "Error ------------------------------------------ ${e}");
                    }
                  } else {
                    print('Add milestone date');
                  }
                }
              } catch (e) {
                print("Erorr ----------------------- $e");
              }
            },
          )
        ],
      ),
    );
  }

  clickAddSubtask() {
    return Padding(
      padding: EdgeInsets.only(top: 2.5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            child: Text(
              "Cancel",
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xffFFFFFF),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300),
            ),
            onTap: () {
              setState(() {
                selectedSubTaskSource.clear();
                subTaskStartDate = "";
                subTaskEndDate = "";
                clickAddSubTask = false;
                saveButtonClickForSubtask1 = true;
              });
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(right: 37.sp, left: 26.sp),
              child: Text(
                "Save 2",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xff93C5FD),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500),
              ),
            ),
            onTap: () {
              setState(() {
                saveButtonClickForSubtask1 = true;
              });

              if (_subtaskFormKey.currentState!.validate()
                  // &&
                  //     subtaskdateCheck == false
                  ) {
                if (selectedSubTaskSource.isNotEmpty &&
                    subTaskStartDate!.isNotEmpty &&
                    subTaskEndDate!.isNotEmpty) {
                  setState(() {
                    try {
                      if (subtaskActionType.isEmpty) {
                        phaseDetails.sub_tasks!.add(SubTasksModel(
                            resource: selectedSubTaskSource[0],
                            end_date: subTaskEndDate,
                            start_date: subTaskStartDate
                            // end_date: AppUtil.dateToString(
                            //     AppUtil.stringToDateValidate(subTaskEndDate!)),
                            // start_date: AppUtil.dateToString(
                            //     AppUtil.stringToDateValidate(subTaskStartDate!)),
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
                      subTaskStartDate = "";
                      subTaskEndDate = "";
                      clickAddSubTask = false;
                      saveButtonClickForSubtask = true;
                      saveSubtaskClick = false;
                    } catch (e) {
                      print(e);
                    }
                  });
                } else {
                  print('Enter sub task data');
                }
              }
            },
          )
        ],
      ),
    );
  }

  titleHeadlineWidget(String title, double i) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
            color: const Color(0xffFFFFFF),
            fontSize: i,
            fontFamily: 'Inter-Bold',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  titleSubHeadlineWidget(String title, double i) {
    return Container(
      margin: EdgeInsets.only(top: 10.sp, bottom: 10.sp, right: 14.sp),
      child: Text(
        title,
        style: TextStyle(
            color: const Color(0xff93C5FD),
            fontSize: i,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.1,
            fontFamily: 'Inter-Bold',
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
    DepartementModel departementModel = DepartementModel();

    departementModel = await api.getDeparment(context);
    print(departementModel.data);
    setState(() {
      if (departementModel.data != null) {
        _department = departementModel.data!;
        print(_department);
        setState(() {
          departmentlist = []; //!.clear();
          _department.forEach((element) {
            departmentlist.add(
                DropdownModel(element.id.toString(), element.name.toString()));
          });
        });
      }
    });
  }

  getPhaseDetailsByID(String id) async {
    try {
      // SmartDialog.showLoading(
      //   msg: "Your request is in progress please wait for a while...",
      // );
      getPhaseDetails = await api.getPhaseDetails(id, context);
      if (getPhaseDetails!.status == true &&
          getPhaseDetails!.statusCode == 200) {
        phaseInitialData();
        setState(() {});
      } else {
        print('');
      }
      //SmartDialog.dismiss();
    } catch (e) {
      //SmartDialog.dismiss();
      print(e);
    }

    isEditDataLoading = false;
  }

  addNewPhaseApi() async {
    SmartDialog.showLoading(
      msg: "Your request is in progress please wait for a while...",
    );
    try {
      phaseDetails.start_date =
          AppUtil.dateToString(DateTime.parse(phaseDetails.start_date!));

      phaseDetails.end_date =
          AppUtil.dateToString(DateTime.parse(phaseDetails.end_date!));

      if (phaseDetails.milestone != null &&
          phaseDetails.milestone!.isNotEmpty) {
        phaseDetails.milestone!.forEach((element) {
          element.m_date =
              AppUtil.dateToString(DateTime.parse(element.m_date!));
        });
      }

      if (phaseDetails.sub_tasks != null &&
          phaseDetails.sub_tasks!.isNotEmpty) {
        phaseDetails.sub_tasks!.forEach((element) {
          element.start_date =
              AppUtil.dateToString(DateTime.parse(element.start_date!));

          element.end_date =
              AppUtil.dateToString(DateTime.parse(element.end_date!));
        });
      }

      CreatePhaseResp createPhaseResp =
          await api.createNewPhase(json.encode(phaseDetails), context);
      SmartDialog.dismiss();
      if (createPhaseResp.status == true) {
        Navigator.pop(context, true);
      }
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
      try {
        phaseDetails.start_date =
            AppUtil.dateToString(DateTime.parse(phaseDetails.start_date!));
      } catch (e) {
        return phaseDetails.start_date;
      }

      try {
        phaseDetails.end_date =
            AppUtil.dateToString(DateTime.parse(phaseDetails.end_date!));
      } catch (e) {
        return phaseDetails.end_date;
      }

      try {
        if (phaseDetails.milestone != null &&
            phaseDetails.milestone!.isNotEmpty) {
          phaseDetails.milestone!.forEach((element) {
            element.m_date =
                AppUtil.dateToString(DateTime.parse(element.m_date!));
          });
        }
      } catch (e) {
        print(e);
      }

      try {
        if (phaseDetails.sub_tasks != null &&
            phaseDetails.sub_tasks!.isNotEmpty) {
          phaseDetails.sub_tasks!.forEach((element) {
            element.start_date =
                AppUtil.dateToString(DateTime.parse(element.start_date!));

            element.end_date =
                AppUtil.dateToString(DateTime.parse(element.end_date!));
          });
        }
      } catch (e) {
        print(e);
      }

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
    // listResource.forEach((element) => listResorceDropDown.add(DropdownModel(
    //        element.department,
    //       element.details.toString(),
    //     )));
    return uniquelist;
  }

  beforeScreenLoad() {
    phaseDetails.start_date = null;
    phaseDetails.end_date = null;
    mileStoneDate = null;
    subTaskStartDate = "";
    subTaskEndDate = "";
  }

  String errorTexts(
      bool createButtonClicks, String? end_date, String? start_date) {
    if (createButtonClicks && end_date == null) {
      return 'Please enter end date';
    } else if (createButtonClicks && start_date != null && end_date != null) {
      DateTime start = AppUtil.stringToDateValidate(start_date);
      DateTime end = AppUtil.stringToDateValidate(end_date);

      if (end.isBefore(start)) {
        return 'End date must be greater then the start date';
      } else if (AppUtil.stringToDateValidate(end_date)
          .isAtSameMomentAs((AppUtil.stringToDateValidate(start_date)))) {
        return 'End date should not be same as start date';
      }
    }

    return '';
  }

  String errorText(DateTime? mileStoneDate, String? end_date) {
    if (saveButtonClickForMileStone && mileStoneDate == null) {
      return 'Please enter milestone date';
    } else if (saveButtonClickForMileStone &&
        mileStoneDate != null &&
        end_date != null) {
      DateTime start = AppUtil.stringToDateValidate(mileStoneDate.toString());
      DateTime end = AppUtil.stringToDateValidate(phaseDetails.end_date!);

      if (end.isBefore(start)) {
        return 'Milestone date must be less then the phase end date';
      } else {
        setState(() {
          mileStoneDateCheck = false;
        });
      }
    }

    return '';
  }

  String errorTextForSubTaskStart(String? subtaskStart, String? end_date) {
    print("date -----------subtask start");
    print(subtaskStart);
    if (saveButtonClickForSubtask1 && subtaskStart!.isEmpty) {
      return 'Please enter Start date';
    } else if (saveButtonClickForSubtask1 &&
        subtaskStart!.isNotEmpty &&
        end_date != null) {
      DateTime start = AppUtil.stringToDateValidate(subtaskStart.toString());
      DateTime end = AppUtil.stringToDateValidate(phaseDetails.end_date!);

      if (end.isBefore(start)) {
        return 'Start date must be less then the phase end date';
      }
    }

    return '';
  }

  String errorTextForSubtask(String? subtask, String? enddate) {
    if (saveButtonClickForSubtask1 &&
        enddate!.isEmpty &&
        enddate != null &&
        subtask != null) {
      return 'Please enter end date';
    } else if (saveButtonClickForSubtask1 &&
        enddate != null &&
        subtask != null) {
      try {
        DateTime start = AppUtil.stringToDateValidate(subtask);
        DateTime end = AppUtil.stringToDateValidate(enddate);
        DateTime endphase =
            AppUtil.stringToDateValidate(phaseDetails.end_date!);
        // DateTime phase = AppUtil.stringToDateValidate(phaseDetails.end_date!);

        if (end.isBefore(start)) {
          return 'End date must be greater then the start date';
        } else if (AppUtil.stringToDateValidate(enddate)
            .isAtSameMomentAs((AppUtil.stringToDateValidate(subtask)))) {
          return 'End date should not be same as start date';
        } else if (endphase.isBefore(AppUtil.stringToDateValidate(enddate))) {
          return 'End date must be less then the phase end date';
        } else {
          setState(() {
            subtaskdateCheck = false;
          });
        }

        // if (endphase.isBefore(start)) {

        // }
        return '';
      } catch (e) {
        print(e);
      }
    }

    return '';
  }
}

class PhasesSortedResources {
  dynamic department;
  Details? details;

  PhasesSortedResources({required this.department, required this.details});
}
