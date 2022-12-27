import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButtonView();
  }

  PopupMenuButtonView() {
    return PopupMenuButton<int>(
      tooltip: "",
      // offset: widget.offset,
      // color: const Color(0xFF0F172A),
      // position: PopupMenuPosition.under,
      constraints: BoxConstraints.expand(width: 140.w, height: 120.h),
      // padding: EdgeInsets.only(left: 50, right: 50),
      offset: Offset(-100.w, 20.h),
      position: PopupMenuPosition.under,
      color: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),

      child: Container(
        height: 38.w,
        width: 38.w,
        decoration: BoxDecoration(
            color: const Color(0xff334155),
            border: Border.all(
              color: ColorSelect.box_decoration,
            ),
            borderRadius: BorderRadius.all(Radius.circular(100.r))),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0.r),
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
              height: 50.h,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 20.sp, top: 15.sp),
                child: Text(
                  "Edit",
                  style: TextStyle(
                      fontSize: 14.sp,
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
                          borderRadius: BorderRadius.circular(28.0.r),
                        ),
                        backgroundColor: ColorSelect.peoplelistbackgroundcolor,
                        content: Container(
                          height: 110.0.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20.0.r),
                                child: Text(
                                  "Do you want to delete ${widget.response.data?.title} ?",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                      color: ColorSelect.white_color),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15.0.h),
                                child: Text(
                                  "Once deleted, you will not find ${widget.response.data?.title} in the list.",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                      color: ColorSelect.delete),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 30.0.h),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.only(right: 35.0.w),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Inter',
                                                color: ColorSelect.delete_text),
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
                                            deleteProject(widget.id, context);
                                          });
                                        },
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Inter',
                                              color: Color(0xffEB4444)),
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
              height: 50.h,
              child: Padding(
                padding: EdgeInsets.only(left: 20.sp, top: 15.sp),
                child: Text(
                  "Delete",
                  style: TextStyle(
                      fontSize: 14.sp,
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
    );
  }

  deleteProject(String? projectId, BuildContext buildContext) async {
    var response;
    var url = '${AppUrl.deleteForProject}${projectId}';
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
        Navigator.of(context).pushAndRemoveUntil(
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
      AppUtil.showErrorDialog(
          context, "Your Session has been expired, Please try again!");
    } else {
      var user = userFromJson(response.body);
      Fluttertoast.showToast(
        msg: user.message != null ? user.message! : 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
      SmartDialog.dismiss();
    }
  }
}
