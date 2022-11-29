import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/DemoContainer.dart';
import 'package:zeus/add_new_phase/model/mileston_model.dart';
import 'package:zeus/add_new_phase/model/phase_details.dart';
import 'package:zeus/add_new_phase/model/resourcedata.dart';
import 'package:zeus/add_new_phase/model/resources_needed.dart';
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
import 'package:zeus/utility/colors.dart';
import 'package:zeus/utility/validations.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class NewPhase extends StatefulWidget {
  const NewPhase({Key? key}) : super(key: key);

  @override
  State<NewPhase> createState() => _NewPhaseState();
}

class _NewPhaseState extends State<NewPhase> {
  TextEditingController controller_next_phase = TextEditingController();
  TextEditingController controller_phase_type = TextEditingController();
  AutoCompleteTextField? searchTextField;
  AutoCompleteTextField? subTaskResourcesSearchTextField;
  ResourceNeededModel? resourceNeededModel;
  String startDateForphaseDetail = '25/11/2022';
  String endDateForphaseDetail = '27/11/2022';
  List<PhaseDetails> _list = [];
  List<String> abc = [];
  static List<Details> users = <Details>[];
  bool loading = true;
  bool startloading = false;
  dynamic? _depat;
  String? selectUser, subtaskDepat;
  String? _depat1;
  List _department = [];
  Api api = Api();
  PhaseDetails phaseDetails = PhaseDetails();
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
  List<String> selectedSubTaskSource = [];

