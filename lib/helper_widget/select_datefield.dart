import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  String? title;

  DatePicker({Key? key, this.title})
      : super(
          key: key,
        );

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());

  DateTime startDate = DateTime.now().subtract(Duration(days: 40));
  DateTime endDate = DateTime.now().add(Duration(days: 40));

  DateTime selectedDate = DateTime.now();
  // DateTime? startDate;
  // DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
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
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  widget.title == "Start date"
                      ? startDateF()
                      : widget.title == "End date"
                          ? endDateF()
                          : Container();
                  // : _selectDate();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 13.0),
                  height: 22.0,
                  width: 20.0,
                  child: Image.asset('images/date.png'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 10.0, left: 20.0),
                      child: Text(
                        widget.title!,
                        style: const TextStyle(
                            fontSize: 13.0,
                            color: Color(0xff64748B),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500),
                      )),
                  GestureDetector(
                    onTap: () async {
                      widget.title == "Start date"
                          ? startDateF()
                          : widget.title == "End date"
                              ? endDateF()
                              : Container();
                      // _selectDate();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(top: 3.0, left: 20.0),
                        child: Text(
                          // '',
                          widget.title == "Start date"
                              ? '${startDate.day} / ${startDate.month} / ${startDate.year}'
                              : widget.title == "End date"
                                  ? '${endDate.day} / ${endDate.month} / ${endDate.year}'
                                  : '',
                          // : '${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}',
                          style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xffFFFFFF),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w200),
                        )),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(top: 5.0, right: 10.0),
                height: 20.0,
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset('images/cross.svg')),
              ),
            ],
          )),
    );
  }

  // Future<void> _selectDate() async {
  //   // widget.title == "start date"
  //   //     ? _buildContractBeginDate(context, _dateTimeNotifier)
  //   //     : widget.title == "end date"
  //   //         ? _buildContractEndDate(context, _dateTimeNotifier)
  //   //         : Container();
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           primaryColor: const Color(0xff0F172A),
  //           accentColor: const Color(0xff0F172A),
  //           colorScheme: ColorScheme.light(primary: const Color(0xff0F172A)),
  //           buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
  //         ),
  //         child: child!,
  //       );
  //     },
  //     initialDate: selectedDate,
  //     // firstDate: new DateTime.now().subtract(new Duration(days: 0)),
  //     initialEntryMode: DatePickerEntryMode.calendarOnly,
  //     firstDate: DateTime.now(),
  //     // .subtract(Duration(days: 0)),
  //     lastDate: DateTime(2100),
  //     // lastDate: DateTime(2101)
  //   );

  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       print("----------------------------------------");
  //       print(selectedDate);
  //       selectedDate = picked;
  //     });
  //   }
  // }

  startDateF() async {
    DateTime? startPickedDate = await showDatePicker(
        context: context,
        fieldLabelText: "Start Date",
        // initialDate: startDate,
        // firstDate: startDate,
        // lastDate: endDate
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (startPickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(startPickedDate);
      setState(() {
        startDate = startPickedDate;
        print("-------------start date------------------");
        print(startDate);

        // startDateController.text =
        //     formattedDate; //set output date to TextField value.
      });
    }
  }

  endDateF() async {
    DateTime? endPickedDate = await showDatePicker(
      context: context,
      fieldLabelText: "End Date",
      // initialDate: startDate,
      // firstDate: startDate,
      // lastDate: endDate,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (endPickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(endPickedDate);
      setState(() {
        endDate = endPickedDate;
        print("-------------end date------------------");
        print(endDate);
        // endDateController.text = formattedDate;
      });
    }
  }
}
