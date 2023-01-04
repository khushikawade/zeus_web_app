import 'package:flutter/material.dart';
import 'package:zeus/services/model/mileston_model.dart';
import 'package:zeus/services/model/phase_details.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeus/utility/util.dart';

Widget milestoneList(context, PhaseDetails phaseDetails, verticalScroll,
        {required Null Function(Milestones values, int index, String action)
            callback}) =>
    Container(
      height: MediaQuery.of(context).size.height * 1.1,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.builder(
            shrinkWrap: true,
            controller: verticalScroll,

            // physics: BouncingScrollPhysics,
            itemCount: phaseDetails.milestone?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(
                    left: 29.5.sp, bottom: 16.sp, top: 16.sp, right: 30.5.sp),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: 69.h,
                    decoration: BoxDecoration(
                      color: const Color(0xff334155),

                      //border: Border.all(color:  const Color(0xff1E293B)),

                      borderRadius: BorderRadius.circular(
                        8.r,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff475569),
                          offset: Offset(
                            0.0.sp,
                            2.0..sp,
                          ),
                          blurRadius: 0.0.r,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 11.sp, left: 22.sp, bottom: 3.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                      phaseDetails.milestone?[index].title ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 14.0.sp,
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
                                      AppUtil.dateToString(
                                              AppUtil.stringToDateValidate(
                                                  phaseDetails.milestone![index]
                                                      .m_date!)) ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 14.0.sp,
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
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 15.sp, right: 15.sp),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          callback(
                                              phaseDetails.milestone![index],
                                              index,
                                              'Edit');
                                        },
                                        child: CircleAvatar(
                                            backgroundColor: Color(0xff475569),
                                            radius: 20.r,
                                            child: Icon(Icons.edit,
                                                color: Colors.white,
                                                size: 18.sp)),
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
                                              phaseDetails.milestone![index],
                                              index,
                                              'Delete');
                                        },
                                        child: CircleAvatar(
                                            backgroundColor: Color(0xff475569),
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
                    )),
              );
            }),
      ),
    );
