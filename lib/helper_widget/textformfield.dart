import 'package:flutter/material.dart';

Widget formField({
  required String labelText,
  required BuildContext context,
  dynamic hintText,
  required controller,
  required Function(String values) callback,
  Function(String values)? validateCallback,
}) {
  String errorText = '';

  return StatefulBuilder(builder: (context, setState) {
    return Column(
      children: [
        Container(
          width: labelText == 'Milestone Title'
              ? MediaQuery.of(context).size.width * 0.3
              : MediaQuery.of(context).size.width * 0.26,
          margin: labelText == 'Milestone Title'
              ? const EdgeInsets.only(left: 15.0)
              : EdgeInsets.only(left: 0.0),
          height: 56,
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
          child: Center(
            child: TextFormField(
              cursorColor: const Color(0xffFFFFFF),
              style: const TextStyle(color: Color(0xffFFFFFF)),
              textAlignVertical: TextAlignVertical.bottom,
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: labelText,
                  labelStyle: TextStyle(
                      fontSize: 11.0,
                      color: Color(0xff64748B),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500),
                  contentPadding: const EdgeInsets.only(
                      top: 8, bottom: 8, right: 15, left: 15),
                  errorText: null,
                  border: InputBorder.none,
                  hintText: hintText ?? '',
                  errorStyle: const TextStyle(color: Colors.green, height: 0),
                  hintStyle: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xffFFFFFF),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400)),

              onChanged: (value) {
                //filterSearchResults(value);
                controller = value;
                callback(controller);
              },
              validator: (value) {
                errorText = validateCallback!(value!) ?? "";
                setState(() {});
                return null;
                //return validateCallback!(value!);
              },
              // onSaved: (value) {
              //   controller = value;
              //   callback(controller);
              // },
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.26,
          margin: const EdgeInsets.only(left: 30.0, top: 03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                errorText,
                style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.red,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        )
      ],
    );
  });
}



// TextFormField(
// cursorColor: const Color(0xffFFFFFF),
// style: const TextStyle(color: Color(0xffFFFFFF)),
// textAlignVertical: TextAlignVertical.bottom,
// keyboardType: TextInputType.text,
// controller: controller,
// decoration: InputDecoration(
// floatingLabelBehavior:FloatingLabelBehavior.always,
// labelText: labelText,
// labelStyle: TextStyle(
// fontSize: 11.0,
// color: Color(0xff64748B),
// fontFamily: 'Inter',
// fontWeight: FontWeight.w500),
// contentPadding: const EdgeInsets.only(
//
// right: 10.0,
// left: 10.0,
// ),
// border: InputBorder.none,
// hintText: hintText ?? labelText,
// errorStyle:
// const TextStyle(color: Colors.transparent),
// hintStyle: const TextStyle(
// fontSize: 14.0,
// color: Color(0xffFFFFFF),
// fontFamily: 'Inter',
// fontWeight: FontWeight.w400)),
// onChanged: (value) {
// //filterSearchResults(value);
// controller = value;
// callback(controller);
// },
//
// validator: (value) {
// setState(() {
// errorText = validateCallback!(value!) ?? "";
// });
// return validateCallback!(value!);
// },
// // onSaved: (value) {
// //   controller = value;
// //   callback(controller);
// // },
// )
