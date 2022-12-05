import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/pop_resource_button.dart';
import 'package:zeus/helper_widget/scrollbar_helper_widget.dart';
import 'package:zeus/helper_widget/searchbar.dart';
import 'package:zeus/navigation/tag_model/tag_user.dart';
import 'package:zeus/navigation/tag_model/tagresponse.dart';
import 'package:zeus/people_profile/editpage/edit_page.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/utility/app_url.dart';
import 'package:zeus/utility/dropdrowndata.dart';

import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import '../../../utility/colors.dart';
import '../../../people_profile/screen/people_detail_view.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../../../utility/constant.dart';
import '../../idle/data/project_detail_data/ProjectDetailData.dart';
import '../data/getdata_provider.dart';
import '../model/model_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';

class PeopleIdle extends StatefulWidget {
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? adOnSubmit;
  const PeopleIdle({Key? key, this.onSubmit, this.adOnSubmit})
      : super(key: key);

  @override
  State<PeopleIdle> createState() => _PeopleIdleState();
}

class _PeopleIdleState extends State<PeopleIdle> {
  List _timeline = [];
  String? _depat, _account, _custome, _curren, _status, _time, _tag;
  String token = "";
  var dataPeople = 'people_data';
  bool imageavail = false;

  //Future? _getList;
  var postion;
  SharedPreferences? sharedPreferences;

  final ScrollController horizontalScroll = ScrollController();
  final double width = 18;
  final double widthVertical = 10;

  // Future getPeopleData() {
  //   return Provider.of<PeopleIdelClass>(context, listen: false).getPeople();
  // }

  Future? getList;
  Future getListData1() {
    return Provider.of<ProjectDetail>(context, listen: false).changeProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void change() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('val', 'y');
  }

  @override
  void initState() {
    //_getList = getPeopleData();

    print(
        "Called second time ------------------------------------------- gff gf f");

    Provider.of<PeopleIdelClass>(context, listen: false).getPeopleDataList();
    change();
    getToken();
    // getpeople();
    super.initState();
  }

