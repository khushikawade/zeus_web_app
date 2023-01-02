import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeus/project_module/project_details_screen/project_details_view.dart';
import 'package:zeus/services/response_model/project_detail_response.dart';
import 'package:zeus/services/response_model/skills_model/skills_response_project.dart';
import 'package:zeus/utility/colors.dart';
import 'package:zeus/utility/constant.dart';
import 'package:zeus/utility/util.dart';
import 'dart:convert';
import '../../helper_widget/custom_popups.dart';
import '../../utility/app_url.dart';
import '../../popup/Popup.dart';

import 'project_home_view_model.dart';
import '../../services/response_model/project_idel_response.dart';
import 'package:zeus/services/response_model/project_idel_response.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProjectHome extends StatefulWidget {
  const ProjectHome({Key? key}) : super(key: key);

  @override
  State<ProjectHome> createState() => ProjectHomeState();
}

class ProjectHomeState extends State<ProjectHome> {
  GlobalKey key1 = new GlobalKey();
  GlobalKey key2 = new GlobalKey();
  GlobalKey key = new GlobalKey();
  GlobalKey key3 = new GlobalKey();
  GlobalKey key4 = new GlobalKey();
  GlobalKey key5 = new GlobalKey();
  GlobalKey key6 = new GlobalKey();
  GlobalKey key7 = new GlobalKey();
  GlobalKey key8 = new GlobalKey();
  GlobalKey key9 = new GlobalKey();
  GlobalKey key10 = new GlobalKey();

  ShowMoreTextPopups? popup;
  List<SkillsData> skillsData = [];

  bool? amIHovering;
  bool? amIHovering1;

  Offset exitFrom = const Offset(0, 0);
  bool hovered = false;

  Future? _getProjectDetail;
  String? spiValue, roadblocks1;
  bool _isDownArrow = true;
  List<String> roadblock = [];
  final ScrollController horizontalScroll = ScrollController();
  final double width = 18;

  final ScrollController verticalScrollcontroller = ScrollController();

  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  double? _scrollPosition = 0;
  double? _opacity = 0;

  Future? getListData() async {
    var result = await Provider.of<ProjectHomeViewModel>(context, listen: false)
        .getPeopleIdel(searchText: '');

    return result;
  }

  Future? getList;

  Future getListData1() {
    return Provider.of<ProjectHomeViewModel>(context, listen: false)
        .changeProfile();
  }

  // @override
  // void didChangeDependencies() {
  //   getList = getListData1();
  //   super.didChangeDependencies();
  // }

