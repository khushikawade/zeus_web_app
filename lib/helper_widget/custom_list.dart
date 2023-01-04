import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';

import '../utility/colors.dart';

// class CustomList extends StatefulWidget {
//   int index;
//   final List<dynamic> dynamicList;
//   VoidCallback onDeleteSuccess;
//   CustomList(
//       {required this.dynamicList,
//       required this.onDeleteSuccess,
//       required this.index});

//   @override
//   State<StatefulWidget> createState() {
//     return CustomListState();
//   }
// }

// class CustomListState extends State<CustomList> {
//   String? errorText = "";
//   DateTime? selectedDate;

//   // validateMethodCall(String val) {
//   //   Future.delayed(const Duration(microseconds: 300), () {
//   //     setState(() {
//   //       errorText = widget.validator!(val);
//   //     });
//   //   });
//   // }

//   @override
//   void initState() {
//     // if (widget.initialDate != null) {
//     //   selectedDate = widget.initialDate;
//     // }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 28.0.sp, top: 8.sp, bottom: 10.sp),
//           child: Wrap(
//             runSpacing: 8.sp,
//             spacing: 8.sp,
//             children: List.generate(
//               widget.dynamicList.length,
//               (index) {
//                 return Container(
//                   // padding: EdgeInsets.only(top: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.red, //const Color(0xff334155),
//                     borderRadius: BorderRadius.circular(
//                       8.r,
//                     ),
//                   ),
//                   // color: Colors.red,
//                   child: Padding(
//                     padding: EdgeInsets.all(8.0.sp),
//                     child: Wrap(
//                       crossAxisAlignment: WrapCrossAlignment.center,
//                       children: [
//                         Text(
//                           widget.dynamicList[index] ?? '',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               color: ColorSelect.white_color,
//                               fontSize: 14.sp,
//                               fontStyle: FontStyle.normal,
//                               fontFamily: 'Inter-Regular',
//                               fontWeight: FontWeight.w500),
//                         ),
//                         InkWell(
//                             child: Tooltip(
//                               decoration: BoxDecoration(
//                                 color: const Color(0xff334155),
//                                 border:
//                                     Border.all(color: const Color(0xff334155)),
//                                 borderRadius: BorderRadius.circular(
//                                   18.0.r,
//                                 ),
//                               ),
//                               message: 'Delete',
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 8.0.sp),
//                                 child: Icon(
//                                   Icons.close,
//                                   color: Colors.white,
//                                   size: 18.sp,
//                                 ),
//                               ),
//                             ),
//                             onTap: widget.onDeleteSuccess

//                             //  () {
//                             //   setState(() {
//                             //     if (widget.onTap != null) {
//                             //       widget.onTap!(widget.dynamicList.remove(index));
//                             //     }
//                             //   });
//                             // },
//                             )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
