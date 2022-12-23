import 'dart:convert';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/custom_datepicker.dart';
import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/helper_widget/custom_form_field.dart';
import 'package:zeus/helper_widget/custom_search_dropdown.dart';
import 'package:zeus/helper_widget/popup_projectbutton.dart';
import 'package:zeus/helper_widget/search_view.dart';
import 'package:zeus/home_module/home_page.dart';
import 'package:zeus/phase_module/new_phase.dart';
import 'package:zeus/popup/popup_phasebutton.dart';
import 'package:zeus/project_module/project_home/project_home_view_model.dart';
import 'package:zeus/services/response_model/project_detail_response.dart';
import 'package:zeus/services/response_model/skills_model/skills_response_project.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/colors.dart';
import 'package:http/http.dart' as http;
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/debouncer.dart';
import 'package:zeus/utility/util.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProjectDetailsDialogView extends StatefulWidget {
  ProjectDetailResponse? response;
  List<SkillsData>? skills;
  GlobalKey<FormState>? formKey = new GlobalKey<FormState>();

  ProjectDetailsDialogView({Key? key, this.formKey, this.response, this.skills})
      : super(key: key);

  @override
  State<ProjectDetailsDialogView> createState() => _EditPageState();
}

class _EditPageState extends State<ProjectDetailsDialogView> {
  DateTime? selectedDate;
  DateTime? selectedDateReminder;
  DateTime? selectedDateDevlivery;
  DateTime? selectedDateDeadline;
  ScrollController _horizontalScrollController = ScrollController();
  ScrollController _verticalScrollController = ScrollController();
  ScrollController _ScrollController = ScrollController();
  TypeAheadFormField? searchTextField;

  final TextEditingController _description = TextEditingController();

  final TextEditingController _projecttitle = TextEditingController();
  final TextEditingController _crmtask = TextEditingController();
  final TextEditingController _warkfolderId = TextEditingController();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _estimatehours = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  Debouncer _debouncer = Debouncer();
  List<SkillsData> users = <SkillsData>[];

  bool? _isSelected;
  String? _account,
      _custome,
      _curren,
      _status,
      roadblockCreateDate,
      roadblockCreateDate1,
      rcName,
      fullName;

