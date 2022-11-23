import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:zeus/helper_widget/scrollbar_helper_widget.dart';
import 'package:zeus/navigation/skills_model/skills_response_project.dart';
import 'package:zeus/navigator_tabs/idle/PopScreen.dart';
import 'package:zeus/utility/colors.dart';
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';
import 'dart:convert';
import '../../navigation/skills_model/skills_response.dart';
import '../../utility/app_url.dart';
import '../../popup/Popup.dart';
import '../../widgets/custom_app_bar.dart';
import 'PopScreen.dart';
import 'PopScreen.dart';
import 'PopScreen.dart';
import 'data/DataClass.dart';
import 'data/project_detail_data/ProjectDetailData.dart';
import 'project_detail_model/project_detail_response.dart';
import 'project_idel_model/project_idel_response.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';

class Idle extends StatefulWidget {
  const Idle({Key? key}) : super(key: key);

  @override
  State<Idle> createState() => _IdleState();
}

class _IdleState extends State<Idle> {
  List _statusList = [];
  List _currencyName = [];
  List _accountableId = [];
  List _customerName = [];
  List<SkillsData> skillsData = [];
  PopupScreen popupScreen = PopupScreen();

  //String? id = "";
  bool amIHovering = false;

  //Future? _getData;
  Future? _getProjectDetail;
  Offset exitFrom = const Offset(0, 0);
  bool hovered = false;

  final ScrollController horizontalScroll = ScrollController();
  final double width = 18;

