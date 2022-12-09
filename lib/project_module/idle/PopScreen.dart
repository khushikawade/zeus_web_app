import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PopupScreen extends StatefulWidget {
  const PopupScreen({Key? key}) : super(key: key);

  @override
  State<PopupScreen> createState() => _PopupScreenState();
}

class _PopupScreenState extends State<PopupScreen> {
  showDailog() {
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
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.99,
                height: MediaQuery.of(context).size.height * 0.99,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 450,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 30.0, top: 30.0),
                                          child: const Text(
                                            "Simple Ceremonies",
                                            style: TextStyle(
                                                color: Color(0xffB2C1D6),
                                                fontSize: 18.0,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Container(
                                          height: 30.0,
                                          margin: const EdgeInsets.only(
                                              left: 30.0, top: 16.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff115E59),
                                            //border: Border.all(color: const Color(0xff0E7490)),
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                "Send for Approval",
                                                style: TextStyle(
                                                    color: Color(0xffFFFFFF),
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
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10.0),
                                        height: 30.0,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xff334155),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(40))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            "images/edit.svg",
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    height: 30.0,
                                    width: MediaQuery.of(context).size.height *
                                        100.0,
                                    child: const Divider(
                                      color: Color(0xff94A3B8),
                                      thickness: 0.2,
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 32.0,
                                          margin: const EdgeInsets.only(
                                              left: 30.0, top: 0.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff334155),
                                            //border: Border.all(color: const Color(0xff0E7490)),
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                "Design",
                                                style: TextStyle(
                                                    color: Color(0xffFFFFFF),
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
                                              left: 5.0, top: 0.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff334155),
                                            //border: Border.all(color: const Color(0xff0E7490)),
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                "Design",
                                                style: TextStyle(
                                                    color: Color(0xffFFFFFF),
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
                                              left: 5.0, top: 0.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff334155),
                                            //border: Border.all(color: const Color(0xff0E7490)),
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                "Design",
                                                style: TextStyle(
                                                    color: Color(0xffFFFFFF),
                                                    fontSize: 11.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            width: 35.0,
                                            height: 35.0,
                                            margin: const EdgeInsets.only(
                                                right: 0.0, left: 10.0),
                                            decoration: const BoxDecoration(
                                              color: Color(0xff334155),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Container(
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: SvgPicture.asset(
                                                      'images/list.svg')),
                                            )
                                            //SvgPicture.asset('images/list.svg'),
                                            ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 123.0, top: 10.0),
                                          child: const Text(
                                            "Work folder",
                                            style: TextStyle(
                                                color: Color(0xff7DD3FC),
                                                fontSize: 14.0,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.99,
                                  margin: const EdgeInsets.only(
                                      left: 30.0, top: 16.0),
                                  height:
                                      MediaQuery.of(context).size.height * 0.10,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff1E293B),
                                    border: Border.all(
                                        color: const Color(0xff424D5F),
                                        width: 0.5),
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ),
                                  ),
                                  child: TextFormField(
                                    cursorColor: const Color(0xffFFFFFF),
                                    style: const TextStyle(
                                        color: Color(0xffFFFFFF)),
                                    textAlignVertical: TextAlignVertical.bottom,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          bottom: 13.0,
                                          top: 14.0,
                                          right: 10,
                                          left: 14.0,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Team working on',
                                        hintStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xffFFFFFF),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500)),
                                    onChanged: (value) {
                                      //filterSearchResults(value);
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 30.0, top: 20.0),
                                  child: const Text(
                                    "Potential roadblocks",
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontSize: 16.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.99,
                                  margin: const EdgeInsets.only(
                                      left: 30.0, top: 12.0),
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff334155),
                                    // border: Border.all(color: const Color(0xff1E293B)),
                                    borderRadius: BorderRadius.circular(
                                      12.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0, top: 0.0),
                                        child: const Text(
                                          "Occurrence",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: 40.0, top: 0.0),
                                        child: const Text(
                                          "Responsible",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0, right: 30.0),
                                        child: const Text(
                                          "Date created",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: 3,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 45.0, top: 8.0),
                                              height: 12.0,
                                              width: 12.0,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xffEF4444),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 16.0, top: 8.0),
                                              child: const Text(
                                                "Technology not define yet",
                                                style: TextStyle(
                                                    color: Color(0xffE2E8F0),
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              height: 28.0,
                                              width: 28.0,
                                              margin: const EdgeInsets.only(
                                                  right: 98.0, top: 8.0),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff334155),
                                                border: Border.all(
                                                    color:
                                                        const Color(0xff0F172A),
                                                    width: 3.0),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  30.0,
                                                ),
                                              ),
                                              child: const Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "RC",
                                                  style: TextStyle(
                                                      color: Color(0xffFFFFFF),
                                                      fontSize: 10.0,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 8.0, right: 50.0),
                                              child: const Text(
                                                "13 Jul",
                                                style: TextStyle(
                                                    color: Color(0xff94A3B8),
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.height *
                                        100.0,
                                    child: const Divider(
                                      color: Color(0xff94A3B8),
                                      thickness: 0.2,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.16,
                              child: const VerticalDivider(
                                color: Color(0xff94A3B8),
                                thickness: 0.2,
                              )),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, top: 40.0),
                                                  child: const Text(
                                                    "Start date",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff94A3B8),
                                                        fontSize: 11.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, top: 6.0),
                                                  child: const Text(
                                                    "15 Jan 2012",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, top: 40.0),
                                                  child: const Text(
                                                    "Reminder date",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff94A3B8),
                                                        fontSize: 11.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, top: 6.0),
                                                  child: const Text(
                                                    "16 Jan 2012",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, top: 40.0),
                                                  child: const Text(
                                                    "Delivery date",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff94A3B8),
                                                        fontSize: 11.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, top: 6.0),
                                                  child: const Text(
                                                    "16 Sep 2012",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, top: 40.0),
                                                  child: const Text(
                                                    "Deadline date",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff94A3B8),
                                                        fontSize: 11.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, top: 6.0),
                                                  child: const Text(
                                                    "21 Sep 2012",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, top: 40.0),
                                                  child: const Text(
                                                    "Working days",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff94A3B8),
                                                        fontSize: 11.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, top: 6.0),
                                                  child: const Text(
                                                    "21 ",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontSize: 14.0,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // const Spacer(),

                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 16.0, left: 40.0),
                                              height: 28.0,
                                              width: 28.0,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xff334155),
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(40))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SvgPicture.asset(
                                                  "images/cross.svg",
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        74.0, //MediaQuery.of(context).size.height * 0.10,
                                    width: MediaQuery.of(context).size.width *
                                        100.0,
                                    child: const Divider(
                                      color: Color(0xff94A3B8),
                                      thickness: 0.2,
                                    )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      // margin: const EdgeInsets.only(left: 20.0, top: 40.0),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.39,
                                      width: MediaQuery.of(context).size.width *
                                          0.99,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff263143),
                                        //border: Border.all(color: const Color(0xff0E7490)),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: SizedBox(
                                      //  height: 25.0,
                                      width: MediaQuery.of(context).size.width *
                                          90.0,
                                      child: const Divider(
                                        color: Color(0xff94A3B8),
                                        thickness: 0.2,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 30.0, top: 0.0),
                          child: const Text(
                            "Timeline",
                            style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 16.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 8.0, top: 0.0),
                              child: SvgPicture.asset(
                                'images/plus.svg',
                                color: const Color(0xff93C5FD),
                                width: 10.0,
                                height: 10.0,
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 45.0, top: 0.0),
                              child: const Text(
                                "Request resources",
                                style: TextStyle(
                                    color: Color(0xff93C5FD),
                                    fontSize: 12.0,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 8.0, top: 0.0),
                              child: SvgPicture.asset(
                                'images/plus.svg',
                                color: const Color(0xff93C5FD),
                                width: 10.0,
                                height: 10.0,
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 80.0, top: 0.0),
                              child: const Text(
                                "New phase",
                                style: TextStyle(
                                    color: Color(0xff93C5FD),
                                    fontSize: 12.0,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.99,
                      margin: const EdgeInsets.only(
                          left: 30.0, top: 12.0, right: 30.0),
                      height: 40, //MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        color: const Color(0xff334155),
                        // border: Border.all(color: const Color(0xff1E293B)),
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),

                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15.0, top: 0.0),
                            child: const Text(
                              "Phase",
                              style: TextStyle(
                                  color: Color(0xff94A3B8),
                                  fontSize: 14.0,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            margin:
                                const EdgeInsets.only(right: 40.0, top: 0.0),
                            child: const Text(
                              "From",
                              style: TextStyle(
                                  color: Color(0xff94A3B8),
                                  fontSize: 14.0,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 30.0),
                            child: const Text(
                              "Till",
                              style: TextStyle(
                                  color: Color(0xff94A3B8),
                                  fontSize: 14.0,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FutureBuilder(
                          //  future: getIdel(),
                          builder: (context, snapshot) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 25.0,
                                        width: 25.0,
                                        margin: const EdgeInsets.only(
                                            left: 45.0, top: 10.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "AH",
                                            style: TextStyle(
                                                color: Color(0xffFFFFFF),
                                                fontSize: 10.0,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 16.0, top: 12.0),
                                        child: const Text(
                                          "Design",
                                          style: TextStyle(
                                              color: Color(0xffE2E8F0),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 12.0, right: 40.0),
                                        child: const Text(
                                          "13 Jul",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 12.0, right: 50.0),
                                        child: const Text(
                                          "13 Jul",
                                          style: TextStyle(
                                              color: Color(0xff94A3B8),
                                              fontSize: 14.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 30.0, right: 30.0, bottom: 0.0),
                                      //  height: 74.0,//MediaQuery.of(context).size.height * 0.10,
                                      width: MediaQuery.of(context).size.width *
                                          100.0,
                                      child: const Divider(
                                        color: Color(0xff94A3B8),
                                        thickness: 0.1,
                                      )),
                                ],
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
