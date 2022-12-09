import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget dropdownTexttfield(
  BuildContext context,
  String dropdownvalue,
  List<String> items, //Function(String values) callback
) {
  return Container(
    // width: 305, //MediaQuery.of(context).size.width * 0.22,
    margin: const EdgeInsets.only(top: 20.0, left: 30.0),
    height: 56.0,
    width: MediaQuery.of(context).size.width * 0.20,
    // margin: const EdgeInsets.only(right: 30.0),
    decoration: BoxDecoration(
      color: const Color(0xff334155),
      //border: Border.all(color:  const Color(0xff1E293B)),
      borderRadius: BorderRadius.circular(
        8.0,
      ),
    ),
    child: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 20.0),
        // padding: const EdgeInsets.all(2.0),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: const Color(0xffFFFFFF),
                value: dropdownvalue,
                underline: Container(),
                hint: const Text(
                  " Type",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xff000000),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500),
                ),
                isExpanded: true,
                icon: SvgPicture.asset(
                  "images/drop_arrow.svg",
                  color: Color.fromARGB(255, 142, 154, 169),
                  width: 8.0,
                  height: 7.0,
                ),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items,
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xff000000),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                    // callback(dropdownvalue);
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return items.map((String value) {
                    return Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: Text(dropdownvalue,
                          style: const TextStyle(
                              color: Color(0xffFFFFFF),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0)),
                    );
                  }).toList();
                },
              ),
            );
          },
        )),
  );
}
