import 'package:flutter/material.dart';

import '../utility/colors.dart';

// Widget(_depat,_department){
//   return Container(
//                             margin:
//                                 const EdgeInsets.only(left: 16.0, right: 16.0),
//                             height: 20.0,
//                             child: Container(

//                                 // padding: const EdgeInsets.all(2.0),
//                                 child: StatefulBuilder(
//                               builder:
//                                   (BuildContext context, StateSettersetState) {
//                                 return DropdownButtonHideUnderline(
//                                   child: DropdownButton(
//                                     dropdownColor: ColorSelect.class_color,
//                                     value: _depat,
//                                     underline: Container(),
//                                     hint: const Text(
//                                       "Select",
//                                       style: TextStyle(
//                                           fontSize: 14.0,
//                                           color: Color(0xffFFFFFF),
//                                           fontFamily: 'Inter',
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     isExpanded: true,
//                                     icon: const Icon(
//                                       // Add this
//                                       Icons.arrow_drop_down, // Add this
//                                       color: Color(0xff64748B),

//                                       // Add this
//                                     ),
//                                     items: _department.map((items) {
//                                       return DropdownMenuItem(
//                                         value: items['id'].toString(),
//                                         child: Text(
//                                           items['name'],
//                                           style: const TextStyle(
//                                               fontSize: 14.0,
//                                               color: Color(0xffFFFFFF),
//                                               fontFamily: 'Inter',
//                                               fontWeight: FontWeight.w400),
//                                         ),
//                                       );
//                                     }).toList(),
//                                     onChanged: (String? newValue) {
//                                       // setState(() {
//                                         _depat = newValue;
//                                     //  });
//                                     },

                                
//                                   ),
//                                 );
//                               },
//                             )),
//                           )
// }