  List<String> abc = [];
  List<String> roadblock = [];
  @override
  void initState() {
    //callAllApi();
    updateControllerValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [createProjectView()],
    );
  }

  Widget createProjectView() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.99,
      height: MediaQuery.of(context).size.height * 0.99,
      child: Form(
        child: RawScrollbar(
          thumbColor: Color(0xff4b5563),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          thickness: 8,
          child: SingleChildScrollView(
              child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topView(),
                tagAndCommentView(),
                Container(
                  color: Color(0xff424D5F),
                  width: double.infinity,
                  height: 2,
                ),
                phaseView()
              ],
            ),
          )),
        ),
      ),
    );
  }

  topView() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.99,
      padding: EdgeInsets.only(),
      // color: Colors.green,
      child: Column(
        children: [
          SizedBox(
            height: 135.h,
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 30.sp, right: 34.sp, top: 30.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.response?.data?.title ?? '',
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 22.0.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12.0.sp),
                              padding: EdgeInsets.only(
                                  left: 16.sp,
                                  right: 16.sp,
                                  top: 10.sp,
                                  bottom: 10.sp),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppUtil.getStatusContainerColor(
                                      _status ?? "")),
                              child: Text(
                                _status ?? "",
                                style: TextStyle(
                                    color: ColorSelect.white_color,
                                    fontSize: 14.0.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        ProjectEdit(
                          response: widget.response!,
                          buildContext: context,
                          title: 'Edit Project',
                          alignment: Alignment.center,
                          deliveryDate: selectedDateDevlivery,
                          accountableId: [],
                          currencyList: [],
                          customerName: [],
                          id: '',
                          statusList: [],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 135.h,
                  width: 2,
                  color: Color(0xff424D5F),
                ),
                Expanded(
                  child: Container(
                    child: RawScrollbar(
                      thumbVisibility: true,
                      controller: _horizontalScrollController,
                      thumbColor: Color(0xff4b5563),
                      radius: Radius.circular(10.r),
                      thickness: 8,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.only(
                                  left: 20.sp, top: 45.sp, right: 100.sp),
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              // physics:
                              //      BouncingScrollPhysics(),
                              physics: ClampingScrollPhysics(),
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Start date",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 11.0.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        //setDate = "2";
                                        _selectDate(setState, 1);
                                      },
                                      child: Text(
                                        AppUtil.formattedDateYear(selectedDate
                                            .toString()), // "$startDate",
                                        style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 14.0.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 40.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reminder date",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 11.0.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _selectDate(setState, 2);
                                      },
                                      child: Text(
                                        AppUtil.formattedDateYear(
                                            selectedDateReminder.toString()),
                                        style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 14.0.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 40.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Delivery date",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 11.0.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _selectDate(setState, 3);
                                      },
                                      child: Text(
                                        AppUtil.formattedDateYear(
                                            selectedDateDevlivery.toString()),
                                        style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 14.0.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 40.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Deadline",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 11.0.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _selectDate(setState, 4);
                                      },
                                      child: Text(
                                        AppUtil.formattedDateYear(
                                            selectedDateDeadline.toString()),
                                        style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 14.0.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 40.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Working days",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 11.0.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      widget.response!.data != null &&
                                              widget.response!.data!
                                                  .workingDays!.isNotEmpty
                                          ? widget.response!.data!.workingDays!
                                          : 'N/A',
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 14.0.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  top: 30.0.sp, right: 30.0.sp, bottom: 0),
                              height: 35.0.sp,
                              width: 35.0.sp,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff334155), width: 0.6),
                                  shape: BoxShape.circle),
                              child: SvgPicture.asset(
                                'images/cross.svg',
                                width: 13.r,
                                height: 13.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //---------------------SAYYAM YADAV
          Container(
            color: Color(0xff424D5F),
            width: double.infinity,
            height: 2,
          ),
        ],
      ),
    );
  }

  tagAndCommentView() {
    return (Container(
      height: 474.h,
      width: MediaQuery.of(context).size.width * 0.99,
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * (0.99 / 2),
              margin: EdgeInsets.only(
                top: 15.sp,
              ),
              child: Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tagView(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.99,
                      margin: EdgeInsets.only(left: 15.0.sp, top: 16.0.sp),
                      height: MediaQuery.of(context).size.height * 0.14,
                      decoration: BoxDecoration(
                        color: const Color(0xff1E293B),
                        border:
                            Border.all(color: Color(0xff424D5F), width: 0.5.sp),
                        borderRadius: BorderRadius.circular(
                          8.0.r,
                        ),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _description,
                        cursorColor: const Color(0xffFFFFFF),
                        style: const TextStyle(color: Color(0xffFFFFFF)),
                        textAlignVertical: TextAlignVertical.bottom,
                        maxLines: 10,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              bottom: 20.0.sp,
                              top: 14.0.sp,
                              right: 10.sp,
                              left: 14.0.sp,
                            ),
                            border: InputBorder.none,
                            hintText: '',
                            hintStyle: TextStyle(
                                fontSize: 14.0.sp,
                                color: Color(0xffFFFFFF),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500)),
                        onChanged: (value) {
                          try {
                            _debouncer.run(() async {
                              addDescriptionProject();
                            });
                          } catch (e) {
                            print(e);
                            print(value);
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 30.0.sp, top: 24.h, bottom: 12.h),
                      child: Text(
                        "Potential roadblocks",
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 16.0.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.99,
                      margin: EdgeInsets.only(
                        left: 30.0.sp,
                      ),
                      height: 40.0.h,
                      decoration: BoxDecoration(
                        color: Color(0xff334155),
                        borderRadius: BorderRadius.circular(
                          12.0.r,
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            flex: 11,
                            child: Text(
                              "Occurrence",
                              style: TextStyle(
                                  color: Color(0xff94A3B8),
                                  fontSize: 14.0.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Center(
                              child: Text(
                                "Responsible",
                                style: TextStyle(
                                    color: Color(0xff94A3B8),
                                    fontSize: 14.0.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Center(
                              child: Text(
                                "Date created",
                                style: TextStyle(
                                    color: Color(0xff94A3B8),
                                    fontSize: 14.0.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.0.sp),
                          child: RawScrollbar(
                            controller: _ScrollController,
                            thumbColor: Color(0xff4b5563),
                            radius: Radius.circular(20.r),
                            thickness: 8,
                            child: ListView.builder(
                              controller: _ScrollController,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: roadblock.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    Expanded(
                                      flex: 12,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 45.0.sp, top: 8.0.sp),
                                            height: 12.0.h,
                                            width: 12.0.w,
                                            decoration: const BoxDecoration(
                                                color: Color(0xffEF4444),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 16.0.sp, top: 8.0..sp),
                                              child: Text(
                                                roadblock[index],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Color(0xffE2E8F0),
                                                    fontSize: 14.0.sp,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 28.0.w,
                                            width: 28.0.w,
                                            margin:
                                                EdgeInsets.only(top: 8.0.sp),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xff0F172A),
                                                  width: 3.0.w),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                100.0.r,
                                              ),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "$fullName",
                                                style: TextStyle(
                                                    color: Color(0xffFFFFFF),
                                                    fontSize: 10.0.sp,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: 8.0.sp,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "$roadblockCreateDate1",
                                            // roadblockCreateDate[0],
                                            style: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 14.0.sp,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xff263143),
            ),
          )
        ],
      ),
    ));
  }

  tagView() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.99,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  child: Wrap(
                    spacing: 8.sp,
                    children: List.generate(
                      abc.length,
                      (index) {
                        return abc[index]!.isEmpty
                            ? PopupMenuButton<int>(
                                tooltip: '',
                                offset: Offset(35, 48),
                                color: Color(0xFF0F172A),
                                child: Container(
                                    width: 45.0.h,
                                    height: 45.0.h,
                                    margin:
                                        EdgeInsets.only(left: 15.0.sp, top: 0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xff334155),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      child: Padding(
                                          padding: EdgeInsets.all(10.0.sp),
                                          child: SvgPicture.asset(
                                              'images/tag_new.svg')),
                                    )),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    padding: const EdgeInsets.all(0),
                                    value: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 400.w,
                                        color: const Color(0xff1E293B),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            searchTextField =
                                                TypeAheadFormField(
                                              keepSuggestionsOnLoading: false,
                                              hideOnLoading: true,
                                              suggestionsBoxVerticalOffset: 0.0,
                                              suggestionsBoxDecoration:
                                                  SuggestionsBoxDecoration(
                                                      color: Color(0xff0F172A)),
                                              suggestionsCallback: (pattern) {
                                                return getSuggestions(pattern);
                                              },
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                controller:
                                                    _typeAheadController,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0.sp),
                                                keyboardType:
                                                    TextInputType.text,
                                                cursorColor: Colors.white,
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                    top: 15.0.sp,
                                                  ),
                                                  prefixIcon: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4.0.sp),
                                                      child: Icon(
                                                        Icons.search,
                                                        color:
                                                            Color(0xff64748B),
                                                      )),
                                                  hintText: 'Search',
                                                  hintStyle: TextStyle(
                                                      fontSize: 14.0.sp,
                                                      color: Colors.white,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                              itemBuilder: (context, item) {
                                                return rowProject(item);
                                              },
                                              transitionBuilder: (context,
                                                  suggestionsBox, controller) {
                                                return suggestionsBox;
                                              },
                                              onSuggestionSelected: (item) {
                                                _typeAheadController.text = '';
                                                if (!abc.contains(item.name)) {
                                                  abc.removeWhere((element) =>
                                                      element.isEmpty);
                                                  abc.add(item.name!);
                                                  abc.add("");
                                                  saveTagApi(
                                                      widget.response!.data!.id
                                                          .toString(),
                                                      item.name!);
                                                }
                                                setState(() {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                elevation: 8.0,
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: 2.sp, bottom: 2.sp, left: 5.sp),
                                child: InputChip(
                                  labelPadding: EdgeInsets.only(
                                      left: 10.sp, top: 7.sp, bottom: 7.sp),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      13.r,
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
                                    abc[index] ?? '',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _isSelected = selected;
                                    });
                                  },
                                  onDeleted: () {
                                    widget.response!.data!.tags!.forEach(
                                      (element) {
                                        if (element.name == abc[index]) {
                                          removeTagAPI(element.id.toString());
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
                )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.sp, top: 8.0.sp),
            child: Container(
              child: Text(
                'Work folder',
                style: TextStyle(
                    color: ColorSelect.cermany_color,
                    fontSize: 14.0.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 35.0, top: 8),
            child: SvgPicture.asset(
              'images/cermony.svg',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0.sp),
            child: Container(
              child: Text(
                'CRM',
                style: TextStyle(
                    color: ColorSelect.cermany_color,
                    fontSize: 14.0.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 16.0, top: 8),
            child: SvgPicture.asset(
              'images/cermony.svg',
            ),
          ),
        ],
      ),
    );
  }

  phaseView() {
    return Container(
      // color: Colors.red,
      height: widget.response!.data!.phase!.length == 0 ? 180.h : 250.h,
      width: MediaQuery.of(context).size.width * 0.99,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 45.sp),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 50.0, top: 0.0),
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
                      margin: EdgeInsets.only(right: 8.0.sp, top: 0.0),
                      child: SvgPicture.asset(
                        'images/plus.svg',
                        color: const Color(0xff93C5FD),
                        width: 10.0.h,
                        height: 10.0.h,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 45.0.sp, top: 0.0),
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
                        margin: EdgeInsets.only(right: 8.0.sp, top: 0.0),
                        child: SvgPicture.asset(
                          'images/plus.svg',
                          color: const Color(0xff93C5FD),
                          width: 10.0,
                          height: 10.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 80.0.sp, top: 0.0),
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
                    // Navigator.pop(context);
                    bool result = await showDialog(
                        context: context,
                        builder: (context) {
                          return NewPhase(
                              widget.response!.data!.id!.toString(), 0);
                        });
                    if (result != null && result) {
                      widget.response = await Provider.of<ProjectHomeViewModel>(
                              context,
                              listen: false)
                          .getProjectDetail(
                              widget.response!.data!.id!.toString());
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.99,
            margin:
                EdgeInsets.only(left: 15.0.sp, top: 12.0.sp, right: 15.0.sp),
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xff334155),
              borderRadius: BorderRadius.circular(
                12.0.r,
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15.0.sp, top: 0.0),
                  child: Text(
                    "Phase",
                    style: TextStyle(
                        color: Color(0xff94A3B8),
                        fontSize: 14.0.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 40.0.sp, top: 0.0),
                  child: Text(
                    "From",
                    style: TextStyle(
                        color: Color(0xff94A3B8),
                        fontSize: 14.0.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.0.sp, right: 50.0.sp),
                  child: const Text(
                    "Till",
                    style: TextStyle(
                        color: Color(0xff94A3B8),
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.0.sp, right: 50.0.sp),
                  child: Text(
                    "Action",
                    style: TextStyle(
                        color: Color(0xff94A3B8),
                        fontSize: 14.0.sp,
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
              padding: EdgeInsets.only(
                  bottom: widget.response!.data!.phase!.length > 0 ? 0 : 0),
              controller: _verticalScrollController,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.response!.data!.phase!.length,
              itemBuilder: (BuildContext context, int index) {
                Phase phase = widget.response!.data!.phase![index];
                var title = phase.title;
                var phaseType = phase.phaseType;
                String name = title!.substring(0, 2).toUpperCase();
                var date = phase.startDate;
                var endDate = phase.endDate;
                var _date = date.toString();
                var date1 = AppUtil.getFormatedDate(_date);
                var fromDate = AppUtil.formattedDateYear1(date1);
                var _endDate = endDate.toString();
                var date2 = AppUtil.getFormatedDate(_endDate);
                var tillDate = AppUtil.formattedDateYear1(date2);
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 38.0,
                          width: 38.0,
                          margin: const EdgeInsets.only(left: 45.0, top: 12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xff334155),
                            borderRadius: BorderRadius.circular(
                              30.0,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "$name",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 12.0,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16.0, top: 20.0),
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
                          margin: const EdgeInsets.only(top: 22.0, right: 42.0),
                          child: Text(
                            "$fromDate",
                            style: const TextStyle(
                                color: Color(0xffffffff),
                                fontSize: 14.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 22.0, right: 36.0),
                          child: Text(
                            "$tillDate",
                            style: const TextStyle(
                                color: Color(0xffffffff),
                                fontSize: 14.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 62.0, bottom: 8),
                          child: Stack(children: [
                            MenuPhase(
                              index: index,
                              onDeleteSuccess: () {
                                setState(() {
                                  widget.response!.data!.phase!.removeAt(index);
                                });
                              },
                              onEditClick: () async {
                                Navigator.pop(context);
                                bool result = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return NewPhase(
                                          widget
                                              .response!.data!.phase![index].id
                                              .toString(),
                                          1);
                                    });
                                if (result != null && result) {
                                  widget.response =
                                      await Provider.of<ProjectHomeViewModel>(
                                              context,
                                              listen: false)
                                          .getProjectDetail(widget
                                              .response!.data!.id!
                                              .toString());
                                  setState(() {});
                                }
                              },
                              setState: setState,
                              response: widget.response!,
                              data: phase,
                              title: 'Menu at bottom',
                              alignment: Alignment.bottomRight,
                              buildContext: context,
                              returnValue: () {
                                print(
                                    "Value returned --------------------------------------");
                              },
                            )
                          ]),
                        ),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            left: 30.0.sp, right: 30.0.sp, bottom: 0.0),
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          color: Color(0xff94A3B8),
                          height: .5.sp,
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // update Controller Value
  updateControllerValue() {
    users = widget.skills ?? [];
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
    if (widget.response!.data != null &&
        widget.response!.data!.reminderDate != null &&
        widget.response!.data!.reminderDate!.isNotEmpty &&
        widget.response!.data!.reminderDate != "0000-00-00 00:00:00") {
      selectedDateReminder =
          DateTime.parse(widget.response!.data!.reminderDate!.toString());
      print("date time now ${DateTime.now()}");
      print('--------------------------------------');
      //selectedDateReminder = DateTime.parse("2022-11-25 00:00:00");
    }
    if (widget.response!.data != null &&
        widget.response!.data!.deadlineDate != null &&
        widget.response!.data!.deadlineDate!.isNotEmpty &&
        widget.response!.data!.deadlineDate != "0000-00-00 00:00:00") {
      selectedDateDeadline =
          DateTime.parse(widget.response!.data!.deadlineDate!.toString());
      //selectedDateDeadline = DateTime.parse("2022-11-27 00:00:00");
    }
    if (widget.response!.data != null &&
        widget.response!.data!.deliveryDate != null &&
        widget.response!.data!.deliveryDate!.isNotEmpty &&
        widget.response!.data!.deliveryDate != "0000-00-00 00:00:00") {
      selectedDateDevlivery =
          DateTime.parse(widget.response!.data!.deliveryDate!.toString());
      //selectedDateDevlivery = DateTime.parse("2022-11-29 00:00:00");
    }
    if (widget.response!.data != null &&
        widget.response!.data!.startDate != null &&
        widget.response!.data!.startDate!.isNotEmpty &&
        widget.response!.data!.startDate != "0000-00-00 00:00:00") {
      // selectedDate = DateTime.parse("2022-11-29 00:00:00");
      selectedDate =
          DateTime.parse(widget.response!.data!.startDate!.toString());
    }
    _description.text = widget.response!.data != null &&
            widget.response!.data!.description != null
        ? widget.response!.data!.description.toString()
        : '';
    if (widget.response!.data != null &&
        widget.response!.data!.tags != null &&
        widget.response!.data!.tags!.isNotEmpty) {
      widget.response!.data!.tags!.forEach((element) {
        if (!abc.contains(element.name)) {
          abc.add(element.name!);
        }
      });
      abc.add("");
    }
    if (widget.response!.data != null &&
        widget.response!.data!.roadblocks != null &&
        widget.response!.data!.roadblocks!.isNotEmpty) {
      widget.response!.data!.roadblocks!.forEach((element) {
        if (!roadblock.contains(element.rodblockDetails!.description)) {
          roadblock.add(element.rodblockDetails!.description!);
        }
      });
    }
    if (widget.response!.data != null &&
        widget.response!.data!.roadblocks != null &&
        widget.response!.data!.roadblocks!.isNotEmpty) {
      widget.response!.data!.roadblocks!.forEach((element) {
        if (element.createdAt != null) {
          roadblockCreateDate = element.createdAt.toString();
          var newStr = roadblockCreateDate!.substring(0, 10) +
              ' ' +
              roadblockCreateDate!.substring(11, 23);
          print(newStr);
          DateTime dt = DateTime.parse(newStr);
          roadblockCreateDate1 = DateFormat("d MMM").format(dt);
        } else {
          roadblockCreateDate1 = 'N/A';
        }
      });
    } else {
      roadblockCreateDate1 = 'N/A';
    }
    String firstName = "";
    String lastName = "";
    // String fullName = '';
    if (widget.response!.data != null &&
        widget.response!.data!.roadblocks != null)
      widget.response!.data!.roadblocks!.forEach((element) {
        if (element.responsiblePerson != null &&
            element.responsiblePerson!.name != null) {
          rcName = element.responsiblePerson!.name;
          if (rcName!.contains(" ")) {
            List<String> splitedList =
                element.responsiblePerson!.name!.split(" ");
            firstName = splitedList[0];
            lastName = splitedList[1];
            fullName = firstName.substring(0, 1).toUpperCase() +
                lastName.substring(0, 1).toUpperCase();
          } else {
            fullName =
                element.responsiblePerson!.name!.substring(0, 1).toUpperCase();
          }
        } else {
          fullName = ' ';
        }
        _status = widget.response!.data != null &&
                widget.response!.data!.status != null &&
                widget.response!.data!.status!.isNotEmpty
            ? widget.response!.data!.status.toString()
            : '';
      });
  }

  List<SkillsData> getSuggestions(String query) {
    List<SkillsData> matches = List.empty(growable: true);
    matches.addAll(users);
    matches.retainWhere(
        (s) => s.name!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  //Edit project_detail api
  Future<void> removeTagAPI(String tagId) async {
    var token = 'Bearer ' + storage.read("token");
    try {
      var response = await http.delete(
        Uri.parse('${AppUrl.baseUrl}/project_detail/tags/${tagId}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        var responseJson =
            jsonDecode(response.body.toString()) as Map<String, dynamic>;
        final stringRes = JsonEncoder.withIndent('').convert(responseJson);
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failuree");
        print(response.body);
      }
    } catch (e) {}
  }

  //Edit project_detail api
  Future<void> saveTagApi(String projectId, String tagName) async {
    var token = 'Bearer ' + storage.read("token");
    try {
      var response = await http.post(
        Uri.parse('${AppUrl.baseUrl}/project_detail/tags'),
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
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failuree");
        print(response.body);
      }
    } catch (e) {}
  }
  //Add

  Future<void> _selectDate(setState, int calendarTapValue) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: Color(0xff0F172A),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
                colorScheme: ColorScheme.light(primary: Color(0xff0F172A))
                    .copyWith(secondary: Color(0xff0F172A))),
            child: child!,
          );
        },
        initialDate: calendarTapValue == 1
            ? selectedDate != null
                ? getInitialDate(calendarTapValue)
                : DateTime.now()
            : calendarTapValue == 2
                ? selectedDateReminder != null
                    ? getInitialDate(calendarTapValue)
                    : DateTime.now()
                : calendarTapValue == 3
                    ? selectedDateDevlivery != null
                        ? getInitialDate(calendarTapValue)
                        : DateTime.now()
                    : selectedDateDeadline != null
                        ? getInitialDate(calendarTapValue)
                        : DateTime.now(),
        firstDate: calendarTapValue == 1
            ? selectedDate != null
                ? getFirstDate(calendarTapValue)
                : DateTime.now()
            : calendarTapValue == 2
                ? selectedDateReminder != null
                    ? getFirstDate(calendarTapValue)
                    : DateTime.now()
                : calendarTapValue == 3
                    ? selectedDateDevlivery != null
                        ? getFirstDate(calendarTapValue)
                        : DateTime.now()
                    : selectedDateDeadline != null
                        ? getFirstDate(calendarTapValue)
                        : DateTime.now(),
        //firstDate: DateTime.now(),
        lastDate: DateTime(5000));

    if (picked != null && picked != selectedDate) {
      setState(() {
        if (calendarTapValue == 1) {
          selectedDate = picked;
        } else if (calendarTapValue == 2) {
          selectedDateReminder = picked;
        } else if (calendarTapValue == 3) {
          selectedDateDevlivery = picked;
        } else if (calendarTapValue == 4) {
          selectedDateDeadline = picked;
        } else {
          selectedDate = picked;
        }
      });
      addDescriptionProject();
    }
  }

  DateTime getFirstDate(int calendarTapValue) {
    if (calendarTapValue == 1) {
      if (selectedDate!.compareTo(DateTime.now()) < 0) {
        return selectedDate!;
      }
    } else if (calendarTapValue == 2) {
      if (selectedDateReminder!.compareTo(DateTime.now()) < 0) {
        return selectedDateReminder!;
      }
    } else if (calendarTapValue == 3) {
      if (selectedDateDevlivery!.compareTo(DateTime.now()) < 0) {
        return selectedDateDevlivery!;
      }
    } else {
      if (selectedDateDeadline!.compareTo(DateTime.now()) < 0) {
        return selectedDateDeadline!;
      }
    }
    return DateTime.now();
  }

  DateTime getInitialDate(int calendarTapValue) {
    if (calendarTapValue == 1) {
      return selectedDate!;
    } else if (calendarTapValue == 2) {
      return selectedDateReminder!;
    } else if (calendarTapValue == 3) {
      return selectedDateDevlivery!;
    } else {
      return selectedDateDeadline!;
    }
  }

  //Add description and time api
  Future<void> addDescriptionProject() async {
    var myFormat = DateFormat('yyyy-MM-dd');
    var token = 'Bearer ' + storage.read("token");
    try {
      var apiResponse = await http.post(
        ///project/$_id/update  /project_detail/project_detail-dates/$_id//project/project-dates/4?delivery_date=2022-09-13&reminder_date=2022-09-03&deadline_date=2022-09-10&working_days=12&cost=12000&description=test this is
        Uri.parse(
            '${AppUrl.baseUrl}/project/project-dates/${widget.response?.data?.id ?? 0}'),

        body: jsonEncode({
          "description": _description.text.toString(),
          "working_days": widget.response!.data != null &&
                  widget.response!.data!.workingDays != null
              ? widget.response!.data!.workingDays.toString()
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
      } else if (apiResponse.statusCode == 401) {
        AppUtil.showErrorDialog(context);
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
}