  @override
  void initState() {
    // _getTag = getProject();
    // change();

    getDepartment();

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
                                  createPhase();
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
                    Expanded(
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
                            hintText: 'Next Waves',
                            callback: (values) {
                              setState(() {
                                phaseDetails.title = values;
                                print(phaseDetails.title);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          formField(
                            controller: controller_phase_type,
                            labelText: "Phase Type",
                            context: context,
                            hintText: 'Design Phase',
                            callback: (values) {
                              setState(() {
                                phaseDetails.phase_type = values;
                                print(phaseDetails.phase_type);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          DatePicker(title: "Start date"),
                          const SizedBox(
                            height: 20.0,
                          ),
                          DatePicker(title: "End date"),
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
                                width:
                                    (MediaQuery.of(context).size.width * 0.22),
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
                                  margin: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  height: 20.0,
                                  child: Container(

                                      // padding: const EdgeInsets.all(2.0),
                                      child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSettersetState) {
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          dropdownColor:
                                              ColorSelect.class_color,
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
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (dynamic newValue) {
                                            setState(() {
                                              print(newValue);
                                              var result = newValue['id'];
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
                            ],
                          ),
                          startloading == true
                              ? loading == true
                                  ? Center(
                                      child: const CircularProgressIndicator())
                                  : Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.26,
                                      margin: const EdgeInsets.only(
                                          top: 16, left: 30),
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
                                              searchTextField =
                                                  AutoCompleteTextField<
                                                      Details>(
                                                clearOnSubmit: false,
                                                key: key,
                                                cursorColor: Colors.white,
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 15.0),
                                                  prefixIcon: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4.0),
                                                      child: Icon(
                                                        Icons.search,
                                                        color:
                                                            Color(0xff64748B),
                                                      )),
                                                  hintText: 'Search',
                                                  hintStyle: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Color(0xff64748B),
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  border: InputBorder.none,
                                                ),
                                                suggestions: users,
                                                keyboardType:
                                                    TextInputType.text,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0),
                                                itemFilter: (item, query) {
                                                  return item.name!
                                                      .toLowerCase()
                                                      .startsWith(
                                                          query.toLowerCase());
                                                },
                                                itemSorter: (a, b) {
                                                  return a.name!
                                                      .compareTo(b.name!);
                                                },
                                                itemSubmitted: (item) {
                                                  setState(() {
                                                    //print(item.title);
                                                    searchTextField!.textField!
                                                        .controller!.text = '';
                                                    if (selectedSource
                                                        .isNotEmpty) {
                                                      if (selectedSource
                                                          .contains(
                                                              item.name)) {
                                                      } else {
                                                        listResource.add(
                                                            PhasesSortedResources(
                                                                department:
                                                                    _depat[
                                                                        'name'],
                                                                details: item));
                                                        selectedSource
                                                            .add(item.name!);
                                                      }
                                                    } else {
                                                      listResource.add(
                                                          PhasesSortedResources(
                                                              department:
                                                                  _depat[
                                                                      'name'],
                                                              details: item));
                                                      selectedSource
                                                          .add(item.name!);
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
                                          margin:
                                              const EdgeInsets.only(left: 12.0),
                                          child: InputChip(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            backgroundColor:
                                                const Color(0xff334155),
                                            visualDensity:
                                                VisualDensity.compact,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            label: Text(
                                              selectedSource[index],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            //  selected: _isSelected!,
                                            onSelected: (bool selected) {
                                              setState(() {
                                                //    _isSelected = selected;
                                              });
                                            },
                                            onDeleted: () {
                                              setState(() {
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
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.99,
                        child: const VerticalDivider(
                          color: Color(0xff94A3B8),
                          thickness: 0.2,
                        )),
                    Expanded(
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
                                    : titleHeadlineWidget(
                                        " Add Milestones", 18.0),
                                InkWell(
                                  child: clickedAddMileStone == false
                                      ? Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Color(0xff93C5FD),
                                              ),
                                              titleSubHeadlineWidget(
                                                  "Add Milestone", 14.0),
                                            ],
                                          ),
                                        )
                                      : clickAddMileStone(),
                                  onTap: () {
                                    setState(() {
                                      clickedAddMileStone = true;
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
                              ?
                              // milestoneList(context),
                              formFieldMilestone(
                                  labelText: "Milestone Title",
                                  context: context,
                                  hintText: 'Design 1',
                                )
                              : saveButtonClick
                                  ? milestoneList(context)
                                  : Container(),
                          const SizedBox(
                            height: 8.0,
                          ),
                          clickedAddMileStone == false
                              ? Container()
                              : DatePicker(title: "Milestone Date"),
                        ],
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.99,
                        child: const VerticalDivider(
                          color: Color(0xff94A3B8),
                          thickness: 0.2,
                        )),
                    Expanded(
                      flex: 1,
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
                                    : titleHeadlineWidget(
                                        " Add Subtasks", 18.0),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: InkWell(
                                    child: Container(
                                        child: clickAddSubTask == false
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
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
                                        clickAddSubTask = true;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          clickAddSubTask
                              ? DatePicker(title: "Start date")
                              : Container(),
                          const SizedBox(
                            height: 8.0,
                          ),
                          clickAddSubTask
                              ? DatePicker(title: "End date")
                              : Container(),
                          const SizedBox(
                            height: 8.0,
                          ),
                          clickAddSubTask
                              ? titleHeadlineWidget(
                                  "Resources need for subtask", 16)
                              : Container(),
                          clickAddSubTask
                              ? subTaskResourcesView()
                              : saveButtonClickForSubtask
                                  ? subTaskList(context)
                                  : Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
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
                        items: listResource.toSet().map((items) {
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
                  subTaskResourcesSearchTextField =
                      AutoCompleteTextField<Details>(
                    clearOnSubmit: false,
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
                    suggestions: users,
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
                        subTaskResourcesSearchTextField!
                            .textField!.controller!.text = '';
                        if (selectedSubTaskSource.isNotEmpty) {
                          if (selectedSubTaskSource.contains(item.name)) {
                          } else {
                            selectedSubTaskSource.add(item.name!);
                          }
                        } else {
                          selectedSubTaskSource.add(item.name!);
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
                            selectedSubTaskSource[index],
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
            : Container(),
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
            child: Text(
              "Cancel",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xffFFFFFF),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300),
            ),
            onTap: (() {}),
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
                clickedAddMileStone = false;
                saveButtonClick = true;
                // clickedAddMileStone = ;
              });
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
            onTap: (() {}),
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
                clickAddSubTask = false;
                saveButtonClickForSubtask = true;
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

  createPhase() {}

  getDepartment() async {
    List department = [];
    department = await api.getDeparment();
    if (department != null) {
      setState(() {
        _department = department;
      });
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

  removeDuplicate() {
    return listResource
        .map((f) => f.toString())
        .toSet()
        .toList()
        .map((f) => json.decode(f) as List<dynamic>)
        .toList();
  }
}

class PhasesSortedResources {
  String? department;
  Details? details;

  PhasesSortedResources({required this.department, required this.details});
}
