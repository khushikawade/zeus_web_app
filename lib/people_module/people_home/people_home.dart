import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrouter/vrouter.dart';
import 'package:zeus/helper_widget/pop_resource_button.dart' as pop;
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/routers/route_constants.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/project_module/project_home/project_home_view_model.dart';
import 'package:zeus/services/model/model_class.dart';
import 'package:zeus/user_module/people_profile/screen/people_detail_view.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:zeus/utility/util.dart';
import '../../utility/colors.dart';
import '../../utility/constant.dart';
import 'people_home_view_model.dart';

class PeopleHomeView extends StatefulWidget {
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? adOnSubmit;
  const PeopleHomeView({Key? key, this.onSubmit, this.adOnSubmit})
      : super(key: key);

  @override
  State<PeopleHomeView> createState() => _PeopleHomeViewState();
}

class _PeopleHomeViewState extends State<PeopleHomeView> {
  // String token = "";
  var dataPeople = 'people_data';
  bool imageavail = false;

  var postion;
  SharedPreferences? sharedPreferences;

  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();

  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);

  void change() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString('val', 'y');
  }

  @override
  void initState() {
    Provider.of<PeopleHomeViewModel>(context, listen: false)
        .getPeopleDataList();
    change();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<PeopleHomeViewModel>(context, listen: false)
        .getPeopleDataList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQueryData.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorSelect.class_color,
        body: Container(
          // width: MediaQuery.of(context).size.width < 950
          //     ? MediaQuery.of(context).size.width * 2
          //     : MediaQuery.of(context).size.width - 160,
          height: 969,
          margin: EdgeInsets.only(
              left: 40.sp, right: 30.sp, bottom: 10.sp, top: 40.sp),
          decoration: BoxDecoration(
            color: const Color(0xff1E293B),
            border: Border.all(color: const Color(0xff1E293B)),
            borderRadius: BorderRadius.circular(
              12.r,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<PeopleHomeViewModel>(builder: (context, data, _) {
                return data.loading
                    ? const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : data.peopleList == null ||
                            data.peopleList == null ||
                            data.peopleList!.data!.isEmpty
                        ? Expanded(
                            child: Center(
                                child: Text(
                              "No Records Found!",
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 22.sp,
                                  fontFamily: 'Inter-Medium',
                                  letterSpacing: 0.1,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500),
                            )),
                          )
                        : Expanded(
                            child: RawScrollbar(
                              controller: verticalScroll,
                              thumbColor: const Color(0xff4b5563),
                              crossAxisMargin: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              thickness: 8,
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context)
                                    .copyWith(scrollbars: false),
                                child: ListView(
                                  controller: verticalScroll,
                                  shrinkWrap: true,
                                  children: [
                                    makePeopleList(data),
                                  ],
                                ),
                              ),
                            ),
                          );
              }),
            ],
          ),
        ),
      ),
      //),
    );
  }

  // Make People List widget or Data Table
  Widget makePeopleList(PeopleHomeViewModel data) {
    List<DataRow> rows = [];
    String firstName = "";
    String lastName = "";
    String fullName = '';

    if (data.peopleList != null) {
      if (data.peopleList!.data!.isNotEmpty) {
        data.peopleList!.data!.asMap().forEach((index, element) {
          PeopleData _peopleList = data.peopleList!.data![index];

          postion = [index];
          var designation = '';
          var associate = '';
          var nickname = '';
          var capacity = '';

          var name = _peopleList.name;

          try {
            if (_peopleList.resource != null) {
              designation = _peopleList.resource!.designation!;
            } else {
              designation = 'N/A';
            }
          } catch (e) {
            print("Exception in ----------------------------- 1 ${e}");
          }

          try {
            if (_peopleList.resource != null) {
              associate = _peopleList.resource!.associate!;
            } else {
              associate = 'N/A';
            }
          } catch (e) {
            print("Exception in ----------------------------- 2 ${e}");
          }

          try {
            if (_peopleList.resource != null) {
              nickname = _peopleList.resource!.nickname!;
            } else {
              nickname = 'N/A';
            }
          } catch (e) {
            print("Exception in ----------------------------- 3 ${e}");
          }

          try {
            if (_peopleList.resource != null) {
              capacity = _peopleList.resource!.capacity!;
            } else {
              capacity = 'N/A';
            }
          } catch (e) {
            print("Exception in ----------------------------- 4 ${e}");
          }

          var image = _peopleList.image;

          try {
            if (_peopleList.name != null && _peopleList.name!.isNotEmpty) {
              if (_peopleList.name!.contains(" ")) {
                List<String> splitedList = _peopleList.name!.split(" ");

                if (splitedList.length > 1) {
                  firstName = splitedList[0];
                  if (splitedList[1].isNotEmpty) {
                    lastName = splitedList[1];
                  }
                } else {
                  firstName = splitedList[0];
                }

                fullName = firstName.substring(0, 1).toUpperCase() +
                    lastName.substring(0, 1).toUpperCase();
              } else {
                fullName = _peopleList.name!.substring(0, 1).toUpperCase();
              }
            }
          } catch (e) {
            print("Exception in ----------------------------- 5 ${e}");
          }

          rows.add(DataRow(
              onSelectChanged: (newValue) async {
                context.vRouter.toSegments(
                    ["people", RouteConstants.peopleDetails],
                    queryParameters: {"id": _peopleList.id.toString()});
              },
              cells: [
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    image != null && image.isNotEmpty
                        ? Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 20.r,
                              backgroundImage: NetworkImage(image),
                            ))
                        : Container(
                            width: 32.w,
                            height: 32.h,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffF2F2F2)),
                            child: Text(
                              fullName.isNotEmpty ? fullName : '',
                              style: TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: Color(0xff8B8B8B)),
                            ),
                          ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$name",
                            style: TextStyle(
                                color: ColorSelect.white_color,
                                fontSize: 14.sp,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.1,
                                fontFamily: 'Inter-Medium',
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "$designation, $associate",
                            style: TextStyle(
                                color: ColorSelect.designation_color,
                                fontSize: 14.sp,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.1,
                                fontFamily: 'Inter-Medium',
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                DataCell(
                  Text(
                    "@$nickname",
                    style: TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.sp,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.1,
                        fontFamily: 'Inter-Medium',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Text(
                    "$capacity" "h/week",
                    style: TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.sp,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.1,
                        fontFamily: 'Inter-Medium',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Text(
                    "TBD",
                    style: TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.sp,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.1,
                        fontFamily: 'Inter-Medium',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Text(
                    "TBD",
                    style: TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.sp,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.1,
                        fontFamily: 'Inter-Medium',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(_peopleList.resource != null &&
                        _peopleList.resource!.skills != null &&
                        _peopleList.resource!.skills!.isNotEmpty
                    ? Container(
                        // color: Colors.amber,
                        width: 260.w,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _peopleList.resource!.skills!.length < 3
                              ? _peopleList.resource!.skills!.length
                              : 3,
                          itemBuilder: (BuildContext context, int index) {
                            Skills _skills =
                                _peopleList.resource!.skills![index];
                            var skill = _skills.title;
                            postion = index;
                            return Container(
                              height: 32.h,
                              margin: EdgeInsets.only(
                                  top: 10.sp, bottom: 10.sp, right: 12.sp),
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                borderRadius: BorderRadius.circular(
                                  8.r,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.sp,
                                      bottom: 8.sp,
                                      right: 12.sp,
                                      left: 12.sp),
                                  child: Text(
                                    '$skill',
                                    style: TextStyle(
                                        color: ColorSelect.white_color,
                                        fontSize: 14.sp,
                                        letterSpacing: 0.1,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Inter-Regular',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Text('N/A',
                        style: TextStyle(
                            color: ColorSelect.white_color,
                            fontSize: 14.sp,
                            letterSpacing: 0.1,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Inter-Regular',
                            fontWeight: FontWeight.w400))),
                DataCell(
                  Stack(children: [
                    pop.MyMenu(
                      peopleList: data.peopleList!.data,
                      data: data.peopleList!.data![index],
                      title: 'Menu at bottom',
                      alignment: Alignment.bottomRight,
                      buildContext: context,
                      returnValue: () {
                        print(
                            "Value returned --------------------------------------");
                        Provider.of<PeopleHomeViewModel>(context, listen: false)
                            .getPeopleDataList();
                      },
                    )
                  ]),
                )
              ]));
        });
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: FittedBox(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: RawScrollbar(
              controller: horizontalScroll,
              thumbColor: const Color(0xff4b5563),
              radius: Radius.circular(20.r),
              thickness: 10,
              child: SingleChildScrollView(
                controller: horizontalScroll,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.sp, right: 20.sp),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Color(0xff525f72)),
                    child: DataTable(
                        horizontalMargin: 10,
                        showCheckboxColumn: false,
                        dataRowHeight: 60.h,
                        dividerThickness: 0.7,
                        columns: [
                          DataColumn(
                            label: Text(
                              "Name",
                              style: TextStyle(
                                  color: ColorSelect.text_color,
                                  fontSize: ScreenUtil().setSp(14.sp),
                                  fontFamily: 'Inter-Medium',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Nickname",
                              style: TextStyle(
                                  color: ColorSelect.text_color,
                                  fontSize: ScreenUtil().setSp(14.sp),
                                  fontFamily: 'Inter-Medium',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Capacity",
                              style: TextStyle(
                                  color: ColorSelect.text_color,
                                  fontSize: ScreenUtil().setSp(14.sp),
                                  fontFamily: 'Inter-Medium',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Occupied till",
                              style: TextStyle(
                                  color: ColorSelect.text_color,
                                  fontSize: ScreenUtil().setSp(14.sp),
                                  fontFamily: 'Inter-Medium',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Scheduled on",
                              style: TextStyle(
                                  color: ColorSelect.text_color,
                                  fontSize: ScreenUtil().setSp(14.sp),
                                  fontFamily: 'Inter-Medium',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Skills",
                              style: TextStyle(
                                  color: ColorSelect.text_color,
                                  fontSize: ScreenUtil().setSp(14.sp),
                                  fontFamily: 'Inter-Medium',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Action",
                              style: TextStyle(
                                  color: ColorSelect.text_color,
                                  fontSize: ScreenUtil().setSp(14.sp),
                                  fontFamily: 'Inter-Medium',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                        rows: rows),
                  ),
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vrouter/vrouter.dart';
// import 'package:zeus/helper_widget/pop_resource_button.dart' as pop;
// import 'package:zeus/people_module/people_home/people_home_view_model.dart';
// import 'package:zeus/routers/routers_class.dart';
// import 'package:zeus/project_module/project_home/project_home_view_model.dart';
// import 'package:zeus/services/model/model_class.dart';
// import 'package:zeus/user_module/people_profile/screen/people_detail_view.dart';
// import 'package:zeus/utility/app_url.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import 'package:zeus/utility/util.dart';
// import '../../utility/colors.dart';
// import '../../utility/constant.dart';
// import 'people_home_view_model.dart';

// class PeopleHomeView extends StatefulWidget {
//   final ValueChanged<String>? onSubmit;
//   final ValueChanged<String>? adOnSubmit;
//   const PeopleHomeView({Key? key, this.onSubmit, this.adOnSubmit})
//       : super(key: key);

//   @override
//   State<PeopleHomeView> createState() => _PeopleHomeViewState();
// }

// class _PeopleHomeViewState extends State<PeopleHomeView> {
//   final ScrollController horizontalScroll = ScrollController();
//   final ScrollController verticalScroll = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     final mediaQueryData = MediaQuery.of(context);

//     return MediaQuery(
//       data: mediaQueryData.copyWith(textScaleFactor: 1.0),
//       child:
//           // Scaffold(
//           //   backgroundColor: ColorSelect.class_color,
//           //   body:
//           Container(
//         //width: 100,
//         width: MediaQuery.of(context).size.width < 950
//             ? MediaQuery.of(context).size.width * 2
//             : MediaQuery.of(context).size.width - 160,
//         height: 969,
//         margin: const EdgeInsets.only(
//             left: 40.0, right: 30.0, bottom: 10.0, top: 40.0),
//         decoration: BoxDecoration(
//           color: const Color(0xff1E293B),
//           border: Border.all(color: const Color(0xff1E293B)),
//           borderRadius: BorderRadius.circular(
//             12.0,
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             makePeopleList(),
//           ],
//         ),
//         //),
//       ),
//     );
//   }

//   // Make People List widget or Data Table
//   Widget makePeopleList() {
//     List<DataRow> rows = [];

//     rows.add(DataRow(onSelectChanged: (newValue) {}, cells: [
//       DataCell(Container(
//         width: 32,
//         height: 50,
//         alignment: Alignment.center,
//         decoration: const BoxDecoration(
//             shape: BoxShape.circle, color: Color(0xff334155)),
//         child: Text(
//           'AP1',
//           style: const TextStyle(
//               fontFamily: 'Inter-Medium',
//               fontSize: 14,
//               fontStyle: FontStyle.normal,
//               fontWeight: FontWeight.w500,
//               letterSpacing: -0.33,
//               color: Colors.white),
//         ),
//       )),
//       DataCell(
//         ConstrainedBox(
//           constraints: new BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * .18,
//           ),
//           child: Text(
//             "Project 11",
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14.0,
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//       DataCell(
//         Text(
//           "Phase 22",
//           style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14.0,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500),
//         ),
//       ),
//       DataCell(
//         Container(
//           padding:
//               const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8), color: Colors.blue),
//           child: Text(
//             "Running 1",
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14.0,
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//       DataCell(
//         Text(
//           "1",
//           style: TextStyle(
//               color: Colors.white,
//               fontSize: 14.0,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500),
//         ),
//       ),
//       DataCell(
//         Text(
//           "N/A 1",
//           style: TextStyle(
//               color: Colors.white,
//               fontSize: 14.0,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500),
//         ),
//       ),
//       DataCell(
//         Text(
//           "12 May 111",
//           style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14.0,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500),
//         ),
//       ),
//       DataCell(
//         Text(
//           'N/A 111',
//           style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14.0,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500),
//         ),
//       ),
//       DataCell(
//         Text(
//           "26 Jan 111",
//           style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14.0,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500),
//         ),
//       ),
//       DataCell(
//         Text(
//           "30 Mar 111",
//           style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14.0,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500),
//         ),
//       ),
//       const DataCell(
//         Text(
//           "TBD 111",
//           style: TextStyle(
//               color: Colors.white,
//               fontSize: 14.0,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w500),
//         ),
//       ),
//     ]));

//     return Row(
//       key: Key("show_more_ink_well"),
//       mainAxisAlignment: MainAxisAlignment.start,
//       mainAxisSize: MainAxisSize.max,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           child: FittedBox(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: RawScrollbar(
//                 controller: horizontalScroll,
//                 isAlwaysShown: true,
//                 thumbColor: const Color(0xff4b5563),
//                 radius: Radius.circular(20),
//                 thickness: 10,
//                 child: SingleChildScrollView(
//                   controller: horizontalScroll,
//                   scrollDirection: Axis.horizontal,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 16, right: 16),
//                     child: Theme(
//                       data: Theme.of(context)
//                           .copyWith(dividerColor: Color(0xff525f72)),
//                       child: DataTable(
//                           horizontalMargin: 10,
//                           showCheckboxColumn: false,
//                           dataRowHeight: 60,
//                           dividerThickness: 0.7,
//                           columns: [
//                             DataColumn(
//                               label: MouseRegion(
//                                 onEnter: (event) {},
//                                 child: Text(
//                                   "AP",
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.0,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 "Project name",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14.0,
//                                     fontFamily: 'Inter',
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             ),
//                             DataColumn(
//                               label: InkWell(
//                                 child: Text(
//                                   "Current phase",
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.0,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: InkWell(
//                                 child: Text(
//                                   "Status",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.0,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: InkWell(
//                                 child: Text(
//                                   "SPI",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.0,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: InkWell(
//                                 child: Text(
//                                   "Potential roadblocks",
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.0,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: InkWell(
//                                 child: Text(
//                                   "Last\nupdate",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.0,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: InkWell(
//                                 child: Text(
//                                   "Next\nmilestone",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.0,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: InkWell(
//                                 child: Text(
//                                   "Delivery\ndate",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.0,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: InkWell(
//                                 child: Text(
//                                   "Deadline",
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.0,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                             DataColumn(
//                               label: InkWell(
//                                 child: Text(
//                                   "Resources",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.0,
//                                       fontFamily: 'Inter',
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),
//                             ),
//                           ],
//                           rows: rows),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
