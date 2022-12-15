import 'package:flutter/material.dart';
import 'package:zeus/services/model/phase_details.dart';
import 'package:zeus/services/model/subtask_model.dart';

Widget subTaskList(context, PhaseDetails phaseDetails,
        {required Null Function(SubTasksModel values, int index, String action)
            callback}) =>
    ListView.builder(
        shrinkWrap: true,
        // physics: BouncingScrollPhysics,
        itemCount: phaseDetails.sub_tasks?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(
                left: 15.0, bottom: 15, top: 0, right: 15),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.30,
                height: 115.0,
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
                                Container(
                                    height: 35,
                                    width: 80,
                                    // margin: const EdgeInsets.only(left: 12.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xff475569),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          phaseDetails.sub_tasks?[index]
                                                  .resource?.department_name ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xffFFFFFF),
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w300),
                                        )))
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                        width: 23.0,
                                        height: 23.0,
                                        // margin: const EdgeInsets.only(
                                        //   top: 26.0,
                                        //   left: 10.0,
                                        // ),
                                        child: CircleAvatar(
                                          radius: 13,
                                          backgroundImage: NetworkImage(phaseDetails
                                                  .sub_tasks?[index]
                                                  .resource
                                                  ?.profileImage ??
                                              'https://picsum.photos/id/237/200/300'),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    Text(
                                        phaseDetails.sub_tasks?[index].resource
                                                ?.resource_name ??
                                            '',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900))
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                    "${phaseDetails.sub_tasks?[index].start_date ?? ''} - ${phaseDetails.sub_tasks?[index].end_date ?? ''}",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xff8897ac),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
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
                                      callback(phaseDetails.sub_tasks![index],
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
                                      callback(phaseDetails.sub_tasks![index],
                                          index, 'Delete');
                                    },
                                    child: const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10.0, top: 7),
                                        child: CircleAvatar(
                                            backgroundColor: Color(0xff475569),
                                            radius: 20,
                                            child: Icon(Icons.delete_outline,
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