  void change() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('val', 'q');
  }

  @override
  initState() {
    print(
        "Called Second time ----------------------------------------- jdfjdjjjdfjdfjdj  ");
    getAllData();
    super.initState();
  }

  getAllData() async {
    await getListData();
    change();

    getUsers();
  }

  // Make People List widget or Data Table
  Widget makeProjectList(ProjectHomeViewModel? data) {
    List<DataRow> rows = [];
    if (data!.projectDetailsResponse != null) {
      if (data.projectDetailsResponse!.data!.isNotEmpty) {
        // print(data.projectDetailsResponse!.data!.length);
        // print(data.projectDetailsResponse!.data!.length);
        data.projectDetailsResponse!.data!.asMap().forEach((index, element) {
          Datum _projectData = data.projectDetailsResponse!.data![index];

          var projectName = '';
          var projectStatus = '';
          var updatedAt = '';
          var deliveryDate = '';
          var deadlineDate = '';
          var currentPhase = '';
          var customerImage = '';
          var nextMileStone = '';
          var apName = '';
          var spi = '';

          if (_projectData.title != null && _projectData.title!.isNotEmpty) {
            projectName = _projectData.title!;
          } else {
            projectName = "TBD";
          }

          if (_projectData.status != null && _projectData.status!.isNotEmpty) {
            projectStatus = _projectData.status!;
          } else {
            projectStatus = "TBD";
          }

          if (_projectData.updatedAt != null &&
              _projectData.updatedAt!.isNotEmpty) {
            updatedAt = AppUtil.formattedDate(_projectData.updatedAt!);
          } else {
            updatedAt = "N/A";
          }

          if (_projectData.deliveryDate != null &&
              _projectData.deliveryDate!.isNotEmpty) {
            deliveryDate = AppUtil.formattedDate(_projectData.deliveryDate!);
          } else {
            deliveryDate = "N/A";
          }

          if (_projectData.deadlineDate != null &&
              _projectData.deadlineDate!.isNotEmpty) {
            deadlineDate = AppUtil.formattedDate(_projectData.deadlineDate!);
          } else {
            deadlineDate = "N/A";
          }

          if (_projectData.currentPhase == null) {
            currentPhase = "N/A";
          } else {
            if (_projectData.currentPhase!.title != null &&
                _projectData.currentPhase!.title!.isNotEmpty) {
              currentPhase = _projectData.currentPhase!.title!;
            }
          }

          if (_projectData.customer != null &&
              _projectData.customer!.image != null &&
              _projectData.customer!.image!.isNotEmpty) {
            print(_projectData.customer!.image!);
          } else {}

          String firstName = "";
          String lastName = "";
          String fullName = '';

          var names;
          if (_projectData.accountablePerson!.name != null &&
              _projectData.accountablePerson!.name!.isNotEmpty) {
            if (_projectData.accountablePerson!.name!.contains(" ")) {
              List<String> splitedList =
                  _projectData.accountablePerson!.name!.split(" ");
              splitedList.removeWhere((element) => element.isEmpty);

              firstName = splitedList[0];
              lastName = splitedList[1];

              fullName = firstName.substring(0, 1).toUpperCase() +
                  lastName.substring(0, 1).toUpperCase();
            } else {
              fullName = _projectData.accountablePerson!.name!
                  .substring(0, 1)
                  .toUpperCase();
            }
          }

          if (_projectData.spiInfo != null &&
              _projectData.spiInfo!.spi != null) {
            spiValue = double.parse(_projectData.spiInfo!.spi.toString())
                .toStringAsFixed(2)
                .toString();
            ;
          } else {
            spiValue = 'N/A';
          }

          if (_projectData != null &&
              _projectData.roadblocks != null &&
              _projectData.roadblocks!.isNotEmpty) {
            _projectData.roadblocks!.forEach((element) {
              if (!roadblock.contains(element.rodblockDetails!.description)) {
                roadblock.add(element.rodblockDetails!.description!);
              }
            });
            // roadblocks1 =
            //     _projectData.roadblocks![index].rodblockDetails!.description;
            // _projectData != null &&
            //               _projectData.roadblocks != null &&
            //               _projectData.roadblocks![0].rodblockDetails !=
            //                   null &&
            //               _projectData.roadblocks![0].rodblockDetails!
            //                       .description !=
            //                   null
            //           ? _projectData
            //                   .roadblocks![0].rodblockDetails!.description ??
            //               "N/A"
            //           : 'N/A',

          } else {
            if (roadblock.isEmpty && roadblock == null) {}
          }

          rows.add(DataRow(
              onSelectChanged: (newValue) {
                Provider.of<ProjectHomeViewModel>(context, listen: false)
                    .getProjectDetail(_projectData.id!.toString())
                    .then((val) {
                  showProjectDetailsDialog(
                      Provider.of<ProjectHomeViewModel>(context, listen: false)
                          .productData(),
                      skillsData);
                });
              },
              cells: [
                DataCell(Container(
                  width: 32,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xff334155)),
                  child: Text(
                    fullName.isNotEmpty ? fullName : '',
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
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .18,
                    ),
                    child: Text(
                      "$projectName",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: ColorSelect.white_color,
                          fontSize: 14.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500),
                    ),
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
                DataCell(
                  Text(
                    "$spiValue",
                    style: TextStyle(
                        color: ColorSelect.white_color,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Text(
                    data.projectDetailsResponse != null &&
                            data.projectDetailsResponse!.data != null &&
                            data.projectDetailsResponse!.data!.isNotEmpty &&
                            data.projectDetailsResponse!.data![index]
                                    .roadblocks !=
                                null &&
                            data.projectDetailsResponse!.data![index]
                                .roadblocks!.isNotEmpty
                        ? data.projectDetailsResponse?.data![index]
                                .roadblocks![0].rodblockDetails?.description ??
                            "N/A"
                        : "N/A",
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
                    _projectData.phase != null &&
                            _projectData.phase!.isNotEmpty &&
                            _projectData.phase?[0]?.milestone != null &&
                            _projectData.phase![0].milestone!.isNotEmpty
                        ? AppUtil.formattedDateYear1(AppUtil.getFormatedDate(
                            _projectData.phase?[0].milestone?[0].mDate ??
                                "N/A"))
                        : 'N/A',
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
              ]));
        });
      }
    }
    return Row(
      key: Key("show_more_ink_well"),
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
                isAlwaysShown: true,
                thumbColor: const Color(0xff4b5563),
                radius: Radius.circular(20),
                thickness: 10,
                child: SingleChildScrollView(
                  controller: horizontalScroll,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Color(0xff525f72)),
                      child: DataTable(
                          horizontalMargin: 10,
                          showCheckboxColumn: false,
                          dataRowHeight: 60,
                          dividerThickness: 0.7,
                          columns: [
                            DataColumn(
                              label: MouseRegion(
                                onEnter: (event) {},
                                child: Text(
                                  "AP",
                                  key: key7,
                                  style: const TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Project name",
                                key: key6,
                                style: TextStyle(
                                    color: ColorSelect.text_color,
                                    fontSize: 14.0,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            DataColumn(
                              label: InkWell(
                                child: Text(
                                  "Current phase",
                                  key: key5,
                                  style: const TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: InkWell(
                                child: Text(
                                  "Status",
                                  key: key4,
                                  style: TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: InkWell(
                                child: Text(
                                  "SPI",
                                  key: key3,
                                  style: TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: InkWell(
                                child: Text(
                                  "Potential roadblocks",
                                  key: key8,
                                  style: const TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: InkWell(
                                child: Text(
                                  "Last\nupdate",
                                  key: key9,
                                  style: TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: InkWell(
                                child: Text(
                                  "Next\nmilestone",
                                  key: key,
                                  style: TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: InkWell(
                                child: Text(
                                  "Delivery\ndate",
                                  key: key2,
                                  style: TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: InkWell(
                                child: Text(
                                  "Deadline",
                                  key: key1,
                                  style: const TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: InkWell(
                                child: Text(
                                  "Resources",
                                  key: key10,
                                  style: TextStyle(
                                      color: ColorSelect.text_color,
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
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
        ),
      ],
    );
  }

  //       .productData(),
  showProjectDetailsDialog(
      ProjectDetailResponse productData, List<SkillsData> skillsData) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
              backgroundColor: const Color(0xff1E293B),
              content: ProjectDetailsDialogView(
                  response: productData, skills: skillsData),
            ),
          );
        });
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
              Consumer<ProjectHomeViewModel?>(builder: (context, data, _) {
                return data!.loading
                    ? const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : data.projectDetailsResponse == null ||
                            data.projectDetailsResponse!.data!.isEmpty
                        ? Expanded(
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
                        : Expanded(
                            child: RawScrollbar(
                            controller: _scrollController,
                            thumbColor: const Color(0xff4b5563),
                            crossAxisMargin: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            thickness: 8,
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context)
                                  .copyWith(scrollbars: false),
                              child: ListView(
                                controller: _scrollController,
                                shrinkWrap: true,
                                children: [makeProjectList(data)],
                              ),
                            ),
                          ));
              }),
            ],
          ),
        ),
      ),
    );
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
    } catch (e) {}
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
    } else if (response.statusCode == 401) {
      AppUtil.showErrorDialog(context);
    } else {
      print("Error getting users.");
    }
  }
}
