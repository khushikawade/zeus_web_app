import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vrouter/vrouter.dart';
import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/people_module/create_people/create_people_page.dart';
import 'package:zeus/people_module/people_home/people_home.dart';
import 'package:zeus/helper_widget/custom_search_dropdown.dart';
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/project_module/create_project/create_project.dart';
import 'package:zeus/project_module/project_home/project_home_view.dart';
import 'package:zeus/project_module/project_home/project_home_view_model.dart';
import 'package:zeus/routers/route_constants.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/user_module/logout_module/logout_view.dart';
import 'package:zeus/utility/debouncer.dart';
import 'package:zeus/utility/dropdrowndata.dart';
import 'package:zeus/utility/util.dart';
import '../helper_widget/search_view.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../services/response_model/skills_model/skills_response_project.dart';
import '../utility/app_url.dart';
import '../utility/colors.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:http_parser/http_parser.dart';
import '../utility/constant.dart';
import '../utility/upertextformate.dart';
import 'package:zeus/helper_widget/custom_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHomePage1 extends StatefulWidget {
  final int currentIndex;
  Widget child;
  MyHomePage1({required this.child, required this.currentIndex});

  @override
  State<MyHomePage1> createState() => _NavigationRailState();
}

class _NavigationRailState extends State<MyHomePage1>
    with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  List<SkillsData> skillsData = [];
  final ScrollController verticalScroll = ScrollController();

  Debouncer _debouncer = Debouncer();

  Future? getList;

  int _selectedIndex = 1;

  GlobalKey<FormState> _addFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(widget.currentIndex);
    print(widget.currentIndex);
    setMenuIndex();
  }

  @override
  void didUpdateWidget(var oldWidget) {
    super.didUpdateWidget(oldWidget);
    setMenuIndex();
  }

  setMenuIndex() {
    if (context.vRouter.path == "/home/project") {
      setState(() {
        _selectedIndex = 1;
      });
    } else if (context.vRouter.path == "/home/second") {
      setState(() {
        _selectedIndex = 2;
      });
    } else if (context.vRouter.path == "/home/people") {
      setState(() {
        _selectedIndex = 3;
      });
    } else if (context.vRouter.path == "/home/four") {
      setState(() {
        _selectedIndex = 4;
      });
    } else if (context.vRouter.path == "/home/five") {
      setState(() {
        _selectedIndex = 5;
      });
    } else if (context.vRouter.path == "/home/six") {
      setState(() {
        _selectedIndex = 6;
      });
    }
  }

  getColor(int index) {
    if (index == 1) {
      //context.vRouter.to(ConnectedRoutes.project);
      return Colors.amber;
    } else if (index == 2) {
      //context.vRouter.to(ConnectedRoutes.project);
      return Colors.blueGrey;
    } else if (index == 3) {
      return Colors.green;
    } else if (index == 4) {
      return Colors.lightBlue;
    } else if (index == 5) {
      return Colors.purpleAccent;
    } else if (index == 6) {
      return Colors.tealAccent;
    } else {
      return Colors.red;
    }
  }

  setPathUrl(int index) {
    if (index == 1) {
      context.vRouter.toSegments([
        "home",
        RouteConstants.projectRoute
      ]); // Push the url '/home/settings'

    } else if (index == 2) {
      context.vRouter.toSegments(
          ["home", RouteConstants.second]); // Push the url '/home/settings'
    } else if (index == 3) {
      context.vRouter.toSegments([
        "home",
        RouteConstants.peopleRoute
      ]); // Push the url '/home/settings'
    } else if (index == 4) {
      context.vRouter.toSegments(
          ["home", RouteConstants.four]); // Push the url '/home/settings'

    } else if (index == 5) {
      context.vRouter.toSegments(
          ["home", RouteConstants.five]); // Push the url '/home/settings'

    } else if (index == 6) {
      context.vRouter.toSegments(
          ["home", RouteConstants.six]); // Push the url '/home/settings'

    }
  }

  // getAllData() async {
  //   // await getListData();
  //   // change();

  //   // getUsers();
  //   // await getData();
  // }

  // get provider data
  // getData() {
  //   var data = context.watch<ProjectHomeViewModel>();
  // }

  // Future? getListData() async {
  //   var result = await Provider.of<ProjectHomeViewModel>(context, listen: false)
  //       .getPeopleIdel(searchText: '');

  //   return result;
  // }

  // void change() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   prefs.setString('val', 'q');
  // }

  // void getUsers() async {
  //   skillsData.clear();
  //   var token = 'Bearer ' + storage.read("token");
  //   var response = await http.get(
  //     Uri.parse(AppUrl.searchLanguage),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": token,
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     print("skills sucess");
  //     var skills = skillProjectFromJson(response.body);
  //     print(skills);
  //     print('Users: ${skills.data}');
  //     skillsData.addAll(skills.data!);
  //     print(skillsData);
  //   } else if (response.statusCode == 401) {
  //     AppUtil.showErrorDialog(
  //         context, "Your Session has been expired, Please try again!");
  //   } else {
  //     print("Error getting users.");
  //   }
  // }

  @override
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQueryData.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Color(0xff0F172A),
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          toolbarHeight: 70.h,
          backgroundColor: const Color(0xff0F172A),
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5.sp, right: 5.sp),
                    width: 475.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xff1e293b),
                      borderRadius: BorderRadius.circular(
                        48.r,
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        controller: searchController,
                        onChanged: (val) {
                          try {
                            _debouncer.run(() async {
                              if (_selectedIndex == 1) {
                                Provider.of<ProjectHomeViewModel>(context,
                                        listen: false)
                                    .getPeopleIdel(searchText: val);
                              } else if (_selectedIndex == 2) {
                                print(_selectedIndex);
                              } else if (_selectedIndex == 3) {
                                Provider.of<PeopleHomeViewModel>(context,
                                        listen: false)
                                    .getPeopleDataList(searchText: val);
                              }
                            });
                          } catch (e) {
                            print(e);
                            print(val);
                          }
                        },
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.only(top: 16.sp),
                          prefixIconConstraints: BoxConstraints(),
                          prefixIcon: Padding(
                              padding:
                                  EdgeInsets.only(left: 15.sp, right: 20.sp),
                              child: Icon(
                                Icons.search,
                                size: 22.sp,
                                color: Color(0xff334155),
                              )),
                          hintText: _selectedIndex == 1
                              ? 'Search project'
                              : _selectedIndex == 3
                                  ? 'Search people'
                                  : 'Search',
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: Color(0xff64748B),
                              fontFamily: 'Inter-Recgular',
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none,
                        ),
                        // textAlign: Alignment.center,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Inter-Medium',
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                      width: 40.w,
                      height: 40.h,
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundImage: AssetImage('images/images.jpeg'),
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  LogOut(),
                  SizedBox(
                    width: 15.w,
                  ),
                ],
              ),
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  'images/hamburger.svg',
                  width: 18.w,
                  height: 12.h,
                ),
              ),
              SvgPicture.asset(
                'images/logo.svg',
              ),
              // SizedBox(
              //   width: 25,
              // ),
              Column(
                children: [
                  _selectedIndex == 1 &&
                          !context.vRouter.path
                              .contains(RouteConstants.peopleDetails)
                      ? Padding(
                          padding: EdgeInsets.only(top: 12.sp, left: 12.sp),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text("List",
                                      style: TextStyle(
                                          color: Color(0xff93C5FD),
                                          fontSize: 14.sp,
                                          fontFamily: 'Inter-Medium',
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 0.1,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Container(
                                    width: 25.w,
                                    height: 3.h,
                                    decoration: BoxDecoration(
                                        color: Color(0xff93C5FD),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(3.r),
                                            topRight: Radius.circular(3.r))),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 30.w,
                              ),
                              _selectedIndex == 1 &&
                                      !context.vRouter.path.contains(
                                          RouteConstants.peopleDetails)
                                  // _selectedIndex == 1
                                  ? Text("Timeline",
                                      style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontSize: 14.sp,
                                          letterSpacing: 0.1,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Inter-Medium',
                                          fontWeight: FontWeight.w500))
                                  : Container(),
                            ],
                          ),
                        )
                      : Container(),
                  context.vRouter.path.contains(RouteConstants.peopleDetails)
                      ? Padding(
                          padding: EdgeInsets.only(left: 22.sp),
                          child: Text("Profile",
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 22.sp,
                                  fontFamily: 'Inter-Medium',
                                  letterSpacing: 0.1,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700)),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        body: Row(
          children: <Widget>[
            LayoutBuilder(builder: (context, constraint) {
              return Theme(
                data: ThemeData(
                  // highlightColor: Colors.transparent,
                  colorScheme: ColorScheme.light(primary: Color(0xff0F172A)),
                ),
                child: RawScrollbar(
                  controller: verticalScroll,
                  thumbColor: const Color(0xff4b5563),
                  crossAxisMargin: -11,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  thickness: 8,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraint.maxHeight),
                        child: IntrinsicHeight(
                          child: NavigationRail(
                            selectedIndex: _selectedIndex,
                            onDestinationSelected: (int index) {
                              if (index == 0) {
                                if (_selectedIndex == 1) {
                                  showAlertDialog(context);
                                } else if (_selectedIndex == 3) {
                                  showAlertDialogPeople(context);
                                }
                              } else {
                                setState(() {
                                  _selectedIndex = index;
                                  setPathUrl(index);
                                });
                              }
                            },
                            // minExtendedWidth: 1
                            // ,

                            labelType: NavigationRailLabelType.selected,

                            backgroundColor: const Color(0xff0F172A),
                            destinations: <NavigationRailDestination>[
                              NavigationRailDestination(
                                padding: EdgeInsets.zero,
                                icon: Container(
                                  width: 56.w,
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff93C5FD),
                                    border: Border.all(
                                        color: const Color(0xff93C5FD)),
                                    borderRadius: BorderRadius.circular(
                                      16.r,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    top: 40.sp,
                                    left: 20.sp,
                                    right: 0.0,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(20.sp),
                                    child: SvgPicture.asset(
                                      "images/plus.svg",
                                    ),
                                  ),
                                ),
                                label: const Text(''),
                              ),
                              NavigationRailDestination(
                                padding: EdgeInsets.zero,
                                icon: Tooltip(
                                  verticalOffset: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff334155),
                                    border: Border.all(
                                        color: const Color(0xff334155)),
                                    borderRadius: BorderRadius.circular(
                                      18.0,
                                    ),
                                  ),
                                  message: 'Projects',
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 40.0,
                                      left: 20.0,
                                      right: 0.0,
                                    ),
                                    child: SvgPicture.asset(
                                      "images/notification_icon.svg",
                                    ),
                                  ),
                                ),
                                selectedIcon: Container(
                                  width: 56.0,
                                  height: 32.0,
                                  margin: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 20.0,
                                    right: 0.0,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff334155),
                                    border: Border.all(
                                        color: const Color(0xff334155)),
                                    borderRadius: BorderRadius.circular(
                                      18.0.r,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    "images/notification_icon.svg",
                                  ),
                                ),
                                label: const Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 25, top: 5),
                                      child: Text(
                                        'Projects',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    )),
                              ),
                              NavigationRailDestination(
                                  padding: EdgeInsets.zero,
                                  icon: Container(
                                    width: 20.0,
                                    height: 18.0,
                                    margin: const EdgeInsets.only(
                                      top: 0.0,
                                      left: 20.0,
                                      right: 0.0,
                                    ),
                                    child: SvgPicture.asset(
                                      "images/camera.svg",
                                    ),
                                  ),
                                  selectedIcon: Container(
                                    width: 56.0,
                                    height: 32.0,
                                    margin: const EdgeInsets.only(
                                      top: 0.0,
                                      left: 20.0,
                                      right: 0.0,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff334155),
                                      border: Border.all(
                                          color: const Color(0xff334155)),
                                      borderRadius: BorderRadius.circular(
                                        18.0.r,
                                      ),
                                    ),
                                    child: SvgPicture.asset(
                                      "images/camera.svg",
                                    ),
                                  ),
                                  label: Text('')),
                              NavigationRailDestination(
                                padding: EdgeInsets.zero,
                                icon: Column(
                                  children: [
                                    Tooltip(
                                      verticalOffset: 17,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 5.0),
                                      //  textAlign: TextAlign.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        border: Border.all(
                                            color: const Color(0xff334155)),
                                        borderRadius: BorderRadius.circular(
                                          18.0,
                                        ),
                                      ),
                                      excludeFromSemantics: true,
                                      preferBelow: true,
                                      message: 'People',
                                      child: Container(
                                        width: 20.0,
                                        height: 18.0,
                                        margin: const EdgeInsets.only(
                                          top: 0.0,
                                          left: 20.0,
                                          right: 0.0,
                                        ),
                                        child: SvgPicture.asset(
                                          "images/people.svg",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                selectedIcon: Container(
                                  width: 56.0,
                                  height: 32.0,
                                  margin: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 20.0,
                                    right: 0.0,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff334155),
                                    border: Border.all(
                                        color: const Color(0xff334155)),
                                    borderRadius: BorderRadius.circular(
                                      18.0.r,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    "images/people.svg",
                                  ),
                                ),
                                label: const Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 25, top: 5),
                                      child: Text(
                                        'People',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    )),
                              ),
                              NavigationRailDestination(
                                padding: EdgeInsets.zero,
                                icon: Container(
                                  width: 20.0,
                                  height: 18.0,
                                  margin: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 20.0,
                                    right: 0.0,
                                  ),
                                  child: SvgPicture.asset(
                                    "images/button.svg",
                                  ),
                                ),
                                selectedIcon: Container(
                                  width: 56.0,
                                  height: 32.0,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 20.0,
                                    right: 0.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff334155),
                                    border: Border.all(
                                        color: const Color(0xff334155)),
                                    borderRadius: BorderRadius.circular(
                                      18.0,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    "images/button.svg",
                                  ),
                                ),
                                label: const Text(''),
                              ),
                              NavigationRailDestination(
                                padding: EdgeInsets.zero,
                                icon: Container(
                                  width: 20.0,
                                  height: 18.0,
                                  margin: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 20.0,
                                    right: 0.0,
                                  ),
                                  child: SvgPicture.asset(
                                    "images/bell.svg",
                                  ),
                                ),
                                selectedIcon: Container(
                                  width: 56.0,
                                  height: 32.0,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 20.0,
                                    right: 0.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff334155),
                                    border: Border.all(
                                        color: const Color(0xff334155)),
                                    borderRadius: BorderRadius.circular(
                                      18.0,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    "images/bell.svg",
                                  ),
                                ),
                                label: const Text(''),
                              ),
                              NavigationRailDestination(
                                padding: EdgeInsets.zero,
                                icon: Container(
                                  width: 20.0,
                                  height: 18.0,
                                  margin: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 20.0,
                                    right: 0.0,
                                  ),
                                  child: SvgPicture.asset(
                                    "images/setting.svg",
                                  ),
                                ),
                                selectedIcon: Container(
                                  width: 56.0,
                                  height: 32.0,
                                  margin: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 20.0,
                                    right: 0.0,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff334155),
                                    border: Border.all(
                                        color: const Color(0xff334155)),
                                    borderRadius: BorderRadius.circular(
                                      16.0,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    "images/setting.svg",
                                  ),
                                ),
                                label: const Text(''),
                              ),
                            ],
                            selectedIconTheme:
                                const IconThemeData(color: Colors.white),
                            unselectedIconTheme:
                                const IconThemeData(color: Colors.black),
                            selectedLabelTextStyle:
                                const TextStyle(color: Colors.white),
                            extended: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            Expanded(child: widget.child)
          ],
        ),
      ),
    );
  }

  //Create project_detail popup
  void showAlertDialog(BuildContext context) async {
    bool result = await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
              backgroundColor: const Color(0xff1E293B),
              content: Form(
                  key: _addFormKey,
                  child: CreateProjectPage(
                    formKey: _addFormKey,
                    response: null,
                  )),
            ),
          );
        });

    if (result != null && result) {
      await Provider.of<ProjectHomeViewModel>(context, listen: false)
          .getPeopleIdel(searchText: '');

      setState(() {});
    }
  }

  //Create project_detail popup
  void showAlertDialogPeople(BuildContext context) async {
    bool result = await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
              backgroundColor: const Color(0xff1E293B),
              content: Form(
                  key: _formKey,
                  child: CreatePeoplePage(
                    formKey: _formKey,
                    response: null,
                    isEdit: false,
                  )),
            ),
          );
        });

    if (result != null && result) {
      Provider.of<PeopleHomeViewModel>(context, listen: false)
          .getPeopleDataList(searchText: '');

      setState(() {});
    }
  }
}

class SecondView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    );
  }
}
