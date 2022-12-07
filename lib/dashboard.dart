import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:side_navigation/side_navigation.dart';
import 'package:zeus/utility/colors.dart';

import 'list.dart';
import 'navigator_tabs/idle/idle.dart';
import 'people_profile/editpage/edit_page.dart';
import 'people_profile/screen/people_detail_view.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List<DataRow> rows = [];
  final List<Widget> _mainContents = [
    // Content for Home tab
    Container(
      color: Colors.yellow.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Home',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // Content for Feed tab
    Idle(),
    // Content for Favorites tab
    Container(
      color: Colors.red.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Favorites',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // Content for Settings tab
    Container(
      color: Colors.pink.shade300,
      alignment: Alignment.center,
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 40),
      ),
    ),

    Container(
      color: Colors.pink.shade300,
      alignment: Alignment.center,
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 40),
      ),
    ),

    Container(
      color: Colors.pink.shade300,
      alignment: Alignment.center,
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 40),
      ),
    ),
    Container(
      color: Colors.pink.shade300,
      alignment: Alignment.center,
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 40),
      ),
    )
  ];
  int selectedIndex = 0;
  TabController? _tabController;
  String dropdownvalue = 'Item 1';
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQueryData.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: const Color(0xff2C2C2C),
        appBar: AppBar(
          toolbarHeight: 64.0,
          backgroundColor: const Color(0xff2C2C2C),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            contentPadding: EdgeInsets.zero,
                            backgroundColor: const Color(0xff1E293B),
                            content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.99,
                                height:
                                    MediaQuery.of(context).size.height * 0.99,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.11,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.94,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xff283345),
                                                  //border: Border.all(color: const Color(0xff0E7490)),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(16.0),
                                                    topLeft:
                                                        Radius.circular(16.0),
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 30.0,
                                                              top: 10.0,
                                                              bottom: 10.0),
                                                      child: const Text(
                                                        "Add people",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 18.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            width:
                                                                97.0, //MediaQuery.of(context).size.width * 0.22,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0,
                                                                    bottom:
                                                                        10.0),
                                                            height: 40.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xff334155),
                                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                40.0,
                                                              ),
                                                            ),
                                                            child: const Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Color(
                                                                        0xffFFFFFF),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 16,
                                                          ),
                                                          Container(
                                                            width:
                                                                97, //MediaQuery.of(context).size.width * 0.22,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0,
                                                                    right: 20.0,
                                                                    bottom:
                                                                        10.0),
                                                            height: 40.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xff7DD3FC),
                                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                40.0,
                                                              ),
                                                            ),

                                                            child: const Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "Save",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Color(
                                                                        0xff000000),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: double.infinity,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 100.0,
                                                          height: 100.0,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 27.0,
                                                                  top: 27.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xff334155),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              110.0,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          34.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                'images/photo.svg',
                                                                width: 36.0,
                                                                height: 36.0,
                                                              )),
                                                        ),
                                                        Container(
                                                          height: 40.0,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 48.0,
                                                                  top: 23.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xff334155),
                                                            //border: Border.all(color: const Color(0xff0E7490)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              40.0,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets
                                                                        .only(
                                                                    left: 16.0),
                                                                child: SvgPicture
                                                                    .asset(
                                                                        'images/camera_pic.svg'),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                        .only(
                                                                    left: 11.0),
                                                                child:
                                                                    const Text(
                                                                  "Upload new",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xffFFFFFF),
                                                                      fontSize:
                                                                          14.0,
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 30.0),
                                                      child: const Text(
                                                        "About you",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 18.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8.0,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.26,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 30.0),
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff334155),
                                                        //border: Border.all(color:  const Color(0xff1E293B)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8.0,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0xff475569),
                                                            offset: Offset(
                                                              0.0,
                                                              2.0,
                                                            ),
                                                            blurRadius: 0.0,
                                                            spreadRadius: 0.0,
                                                          ), //BoxShadow
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 6.0,
                                                                      left:
                                                                          16.0),
                                                              child: const Text(
                                                                "Name",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11.0,
                                                                    color: Color(
                                                                        0xff64748B),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0,
                                                                    left: 0.0),
                                                            height: 20.0,
                                                            child:
                                                                TextFormField(
                                                              cursorColor:
                                                                  const Color(
                                                                      0xffFFFFFF),
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xffFFFFFF)),
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .bottom,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              decoration:
                                                                  const InputDecoration(
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        bottom:
                                                                            16.0,
                                                                        top:
                                                                            0.0,
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            15.0,
                                                                      ),
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          'Enter name',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color: Color(
                                                                              0xffFFFFFF),
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                              onChanged:
                                                                  (value) {
                                                                //filterSearchResults(value);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.26,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 30.0,
                                                              top: 16.0),
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff334155),
                                                        //border: Border.all(color:  const Color(0xff1E293B)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8.0,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0xff475569),
                                                            offset: Offset(
                                                              0.0,
                                                              2.0,
                                                            ),
                                                            blurRadius: 0.0,
                                                            spreadRadius: 0.0,
                                                          ), //BoxShadow
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 6.0,
                                                                      left:
                                                                          16.0),
                                                              child: const Text(
                                                                "Nickname",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11.0,
                                                                    color: Color(
                                                                        0xff64748B),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0,
                                                                    left: 0.0),
                                                            height: 20.0,
                                                            child:
                                                                TextFormField(
                                                              cursorColor:
                                                                  const Color(
                                                                      0xffFFFFFF),
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xffFFFFFF)),
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .bottom,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              decoration:
                                                                  const InputDecoration(
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        bottom:
                                                                            16.0,
                                                                        top:
                                                                            0.0,
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            15.0,
                                                                      ),
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          'Enter nickname',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color: Color(
                                                                              0xffFFFFFF),
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                              onChanged:
                                                                  (value) {
                                                                //filterSearchResults(value);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.26,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 30.0,
                                                              top: 16.0),
                                                      height: 80.0,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xff334155),
                                                        //border: Border.all(color:  const Color(0xff1E293B)),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  8.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(
                                                                0xff475569),
                                                            offset: Offset(
                                                              0.0,
                                                              2.0,
                                                            ),
                                                            blurRadius: 0.0,
                                                            spreadRadius: 0.0,
                                                          ), //BoxShadow
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 6.0,
                                                                      left:
                                                                          16.0),
                                                              child: const Text(
                                                                "Your bio",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11.0,
                                                                    color: Color(
                                                                        0xff64748B),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0,
                                                                    left: 0.0),
                                                            height: 20.0,
                                                            child:
                                                                TextFormField(
                                                              cursorColor:
                                                                  const Color(
                                                                      0xffFFFFFF),
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xffFFFFFF)),
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .bottom,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              decoration:
                                                                  const InputDecoration(
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        bottom:
                                                                            16.0,
                                                                        top:
                                                                            0.0,
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            15.0,
                                                                      ),
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          'Enter your bio',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color: Color(
                                                                              0xffFFFFFF),
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                              onChanged:
                                                                  (value) {
                                                                //filterSearchResults(value);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 30.0,
                                                                  top: 16.0),
                                                          height: 50.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xff334155),
                                                            //border: Border.all(color:  const Color(0xff1E293B)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              8.0,
                                                            ),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0xff475569),
                                                                offset: Offset(
                                                                  0.0,
                                                                  2.0,
                                                                ),
                                                                blurRadius: 0.0,
                                                                spreadRadius:
                                                                    0.0,
                                                              ), //BoxShadow
                                                            ],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 6.0,
                                                                      left:
                                                                          16.0),
                                                                  child:
                                                                      const Text(
                                                                    "Name",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11.0,
                                                                        color: Color(
                                                                            0xff64748B),
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  )),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            5.0,
                                                                        left:
                                                                            0.0),
                                                                height: 20.0,
                                                                child:
                                                                    TextFormField(
                                                                  cursorColor:
                                                                      const Color(
                                                                          0xffFFFFFF),
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xffFFFFFF)),
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .bottom,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                          contentPadding: EdgeInsets
                                                                              .only(
                                                                            bottom:
                                                                                16.0,
                                                                            top:
                                                                                0.0,
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                15.0,
                                                                          ),
                                                                          border: InputBorder
                                                                              .none,
                                                                          hintText:
                                                                              'Enter name',
                                                                          hintStyle: TextStyle(
                                                                              fontSize: 14.0,
                                                                              color: Color(0xffFFFFFF),
                                                                              fontFamily: 'Inter',
                                                                              fontWeight: FontWeight.w500)),
                                                                  onChanged:
                                                                      (value) {
                                                                    //filterSearchResults(value);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16.0),
                                                          height: 50.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xff334155),
                                                            //border: Border.all(color:  const Color(0xff1E293B)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              8.0,
                                                            ),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0xff475569),
                                                                offset: Offset(
                                                                  0.0,
                                                                  2.0,
                                                                ),
                                                                blurRadius: 0.0,
                                                                spreadRadius:
                                                                    0.0,
                                                              ), //BoxShadow
                                                            ],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 6.0,
                                                                      left:
                                                                          16.0),
                                                                  child:
                                                                      const Text(
                                                                    "Name",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11.0,
                                                                        color: Color(
                                                                            0xff64748B),
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  )),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            5.0,
                                                                        left:
                                                                            0.0),
                                                                height: 20.0,
                                                                child:
                                                                    TextFormField(
                                                                  cursorColor:
                                                                      const Color(
                                                                          0xffFFFFFF),
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xffFFFFFF)),
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .bottom,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                          contentPadding: EdgeInsets
                                                                              .only(
                                                                            bottom:
                                                                                16.0,
                                                                            top:
                                                                                0.0,
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                15.0,
                                                                          ),
                                                                          border: InputBorder
                                                                              .none,
                                                                          hintText:
                                                                              'Enter name',
                                                                          hintStyle: TextStyle(
                                                                              fontSize: 14.0,
                                                                              color: Color(0xffFFFFFF),
                                                                              fontFamily: 'Inter',
                                                                              fontWeight: FontWeight.w500)),
                                                                  onChanged:
                                                                      (value) {
                                                                    //filterSearchResults(value);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.26,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 30.0,
                                                              top: 16.0),
                                                      height: 50.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff334155),
                                                        //border: Border.all(color:  const Color(0xff1E293B)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8.0,
                                                        ),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color(
                                                                0xff475569),
                                                            offset: Offset(
                                                              0.0,
                                                              2.0,
                                                            ),
                                                            blurRadius: 0.0,
                                                            spreadRadius: 0.0,
                                                          ), //BoxShadow
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 6.0,
                                                                      left:
                                                                          16.0),
                                                              child: const Text(
                                                                "Associated with",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11.0,
                                                                    color: Color(
                                                                        0xff64748B),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0,
                                                                    left: 0.0),
                                                            height: 20.0,
                                                            child:
                                                                TextFormField(
                                                              cursorColor:
                                                                  const Color(
                                                                      0xffFFFFFF),
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xffFFFFFF)),
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .bottom,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              decoration:
                                                                  const InputDecoration(
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        bottom:
                                                                            16.0,
                                                                        top:
                                                                            0.0,
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            15.0,
                                                                      ),
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          'Enter team name',
                                                                      hintStyle: TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color: Color(
                                                                              0xffFFFFFF),
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                              onChanged:
                                                                  (value) {
                                                                //filterSearchResults(value);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 30.0,
                                                              top: 18.0),
                                                      child: const Text(
                                                        "Salary",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 18.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 30.0,
                                                                  top: 16.0),
                                                          height: 50.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xff334155),
                                                            //border: Border.all(color:  const Color(0xff1E293B)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              8.0,
                                                            ),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0xff475569),
                                                                offset: Offset(
                                                                  0.0,
                                                                  2.0,
                                                                ),
                                                                blurRadius: 0.0,
                                                                spreadRadius:
                                                                    0.0,
                                                              ), //BoxShadow
                                                            ],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 6.0,
                                                                      left:
                                                                          16.0),
                                                                  child:
                                                                      const Text(
                                                                    "Name",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11.0,
                                                                        color: Color(
                                                                            0xff64748B),
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  )),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            5.0,
                                                                        left:
                                                                            0.0),
                                                                height: 20.0,
                                                                child:
                                                                    TextFormField(
                                                                  cursorColor:
                                                                      const Color(
                                                                          0xffFFFFFF),
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xffFFFFFF)),
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .bottom,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                          contentPadding: EdgeInsets
                                                                              .only(
                                                                            bottom:
                                                                                16.0,
                                                                            top:
                                                                                0.0,
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                15.0,
                                                                          ),
                                                                          border: InputBorder
                                                                              .none,
                                                                          hintText:
                                                                              'Enter name',
                                                                          hintStyle: TextStyle(
                                                                              fontSize: 14.0,
                                                                              color: Color(0xffFFFFFF),
                                                                              fontFamily: 'Inter',
                                                                              fontWeight: FontWeight.w500)),
                                                                  onChanged:
                                                                      (value) {
                                                                    //filterSearchResults(value);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.10,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16.0),
                                                          height: 50.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xff334155),
                                                            //border: Border.all(color:  const Color(0xff1E293B)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              8.0,
                                                            ),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0xff475569),
                                                                offset: Offset(
                                                                  0.0,
                                                                  2.0,
                                                                ),
                                                                blurRadius: 0.0,
                                                                spreadRadius:
                                                                    0.0,
                                                              ), //BoxShadow
                                                            ],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 6.0,
                                                                      left:
                                                                          16.0),
                                                                  child:
                                                                      const Text(
                                                                    "Name",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11.0,
                                                                        color: Color(
                                                                            0xff64748B),
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  )),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            5.0,
                                                                        left:
                                                                            0.0),
                                                                height: 20.0,
                                                                child:
                                                                    TextFormField(
                                                                  cursorColor:
                                                                      const Color(
                                                                          0xffFFFFFF),
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xffFFFFFF)),
                                                                  textAlignVertical:
                                                                      TextAlignVertical
                                                                          .bottom,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                          contentPadding: EdgeInsets
                                                                              .only(
                                                                            bottom:
                                                                                16.0,
                                                                            top:
                                                                                0.0,
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                15.0,
                                                                          ),
                                                                          border: InputBorder
                                                                              .none,
                                                                          hintText:
                                                                              'Enter name',
                                                                          hintStyle: TextStyle(
                                                                              fontSize: 14.0,
                                                                              color: Color(0xffFFFFFF),
                                                                              fontFamily: 'Inter',
                                                                              fontWeight: FontWeight.w500)),
                                                                  onChanged:
                                                                      (value) {
                                                                    //filterSearchResults(value);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.82,
                                              child: const VerticalDivider(
                                                color: Color(0xff94A3B8),
                                                thickness: 0.2,
                                              )),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0, top: 27.0),
                                                  child: const Text(
                                                    "Availabilty",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 18.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8.0,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.26,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0),
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    //border: Border.all(color:  const Color(0xff1E293B)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color:
                                                            Color(0xff475569),
                                                        offset: Offset(
                                                          0.0,
                                                          2.0,
                                                        ),
                                                        blurRadius: 0.0,
                                                        spreadRadius: 0.0,
                                                      ), //BoxShadow
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 6.0,
                                                                  left: 16.0),
                                                          child: const Text(
                                                            "Select days",
                                                            style: TextStyle(
                                                                fontSize: 11.0,
                                                                color: Color(
                                                                    0xff64748B),
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 5.0,
                                                            left: 0.0),
                                                        height: 20.0,
                                                        child: TextFormField(
                                                          cursorColor:
                                                              const Color(
                                                                  0xffFFFFFF),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffFFFFFF)),
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .bottom,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              const InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom:
                                                                        16.0,
                                                                    top: 0.0,
                                                                    right: 10,
                                                                    left: 15.0,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Select',
                                                                  hintStyle: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Color(
                                                                          0xffFFFFFF),
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                          onChanged: (value) {
                                                            //filterSearchResults(value);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.26,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0, top: 16.0),
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    //border: Border.all(color:  const Color(0xff1E293B)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color:
                                                            Color(0xff475569),
                                                        offset: Offset(
                                                          0.0,
                                                          2.0,
                                                        ),
                                                        blurRadius: 0.0,
                                                        spreadRadius: 0.0,
                                                      ), //BoxShadow
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 6.0,
                                                                  left: 16.0),
                                                          child: const Text(
                                                            "Select time",
                                                            style: TextStyle(
                                                                fontSize: 11.0,
                                                                color: Color(
                                                                    0xff64748B),
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 5.0,
                                                            left: 0.0),
                                                        height: 20.0,
                                                        child: TextFormField(
                                                          cursorColor:
                                                              const Color(
                                                                  0xffFFFFFF),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffFFFFFF)),
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .bottom,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              const InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom:
                                                                        16.0,
                                                                    top: 0.0,
                                                                    right: 10,
                                                                    left: 15.0,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Select',
                                                                  hintStyle: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Color(
                                                                          0xffFFFFFF),
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                          onChanged: (value) {
                                                            //filterSearchResults(value);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 30.0,
                                                              top: 27.0),
                                                      child: const Text(
                                                        "Skills",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 18.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        margin: const EdgeInsets
                                                                .only(
                                                            right: 20.0,
                                                            top: 25.0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xff334155),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Container(
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          12.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'images/list.svg')),
                                                        )
                                                        //SvgPicture.asset('images/list.svg'),
                                                        ),
                                                  ],
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.27,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0,
                                                      top: 26.0,
                                                      right: 20.0),
                                                  height: 35.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff334155)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      48.0,
                                                    ),
                                                  ),
                                                  child: TextFormField(
                                                    cursorColor:
                                                        const Color(0xffFFFFFF),
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF)),
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .bottom,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                        bottom: 13.0,
                                                        top: 14.0,
                                                        right: 10,
                                                        left: 20.0,
                                                      ),
                                                      prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: InkWell(
                                                          onTap: () {},
                                                          child:
                                                              SvgPicture.asset(
                                                            "images/search.svg",
                                                            color: const Color(
                                                                0xff64748B),
                                                            width: 17.05,
                                                            height: 17.06,
                                                          ),
                                                        ),
                                                      ),
                                                      border: InputBorder.none,
                                                      hintText: 'Search ',
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 14.0,
                                                              color: Color(
                                                                  0xff64748B),
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    onChanged: (value) {
                                                      //filterSearchResults(value);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.82,
                                              child: const VerticalDivider(
                                                color: Color(0xff94A3B8),
                                                thickness: 0.2,
                                              )),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0, top: 27.0),
                                                  child: const Text(
                                                    "Contact info",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 18.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8.0,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.26,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0),
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    //border: Border.all(color:  const Color(0xff1E293B)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color:
                                                            Color(0xff475569),
                                                        offset: Offset(
                                                          0.0,
                                                          2.0,
                                                        ),
                                                        blurRadius: 0.0,
                                                        spreadRadius: 0.0,
                                                      ), //BoxShadow
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 6.0,
                                                                  left: 16.0),
                                                          child: const Text(
                                                            "Country",
                                                            style: TextStyle(
                                                                fontSize: 11.0,
                                                                color: Color(
                                                                    0xff64748B),
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 5.0,
                                                            left: 0.0),
                                                        height: 20.0,
                                                        child: TextFormField(
                                                          cursorColor:
                                                              const Color(
                                                                  0xffFFFFFF),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffFFFFFF)),
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .bottom,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              const InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom:
                                                                        16.0,
                                                                    top: 0.0,
                                                                    right: 10,
                                                                    left: 15.0,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Enter country',
                                                                  hintStyle: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Color(
                                                                          0xffFFFFFF),
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                          onChanged: (value) {
                                                            //filterSearchResults(value);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.26,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0, top: 16.0),
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    //border: Border.all(color:  const Color(0xff1E293B)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color:
                                                            Color(0xff475569),
                                                        offset: Offset(
                                                          0.0,
                                                          2.0,
                                                        ),
                                                        blurRadius: 0.0,
                                                        spreadRadius: 0.0,
                                                      ), //BoxShadow
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 6.0,
                                                                  left: 16.0),
                                                          child: const Text(
                                                            "City",
                                                            style: TextStyle(
                                                                fontSize: 11.0,
                                                                color: Color(
                                                                    0xff64748B),
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 5.0,
                                                            left: 0.0),
                                                        height: 20.0,
                                                        child: TextFormField(
                                                          cursorColor:
                                                              const Color(
                                                                  0xffFFFFFF),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffFFFFFF)),
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .bottom,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              const InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom:
                                                                        16.0,
                                                                    top: 0.0,
                                                                    right: 10,
                                                                    left: 15.0,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Enter city',
                                                                  hintStyle: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Color(
                                                                          0xffFFFFFF),
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                          onChanged: (value) {
                                                            //filterSearchResults(value);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.26,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0, top: 16.0),
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    //border: Border.all(color:  const Color(0xff1E293B)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color:
                                                            Color(0xff475569),
                                                        offset: Offset(
                                                          0.0,
                                                          2.0,
                                                        ),
                                                        blurRadius: 0.0,
                                                        spreadRadius: 0.0,
                                                      ), //BoxShadow
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 6.0,
                                                                  left: 16.0),
                                                          child: const Text(
                                                            "Phone number",
                                                            style: TextStyle(
                                                                fontSize: 11.0,
                                                                color: Color(
                                                                    0xff64748B),
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 5.0,
                                                            left: 0.0),
                                                        height: 20.0,
                                                        child: TextFormField(
                                                          cursorColor:
                                                              const Color(
                                                                  0xffFFFFFF),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffFFFFFF)),
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .bottom,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              const InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom:
                                                                        16.0,
                                                                    top: 0.0,
                                                                    right: 10,
                                                                    left: 15.0,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Enter number',
                                                                  hintStyle: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Color(
                                                                          0xffFFFFFF),
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                          onChanged: (value) {
                                                            //filterSearchResults(value);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.26,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0, top: 16.0),
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    //border: Border.all(color:  const Color(0xff1E293B)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color:
                                                            Color(0xff475569),
                                                        offset: Offset(
                                                          0.0,
                                                          2.0,
                                                        ),
                                                        blurRadius: 0.0,
                                                        spreadRadius: 0.0,
                                                      ), //BoxShadow
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 6.0,
                                                                  left: 16.0),
                                                          child: const Text(
                                                            "Email address",
                                                            style: TextStyle(
                                                                fontSize: 11.0,
                                                                color: Color(
                                                                    0xff64748B),
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 5.0,
                                                            left: 0.0),
                                                        height: 20.0,
                                                        child: TextFormField(
                                                          cursorColor:
                                                              const Color(
                                                                  0xffFFFFFF),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffFFFFFF)),
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .bottom,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              const InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom:
                                                                        16.0,
                                                                    top: 0.0,
                                                                    right: 10,
                                                                    left: 15.0,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Enter email address',
                                                                  hintStyle: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Color(
                                                                          0xffFFFFFF),
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                          onChanged: (value) {
                                                            //filterSearchResults(value);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.26,
                                                  margin: const EdgeInsets.only(
                                                      top: 20.0, left: 30.0),
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    //border: Border.all(color:  const Color(0xff1E293B)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 20.0),
                                                      // padding: const EdgeInsets.all(2.0),
                                                      child: StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState) {
                                                          return DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton(
                                                              dropdownColor:
                                                                  const Color(
                                                                      0xffFFFFFF),
                                                              value:
                                                                  dropdownvalue,
                                                              underline:
                                                                  Container(),
                                                              hint: const Text(
                                                                " Choose",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Color(
                                                                        0xff000000),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              isExpanded: true,
                                                              icon: SvgPicture
                                                                  .asset(
                                                                "images/drop_arrow.svg",
                                                                color: const Color(
                                                                    0xff64748B),
                                                                width: 8.0,
                                                                height: 5.0,
                                                              ),
                                                              items: items.map(
                                                                  (String
                                                                      items) {
                                                                return DropdownMenuItem(
                                                                  value: items,
                                                                  child: Text(
                                                                    items,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                              onChanged: (String?
                                                                  newValue) {
                                                                setState(() {
                                                                  dropdownvalue =
                                                                      newValue!;
                                                                });
                                                              },
                                                              selectedItemBuilder:
                                                                  (BuildContext
                                                                      context) {
                                                                return items
                                                                    .map((String
                                                                        value) {
                                                                  return Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                15.0),
                                                                    child: Text(
                                                                        dropdownvalue,
                                                                        style: const TextStyle(
                                                                            color: Color(
                                                                                0xffFFFFFF),
                                                                            fontFamily:
                                                                                'Inter',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 14.0)),
                                                                  );
                                                                }).toList();
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        );
                      });
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 26.0, left: 5.0),
                  child: SvgPicture.asset(
                    'images/hamburger.svg',
                    width: 18.0,
                    height: 12.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 26.0, left: 0.0),
                child: SvgPicture.asset(
                  'images/logo.svg',
                ),
              ),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.22,
                margin: const EdgeInsets.only(left: 15.0, top: 26.0),
                height: 35.0,
                decoration: BoxDecoration(
                  color: const Color(0xff1E293B),
                  border: Border.all(color: const Color(0xff1E293B)),
                  borderRadius: BorderRadius.circular(
                    48.0,
                  ),
                ),
                child: TextFormField(
                  cursorColor: const Color(0xffFFFFFF),
                  style: const TextStyle(color: Color(0xffFFFFFF)),
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        bottom: 13.0,
                        top: 14.0,
                        right: 10,
                        left: 14.0,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                            "images/search.svg",
                            color: const Color(0xff64748B),
                            width: 17.05,
                            height: 17.06,
                          ),
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: 'Search projects',
                      hintStyle: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xff64748B),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400)),
                  onChanged: (value) {
                    //filterSearchResults(value);
                  },
                ),
              ),
              Container(
                  width: 30.0,
                  height: 30.0,
                  margin: const EdgeInsets.only(
                    top: 26.0,
                    left: 10.0,
                  ),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage('https://picsum.photos/id/237/200/300'),
                  )),
              Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  color: const Color(0xff334155),
                  border: Border.all(color: const Color(0xff334155)),
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                margin: const EdgeInsets.only(
                  top: 26.0,
                  left: 8.0,
                  right: 5.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    "images/drop_arrow.svg",
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) =>
                                          EditPage());
                                });
                          },
                          child: Container(
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
                              top: 55.0,
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
                        ),
                        Container(
                          width: 46.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff334155),
                            border: Border.all(color: const Color(0xff334155)),
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          margin: const EdgeInsets.only(
                            top: 100.0,
                            left: 20.0,
                            right: 0.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: SvgPicture.asset(
                              "images/notification_icon.svg",
                            ),
                          ),
                        ),
                        Container(
                          width: 20.0,
                          height: 18.0,
                          margin: const EdgeInsets.only(
                            top: 23.0,
                            left: 34.0,
                            right: 0.0,
                          ),
                          child: SvgPicture.asset(
                            "images/camera.svg",
                          ),
                        ),
                        Container(
                          width: 20.0,
                          height: 18.0,
                          margin: const EdgeInsets.only(
                            top: 23.0,
                            left: 34.0,
                            right: 0.0,
                          ),
                          child: SvgPicture.asset(
                            "images/people.svg",
                          ),
                        ),
                        Container(
                          width: 20.0,
                          height: 18.0,
                          margin: const EdgeInsets.only(
                            top: 23.0,
                            left: 34.0,
                            right: 0.0,
                          ),
                          child: SvgPicture.asset(
                            "images/button.svg",
                          ),
                        ),
                        Container(
                          width: 20.0,
                          height: 18.0,
                          margin: const EdgeInsets.only(
                            top: 23.0,
                            left: 34.0,
                            right: 0.0,
                          ),
                          child: SvgPicture.asset(
                            "images/bell.svg",
                          ),
                        ),
                        Container(
                          width: 20.0,
                          height: 18.0,
                          margin: const EdgeInsets.only(
                            top: 23.0,
                            left: 34.0,
                            right: 0.0,
                          ),
                          child: SvgPicture.asset(
                            "images/setting.svg",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: MediaQuery.of(context).size.height * 0.83,
                          margin: const EdgeInsets.only(
                              left: 40.0, right: 16.0, bottom: 10.0, top: 40.0),
                          decoration: BoxDecoration(
                            color: const Color(0xff1E293B),
                            border: Border.all(color: const Color(0xff1E293B)),
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                          ),
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        child: SingleChildScrollView(
                                          // controller:
                                          // vertical_scrollcontroller,
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                                dataRowHeight: 60,
                                                columns: const [
                                                  DataColumn(
                                                    label: Text(
                                                      "AP",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff94A3B8),
                                                          fontSize: 14.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      "Project name",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff94A3B8),
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.1,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      "Current phase",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff94A3B8),
                                                          fontSize: 14.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      "Status",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff94A3B8),
                                                          fontSize: 14.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      "SPI",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff94A3B8),
                                                          fontSize: 14.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      "Potential roadblocks",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff94A3B8),
                                                          fontSize: 14.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      "Last\nupdate",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff94A3B8),
                                                          fontSize: 14.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      "Next\nmilestone",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff94A3B8),
                                                          fontSize: 14.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      "Delivery\ndate",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff94A3B8),
                                                          fontSize: 14.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      "Deadline",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff94A3B8),
                                                          fontSize: 14.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                                rows: rows),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   margin: const EdgeInsets.only(
                                    //       left: 16.0, top: 16.0),
                                    //   child: const Text(
                                    //     "AP",
                                    //     style: TextStyle(
                                    //         color: Color(0xff94A3B8),
                                    //         fontSize: 14.0,
                                    //         fontFamily: 'Inter',
                                    //         fontWeight: FontWeight.w500),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   margin: const EdgeInsets.only(
                                    //       left: 16.0, top: 16.0),
                                    //   child: const Text(
                                    //     "Project name",
                                    //     style: TextStyle(
                                    //         color: Color(0xff94A3B8),
                                    //         fontSize: 14.0,
                                    //         fontFamily: 'Inter',
                                    //         fontWeight: FontWeight.w500),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   width: 125.0,
                                    //   margin: const EdgeInsets.only(
                                    //       left: 128.0, top: 16.0),
                                    //   child: const Text(
                                    //     "Current phase",
                                    //     style: TextStyle(
                                    //         color: Color(0xff94A3B8),
                                    //         fontSize: 14.0,
                                    //         fontFamily: 'Inter',
                                    //         fontWeight: FontWeight.w500),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   width: 120.0,
                                    //   margin: const EdgeInsets.only(
                                    //       top: 16.0, left: 35.0),
                                    //   child: const Text(
                                    //     "Status",
                                    //     style: TextStyle(
                                    //         color: Color(0xff94A3B8),
                                    //         fontSize: 14.0,
                                    //         fontFamily: 'Inter',
                                    //         fontWeight: FontWeight.w500),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   margin: const EdgeInsets.only(top: 16.0),
                                    //   child: const Text(
                                    //     "SPI",
                                    //     style: TextStyle(
                                    //         color: Color(0xff94A3B8),
                                    //         fontSize: 14.0,
                                    //         fontFamily: 'Inter',
                                    //         fontWeight: FontWeight.w500),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   margin: const EdgeInsets.only(
                                    //       top: 16.0, left: 22.0),
                                    //   child: const Text(
                                    //     "Potential roadblocks",
                                    //     style: TextStyle(
                                    //         color: Color(0xff94A3B8),
                                    //         fontSize: 14.0,
                                    //         fontFamily: 'Inter',
                                    //         fontWeight: FontWeight.w500),
                                    //   ),
                                    // ),
                                    // const Text(
                                    //   "Last\nupdate",
                                    //   style: TextStyle(
                                    //       color: Color(0xff94A3B8),
                                    //       fontSize: 14.0,
                                    //       fontFamily: 'Inter',
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                    // const Text(
                                    //   "Next\nmilestone",
                                    //   style: TextStyle(
                                    //       color: Color(0xff94A3B8),
                                    //       fontSize: 14.0,
                                    //       fontFamily: 'Inter',
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                    // const Text(
                                    //   "Delivery\ndate",
                                    //   style: TextStyle(
                                    //       color: Color(0xff94A3B8),
                                    //       fontSize: 14.0,
                                    //       fontFamily: 'Inter',
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                    // Expanded(
                                    //   child: Container(
                                    //     margin: const EdgeInsets.only(
                                    //         top: 16.0, left: 35.0),
                                    //     child: const Text(
                                    //       "Deadline",
                                    //       style: TextStyle(
                                    //           color: Color(0xff94A3B8),
                                    //           fontSize: 14.0,
                                    //           fontFamily: 'Inter',
                                    //           fontWeight: FontWeight.w500),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    child: const Divider(
                                      color: Color(0xff94A3B8),
                                      thickness: 0.1,
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 10,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 20.0,
                                                height: 20.0,
                                                margin: const EdgeInsets.only(
                                                    left: 16.0, top: 16.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff334155),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff334155)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    16.0,
                                                  ),
                                                ),
                                                child: const Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "YL",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 8.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 200.0,
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, top: 16.0),
                                                child: const Text(
                                                  "ASCAN- Web3 Onboarging",
                                                  style: TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                width: 125.0,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16, 16, 0, 0),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "Backend: Phase 2/4",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 30.0,
                                                margin: const EdgeInsets.only(
                                                    left: 30.0,
                                                    right: 16.0,
                                                    top: 16.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff9A3412),
                                                  //border: Border.all(color: const Color(0xff0E7490)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    8.0,
                                                  ),
                                                ),
                                                child: const Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Text(
                                                      "Send for Approval",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          fontSize: 11.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 12.0, top: 16.0),
                                                child: const Text(
                                                  "1.2",
                                                  style: TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                width: 184.0,
                                                margin: const EdgeInsets.only(
                                                    left: 20.0, top: 16.0),
                                                child: const Text(
                                                  "Ticket not updated for 3 days",
                                                  style: TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 30.0, top: 16.0),
                                                child: const Text(
                                                  "13 Jul",
                                                  style: TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 38.0, top: 16.0),
                                                  child: const Text(
                                                    "29 Aug",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 35.0, top: 16.0),
                                                  child: const Text(
                                                    "29 Jul",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 16.0, top: 16.0),
                                                  child: const Text(
                                                    "13 Aug",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 16.0, right: 16.0),
                                              child: const Divider(
                                                color: Color(0xff94A3B8),
                                                thickness: 0.1,
                                              )),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Expanded(
                      flex: 18,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.83,
                        margin: const EdgeInsets.only(
                            left: 40.0, right: 16.0, bottom: 10.0, top: 40.0),
                        decoration: BoxDecoration(
                          color: const Color(0xff1E293B),
                          border: Border.all(color: const Color(0xff1E293B)),
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 168.0,
                                    margin: const EdgeInsets.only(
                                        left: 16.0, top: 16.0),
                                    child: const Text(
                                      "Name",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 14.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 120.0, top: 16.0),
                                    child: const Text(
                                      "Nickname",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 14.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 82.0, top: 16.0),
                                    child: const Text(
                                      "Capacity",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 14.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 16.0, left: 45.0),
                                    child: const Text(
                                      "Occupied till",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 14.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    width: 150.0,
                                    margin: const EdgeInsets.only(
                                        top: 16.0, left: 45.0),
                                    child: const Text(
                                      "Scheduled on",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 14.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 16.0, left: 0.0),
                                    child: const Text(
                                      "Skills",
                                      style: TextStyle(
                                          color: Color(0xff94A3B8),
                                          fontSize: 14.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  child: const Divider(
                                    color: Color(0xff94A3B8),
                                    thickness: 0.1,
                                  )),
                              Expanded(
                                flex: 1,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: 10,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        if (index == 0) {
                                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  ProfileDetail()));

                                        }
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width: 28.0,
                                                  height: 28.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 16.0, top: 5.0),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      40.0,
                                                    ),
                                                  ),
                                                  child: const CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: NetworkImage(
                                                        'https://picsum.photos/id/237/200/300'),
                                                  )),
                                              Container(
                                                width: 200.0,
                                                margin: const EdgeInsets.only(
                                                    left: 16.0, top: 5.0),
                                                child: const Text(
                                                  "Youri Luiten\nUX Designer,Design",
                                                  style: TextStyle(
                                                      color: Color(0xffB2C1D6),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 42.0, top: 5.0),
                                                child: const Text(
                                                  "@InTheGoatWay",
                                                  style: TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 42.0, top: 5.0),
                                                child: const Text(
                                                  "40h/week",
                                                  style: TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 40.0, top: 5.0),
                                                child: const Text(
                                                  "24 Oct",
                                                  style: TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 80.0, top: 5.0),
                                                child: const Text(
                                                  "Screaming",
                                                  style: TextStyle(
                                                      color: Color(0xff22C55E),
                                                      fontSize: 14.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                height: 32.0,
                                                margin: const EdgeInsets.only(
                                                    left: 80.0, top: 5.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff334155),
                                                  //border: Border.all(color: const Color(0xff0E7490)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    8.0,
                                                  ),
                                                ),
                                                child: const Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Text(
                                                      "Durapal",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          fontSize: 11.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 32.0,
                                                margin: const EdgeInsets.only(
                                                    left: 12.0, top: 5.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff334155),
                                                  //border: Border.all(color: const Color(0xff0E7490)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    8.0,
                                                  ),
                                                ),
                                                child: const Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Text(
                                                      "Durapal",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          fontSize: 11.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 32.0,
                                                margin: const EdgeInsets.only(
                                                    left: 12.0, top: 5.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff334155),
                                                  //border: Border.all(color: const Color(0xff0E7490)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    8.0,
                                                  ),
                                                ),
                                                child: const Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Text(
                                                      "Durapal",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          fontSize: 11.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 16.0, right: 16.0),
                                              child: const Divider(
                                                color: Color(0xff94A3B8),
                                                thickness: 0.1,
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _tabSection() {}
}
