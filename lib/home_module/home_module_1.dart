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
import 'package:zeus/people_module/people_home/people_home.dart';
import 'package:zeus/helper_widget/custom_search_dropdown.dart';
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/project_module/create_project/create_project.dart';
import 'package:zeus/project_module/project_home/project_home_view.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/user_module/logout_module/logout_view.dart';
import 'package:zeus/utility/debouncer.dart';
import 'package:zeus/utility/dropdrowndata.dart';
import 'package:zeus/utility/util.dart';
import '../helper_widget/search_view.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
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
  final Widget child;
  final int currentIndex;

  const MyHomePage1(this.child, {required this.currentIndex});

  @override
  State<MyHomePage1> createState() => _NavigationRailState();
}

class _NavigationRailState extends State<MyHomePage1>
    with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();

  Debouncer _debouncer = Debouncer();

  Future? getList;

  int _selectedIndex = 1;

  final List<Widget> _mainContents = [
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Home',
        style: TextStyle(fontSize: 40),
      ),
    ),
    ProjectHome(),
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
    PeopleHomeView(),
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
  ];

  @override
  void initState() {
    print(widget.currentIndex);
    _selectedIndex = widget.currentIndex;
    print(_selectedIndex);

    // TODO: implement initState
    super.initState();
  }

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
                        42.r,
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (val) {
                        // try {
                        //   _debouncer.run(() async {
                        //     if (projectListTapIcon) {
                        //       if (val != null && val.isNotEmpty) {
                        //         await Provider.of<ProjectHomeViewModel>(context,
                        //                 listen: false)
                        //             .getPeopleIdel(searchText: val);
                        //       }
                        //     } else if (_selectedIndex == 2) {
                        //       print(_selectedIndex);
                        //     } else if (peopleListTapIcon) {
                        //       Provider.of<PeopleHomeViewModel>(context,
                        //               listen: false)
                        //           .getPeopleDataList(searchText: val);
                        //     }
                        //   });
                        // } catch (e) {
                        //   print(e);
                        //   print(val);
                        // }
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 16.sp),
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                top: 4.0.sp, left: 15.sp, right: 20.sp),
                            child: Icon(
                              Icons.search,
                              color: Color(0xff64748B),
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
              FutureBuilder(
                  future: getList,
                  builder: (context, snapshot) {
                    return Visibility(
                      visible: snapshot.data != null && snapshot.data as bool,
                      child: Column(
                        children: [
                          _selectedIndex == 1
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: 12.sp, left: 12.sp),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                    topLeft:
                                                        Radius.circular(3.r),
                                                    topRight:
                                                        Radius.circular(3.r))),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      _selectedIndex == 1
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
                          _selectedIndex == 3
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
                    );
                  }),
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
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: (int index) {
                          _selectedIndex = index;

                          final username = VRouter.of(context).path;
                          print("User name ----------------- ${username}");
                          if (_selectedIndex == 1) {
                            ConnectedRoutes.toProject(context, username);
                          } else if (_selectedIndex == 3) {
                            ConnectedRoutes.toPeople(context, username);
                          } else {}

                          setState(() {});
                        },
                        labelType: NavigationRailLabelType.selected,
                        backgroundColor: const Color(0xff0F172A),
                        destinations: <NavigationRailDestination>[
                          NavigationRailDestination(
                            padding: EdgeInsets.zero,
                            icon: Container(
                              width: 46.0,
                              height: 46.0,
                              decoration: BoxDecoration(
                                color: const Color(0xff93C5FD),
                                border:
                                    Border.all(color: const Color(0xff93C5FD)),
                                borderRadius: BorderRadius.circular(
                                  16.0,
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                top: 40.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
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
                                border:
                                    Border.all(color: const Color(0xff334155)),
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
                                top: 40.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    "images/notification_icon.svg",
                                  ),
                                ],
                              ),
                            ),
                            label: const Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 25, top: 5),
                                  child: Text(
                                    'Projects',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                          ),
                          NavigationRailDestination(
                              padding: EdgeInsets.zero,
                              icon: Column(
                                children: [
                                  Container(
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
                                    18.0,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                      "images/camera.svg",
                                    ),
                                  ],
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
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: SvgPicture.asset(
                                "images/people.svg",
                              ),
                            ),
                            label: const Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 25, top: 5),
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
                                border:
                                    Border.all(color: const Color(0xff334155)),
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
                                border:
                                    Border.all(color: const Color(0xff334155)),
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
                                border:
                                    Border.all(color: const Color(0xff334155)),
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
              );
            }),
            _selectedIndex == 1
                ?
                //ProfileWidget()
                ProjectHome()
                : _selectedIndex == 3
                    ? PeopleHomeView()
                    : Container(
                        color: const Color(0xff0F172A),
                        alignment: Alignment.center,
                        child: Text(
                          'Coming Soon',
                          style:
                              TextStyle(fontSize: 40.sp, color: Colors.white),
                        ),
                      ),
            // sayyamm
            // Expanded(child: _mainContents[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    // VNavigationGuard allows you to react to navigation events locally
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                VRouter.of(context).to(
                  context.vRouter.url,
                  isReplacement: true,
                  historyState: {'count': '${count + 1}'},
                );
                setState(() => count++);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blueAccent,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Text(
                  'Your pressed this button $count times',
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This number is saved in the history state so if you are on the web leave this page and hit the back button to see this number restored!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
