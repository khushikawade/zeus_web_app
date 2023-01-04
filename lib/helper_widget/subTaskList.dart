import 'package:flutter/material.dart';
import 'package:zeus/services/model/phase_details.dart';
import 'package:zeus/services/model/subtask_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeus/utility/util.dart';

Widget subTaskList(context, PhaseDetails phaseDetails, verticalScroll,
        {required Null Function(SubTasksModel values, int index, String action)
            callback}) =>
    Container(
      height: MediaQuery.of(context).size.height * 1.1,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.builder(
            shrinkWrap: true,
            controller: verticalScroll,
            // physics: BouncingScrollPhysics,
            itemCount: phaseDetails.sub_tasks?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(
                    left: 29.5.sp, bottom: 16.sp, top: 16.sp, right: 31.sp),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: 114.h,
                    decoration: BoxDecoration(
                      color: const Color(0xff334155),

                      //border: Border.all(color:  const Color(0xff1E293B)),

                      borderRadius: BorderRadius.circular(
                        8.0.r,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff475569),
                          offset: Offset(
                            0.0.sp,
                            2.0.sp,
                          ),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12.5.sp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        height: 32.h,
                                        width: 71.w,
                                        // margin: const EdgeInsets.only(left: 12.0),
                                        decoration: BoxDecoration(
                                          color: Color(0xff475569),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.r),
                                          ),
                                        ),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              phaseDetails
                                                      .sub_tasks?[index]
                                                      .resource
                                                      ?.department_name ??
                                                  '',
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Color(0xffFFFFFF),
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w300),
                                            )))
                                  ],
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                            width: 23.w,
                                            height: 23.h,
                                            // margin: const EdgeInsets.only(
                                            //   top: 26.0,
                                            //   left: 10.0,
                                            // ),
                                            child: CircleAvatar(
                                              radius: 13.r,
                                              backgroundImage: NetworkImage(
                                                  phaseDetails
                                                          .sub_tasks?[index]
                                                          .resource
                                                          ?.profileImage ??
                                                      'https://picsum.photos/id/237/200/300'),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            phaseDetails.sub_tasks?[index]
                                                    .resource?.resource_name ??
                                                '',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w900))
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Text(
                                        "${AppUtil.dateToString(AppUtil.stringToDateValidate(phaseDetails.sub_tasks![index].start_date!)) ?? ''} - ${AppUtil.dateToString(AppUtil.stringToDateValidate(phaseDetails.sub_tasks![index].end_date!)) ?? ''}",
                                        style: TextStyle(
                                            fontSize: 14.0.sp,
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
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 15.sp, right: 16.sp),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            callback(
                                                phaseDetails.sub_tasks![index],
                                                index,
                                                'Edit');
                                          },
                                          child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xff475569),
                                              radius: 20.r,
                                              child: Icon(Icons.edit,
                                                  color: Colors.white,
                                                  size: 18.sp)

                                              // SvgPicture.asset(

                                              //   'images/photo.svg',

                                              //   width: 24.0,

                                              //   height: 24.0,

                                              // ),

                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            callback(
                                                phaseDetails.sub_tasks![index],
                                                index,
                                                'Delete');
                                          },
                                          child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xff475569),
                                              radius: 20.r,
                                              child: Icon(Icons.delete_outline,
                                                  color: Colors.white,
                                                  size: 18.sp)

                                              // SvgPicture.asset(

                                              //   'images/photo.svg',

                                              //   width: 24.0,

                                              //   height: 24.0,

                                              // ),

                                              ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              );
            }),
      ),
    );
