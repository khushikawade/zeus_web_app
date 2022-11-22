import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import 'package:responsive_table/responsive_table.dart';

class ListClass extends StatefulWidget {
  const ListClass({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListClass> {
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
    // _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C2C2C),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 0.0),
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
                                  builder: (context, setState) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: const Color(0xff1E293B),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      height:
                                          600.0, //MediaQuery.of(context).size.height * 0.85,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 0.0, left: 10.0),
                                                  child: const Text(
                                                    'Create Project',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 18.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  )),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 0.0, right: 10.0),
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      const Color(0xff1E293B),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffFFFFFF),
                                                      width: 0.1),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: SvgPicture.asset(
                                                    'images/cross.svg',
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.99,
                                            margin: const EdgeInsets.only(
                                                top: 25.0,
                                                left: 10.0,
                                                right: 10.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                8.0,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xff475569),
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 6.0,
                                                            left: 16.0),
                                                    child: const Text(
                                                      "Project title",
                                                      style: TextStyle(
                                                          fontSize: 11.0,
                                                          color:
                                                              Color(0xff64748B),
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 5.0, left: 0.0),
                                                  height: 20.0,
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
                                                    decoration:
                                                        const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                              bottom: 16.0,
                                                              top: 0.0,
                                                              right: 10,
                                                              left: 15.0,
                                                            ),
                                                            border: InputBorder
                                                                .none,
                                                            // hintText: 'Project title',
                                                            hintStyle: TextStyle(
                                                                fontSize: 14.0,
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                  margin: const EdgeInsets.only(
                                                      top: 20.0, left: 10.0),
                                                  height: 56.0,
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
                                                            "AP",
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
                                                                  //   hintText: 'AP',
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
                                                  )),
                                              const SizedBox(
                                                width: 12.0,
                                              ),
                                              Expanded(
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.18,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 10.0),
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff334155),
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
                                                              "Customer",
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
                                                                      left:
                                                                          15.0,
                                                                    ),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    // hintText: 'Project title',
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color: Color(
                                                                            0xffFFFFFF),
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                            onChanged: (value) {
                                                              //filterSearchResults(value);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.99,
                                              margin: const EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              height: 56.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff334155),
                                                //border: Border.all(color:  const Color(0xff1E293B)),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8.0,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0xff475569),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 6.0,
                                                              left: 16.0),
                                                      child: const Text(
                                                        "CRM task ID",
                                                        style: TextStyle(
                                                            fontSize: 11.0,
                                                            color: Color(
                                                                0xff64748B),
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5.0,
                                                            left: 0.0),
                                                    height: 20.0,
                                                    child: TextFormField(
                                                      cursorColor: const Color(
                                                          0xffFFFFFF),
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xffFFFFFF)),
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .bottom,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .only(
                                                                bottom: 16.0,
                                                                top: 0.0,
                                                                right: 10,
                                                                left: 15.0,
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              // hintText: 'Project title',
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
                                              )),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.99,
                                              margin: const EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              height: 56.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff334155),
                                                //border: Border.all(color:  const Color(0xff1E293B)),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8.0,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0xff475569),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 6.0,
                                                              left: 16.0),
                                                      child: const Text(
                                                        "Work Folder ID:",
                                                        style: TextStyle(
                                                            fontSize: 11.0,
                                                            color: Color(
                                                                0xff64748B),
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5.0,
                                                            left: 0.0),
                                                    height: 20.0,
                                                    child: TextFormField(
                                                      cursorColor: const Color(
                                                          0xffFFFFFF),
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xffFFFFFF)),
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .bottom,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .only(
                                                                bottom: 16.0,
                                                                top: 0.0,
                                                                right: 10,
                                                                left: 15.0,
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              //  hintText: 'Project title',
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
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.10,
                                                  margin: const EdgeInsets.only(
                                                      top: 20.0, left: 10.0),
                                                  height: 56.0,
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
                                                            "Budget",
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
                                                                  //hintText: 'Project title',
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
                                                  )),
                                              const SizedBox(
                                                width: 12.0,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.07,
                                                margin: const EdgeInsets.only(
                                                    top: 20.0),
                                                height: 56.0,
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
                                                            left: 5.0,
                                                            right: 20.0),
                                                    // padding: const EdgeInsets.all(2.0),
                                                    child: StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setState) {
                                                        return DropdownButtonHideUnderline(
                                                          child: DropdownButton(
                                                            dropdownColor:
                                                                Color(
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
                                                                      0xffFFFFFF),
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
                                                                (String items) {
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
                                                                          FontWeight
                                                                              .w400),
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
                                                              return items.map(
                                                                  (String
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
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize:
                                                                              14.0)),
                                                                );
                                                              }).toList();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    )),
                                              ),
                                              const SizedBox(
                                                width: 12.0,
                                              ),
                                              Expanded(
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.18,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 10.0),
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff334155),
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
                                                              "Estimated hours",
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
                                                                      left:
                                                                          15.0,
                                                                    ),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    //   hintText: 'Project title',
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color: Color(
                                                                            0xffFFFFFF),
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                            onChanged: (value) {
                                                              //filterSearchResults(value);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.18,
                                                margin: const EdgeInsets.only(
                                                    top: 20.0, left: 10.0),
                                                height: 56.0,
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
                                                      builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setState) {
                                                        return DropdownButtonHideUnderline(
                                                          child: DropdownButton(
                                                            dropdownColor:
                                                                Color(
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
                                                                (String items) {
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
                                                                          FontWeight
                                                                              .w400),
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
                                                              return items.map(
                                                                  (String
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
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize:
                                                                              14.0)),
                                                                );
                                                              }).toList();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    )),
                                              ),
                                              const SizedBox(
                                                width: 12.0,
                                              ),
                                              Expanded(
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.18,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 10.0),
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff334155),
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
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 13.0),
                                                          height: 20.0,
                                                          child: Image.asset(
                                                              'images/date.png'),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                                margin: const EdgeInsets
                                                                        .only(
                                                                    top: 15.0,
                                                                    left: 10.0),
                                                                child:
                                                                    const Text(
                                                                  "Delivery Date",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Color(
                                                                          0xff64748B),
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                )),
                                                            InkWell(
                                                              onTap: () async {
                                                                _selectDate(
                                                                    setState);
                                                              },
                                                              child: Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 0.0,
                                                                      left:
                                                                          10.0),
                                                                  child: Text(
                                                                    '${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color: Color(
                                                                            0xffFFFFFF),
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5.0,
                                                                  right: 10.0),
                                                          height: 20.0,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'images/cross.svg')),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width:
                                                      97.0, //MediaQuery.of(context).size.width * 0.22,
                                                  margin: const EdgeInsets.only(
                                                      top: 30.0),
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    //border: Border.all(color:  const Color(0xff1E293B)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      40.0,
                                                    ),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Create",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Container(
                                                  width:
                                                      97, //MediaQuery.of(context).size.width * 0.22,
                                                  margin: const EdgeInsets.only(
                                                      top: 30.0, right: 10.0),
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff7DD3FC),
                                                    //border: Border.all(color:  const Color(0xff1E293B)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      40.0,
                                                    ),
                                                  ),

                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                              Color(0xff000000),
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Container(
                          width: 46.0,
                          height: 46.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff93C5FD),
                            border: Border.all(color: const Color(0xff93C5FD)),
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          margin: EdgeInsets.only(
                            top: 0.0,
                            left: 25.0,
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
                        margin: EdgeInsets.only(
                          top: 100.0,
                          left: 25.0,
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
                          left: 38.0,
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
                          left: 38.0,
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
                          left: 38.0,
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
                          left: 38.0,
                          right: 0.0,
                        ),
                        child: SvgPicture.asset(
                          "images/bell.svg",
                        ),
                      ),
                      Container(
                        width: 20.0,
                        height: 18.0,
                        margin: EdgeInsets.only(
                          top: 23.0,
                          left: 38.0,
                          right: 0.0,
                        ),
                        child: SvgPicture.asset(
                          "images/setting.svg",
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.89,
                        height: MediaQuery.of(context).size.height * 0.85,
                        margin: const EdgeInsets.only(
                            left: 40.0, right: 16.0, bottom: 10.0, top: 20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xff1E293B),
                          border: Border.all(color: const Color(0xff1E293B)),
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                        ),
                        child: ResponsiveDatatable(
                            reponseScreenSizes: [ScreenSize.xs],
                            autoHeight: false,
                            actions: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 16.0, top: 16.0),
                                        child: const Text(
                                          "AP",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 16.0, top: 16.0),
                                        child: const Text(
                                          "Project name",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        width: 125.0,
                                        margin: const EdgeInsets.only(
                                            left: 128.0, top: 16.0),
                                        child: const Text(
                                          "Current phase",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        width: 120.0,
                                        margin: const EdgeInsets.only(
                                            top: 16.0, left: 35.0),
                                        child: const Text(
                                          "Status",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 16.0),
                                        child: const Text(
                                          "SPI",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        width: 168.0,
                                        margin: const EdgeInsets.only(
                                            top: 16.0, left: 22.0),
                                        child: const Text(
                                          "Potential roadblocks",
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
                                          "Last\nupdate",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 16.0, left: 35.0),
                                        child: const Text(
                                          "Next\nmilestone",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 16.0, left: 35.0),
                                        child: const Text(
                                          "Delivery\ndate",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 16.0, left: 35.0),
                                          child: const Text(
                                            "Deadline",
                                            style: TextStyle(
                                                color: Color(0xff94A3B8),
                                                fontSize: 14.0,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
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
                                                  margin: const EdgeInsets.only(
                                                      left: 16.0, top: 16.0),
                                                  child: const Text(
                                                    "ASCAN- Web3 Onboarging",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Container(
                                                  width: 125.0,
                                                  margin: const EdgeInsets.only(
                                                      left: 10.0, top: 16.0),
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
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontSize: 11.0,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                        color:
                                                            Color(0xffFFFFFF),
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
                                                        color:
                                                            Color(0xffFFFFFF),
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
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 38.0,
                                                            top: 16.0),
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 35.0,
                                                            top: 16.0),
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            top: 16.0),
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
                            ])),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _tabSection() {}
}