  void getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        token = sharedPreferences.getString('login')!;
        //   name = sharedPreferences.getString('user')!;
        print(token);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return AdaptiveScrollbar(
      underSpacing: EdgeInsets.only(bottom: width),
      controller: horizontalScroll,
      width: width,
      position: ScrollbarPosition.bottom,
      sliderDecoration: const BoxDecoration(
          color: Color(0xff4B5563),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      sliderActiveDecoration: const BoxDecoration(
          color: Color.fromRGBO(206, 206, 206, 100),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      underColor: Colors.transparent,
      child: MediaQuery(
        data: mediaQueryData.copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: ColorSelect.class_color,
          body: SingleChildScrollView(
            controller: horizontalScroll,
            scrollDirection: Axis.horizontal,
            //controller: vertical_scrollcontroller,
            // scrollDirection: Axis.vertical,
            child: Container(
              width: MediaQuery.of(context).size.width < 950
                  ? MediaQuery.of(context).size.width * 2
                  : MediaQuery.of(context).size.width - 160,

              // height: MediaQuery.of(context).size.height * 0.83,
              // height: MediaQuery.of(context).size.height * 0.83,

              height: 969,
              margin: const EdgeInsets.only(
                  left: 40.0, right: 30.0, bottom: 10.0, top: 40.0),
              decoration: BoxDecoration(
                color: const Color(0xff1E293B),
                border: Border.all(color: const Color(0xff1E293B)),
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Consumer<PeopleIdelClass>(builder: (context, data, _) {
                    return data.loading
                        ? const Expanded(
                            child: Center(child: CircularProgressIndicator()))
                        : Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                makePeopleList(data),
                              ],
                            ),
                          );
                    //return Container();
                  }),
                  //   FutureBuilder(
                  //       //future: _getList,
                  //       //future: getPeopleData(),
                  //       future:
                  //           Provider.of<PeopleIdelClass>(context, listen: true)
                  //               .getPeopleDataList(),
                  //       builder: (context, snapshot) {
                  //         if (snapshot.connectionState ==
                  //             ConnectionState.waiting) {
                  //           return const Expanded(
                  //               child:
                  //                   Center(child: CircularProgressIndicator()));
                  //         } else {
                  //           return Consumer<PeopleIdelClass>(
                  //               builder: (context, data, _) {
                  //             List<DataRow> rows = [];

                  //             if (data.peopleList != null) {
                  //               if (data.peopleList!.data!.isNotEmpty) {
                  //                 data.peopleList!.data!
                  //                     .asMap()
                  //                     .forEach((index, element) {
                  //                   PeopleData _peopleList =
                  //                       data.peopleList!.data![index];

                  //                   postion = [index];
                  //                   var designation = '';
                  //                   var associate = '';
                  //                   var nickname = '';
                  //                   var capacity = '';

                  //                   var name = _peopleList.name;
                  //                   if (_peopleList.resource != null) {
                  //                     designation =
                  //                         _peopleList.resource!.designation!;
                  //                   } else {
                  //                     designation = 'TBD';
                  //                   }

                  //                   if (_peopleList.resource != null) {
                  //                     associate =
                  //                         _peopleList.resource!.associate!;
                  //                   } else {
                  //                     associate = 'TBD';
                  //                   }

                  //                   if (_peopleList.resource != null) {
                  //                     nickname =
                  //                         _peopleList.resource!.nickname!;
                  //                   } else {
                  //                     nickname = 'TBD';
                  //                   }

                  //                   if (_peopleList.resource != null) {
                  //                     capacity =
                  //                         _peopleList.resource!.capacity!;
                  //                   } else {
                  //                     capacity = 'TBD';
                  //                   }

                  //                   var image = _peopleList.image;

                  //                   String firstName = "";
                  //                   String lastName = "";
                  //                   String fullName = '';

                  //                   var names;
                  //                   if (_peopleList.name != null &&
                  //                       _peopleList.name!.isNotEmpty) {
                  //                     if (_peopleList.name!.contains(" ")) {
                  //                       List<String> splitedList =
                  //                           _peopleList.name!.split(" ");

                  //                       firstName = splitedList[0];
                  //                       lastName = splitedList[1];

                  //                       fullName = firstName
                  //                               .substring(0, 1)
                  //                               .toUpperCase() +
                  //                           lastName
                  //                               .substring(0, 1)
                  //                               .toUpperCase();
                  //                     } else {
                  //                       fullName = _peopleList.name!
                  //                           .substring(0, 1)
                  //                           .toUpperCase();
                  //                     }
                  //                   }

                  //                   rows.add(DataRow(
                  //                       onSelectChanged: (newValue) {
                  //                         Navigator.push(
                  //                             context,
                  //                             MaterialPageRoute(
                  //                                 builder: (context) =>
                  //                                     ProfileDetail(
                  //                                         list: _peopleList)));
                  //                       },
                  //                       cells: [
                  //                         DataCell(Row(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.start,
                  //                           mainAxisSize: MainAxisSize.max,
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.center,
                  //                           children: [
                  //                             image != null && image.isNotEmpty
                  //                                 ? Container(
                  //                                     width: 32.0,
                  //                                     height: 32.0,
                  //                                     margin:
                  //                                         const EdgeInsets.only(
                  //                                             left: 0.0,
                  //                                             top: 0.0),
                  //                                     decoration: BoxDecoration(
                  //                                       color: const Color(
                  //                                           0xff334155),
                  //                                       borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(
                  //                                         40.0,
                  //                                       ),
                  //                                     ),
                  //                                     child: CircleAvatar(
                  //                                       radius: 20,
                  //                                       backgroundImage:
                  //                                           NetworkImage(image),
                  //                                     ))
                  //                                 : Container(
                  //                                     width: 32,
                  //                                     height: 50,
                  //                                     alignment:
                  //                                         Alignment.center,
                  //                                     decoration:
                  //                                         const BoxDecoration(
                  //                                             shape: BoxShape
                  //                                                 .circle,
                  //                                             color: Color(
                  //                                                 0xffF2F2F2)),
                  //                                     child: Text(
                  //                                       fullName != null &&
                  //                                               fullName
                  //                                                   .isNotEmpty
                  //                                           ? fullName
                  //                                           : '',
                  //                                       style: const TextStyle(
                  //                                           fontFamily:
                  //                                               'Inter-Medium',
                  //                                           fontSize: 14,
                  //                                           fontStyle: FontStyle
                  //                                               .normal,
                  //                                           fontWeight:
                  //                                               FontWeight.w500,
                  //                                           letterSpacing:
                  //                                               -0.33,
                  //                                           color: Color(
                  //                                               0xff8B8B8B)),
                  //                                     ),
                  //                                   ),
                  //                             Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment.start,
                  //                               mainAxisSize: MainAxisSize.min,
                  //                               children: [
                  //                                 Expanded(
                  //                                   child: Container(
                  //                                     margin:
                  //                                         const EdgeInsets.only(
                  //                                             left: 16.0,
                  //                                             top: 7.5),
                  //                                     child: Text(
                  //                                       "$name",
                  //                                       style: const TextStyle(
                  //                                           color: ColorSelect
                  //                                               .white_color,
                  //                                           fontSize: 14.0,
                  //                                           fontFamily: 'Inter',
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w500),
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                                 Expanded(
                  //                                   child: Container(
                  //                                     margin:
                  //                                         const EdgeInsets.only(
                  //                                             left: 16.0,
                  //                                             top: 5.5),
                  //                                     child: Text(
                  //                                       "$designation,$associate",
                  //                                       style: const TextStyle(
                  //                                           color: ColorSelect
                  //                                               .designation_color,
                  //                                           fontSize: 14.0,
                  //                                           fontFamily: 'Inter',
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w500),
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ],
                  //                         )),
                  //                         DataCell(
                  //                           Text(
                  //                             "@$nickname",
                  //                             style: const TextStyle(
                  //                                 color:
                  //                                     ColorSelect.white_color,
                  //                                 fontSize: 14.0,
                  //                                 fontFamily: 'Inter',
                  //                                 fontWeight: FontWeight.w500),
                  //                           ),
                  //                         ),
                  //                         DataCell(
                  //                           Text(
                  //                             "$capacity",
                  //                             style: const TextStyle(
                  //                                 color:
                  //                                     ColorSelect.white_color,
                  //                                 fontSize: 14.0,
                  //                                 fontFamily: 'Inter',
                  //                                 fontWeight: FontWeight.w500),
                  //                           ),
                  //                         ),
                  //                         const DataCell(
                  //                           Text(
                  //                             "TBD",
                  //                             style: TextStyle(
                  //                                 color:
                  //                                     ColorSelect.white_color,
                  //                                 fontSize: 14.0,
                  //                                 fontFamily: 'Inter',
                  //                                 fontWeight: FontWeight.w500),
                  //                           ),
                  //                         ),
                  //                         const DataCell(
                  //                           Text(
                  //                             "TBD",
                  //                             style: TextStyle(
                  //                                 color:
                  //                                     ColorSelect.white_color,
                  //                                 fontSize: 14.0,
                  //                                 fontFamily: 'Inter',
                  //                                 fontWeight: FontWeight.w500),
                  //                           ),
                  //                         ),
                  //                         DataCell(_peopleList.resource != null
                  //                             ? Container(
                  //                                 // height: 50,
                  //                                 width: 250,
                  //                                 child: ListView.builder(
                  //                                   shrinkWrap: true,
                  //                                   scrollDirection:
                  //                                       Axis.horizontal,
                  //                                   itemCount: _peopleList
                  //                                               .resource!
                  //                                               .skills!
                  //                                               .length <
                  //                                           3
                  //                                       ? _peopleList.resource!
                  //                                           .skills!.length
                  //                                       : 3,
                  //                                   itemBuilder:
                  //                                       (BuildContext context,
                  //                                           int index) {
                  //                                     Skills _skills =
                  //                                         _peopleList.resource!
                  //                                             .skills![index];
                  //                                     var skill = _skills.title;
                  //                                     postion = index;
                  //                                     return Container(
                  //                                       height: 25.0,
                  //                                       margin: const EdgeInsets
                  //                                               .only(
                  //                                           top: 10.0,
                  //                                           bottom: 10,
                  //                                           right: 12),
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                         color: const Color(
                  //                                             0xff334155),
                  //                                         borderRadius:
                  //                                             BorderRadius
                  //                                                 .circular(
                  //                                           8.0,
                  //                                         ),
                  //                                       ),
                  //                                       child: Align(
                  //                                         alignment:
                  //                                             Alignment.center,
                  //                                         child: Padding(
                  //                                           padding:
                  //                                               const EdgeInsets
                  //                                                       .only(
                  //                                                   top: 6.0,
                  //                                                   bottom: 6.0,
                  //                                                   right: 12.0,
                  //                                                   left: 12.0),
                  //                                           child: Text(
                  //                                             '$skill',
                  //                                             style: const TextStyle(
                  //                                                 color: ColorSelect
                  //                                                     .white_color,
                  //                                                 fontSize:
                  //                                                     14.0,
                  //                                                 fontFamily:
                  //                                                     'Inter',
                  //                                                 fontWeight:
                  //                                                     FontWeight
                  //                                                         .w400),
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                     );
                  //                                   },
                  //                                 ),
                  //                               )
                  //                             : const Text('TBD',
                  //                                 style: TextStyle(
                  //                                     color: ColorSelect
                  //                                         .white_color,
                  //                                     fontSize: 14.0,
                  //                                     fontFamily: 'Inter',
                  //                                     fontWeight:
                  //                                         FontWeight.w500))),
                  //                         DataCell(
                  //                           Padding(
                  //                             padding: const EdgeInsets.only(
                  //                                 left: 10.0, bottom: 12),
                  //                             child: Stack(children: [
                  //                               MyMenu(
                  //                                   data: data.peopleList!
                  //                                       .data![index],
                  //                                   title: 'Menu at bottom',
                  //                                   alignment:
                  //                                       Alignment.bottomRight)
                  //                             ]),
                  //                           ),
                  //                         )
                  //                       ]));
                  //                 });
                  //               }
                  //             }

                  //             return data.peopleList == null ||
                  //                     data.peopleList!.data!.isEmpty
                  //                 ? const Expanded(
                  //                     child: Center(
                  //                         child: Text(
                  //                       "No Records Found !",
                  //                       style: TextStyle(
                  //                           color: Color(0xffFFFFFF),
                  //                           fontSize: 22.0,
                  //                           fontFamily: 'Inter',
                  //                           fontWeight: FontWeight.w500),
                  //                     )),
                  //                   )
                  //                 : Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.start,
                  //                     mainAxisSize: MainAxisSize.max,
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.center,
                  //                     children: [
                  //                       Expanded(
                  //                         child: FittedBox(
                  //                           child: SingleChildScrollView(
                  //                             // controller:
                  //                             //     vertical_scrollcontroller,
                  //                             scrollDirection: Axis.vertical,
                  //                             child: SingleChildScrollView(
                  //                               scrollDirection:
                  //                                   Axis.horizontal,
                  //                               child: DataTable(
                  //                                   showCheckboxColumn: false,
                  //                                   dataRowHeight: 60,
                  //                                   columns: const [
                  //                                     DataColumn(
                  //                                       label: Text(
                  //                                         "Name",
                  //                                         style: TextStyle(
                  //                                             color: ColorSelect
                  //                                                 .text_color,
                  //                                             fontSize: 14.0,
                  //                                             fontFamily:
                  //                                                 'Inter',
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500),
                  //                                       ),
                  //                                     ),
                  //                                     DataColumn(
                  //                                       label: Text(
                  //                                         "Nickname",
                  //                                         style: TextStyle(
                  //                                             color: ColorSelect
                  //                                                 .text_color,
                  //                                             fontSize: 14.0,
                  //                                             fontFamily:
                  //                                                 'Inter',
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500),
                  //                                       ),
                  //                                     ),
                  //                                     DataColumn(
                  //                                       label: Text(
                  //                                         "Capacity",
                  //                                         style: TextStyle(
                  //                                             color: ColorSelect
                  //                                                 .text_color,
                  //                                             fontSize: 14.0,
                  //                                             fontFamily:
                  //                                                 'Inter',
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500),
                  //                                       ),
                  //                                     ),
                  //                                     DataColumn(
                  //                                       label: Text(
                  //                                         "Occupied till",
                  //                                         style: TextStyle(
                  //                                             color: ColorSelect
                  //                                                 .text_color,
                  //                                             fontSize: 14.0,
                  //                                             fontFamily:
                  //                                                 'Inter',
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500),
                  //                                       ),
                  //                                     ),
                  //                                     DataColumn(
                  //                                       label: Text(
                  //                                         "Scheduled on",
                  //                                         style: TextStyle(
                  //                                             color: ColorSelect
                  //                                                 .text_color,
                  //                                             fontSize: 14.0,
                  //                                             fontFamily:
                  //                                                 'Inter',
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500),
                  //                                       ),
                  //                                     ),
                  //                                     DataColumn(
                  //                                       label: Text(
                  //                                         "Skills",
                  //                                         style: TextStyle(
                  //                                             color: ColorSelect
                  //                                                 .text_color,
                  //                                             fontSize: 14.0,
                  //                                             fontFamily:
                  //                                                 'Inter',
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500),
                  //                                       ),
                  //                                     ),
                  //                                     DataColumn(
                  //                                       label: Text(
                  //                                         "",
                  //                                         style: TextStyle(
                  //                                             color: ColorSelect
                  //                                                 .text_color,
                  //                                             fontSize: 14.0,
                  //                                             fontFamily:
                  //                                                 'Inter',
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w500),
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                   rows: rows),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   );
                  //           });
                  //         }
                  //       }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Make People List widget or Data Table
  Widget makePeopleList(PeopleIdelClass data) {
    List<DataRow> rows = [];

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
          if (_peopleList.resource != null) {
            designation = _peopleList.resource!.designation!;
          } else {
            designation = 'TBD';
          }

          if (_peopleList.resource != null) {
            associate = _peopleList.resource!.associate!;
          } else {
            associate = 'TBD';
          }

          if (_peopleList.resource != null) {
            nickname = _peopleList.resource!.nickname!;
          } else {
            nickname = 'TBD';
          }

          if (_peopleList.resource != null) {
            capacity = _peopleList.resource!.capacity!;
          } else {
            capacity = 'TBD';
          }

          var image = _peopleList.image;

          String firstName = "";
          String lastName = "";
          String fullName = '';

          var names;
          if (_peopleList.name != null && _peopleList.name!.isNotEmpty) {
            if (_peopleList.name!.contains(" ")) {
              List<String> splitedList = _peopleList.name!.split(" ");

              firstName = splitedList[0];
              lastName = splitedList[1];

              fullName = firstName.substring(0, 1).toUpperCase() +
                  lastName.substring(0, 1).toUpperCase();
            } else {
              fullName = _peopleList.name!.substring(0, 1).toUpperCase();
            }
          }

          rows.add(DataRow(
              onSelectChanged: (newValue) async {
                bool result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileDetail(list: _peopleList)));

                if (result != null && result) {
                  Provider.of<PeopleIdelClass>(context, listen: false)
                      .getPeopleDataList();
                }
              },
              cells: [
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    image != null && image.isNotEmpty
                        ? Container(
                            width: 32.0,
                            height: 32.0,
                            margin: const EdgeInsets.only(left: 0.0, top: 0.0),
                            decoration: BoxDecoration(
                              color: const Color(0xff334155),
                              borderRadius: BorderRadius.circular(
                                40.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(image),
                            ))
                        : Container(
                            width: 32,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffF2F2F2)),
                            child: Text(
                              fullName != null && fullName.isNotEmpty
                                  ? fullName
                                  : '',
                              style: const TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.33,
                                  color: Color(0xff8B8B8B)),
                            ),
                          ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 16.0, top: 7.5),
                            child: Text(
                              "$name",
                              style: const TextStyle(
                                  color: ColorSelect.white_color,
                                  fontSize: 14.0,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 16.0, top: 0),
                            child: Text(
                              "$designation,$associate",
                              style: const TextStyle(
                                  color: ColorSelect.designation_color,
                                  fontSize: 14.0,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
                DataCell(
                  Text(
                    "@$nickname",
                    style: const TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Text(
                    "$capacity",
                    style: const TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const DataCell(
                  Text(
                    "TBD",
                    style: TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const DataCell(
                  Text(
                    "TBD",
                    style: TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(_peopleList.resource != null
                    ? Container(
                        // height: 50,
                        width: 250,
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
                              height: 25.0,
                              margin: const EdgeInsets.only(
                                  top: 10.0, bottom: 10, right: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 6.0,
                                      bottom: 6.0,
                                      right: 12.0,
                                      left: 12.0),
                                  child: Text(
                                    '$skill',
                                    style: const TextStyle(
                                        color: ColorSelect.white_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Text('TBD',
                        style: TextStyle(
                            color: ColorSelect.white_color,
                            fontSize: 14.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500))),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 12),
                    child: Stack(children: [
                      MyMenu(
                        peopleList: data.peopleList!.data,
                        data: data.peopleList!.data![index],
                        title: 'Menu at bottom',
                        alignment: Alignment.bottomRight,
                        buildContext: context,
                        returnValue: () {
                          print(
                              "Value returned --------------------------------------");
                          Provider.of<PeopleIdelClass>(context, listen: false)
                              .getPeopleDataList();
                          // setState(() {
                          //   data.peopleList!.data!.forEach((element) {
                          //     data.peopleList!.data!.removeAt(index);
                          //     // if (element.id.toString() ==
                          //     //     data.peopleList!.data![index].id.toString()) {

                          //     //   data.peopleList!.data!.removeAt(index);
                          //     // }
                          //   });
                          // });
                        },
                      )
                    ]),
                  ),
                )
              ]));
        });
      }
    }

    return data.peopleList == null || data.peopleList!.data!.isEmpty
        ? Container(
            width: MediaQuery.of(context).size.width < 950
                ? MediaQuery.of(context).size.width * 2
                : MediaQuery.of(context).size.width - 200,

            // height: MediaQuery.of(context).size.height * 0.83,
            // height: MediaQuery.of(context).size.height * 0.83,

            height: 969,
            child: const Center(
                child: Text(
              "No Records Found!",
              style: TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 22.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500),
            )),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Color(0xff525f72)),
                          child: DataTable(
                              // showBottomBorder: true,
                              showCheckboxColumn: false,
                              dataRowHeight: 60,
                              dividerThickness: 0.7,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    "Name",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Nickname",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Capacity",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Occupied till",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Scheduled on",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Skills",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Action",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
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
              ),
            ],
          );
  }

  Future<String?> getTimeline() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/time-zone/list"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _timeline = mdata;
        });
        //var res = response.body;
        //  print('helloDepartment' + res);
        //  DepartmentResponce peopleList = DepartmentResponce.fromJson(json.decode(res));
        // return peopleList;

        // final stringRes = JsonEncoder.withIndent('').convert(res);
        //  print(stringRes);
      } else {
        print("failed to much");
      }
      return value;
    }
  }
}