  final ScrollController vertical_scrollcontroller = ScrollController();

  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  double? _scrollPosition = 0;
  double? _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition;
    });
  }

  showMenus(BuildContext context, int index) async {
    await showMenu(
      color: Color(0xff334155),
      context: context,
      position: RelativeRect.fromLTRB(450, 240, 120, 0),
      items: [
        PopupMenuItem(
          child: Column(
            children: [
              Container(
                width: 219.0,
                child: Row(
                  children: [
                    Container(
                        width: 32.0,
                        height: 32.0,
                        margin: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://picsum.photos/id/237/200/300'),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 8.0),
                      child: const Text(
                        'Ruben Culhane',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 219.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Container(
                        width: 32.0,
                        height: 32.0,
                        margin: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://picsum.photos/id/237/200/300'),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 8.0),
                      child: const Text(
                        'Ruben Culhane',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 219.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Container(
                        width: 32.0,
                        height: 32.0,
                        margin: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://picsum.photos/id/237/200/300'),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 8.0),
                      child: const Text(
                        'Ruben Culhane',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 219.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Container(
                        width: 32.0,
                        height: 32.0,
                        margin: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://picsum.photos/id/237/200/300'),
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 8.0),
                      child: const Text(
                        'Ruben Culhane',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /* const PopupMenuItem(
          child: Text("Edit"),),
        const PopupMenuItem(

          child: Text("Delete"),),*/
        ),
      ],
    );
  }

  ScrollController _controller = ScrollController();

  Future? getListData() {
    return Provider.of<DataIdelClass>(context, listen: false).getPeopleIdel();
  }

  Future? getList;

  Future getListData1() {
    return Provider.of<ProjectDetail>(context, listen: false).changeProfile();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // change();
    getList = getListData1();
    super.didChangeDependencies();
  }

  void change() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('val', 'q');
  }

  @override
  void initState() {
    //getIdel();
    //_getData = getListData();
    getListData();
    change();
    getSelectStatus();
    getAccountable();
    getAccountable();
    getCustomer();
    getCurrency();
    getUsers();
    //  var abv=Provider.of<ProjectDetail>(context, listen: false).productData();
    // print('checkDate '+abv.data.toString());
    //var a=_getProjectDetail as ProjectDetailResponse;
    // print(a.data!.title);
    // getData.getPeopleIdel();
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients) _scrollController.jumpTo(50.0);
    // });
  }

  // Make People List widget or Data Table
  Widget makeProjectList(DataIdelClass? data) {
    List<DataRow> rows = [];

    if (data!.peopleIdelResponse != null) {
      if (data.peopleIdelResponse!.data!.isNotEmpty) {
        data.peopleIdelResponse!.data!.asMap().forEach((index, element) {
          Data _projectData = data.peopleIdelResponse!.data![index];

          //postion = [index];
          var projectName = '';
          var projectStatus = '';
          var updatedAt = '';
          var deliveryDate = '';
          var deadlineDate = '';
          var currentPhase = '';
          var customerImage = '';
          var nextMileStone = '';

          if (_projectData != null &&
              _projectData.title != null &&
              _projectData.title!.isNotEmpty) {
            projectName = _projectData.title!;
          } else {
            projectName = "TBD";
          }

          if (_projectData != null &&
              _projectData.status != null &&
              _projectData.status!.isNotEmpty) {
            projectStatus = _projectData.status!;
          } else {
            projectStatus = "TBD";
          }

          if (_projectData != null &&
              _projectData.updatedAt != null &&
              _projectData.updatedAt!.isNotEmpty) {
            updatedAt = AppUtil.formattedDate(_projectData.updatedAt!);
          } else {
            updatedAt = "N/A";
          }

          if (_projectData != null &&
              _projectData.deliveryDate != null &&
              _projectData.deliveryDate!.isNotEmpty) {
            deliveryDate = AppUtil.formattedDate(_projectData.deliveryDate!);
          } else {
            deliveryDate = "N/A";
          }

          if (_projectData != null &&
              _projectData.deadlineDate != null &&
              _projectData.deadlineDate!.isNotEmpty) {
            deadlineDate = AppUtil.formattedDate(_projectData.deadlineDate!);
          } else {
            deadlineDate = "N/A";
          }

          // if (_projectData != null &&
          //     _projectData.currentPhase! != null &&
          //     _projectData.currentPhase!.title != null &&
          //     _projectData.currentPhase!.title!.isNotEmpty) {
          //   currentPhase = _projectData.currentPhase!.title!;
          // } else {
          //   currentPhase = "TBD";
          // }

          if (_projectData.currentPhase == null) {
            currentPhase = "N/A";
          } else {
            if (_projectData.currentPhase! != null &&
                _projectData.currentPhase!.title != null &&
                _projectData.currentPhase!.title!.isNotEmpty) {
              currentPhase = _projectData.currentPhase!.title!;
            }
          }

          if (_projectData != null &&
              _projectData.customer != null &&
              _projectData.customer!.image != null &&
              _projectData.customer!.image!.isNotEmpty) {
            print(_projectData.customer!.image!);
          } else {
            print("96939633");
          }

          if (_projectData != null &&
              _projectData.currentPhase != null &&
              _projectData.currentPhase!.currentMilestone != null &&
              _projectData.currentPhase!.currentMilestone!.mDate != null) {
            nextMileStone = AppUtil.formattedDate(
                _projectData.currentPhase!.currentMilestone!.mDate!);
          } else {
            nextMileStone = 'N/A';
          }

          // if (_peopleList.resource != null) {
          //   nickname = _peopleList.resource!.nickname!;
          // } else {
          //   nickname = 'TBD';
          // }

          // if (_peopleList.resource != null) {
          //   capacity = _peopleList.resource!.capacity!;
          // } else {
          //   capacity = 'TBD';
          // }

          // var image = _peopleList.image;

          String firstName = "";
          String lastName = "";
          String fullName = '';

          var names;
          if (_projectData.customer!.name != null &&
              _projectData.customer!.name!.isNotEmpty) {
            if (_projectData.customer!.name!.contains(" ")) {
              List<String> splitedList =
                  _projectData.customer!.name!.split(" ");

              firstName = splitedList[0];
              lastName = splitedList[1];

              fullName = firstName.substring(0, 1).toUpperCase() +
                  lastName.substring(0, 1).toUpperCase();
            } else {
              fullName =
                  _projectData.customer!.name!.substring(0, 1).toUpperCase();
            }
          }

          rows.add(DataRow(
              onSelectChanged: (newValue) {
                Provider.of<ProjectDetail>(context, listen: false)
                    .getProjectDetail(_projectData.id!.toString())
                    .then((val) {
                  showDailog(
                      context,
                      Provider.of<ProjectDetail>(context, listen: false)
                          .productData(),
                      _statusList,
                      _currencyName,
                      _accountableId,
                      _customerName,
                      _projectData.id.toString(),
                      skillsData);
                });
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             ProfileDetail(list: _peopleList)));
              },
              cells: [
                DataCell(Container(
                  width: 32,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xff334155)),
                  child: Text(
                    fullName != null && fullName.isNotEmpty ? fullName : '',
                    // 'AP',
                    style: const TextStyle(
                        fontFamily: 'Inter-Medium',
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.33,
                        color: Colors.white),
                  ),
                )),
                DataCell(
                  Text(
                    "$projectName",
                    style: const TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Text(
                    "$currentPhase",
                    style: const TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppUtil.getStatusContainerColor(projectStatus)),
                    child: Text(
                      projectStatus,
                      style: const TextStyle(
                          color: ColorSelect.white_color,
                          fontSize: 14.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500),
                    ),
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

                DataCell(
                  Text(
                    updatedAt,
                    style: const TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Text(
                    '$nextMileStone',
                    style: const TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Text(
                    deliveryDate,
                    style: const TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Text(
                    deadlineDate,
                    style: const TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // _projectData.customer!.image != null &&
                //         _projectData.customer!.image!.isNotEmpty
                //     ? DataCell(
                //         ConstrainedBox(
                //           constraints: BoxConstraints.tight(Size(200.0, 50.0)),
                //           child: InkWell(
                //             onTap: () {
                //               setState(() {
                //                 showMenus(context, index);
                //               });
                //             },
                //             child: Container(
                //               width: 80,
                //               height: 32,
                //               child: Stack(
                //                 children: [
                //                   Positioned(
                //                       top: 0,
                //                       child: ClipRRect(
                //                           borderRadius:
                //                               BorderRadius.circular(100),
                //                           child: Image.network(
                //                             '${_projectData.customer!.image}',
                //                             width: 32,
                //                             height: 32,
                //                             fit: BoxFit.cover,
                //                           ))),
                //                   Positioned(
                //                     left: 16,
                //                     child: ClipRRect(
                //                       borderRadius: BorderRadius.circular(100),
                //                       child: Image.network(
                //                         'https://media.istockphoto.com/photos/side-view-of-one-young-woman-picture-id1134378235?k=20&m=1134378235&s=612x612&w=0&h=0yIqc847atslcQvC3sdYE6bRByfjNTfOkyJc5e34kgU=',
                //                         width: 32,
                //                         height: 32,
                //                         fit: BoxFit.cover,
                //                       ),
                //                     ),
                //                   ),
                //                   // Positioned(
                //                   //   top: 0,
                //                   //   child: ClipRRect(
                //                   //     borderRadius: BorderRadius.circular(100),
                //                   //     child: Image.network(
                //                   //       'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80',
                //                   //       width: 32,
                //                   //       height: 32,
                //                   //       fit: BoxFit.cover,
                //                   //     ),
                //                   //   ),
                //                   // ),

                //                   // image_count > 2 ?

                //                   Positioned(
                //                     left: 30,
                //                     child: ClipRRect(
                //                       borderRadius: BorderRadius.circular(100),
                //                       child: Container(
                //                         width: 32,
                //                         height: 32,
                //                         color: Color(0xff334155),
                //                         child: const Center(
                //                             child: Text(
                //                           '+1',
                //                           style: TextStyle(
                //                               color: Color(0xffFFFFFF),
                //                               fontSize: 12.0,
                //                               fontFamily: 'Inter',
                //                               fontWeight: FontWeight.w500),
                //                         )),
                //                       ),
                //                     ),
                //                   )
                //                   // :
                //                   // Container()
                //                 ],
                //               ),
                //             ),
                //           ),
                //           //  ),
                //         ),
                //       )
                //     :
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

                // DataCell(_peopleList.resource != null
                //     ? Container(
                //         // height: 50,
                //         width: 250,
                //         child: ListView.builder(
                //           shrinkWrap: true,
                //           scrollDirection: Axis.horizontal,
                //           itemCount: _peopleList.resource!.skills!.length < 3
                //               ? _peopleList.resource!.skills!.length
                //               : 3,
                //           itemBuilder: (BuildContext context, int index) {
                //             Skills _skills =
                //                 _peopleList.resource!.skills![index];
                //             var skill = _skills.title;
                //             postion = index;
                //             return Container(
                //               height: 25.0,
                //               margin: const EdgeInsets.only(
                //                   top: 10.0, bottom: 10, right: 12),
                //               decoration: BoxDecoration(
                //                 color: const Color(0xff334155),
                //                 borderRadius: BorderRadius.circular(
                //                   8.0,
                //                 ),
                //               ),
                //               child: Align(
                //                 alignment: Alignment.center,
                //                 child: Padding(
                //                   padding: const EdgeInsets.only(
                //                       top: 6.0,
                //                       bottom: 6.0,
                //                       right: 12.0,
                //                       left: 12.0),
                //                   child: Text(
                //                     '$skill',
                //                     style: const TextStyle(
                //                         color: ColorSelect.white_color,
                //                         fontSize: 14.0,
                //                         fontFamily: 'Inter',
                //                         fontWeight: FontWeight.w400),
                //                   ),
                //                 ),
                //               ),
                //             );
                //           },
                //         ),
                //       )
                //     : const Text('TBD',
                //         style: TextStyle(
                //             color: ColorSelect.white_color,
                //             fontSize: 14.0,
                //             fontFamily: 'Inter',
                //             fontWeight: FontWeight.w500))),
                // DataCell(
                //   Padding(
                //     padding: const EdgeInsets.only(left: 10.0, bottom: 12),
                //     child: Stack(children: [
                //       MyMenu(
                //           data: data.peopleList!.data![index],
                //           title: 'Menu at bottom',
                //           alignment: Alignment.bottomRight)
                //     ]),
                //   ),
                // )
              ]));
        });
      }
    }

    return data!.peopleIdelResponse == null ||
            data.peopleIdelResponse!.data!.isEmpty
        ? const Expanded(
            child: Center(
                child: Text(
              "No Records Found !",
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
                              showCheckboxColumn: false,
                              dataRowHeight: 60,
                              dividerThickness: 0.5,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    "AP",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Project name",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Current phase",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Status",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "SPI",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Potential roadblocks",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Last\nupdate",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Next\nmilestone",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Delivery\ndate",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Deadline",
                                    style: TextStyle(
                                        color: ColorSelect.text_color,
                                        fontSize: 14.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Resources",
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
            controller: vertical_scrollcontroller,
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              controller: horizontalScroll,
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width < 950
                    ? MediaQuery.of(context).size.width * 2
                    : MediaQuery.of(context).size.width - 200,

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
                    Consumer<DataIdelClass?>(builder: (context, data, _) {
                      return data!.loading
                          ? const Expanded(
                              child: Center(child: CircularProgressIndicator()))
                          : makeProjectList(data);
                      //return Container();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // return MediaQuery(
    //     data: mediaQueryData.copyWith(textScaleFactor: 1.0),
    //     child: SafeArea(
    //       child: Scaffold(
    //         backgroundColor: const Color(0xff0F172A),
    //         body: Container(
    //             margin: const EdgeInsets.only(
    //                 left: 40.0, right: 30.0, bottom: 10.0, top: 40.0),
    //             decoration: BoxDecoration(
    //               color: Color(0xff1E293B),
    //               border: Border.all(color: const Color(0xff1E293B)),
    //               borderRadius: BorderRadius.circular(
    //                 12.0,
    //               ),
    //             ),
    //             child: Container(
    //                 alignment: Alignment.center,
    //                 padding: EdgeInsets.all(20),
    //                 child: CustomScrollBar(
    //                   scrollController: _scrollController,
    //                   child: SingleChildScrollView(
    //                     scrollDirection: Axis.horizontal,
    //                     controller: _scrollController,
    //                     child: SingleChildScrollView(
    //                       scrollDirection: Axis.vertical,
    //                       child: Container(
    //                           width: MediaQuery.of(context).size.width * 1,
    //                           height: MediaQuery.of(context).size.height,
    //                           child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Row(
    //                                 mainAxisAlignment: MainAxisAlignment.start,
    //                                 children: [
    //                                   InkWell(
    //                                     onTap: () {
    //                                       print('i am call');
    //                                       // api();
    //                                     },
    //                                     child: Container(
    //                                       margin: const EdgeInsets.only(
    //                                           left: 16.0, top: 16.0),
    //                                       child: const Text(
    //                                         "AP",
    //                                         style: TextStyle(
    //                                             color: Color(0xff94A3B8),
    //                                             fontSize: 14.0,
    //                                             fontFamily: 'Inter',
    //                                             fontWeight: FontWeight.w500),
    //                                       ),
    //                                     ),
    //                                   ),

    //                                   Container(
    //                                     margin: const EdgeInsets.only(
    //                                         left: 25.0, top: 16.0),
    //                                     child: const Text(
    //                                       "Project name",
    //                                       style: TextStyle(
    //                                           color: Color(0xff94A3B8),
    //                                           fontSize: 14.0,
    //                                           fontFamily: 'Inter',
    //                                           fontWeight: FontWeight.w500),
    //                                     ),
    //                                   ),

    //                                   // Spacer(flex: 1,),

    //                                   Container(
    //                                     margin: const EdgeInsets.only(
    //                                         left: 38, top: 16.0),
    //                                     child: const Text(
    //                                       "Current phase",
    //                                       style: TextStyle(
    //                                           color: Color(0xff94A3B8),
    //                                           fontSize: 14.0,
    //                                           fontFamily: 'Inter',
    //                                           fontWeight: FontWeight.w500),
    //                                     ),
    //                                   ),

    //                                   // Spacer(flex: 1,),
    //                                   Container(
    //                                     margin: const EdgeInsets.only(
    //                                         top: 16.0, left: 65.0),
    //                                     child: const Text(
    //                                       "Status",
    //                                       style: TextStyle(
    //                                           color: Color(0xff94A3B8),
    //                                           fontSize: 14.0,
    //                                           fontFamily: 'Inter',
    //                                           fontWeight: FontWeight.w500),
    //                                     ),
    //                                   ),

    //                                   Expanded(
    //                                     flex: 1,
    //                                     child: FutureBuilder(
    //                                         future: _getData,
    //                                         builder: (context, snapshot) {
    //                                           return Consumer<DataIdelClass?>(
    //                                               builder: (context, data, _) {
    //                                             //  print("hellodatanew"+data!.peopleIdelResponse!.data!.length.toString());
    //                                             return Row(
    //                                               children: [
    //                                                 Container(
    //                                                   margin: EdgeInsets.only(
    //                                                       top: 16.0,
    //                                                       left: (data != null &&
    //                                                               data.peopleIdelResponse !=
    //                                                                   null)
    //                                                           ? data.peopleIdelResponse!.data!
    //                                                                       .length ==
    //                                                                   0
    //                                                               ? 50
    //                                                               : 180.0
    //                                                           : 50),
    //                                                   child: const Text(
    //                                                     "SPI",
    //                                                     style: TextStyle(
    //                                                         color: Color(
    //                                                             0xff94A3B8),
    //                                                         fontSize: 14.0,
    //                                                         fontFamily: 'Inter',
    //                                                         fontWeight:
    //                                                             FontWeight
    //                                                                 .w500),
    //                                                   ),
    //                                                 ),
    //                                                 Container(
    //                                                   width:
    //                                                       MediaQuery.of(context)
    //                                                               .size
    //                                                               .width /
    //                                                           2,
    //                                                   margin: EdgeInsets.only(
    //                                                       top: 16.0,
    //                                                       left: (data != null &&
    //                                                               data.peopleIdelResponse !=
    //                                                                   null)
    //                                                           ? data.peopleIdelResponse!.data!
    //                                                                       .length ==
    //                                                                   0
    //                                                               ? 50
    //                                                               : 50
    //                                                           : 50),
    //                                                   child: const Text(
    //                                                     "Potential roadblocks",
    //                                                     style: TextStyle(
    //                                                         color: Color(
    //                                                             0xff94A3B8),
    //                                                         fontSize: 14,
    //                                                         fontFamily: 'Inter',
    //                                                         fontWeight:
    //                                                             FontWeight
    //                                                                 .w500),
    //                                                   ),
    //                                                 ),
    //                                                 Container(
    //                                                   margin: EdgeInsets.only(
    //                                                       top: 16.0,
    //                                                       left: (data != null &&
    //                                                               data.peopleIdelResponse !=
    //                                                                   null)
    //                                                           ? data.peopleIdelResponse!.data!
    //                                                                       .length ==
    //                                                                   0
    //                                                               ? 50
    //                                                               : 100
    //                                                           : 50),
    //                                                   child: const Text(
    //                                                     "Last\nupdate",
    //                                                     style: TextStyle(
    //                                                         color: Color(
    //                                                             0xff94A3B8),
    //                                                         fontSize: 14.0,
    //                                                         fontFamily: 'Inter',
    //                                                         fontWeight:
    //                                                             FontWeight
    //                                                                 .w500),
    //                                                   ),
    //                                                 ),
    //                                                 Container(
    //                                                   margin: EdgeInsets.only(
    //                                                       top: 16.0,
    //                                                       left: (data != null &&
    //                                                               data.peopleIdelResponse !=
    //                                                                   null)
    //                                                           ? data.peopleIdelResponse!.data!
    //                                                                       .length ==
    //                                                                   0
    //                                                               ? 50
    //                                                               : 35.0
    //                                                           : 50),
    //                                                   child: const Text(
    //                                                     "Next\nmilestone",
    //                                                     style: TextStyle(
    //                                                         color: Color(
    //                                                             0xff94A3B8),
    //                                                         fontSize: 14.0,
    //                                                         fontFamily: 'Inter',
    //                                                         fontWeight:
    //                                                             FontWeight
    //                                                                 .w500),
    //                                                   ),
    //                                                 ),
    //                                                 Container(
    //                                                   margin: EdgeInsets.only(
    //                                                       top: 16.0,
    //                                                       left: (data != null &&
    //                                                               data.peopleIdelResponse !=
    //                                                                   null)
    //                                                           ? data.peopleIdelResponse!.data!
    //                                                                       .length ==
    //                                                                   0
    //                                                               ? 50
    //                                                               : 35.0
    //                                                           : 50),
    //                                                   child: const Text(
    //                                                     "Delivery\ndate",
    //                                                     style: TextStyle(
    //                                                         color: Color(
    //                                                             0xff94A3B8),
    //                                                         fontSize: 14.0,
    //                                                         fontFamily: 'Inter',
    //                                                         fontWeight:
    //                                                             FontWeight
    //                                                                 .w500),
    //                                                   ),
    //                                                 ),
    //                                                 Container(
    //                                                   margin: EdgeInsets.only(
    //                                                       top: 16.0,
    //                                                       left: (data != null &&
    //                                                               data.peopleIdelResponse !=
    //                                                                   null)
    //                                                           ? data.peopleIdelResponse!.data!
    //                                                                       .length ==
    //                                                                   0
    //                                                               ? 50
    //                                                               : 35.0
    //                                                           : 50),
    //                                                   child: const Text(
    //                                                     "Deadline",
    //                                                     style: TextStyle(
    //                                                         color: Color(
    //                                                             0xff94A3B8),
    //                                                         fontSize: 14.0,
    //                                                         fontFamily: 'Inter',
    //                                                         fontWeight:
    //                                                             FontWeight
    //                                                                 .w500),
    //                                                   ),
    //                                                 ),
    //                                                 Container(
    //                                                   margin: EdgeInsets.only(
    //                                                       top: 16.0,
    //                                                       right: 0.0,
    //                                                       left: (data != null &&
    //                                                               data.peopleIdelResponse !=
    //                                                                   null)
    //                                                           ? data.peopleIdelResponse!.data!
    //                                                                       .length ==
    //                                                                   0
    //                                                               ? 50
    //                                                               : 35.0
    //                                                           : 50),
    //                                                   child: const Text(
    //                                                     "Resources",
    //                                                     style: TextStyle(
    //                                                         color: Color(
    //                                                             0xff94A3B8),
    //                                                         fontSize: 14.0,
    //                                                         fontFamily: 'Inter',
    //                                                         fontWeight:
    //                                                             FontWeight
    //                                                                 .w500),
    //                                                   ),
    //                                                 ),
    //                                               ],
    //                                             );
    //                                           });
    //                                         }),
    //                                   ),
    //                                 ],
    //                               ),
    //                               const SizedBox(
    //                                 height: 8.0,
    //                               ),
    //                               Container(
    //                                   margin: const EdgeInsets.only(
    //                                       left: 16.0, right: 16.0),
    //                                   child: const Divider(
    //                                     color: Color(0xff94A3B8),
    //                                     thickness: 0.1,
    //                                   )),
    //                               Expanded(
    //                                   flex: 1,
    //                                   child: FutureBuilder(
    //                                       future: _getData,
    //                                       builder: (context, snapshot) {
    //                                         if (snapshot.connectionState ==
    //                                             ConnectionState.waiting) {
    //                                           return const Center(
    //                                               child:
    //                                                   CircularProgressIndicator());
    //                                         } else {
    //                                           return Consumer<DataIdelClass?>(
    //                                               builder: (context, data, _) {
    //                                             print("hellodatanew" +
    //                                                 data!.peopleIdelResponse!
    //                                                     .data!.length
    //                                                     .toString());

    //                                             return data.peopleIdelResponse!
    //                                                         .data!.length ==
    //                                                     0
    //                                                 ? const Center(
    //                                                     child: Text(
    //                                                     "No Records Found !",
    //                                                     style: TextStyle(
    //                                                         color: Color(
    //                                                             0xffFFFFFF),
    //                                                         fontSize: 22.0,
    //                                                         fontFamily: 'Inter',
    //                                                         fontWeight:
    //                                                             FontWeight
    //                                                                 .w500),
    //                                                   ))
    //                                                 : ListView.builder(

    //                                                     // physics: NeverScrollableScrollPhysics(),
    //                                                     shrinkWrap: true,
    //                                                     itemCount: data
    //                                                         .peopleIdelResponse!
    //                                                         .data!
    //                                                         .length,
    //                                                     itemBuilder:
    //                                                         (BuildContext
    //                                                                 context,
    //                                                             int index) {
    //                                                       String name = '';
    //                                                       Data upLoad = data
    //                                                           .peopleIdelResponse!
    //                                                           .data![index];
    //                                                       var projectname =
    //                                                           upLoad.title;
    //                                                       if (upLoad
    //                                                               .accountablePerson !=
    //                                                           null) {
    //                                                         var ee = upLoad
    //                                                             .accountablePerson!
    //                                                             .name;
    //                                                         name = ee!
    //                                                             .substring(
    //                                                                 0, 2);
    //                                                       }

    //                                                       // var idd=upLoad.customer!.phoneNumber;
    //                                                       var phone = upLoad
    //                                                           .workFolderId;
    //                                                       var status =
    //                                                           upLoad.status;
    //                                                       //-------------------sayyam remove on Tap and add on Button of status
    //                                                       return Column(
    //                                                         children: [
    //                                                           Row(
    //                                                             mainAxisAlignment:
    //                                                                 MainAxisAlignment
    //                                                                     .start,
    //                                                             children: [
    //                                                               Container(
    //                                                                 width: 32.0,
    //                                                                 height:
    //                                                                     32.0,
    //                                                                 margin: const EdgeInsets
    //                                                                         .only(
    //                                                                     left:
    //                                                                         16.0,
    //                                                                     top:
    //                                                                         16.0),
    //                                                                 decoration:
    //                                                                     BoxDecoration(
    //                                                                   color: const Color(
    //                                                                       0xff334155),
    //                                                                   border: Border.all(
    //                                                                       color:
    //                                                                           const Color(0xff334155)),
    //                                                                   borderRadius:
    //                                                                       BorderRadius
    //                                                                           .circular(
    //                                                                     16.0,
    //                                                                   ),
    //                                                                 ),
    //                                                                 child:
    //                                                                     Align(
    //                                                                   alignment:
    //                                                                       Alignment
    //                                                                           .center,
    //                                                                   child:
    //                                                                       Text(
    //                                                                     name != null &&
    //                                                                             name.isNotEmpty
    //                                                                         ? name
    //                                                                         : 'TBD',
    //                                                                     style: const TextStyle(
    //                                                                         color: Color(
    //                                                                             0xffFFFFFF),
    //                                                                         fontSize:
    //                                                                             13.0,
    //                                                                         fontFamily:
    //                                                                             'Inter',
    //                                                                         fontWeight:
    //                                                                             FontWeight.w500),
    //                                                                   ),
    //                                                                 ),
    //                                                               ),

    //                                                               Container(
    //                                                                 width:
    //                                                                     140.0,
    //                                                                 padding: const EdgeInsets
    //                                                                         .only(
    //                                                                     left:
    //                                                                         16.0,
    //                                                                     top:
    //                                                                         16.0),
    //                                                                 child: Text(
    //                                                                   projectname!,
    //                                                                   style: const TextStyle(
    //                                                                       color: Color(
    //                                                                           0xffFFFFFF),
    //                                                                       fontSize:
    //                                                                           14.0,
    //                                                                       fontFamily:
    //                                                                           'Inter',
    //                                                                       fontWeight:
    //                                                                           FontWeight.w500),
    //                                                                 ),
    //                                                               ),

    //                                                               Container(
    //                                                                 // width: 100.0,
    //                                                                 padding:
    //                                                                     const EdgeInsets.fromLTRB(
    //                                                                         0,
    //                                                                         16,
    //                                                                         0,
    //                                                                         0),
    //                                                                 child:
    //                                                                     const Align(
    //                                                                   alignment:
    //                                                                       Alignment
    //                                                                           .center,
    //                                                                   child:
    //                                                                       Text(
    //                                                                     "Backend:Phase 2/4",
    //                                                                     style: TextStyle(
    //                                                                         color: Color(
    //                                                                             0xffFFFFFF),
    //                                                                         fontSize:
    //                                                                             14.0,
    //                                                                         fontFamily:
    //                                                                             'Inter',
    //                                                                         fontWeight:
    //                                                                             FontWeight.w500),
    //                                                                   ),
    //                                                                 ),
    //                                                               ),

    //                                                               InkWell(
    //                                                                 onTap: () {
    //                                                                   Data dta = data
    //                                                                       .peopleIdelResponse!
    //                                                                       .data![index];
    //                                                                   id = dta
    //                                                                       .id
    //                                                                       .toString();
    //                                                                   print("sjcdjcjsd" +
    //                                                                       id.toString());
    //                                                                   //Provider.of<ProjectDetail>(context, listen: false).productData()
    //                                                                   Provider.of<ProjectDetail>(
    //                                                                           context,
    //                                                                           listen:
    //                                                                               false)
    //                                                                       .getProjectDetail(
    //                                                                           id!)
    //                                                                       .then(
    //                                                                           (val) {
    //                                                                     showDailog(
    //                                                                         context,
    //                                                                         Provider.of<ProjectDetail>(context, listen: false).productData(),
    //                                                                         _statusList,
    //                                                                         _currencyName,
    //                                                                         _accountableId,
    //                                                                         _customerName,
    //                                                                         id);
    //                                                                   });
    //                                                                 },
    //                                                                 child:
    //                                                                     Container(
    //                                                                   width:
    //                                                                       254.0, //MediaQuery.of(context).size.width * 0.2,
    //                                                                   child:
    //                                                                       Column(
    //                                                                     crossAxisAlignment:
    //                                                                         CrossAxisAlignment.start,
    //                                                                     mainAxisAlignment:
    //                                                                         MainAxisAlignment.start,
    //                                                                     children: [
    //                                                                       if (status ==
    //                                                                           "Open") ...[
    //                                                                         Container(
    //                                                                           height: 32.0,
    //                                                                           width: 82.0,
    //                                                                           margin: const EdgeInsets.only(left: 30.0, right: 12.0, top: 12.0),
    //                                                                           decoration: BoxDecoration(
    //                                                                             color: const Color(0xff16A34A),
    //                                                                             //border: Border.all(color: const Color(0xff0E7490)),
    //                                                                             borderRadius: BorderRadius.circular(
    //                                                                               8.0,
    //                                                                             ),
    //                                                                           ),
    //                                                                           child: const Align(
    //                                                                             alignment: Alignment.center,
    //                                                                             child: Padding(
    //                                                                               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
    //                                                                               child: Text(
    //                                                                                 "Open",
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               ),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ] else if (status ==
    //                                                                           'On track') ...[
    //                                                                         Container(
    //                                                                           height: 32.0,
    //                                                                           width: 82.0,
    //                                                                           margin: const EdgeInsets.only(left: 30.0, right: 12.0, top: 12.0),
    //                                                                           decoration: BoxDecoration(
    //                                                                             color: const Color(0xff16A34A),
    //                                                                             //border: Border.all(color: const Color(0xff0E7490)),
    //                                                                             borderRadius: BorderRadius.circular(
    //                                                                               8.0,
    //                                                                             ),
    //                                                                           ),
    //                                                                           child: const Align(
    //                                                                             alignment: Alignment.center,
    //                                                                             child: Padding(
    //                                                                               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
    //                                                                               child: Text(
    //                                                                                 "On track",
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               ),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ] else if (status ==
    //                                                                           'Live') ...[
    //                                                                         Container(
    //                                                                           height: 32.0,
    //                                                                           width: 52.0,
    //                                                                           margin: const EdgeInsets.only(left: 30.0, right: 12.0, top: 12.0),
    //                                                                           decoration: BoxDecoration(
    //                                                                             color: const Color(0xff16A34A),
    //                                                                             //border: Border.all(color: const Color(0xff0E7490)),
    //                                                                             borderRadius: BorderRadius.circular(
    //                                                                               8.0,
    //                                                                             ),
    //                                                                           ),
    //                                                                           child: const Align(
    //                                                                             alignment: Alignment.center,
    //                                                                             child: Padding(
    //                                                                               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
    //                                                                               child: Text(
    //                                                                                 "Live",
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               ),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ] else if (status ==
    //                                                                           "Design sent for approval") ...[
    //                                                                         Container(
    //                                                                           height: 32.0,
    //                                                                           width: 190.0,
    //                                                                           margin: const EdgeInsets.only(left: 20.0, right: 12.0, top: 12.0),
    //                                                                           decoration: BoxDecoration(
    //                                                                             color: const Color(0xff115E59),
    //                                                                             //border: Border.all(color: const Color(0xff0E7490)),
    //                                                                             borderRadius: BorderRadius.circular(
    //                                                                               8.0,
    //                                                                             ),
    //                                                                           ),
    //                                                                           child: const Align(
    //                                                                             alignment: Alignment.center,
    //                                                                             child: Padding(
    //                                                                               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
    //                                                                               child: Text(
    //                                                                                 "Design sent for approval",
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               ),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ] else if (status ==
    //                                                                           "New features request") ...[
    //                                                                         Container(
    //                                                                           height: 32.0,
    //                                                                           width: 171.0,
    //                                                                           margin: const EdgeInsets.only(left: 30.0, right: 12.0, top: 12.0),
    //                                                                           decoration: BoxDecoration(
    //                                                                             color: const Color(0xffA21CAF),
    //                                                                             //border: Border.all(color: const Color(0xff0E7490)),
    //                                                                             borderRadius: BorderRadius.circular(
    //                                                                               8.0,
    //                                                                             ),
    //                                                                           ),
    //                                                                           child: const Align(
    //                                                                             alignment: Alignment.center,
    //                                                                             child: Padding(
    //                                                                               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
    //                                                                               child: Text(
    //                                                                                 "New features request",
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               ),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ] else if (status ==
    //                                                                           "Update request") ...[
    //                                                                         Container(
    //                                                                           height: 32.0,
    //                                                                           width: 147.0,
    //                                                                           margin: const EdgeInsets.only(left: 30.0, right: 12.0, top: 12.0),
    //                                                                           decoration: BoxDecoration(
    //                                                                             color: const Color(0xff0E7490),
    //                                                                             //border: Border.all(color: const Color(0xff0E7490)),
    //                                                                             borderRadius: BorderRadius.circular(
    //                                                                               8.0,
    //                                                                             ),
    //                                                                           ),
    //                                                                           child: const Align(
    //                                                                             alignment: Alignment.center,
    //                                                                             child: Padding(
    //                                                                               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
    //                                                                               child: Text(
    //                                                                                 "Update request",
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               ),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ] else if (status ==
    //                                                                           "Sent for approval") ...[
    //                                                                         Container(
    //                                                                           height: 32.0,
    //                                                                           width: 147.0,
    //                                                                           margin: const EdgeInsets.only(left: 30.0, right: 12.0, top: 12.0),
    //                                                                           decoration: BoxDecoration(
    //                                                                             color: const Color(0xff166534),
    //                                                                             //border: Border.all(color: const Color(0xff0E7490)),
    //                                                                             borderRadius: BorderRadius.circular(
    //                                                                               8.0,
    //                                                                             ),
    //                                                                           ),
    //                                                                           child: const Align(
    //                                                                             alignment: Alignment.center,
    //                                                                             child: Padding(
    //                                                                               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
    //                                                                               child: Text(
    //                                                                                 "Sent for approval",
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               ),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ] else if (status ==
    //                                                                           'Risk') ...[
    //                                                                         Container(
    //                                                                           height: 32.0,
    //                                                                           width: 53.0,
    //                                                                           margin: const EdgeInsets.only(left: 30.0, right: 12.0, top: 12.0),
    //                                                                           decoration: BoxDecoration(
    //                                                                             color: const Color(0xffB91C1C),
    //                                                                             //border: Border.all(color: const Color(0xff0E7490)),
    //                                                                             borderRadius: BorderRadius.circular(
    //                                                                               8.0,
    //                                                                             ),
    //                                                                           ),
    //                                                                           child: const Align(
    //                                                                             alignment: Alignment.center,
    //                                                                             child: Padding(
    //                                                                               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
    //                                                                               child: Text(
    //                                                                                 "Risk",
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               ),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ] else if (status ==
    //                                                                           "Potential risk") ...[
    //                                                                         Container(
    //                                                                           height: 32.0,
    //                                                                           width: 113.0,
    //                                                                           margin: const EdgeInsets.only(left: 30.0, right: 12.0, top: 12.0),
    //                                                                           decoration: BoxDecoration(
    //                                                                             color: const Color(0xff9A3412),
    //                                                                             //border: Border.all(color: const Color(0xff0E7490)),
    //                                                                             borderRadius: BorderRadius.circular(
    //                                                                               8.0,
    //                                                                             ),
    //                                                                           ),
    //                                                                           child: const Align(
    //                                                                             alignment: Alignment.center,
    //                                                                             child: Padding(
    //                                                                               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
    //                                                                               child: Text(
    //                                                                                 "Potential risk",
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               ),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ] else ...[
    //                                                                         Container(
    //                                                                           height: 32.0,
    //                                                                           width: 53.0,
    //                                                                           margin: const EdgeInsets.only(left: 30.0, right: 12.0, top: 12.0),
    //                                                                           decoration: BoxDecoration(
    //                                                                             color: const Color(0xffB91C1C),
    //                                                                             //border: Border.all(color: const Color(0xff0E7490)),
    //                                                                             borderRadius: BorderRadius.circular(
    //                                                                               8.0,
    //                                                                             ),
    //                                                                           ),
    //                                                                           child: const Align(
    //                                                                             alignment: Alignment.center,
    //                                                                             child: Padding(
    //                                                                               padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
    //                                                                               child: Text(
    //                                                                                 "Risk",
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               ),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ],
    //                                                                     ],
    //                                                                   ),
    //                                                                 ),
    //                                                               ),
    //                                                               //  Spacer(flex: 1,),
    //                                                               //Spacer(flex: 1,),
    //                                                               Container(
    //                                                                 margin: const EdgeInsets
    //                                                                         .only(
    //                                                                     top:
    //                                                                         16.0),
    //                                                                 child:
    //                                                                     const Text(
    //                                                                   "1.2",
    //                                                                   style: TextStyle(
    //                                                                       color: Color(
    //                                                                           0xffFFFFFF),
    //                                                                       fontSize:
    //                                                                           14.0,
    //                                                                       fontFamily:
    //                                                                           'Inter',
    //                                                                       fontWeight:
    //                                                                           FontWeight.w500),
    //                                                                 ),
    //                                                               ),
    //                                                               // Spacer(flex: 1,),
    //                                                               Container(
    //                                                                 width: MediaQuery.of(context)
    //                                                                         .size
    //                                                                         .width /
    //                                                                     9.5,
    //                                                                 //  204.0,
    //                                                                 margin: const EdgeInsets
    //                                                                         .only(
    //                                                                     left:
    //                                                                         50.0,
    //                                                                     top:
    //                                                                         16.0),
    //                                                                 child:
    //                                                                     const Text(
    //                                                                   "Ticket not updated for 3 days",
    //                                                                   style: TextStyle(
    //                                                                       color: Color(
    //                                                                           0xffFFFFFF),
    //                                                                       fontSize:
    //                                                                           14.0,
    //                                                                       fontFamily:
    //                                                                           'Inter',
    //                                                                       fontWeight:
    //                                                                           FontWeight.w500),
    //                                                                 ),
    //                                                               ),
    //                                                               //Spacer(flex: 1,),
    //                                                               Container(
    //                                                                 width: MediaQuery.of(context)
    //                                                                         .size
    //                                                                         .width /
    //                                                                     45,
    //                                                                 margin: const EdgeInsets
    //                                                                         .only(
    //                                                                     left:
    //                                                                         36.0,
    //                                                                     top:
    //                                                                         16.0),
    //                                                                 child:
    //                                                                     const Text(
    //                                                                   "13 Jul",
    //                                                                   style: TextStyle(
    //                                                                       color: Color(
    //                                                                           0xffFFFFFF),
    //                                                                       fontSize:
    //                                                                           14.0,
    //                                                                       fontFamily:
    //                                                                           'Inter',
    //                                                                       fontWeight:
    //                                                                           FontWeight.w500),
    //                                                                 ),
    //                                                               ),
    //                                                               // Spacer(flex: 1,),
    //                                                               Container(
    //                                                                 //width: MediaQuery.of(context).size.width/2,
    //                                                                 // height: MediaQuery.of(context).size.height/2,
    //                                                                 margin: const EdgeInsets
    //                                                                         .only(
    //                                                                     left:
    //                                                                         44.0,
    //                                                                     top:
    //                                                                         16.0),
    //                                                                 child:
    //                                                                     const Text(
    //                                                                   "28 Aug",
    //                                                                   style: TextStyle(
    //                                                                       color: Color(
    //                                                                           0xffFFFFFF),
    //                                                                       fontSize:
    //                                                                           14.0,
    //                                                                       fontFamily:
    //                                                                           'Inter',
    //                                                                       fontWeight:
    //                                                                           FontWeight.w500),
    //                                                                 ),
    //                                                               ),
    //                                                               //  Spacer(flex: 1,),
    //                                                               Container(
    //                                                                 margin: const EdgeInsets
    //                                                                         .only(
    //                                                                     left:
    //                                                                         47.0,
    //                                                                     top:
    //                                                                         16.0),
    //                                                                 child:
    //                                                                     const Text(
    //                                                                   "29 Jul",
    //                                                                   style: TextStyle(
    //                                                                       color: Color(
    //                                                                           0xffFFFFFF),
    //                                                                       fontSize:
    //                                                                           14.0,
    //                                                                       fontFamily:
    //                                                                           'Inter',
    //                                                                       fontWeight:
    //                                                                           FontWeight.w500),
    //                                                                 ),
    //                                                               ),
    //                                                               // Spacer(flex: 1,),

    //                                                               Container(
    //                                                                 margin: const EdgeInsets
    //                                                                         .only(
    //                                                                     left:
    //                                                                         52.0,
    //                                                                     top:
    //                                                                         16.0),
    //                                                                 child:
    //                                                                     const Text(
    //                                                                   "13 Aug",
    //                                                                   style: TextStyle(
    //                                                                       color: Color(
    //                                                                           0xffFFFFFF),
    //                                                                       fontSize:
    //                                                                           14.0,
    //                                                                       fontFamily:
    //                                                                           'Inter',
    //                                                                       fontWeight:
    //                                                                           FontWeight.w500),
    //                                                                 ),
    //                                                               ),
    //                                                               // Spacer(flex: 1,),

    //                                                               ConstrainedBox(
    //                                                                 constraints:
    //                                                                     BoxConstraints.tight(Size(
    //                                                                         200.0,
    //                                                                         50.0)),
    //                                                                 child:
    //                                                                     // MouseRegion(
    //                                                                     //   // cursor: SystemMouseCursors.text,
    //                                                                     //   //onHover: showMenus(context),
    //                                                                     //   onEnter: (_) {
    //                                                                     //     setState(() {
    //                                                                     //       showMenus(
    //                                                                     //           context);
    //                                                                     //       hovered =
    //                                                                     //           true;
    //                                                                     //     });
    //                                                                     //   },
    //                                                                     //   onExit: (_) {
    //                                                                     //     setState(() {
    //                                                                     //       hovered =
    //                                                                     //           false;
    //                                                                     //       // Navigator.of(context).pop();
    //                                                                     //     });
    //                                                                     //   },
    //                                                                     //   child:
    //                                                                     InkWell(
    //                                                                   onTap:
    //                                                                       () {
    //                                                                     print(
    //                                                                         index);
    //                                                                     print(
    //                                                                         index);
    //                                                                     setState(
    //                                                                         () {
    //                                                                       showMenus(
    //                                                                           context,
    //                                                                           index);
    //                                                                       // hovered =
    //                                                                       //     true;
    //                                                                     });
    //                                                                   },
    //                                                                   child:
    //                                                                       Container(
    //                                                                     margin: const EdgeInsets.only(
    //                                                                         left:
    //                                                                             47.0,
    //                                                                         top:
    //                                                                             16.0),
    //                                                                     width:
    //                                                                         80,
    //                                                                     height:
    //                                                                         32,
    //                                                                     child:
    //                                                                         Stack(
    //                                                                       children: [
    //                                                                         Positioned(
    //                                                                           top: 0,
    //                                                                           child: ClipRRect(
    //                                                                             borderRadius: BorderRadius.circular(100),
    //                                                                             child: Image.network(
    //                                                                               'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80',
    //                                                                               width: 32,
    //                                                                               height: 32,
    //                                                                               fit: BoxFit.cover,
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                         Positioned(
    //                                                                           left: 16,
    //                                                                           child: ClipRRect(
    //                                                                             borderRadius: BorderRadius.circular(100),
    //                                                                             child: Image.network(
    //                                                                               'https://media.istockphoto.com/photos/side-view-of-one-young-woman-picture-id1134378235?k=20&m=1134378235&s=612x612&w=0&h=0yIqc847atslcQvC3sdYE6bRByfjNTfOkyJc5e34kgU=',
    //                                                                               width: 32,
    //                                                                               height: 32,
    //                                                                               fit: BoxFit.cover,
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                         Positioned(
    //                                                                           left: 30,
    //                                                                           child: ClipRRect(
    //                                                                             borderRadius: BorderRadius.circular(100),
    //                                                                             child: Container(
    //                                                                               width: 32,
    //                                                                               height: 32,
    //                                                                               color: Color(0xff334155),
    //                                                                               child: const Center(
    //                                                                                   child: Text(
    //                                                                                 '+1',
    //                                                                                 style: TextStyle(color: Color(0xffFFFFFF), fontSize: 12.0, fontFamily: 'Inter', fontWeight: FontWeight.w500),
    //                                                                               )),
    //                                                                             ),
    //                                                                           ),
    //                                                                         ),
    //                                                                       ],
    //                                                                     ),
    //                                                                   ),
    //                                                                 ),
    //                                                                 //  ),
    //                                                               ),

    //                                                               /* Container(
    //                                      margin: const EdgeInsets.only(
    //                                          left: 47.0, top: 16.0),
    //                                      width: 80,
    //                                      height: 32,
    //                                      child: Stack(
    //                                        children: [
    //                                          Positioned(
    //                                            top: 0,
    //                                            child: ClipRRect(
    //                                              borderRadius: BorderRadius.circular(100),
    //                                              child: Image.network(
    //                                                'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80',
    //                                                width: 32,
    //                                                height: 32,
    //                                                fit: BoxFit.cover,
    //                                              ),
    //                                            ),
    //                                          ),
    //                                          Positioned(
    //                                            left: 16,
    //                                            child: ClipRRect(
    //                                              borderRadius: BorderRadius.circular(100),
    //                                              child: Image.network(
    //                                                'https://media.istockphoto.com/photos/side-view-of-one-young-woman-picture-id1134378235?k=20&m=1134378235&s=612x612&w=0&h=0yIqc847atslcQvC3sdYE6bRByfjNTfOkyJc5e34kgU=',
    //                                                width: 32,
    //                                                height: 32,
    //                                                fit: BoxFit.cover,
    //                                              ),
    //                                            ),
    //                                          ),

    //                                          Positioned(
    //                                            left: 30,
    //                                            child: ClipRRect(
    //                                              borderRadius: BorderRadius.circular(100),
    //                                              child: Container(
    //                                                width: 32,
    //                                                height: 32,
    //                                                color: Color(0xff334155),
    //                                                child: const Center(child: Text('+1',style: TextStyle(
    //                                                  color: Color(0xffFFFFFF),
    //                                                  fontSize: 12.0,
    //                                                  fontFamily: 'Inter',
    //                                                  fontWeight:
    //                                                  FontWeight.w500),)),
    //                                              ),
    //                                            ),
    //                                          ),
    //                                        ],
    //                                      ),
    //                                    ),*/
    //                                                             ],
    //                                                           ),
    //                                                           const SizedBox(
    //                                                             height: 8.0,
    //                                                           ),
    //                                                           Container(
    //                                                               margin: const EdgeInsets
    //                                                                       .only(
    //                                                                   left:
    //                                                                       16.0,
    //                                                                   right:
    //                                                                       16.0),
    //                                                               child:
    //                                                                   const Divider(
    //                                                                 color: Color(
    //                                                                     0xff94A3B8),
    //                                                                 thickness:
    //                                                                     0.1,
    //                                                               )),
    //                                                         ],
    //                                                       );
    //                                                     });
    //                                           });
    //                                         }
    //                                       }))
    //                             ],
    //                           )),
    //                     ),
    //                   ),
    //                 ))),
    //       ),
    //     ));
  }

  Future<void> api() async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://staging-api.vanwijk.app/api/scan/deregister/cancel/complete'),
        body: jsonEncode({
          "code": 20221090915620,
          "reason": 'test',
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvc3RhZ2luZy1hcGkudmFud2lqay5hcHBcL2FwaVwvbG9naW4iLCJpYXQiOjE2NjI5OTk3MzIsImV4cCI6MTY2MzAwMzMzMiwibmJmIjoxNjYyOTk5NzMyLCJqdGkiOiJ3T05yaDBLZHVvenFhbDBSIiwic3ViIjoxLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.h20MqyqGtvq8mHw0X7IXJkjV_gH2wxgaANQY8IKGl3Q'
        },
      );
      print(response.body);
      // ignore: unrelated_type_equality_checks
      if (response.statusCode == 200) {
        var responseJson =
            jsonDecode(response.body.toString()) as Map<String, dynamic>;
        final stringRes = JsonEncoder.withIndent('').convert(responseJson);
        print(stringRes);
        print("yes Creaete");
        print(response.body);
      } else {
        print("failuree");
      }
    } catch (e) {
      // print('error caught: $e');
    }
  }

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
          _statusList = mdata;
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

  Future<String?> getCurrency() async {
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
          _currencyName = mdata;
        });
      } else {
        print("failed to much");
      }
      return value;
    }
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
          _accountableId = mdata;
        });
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  void getUsers() async {
    skillsData.clear();
    var token = 'Bearer ' + storage.read("token");
    var response = await http.get(
      Uri.parse(AppUrl.searchLanguage),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      },
    );
    if (response.statusCode == 200) {
      print("skills sucess");
      var skills = skillProjectFromJson(response.body);
      print(skills);
      print('Users: ${skills.data}');
      skillsData.addAll(skills.data!);
      print(skillsData);
    } else {
      print("Error getting users.");
      // print(response.body);
    }
  }

  Future<String?> getCustomer() async {
    String? value;
    if (value == null) {
      //    "Authorization": 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWVlM2EwY2E0NmYyNmI1NzZkZDY0MTRhZDY0NTFlNjFjNjVlNTY2NzgxYjE1OWYxMzY5NDFmMjMwYmI5ZDVhODlhOGI4Y2QzMzBiNDg0NzMiLCJpYXQiOjE2NjM5NDMxMzUuNjY1NzY2LCJuYmYiOjE2NjM5NDMxMzUuNjY1NzY5LCJleHAiOjE2OTU0NzkxMzUuNjEyNTQ2LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.MQDtmzlqx5LkruPq7TwzFcPD2sClWNSioqOdZ4fnp3CoRL7gsELEv_nGZNR0ZjqcYCzQI0abz9PCVXQ6StgYNdN4ceGVTC2G004kaWj4edXGchTPQLLHnKQ73L47WZuqhwEOQ-0D6TITRczOScTuHuUC7VEwmQTsohzd3EAswGHSBBOiauRmgXiDEOTR9SPNvzH0b11AFcHeFjkPFG82LIJHI3h18ScWF2C4nKy2qnFgweCFhr7NwhYj1sNJKRqee-sa1BATvvkpXf7h4IQ5CEVIqrLEVoXviD958Nty1MC-gYsinaEQTWiyN-a6bb4o0RrHys8KPgVeSS4Ihe_FitaVjm7KPrV4LrEmvUhn2Fu_NJsV6n5toBJgHQ4_W6aR4fxMGMfmmx4mSfr7HdrDQNFeJ5BKhD88WYFuJPP3QyKuj6ps9w7wLK2DHHJ2VVKL06I8SIJq4R_-QNhT9_xSNKBWRWwbs4-Kp6xYtC0jSAcGhAIMmiEMxkt3cyCBwO9OcZEowWd7499nlTSMwSwYt8rwiX32ACBp3h2Sr8SdkBpBmuWQcAQEYPYteSWgV0OZkyAacHUg94xjDxF8dbNLEXab6ZNoL-uFmdzHXJxXENdAW6Gux_XejDgd4PgG6nD84nQIJPvhkDeIs5u_UZ3VUs8dO36FByLcKQNWNOUd15s'
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
          _customerName = mdata;
        });
      } else {
        print("failed to much");
      }
      return value;
    }
  }
}
