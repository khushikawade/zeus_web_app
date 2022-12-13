import 'package:flutter/material.dart';
import 'package:zeus/services/model/mileston_model.dart';
import 'package:zeus/services/model/phase_details.dart';

Widget milestoneList(context, PhaseDetails phaseDetails,
        {required Null Function(Milestones values, int index, String action)
            callback}) =>
    ListView.builder(
        shrinkWrap: true,
        // physics: BouncingScrollPhysics,
        itemCount: phaseDetails.milestone?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(
                left: 15.0, bottom: 15, top: 5, right: 15),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.30,
                height: 65.0,
                decoration: BoxDecoration(
                  color: const Color(0xff334155),

                  //border: Border.all(color:  const Color(0xff1E293B)),

                  borderRadius: BorderRadius.circular(
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(phaseDetails.milestone?[index].title ?? '',
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xffFFFFFF),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                    phaseDetails.milestone?[index].m_date ?? '',
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xff8897ac),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500))
                              ],
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      callback(phaseDetails.milestone![index],
                                          index, 'Edit');
                                    },
                                    child: const Padding(
                                        padding:
                                            EdgeInsets.only(left: 20.0, top: 7),
                                        child: CircleAvatar(
                                            backgroundColor: Color(0xff475569),
                                            radius: 20,
                                            child: Icon(Icons.edit,
                                                color: Colors.white, size: 20)

                                            // SvgPicture.asset(

                                            //   'images/photo.svg',

                                            //   width: 24.0,

                                            //   height: 24.0,

                                            // ),

                                            )),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      callback(phaseDetails.milestone![index],
                                          index, 'Delete');
                                    },
                                    child: const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10.0, top: 7),
                                        child: CircleAvatar(
                                            backgroundColor: Color(0xff475569),
                                            radius: 20,
                                            child: Icon(Icons.delete,
                                                color: Colors.white, size: 20)

                                            // SvgPicture.asset(

                                            //   'images/photo.svg',

                                            //   width: 24.0,

                                            //   height: 24.0,

                                            // ),

                                            )),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )),
          );
        });
