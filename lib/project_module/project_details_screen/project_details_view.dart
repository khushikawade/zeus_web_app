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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: Text(
                                widget.response?.data?.title ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 22.0.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Row(
                              children: [
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
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 16.0.sp, top: 12.0.sp),
                                  width: 110.w,
                                  height: 32.h,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.network(
                                            'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80',
                                            width: 32.w,
                                            height: 32.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 22.sp,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.network(
                                            'https://media.istockphoto.com/photos/side-view-of-one-young-woman-picture-id1134378235?k=20&m=1134378235&s=612x612&w=0&h=0yIqc847atslcQvC3sdYE6bRByfjNTfOkyJc5e34kgU=',
                                            width: 32.w,
                                            height: 32.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 46.0.sp,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.r),
                                          child: Container(
                                            width: 32.w,
                                            height: 32.w,
                                            color: Color(0xff334155),
                                            child: Image.network(
                                              'data:image/jpeg;base64,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',
                                              width: 32.w,
                                              height: 32.w,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 70.0.sp,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.r),
                                          child: Container(
                                            width: 32.w,
                                            height: 32.w,
                                            color: Color(0xff334155),
                                            child: Image.network(
                                              'data:image/jpeg;base64,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',
                                              width: 32.w,
                                              height: 32.w,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                          id: widget.response!.data!.id.toString(),
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
      height: 350.h,
      width: MediaQuery.of(context).size.width * 0.99,
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * (0.99 / 2),
              padding: EdgeInsets.only(right: 16.sp),
              margin: EdgeInsets.only(
                top: 15.sp,
              ),
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
                    margin:
                        EdgeInsets.only(left: 30.0.sp, top: 24.h, bottom: 12.h),
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
                      left: 15.0.sp,
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
                                              left: 30.0.sp, top: 8.0.sp),
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
                                              softWrap: false,
                                              style: TextStyle(
                                                  color: Color(0xffE2E8F0),
                                                  fontSize: 14.0.sp,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500),
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
                                          margin: EdgeInsets.only(top: 8.0.sp),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff334155),
                                            border: Border.all(
                                                color: const Color(0xff0F172A),
                                                width: 3.0.w),
                                            borderRadius: BorderRadius.circular(
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
                                                  fontWeight: FontWeight.w500),
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
      padding: EdgeInsets.only(left: 30.sp),
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
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: 2.sp,
                                  bottom: 2.sp,
                                ),
                                child: PopupMenuButton<int>(
                                  tooltip: '',
                                  offset: Offset(35, 48),
                                  color: Color(0xFF0F172A),
                                  child: Container(
                                      width: 45.0.h,
                                      height: 45.0.h,
                                      margin: EdgeInsets.only(
                                          left: abc.length < 2 ? 0 : 15.0.sp,
                                          top: 0),
                                      decoration: const BoxDecoration(
                                        color: Color(0xff334155),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(
                                        child: Padding(
                                            padding: EdgeInsets.all(10.0.sp),
                                            child: SvgPicture.asset(
                                              'images/tag_new.svg',
                                              height: 5.h,
                                              width: 5.h,
                                            )),
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
                                                suggestionsBoxVerticalOffset:
                                                    0.0,
                                                suggestionsBoxDecoration:
                                                    SuggestionsBoxDecoration(
                                                        color:
                                                            Color(0xff0F172A)),
                                                suggestionsCallback: (pattern) {
                                                  return getSuggestions(
                                                      pattern);
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
                                                        padding:
                                                            EdgeInsets.only(
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
                                                    suggestionsBox,
                                                    controller) {
                                                  return suggestionsBox;
                                                },
                                                onSuggestionSelected: (item) {
                                                  _typeAheadController.text =
                                                      '';
                                                  if (!abc
                                                      .contains(item.name)) {
                                                    abc.removeWhere((element) =>
                                                        element.isEmpty);
                                                    abc.add(item.name!);
                                                    abc.add("");
                                                    saveTagApi(
                                                        widget
                                                            .response!.data!.id
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
                                ),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 10.sp,
                ),
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
                margin: EdgeInsets.only(
                  left: 10.0.sp,
                  right: 35.0.sp,
                ),
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
                margin: EdgeInsets.only(
                  left: 10.0.sp,
                  right: 16.0.sp,
                ),
                child: SvgPicture.asset(
                  'images/cermony.svg',
                ),
              ),
            ],
          )
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
                  margin: EdgeInsets.only(left: 30.sp, top: 0.0),
                  child: Text(
                    "Timeline",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 16.0.sp,
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
                      child: Text(
                        "Request resources",
                        style: TextStyle(
                            color: Color(0xff93C5FD),
                            fontSize: 12.0.sp,
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
                          width: 10.0.h,
                          height: 10.0.h,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 80.0.sp, top: 0.0),
                        child: Text(
                          "New phase",
                          style: TextStyle(
                              color: Color(0xff93C5FD),
                              fontSize: 12.0.sp,
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
                Expanded(
                  flex: 65,
                  child: Container(
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
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Text(
                      "From",
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
                  child: Container(
                    child: Text(
                      "Till",
                      style: TextStyle(
                          color: Color(0xff94A3B8),
                          fontSize: 14.0.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Center(
                    child: Container(
                      child: Text(
                        "Action",
                        style: TextStyle(
                            color: Color(0xff94A3B8),
                            fontSize: 14.0.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500),
                      ),
                    ),
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.99,
                      margin: EdgeInsets.only(
                          left: 15.0.sp, top: 12.0.sp, right: 15.0.sp),
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          12.0.r,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 65,
                            child: Row(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 15.0.sp, top: 0.0),
                                  child: Container(
                                    height: 38.0.sp,
                                    width: 38.0.sp,
                                    decoration: BoxDecoration(
                                      color: Color(0xff334155),
                                      borderRadius: BorderRadius.circular(
                                        30.0.r,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "$name",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 12.0.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20.sp),
                                  child: Text(
                                    "$phaseType",
                                    style: TextStyle(
                                        color: Color(0xffE2E8F0),
                                        fontSize: 14.0.sp,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: Container(
                                child: Text(
                                  "$fromDate",
                                  style: TextStyle(
                                      color: Color(0xffffffff),
                                      fontSize: 14.0.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: Text(
                                "$tillDate",
                                style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: 14.0.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MenuPhase(
                                    index: index,
                                    onDeleteSuccess: () {
                                      setState(() {
                                        widget.response!.data!.phase!
                                            .removeAt(index);
                                      });
                                    },
                                    onEditClick: () async {
                                      Navigator.pop(context);
                                      bool result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return NewPhase(
                                                widget.response!.data!
                                                    .phase![index].id
                                                    .toString(),
                                                1);
                                          });
                                      if (result != null && result) {
                                        widget.response = await Provider.of<
                                                    ProjectHomeViewModel>(
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          left: 30.0.sp,
                          right: 30.0.sp,
                        ),
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
    } else {
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
