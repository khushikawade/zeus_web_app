import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  String? title;
  DateTime? startDate;
  DateTime? initialDate;
  DateTime? endDate;
  Function(String values)? callback;
  Function(String values)? validationCallBack;

  DatePicker(
      {required this.title,
      required this.startDate,
      this.endDate,
      this.initialDate,
      required this.callback,
      required this.validationCallBack});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? startDate;
  DateTime? endDate;
  DateTime? selectedDate;
  TextEditingController controller = TextEditingController();
  String? errorText = "";

  @override
  void initState() {
    startDate = widget.startDate ?? DateTime.now();
    endDate = widget.endDate ?? DateTime.now().add(const Duration(days: 36500));
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.26,
              margin: const EdgeInsets.only(left: 30.0),
              height: 56.0,
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
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        startDateF();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 13.0),
                            height: 22.0,
                            width: 20.0,
                            child: Image.asset('images/date.png'),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 10.0, left: 20.0),
                                  child: Text(
                                    widget.title!,
                                    style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Color(0xff64748B),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  )),
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 3.0, left: 20.0),
                                  child: Text(
                                    '${startDate!.day} / ${startDate!.month} / ${startDate!.year}',
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xffFFFFFF),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w200),
                                  )),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, right: 10.0),
                    height: 20.0,
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SvgPicture.asset('images/cross.svg')),
                  ),
                ],
              )),
          Container(
            width: MediaQuery.of(context).size.width * 0.26,
            margin: const EdgeInsets.only(left: 30.0, top: 03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  errorText ?? '',
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
      ),
    );
  }

  startDateF() async {
    DateTime? startPickedDate = await showDatePicker(
        context: context,
        fieldLabelText: "Start Date",
        initialDate: widget.startDate ?? DateTime.now(),
        firstDate: widget.startDate ?? DateTime.now(),
        lastDate:
            widget.endDate ?? DateTime.now().add(const Duration(days: 3650)));
    if (startPickedDate != null) {
      //String formattedDate = DateFormat('dd-MM-yyyy').format(startPickedDate);
      setState(() {
        widget.callback!(
            "${startDate!.day} / ${startDate!.month} / ${startDate!.year}");
        startDate = startPickedDate;
      });
    }
  }
}
