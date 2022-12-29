import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DropdownCustomView extends StatefulWidget {
  TextEditingController? controller;
  String? label;
  String? hint;
  Function(String val)? validator;
  Function(String value)? onChange;
  Function(String value)? onFieldSubmitted;

  DropdownCustomView(
      {this.controller,
      this.label,
      this.hint,
      this.validator,
      this.onChange,
      this.onFieldSubmitted});

  @override
  State<StatefulWidget> createState() {
    return DropdownCustomViewState();
  }
}

class DropdownCustomViewState extends State<DropdownCustomView> {
  String? errorText = "";

  validateMethodCall(String val) {
    Future.delayed(const Duration(microseconds: 300), () {
      setState(() {
        errorText = widget.validator!(val);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 9),
      child: Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: PopupMenuButton<int>(
                tooltip: '',
                //offset: const Offset(0, 10),
                position: PopupMenuPosition.under,
                color: Color(0xFF0F172A),
                child: Container(
                    height: 56.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff334155),
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Type",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xffFFFFFF),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xff64748B),
                        )
                      ],
                    )),
                // padding:
                //     const EdgeInsets.only(left: 30.0, right: 18),
                constraints: BoxConstraints.tightForFinite(
                  width: double.infinity,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    padding: const EdgeInsets.all(0),
                    value: 1,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------',
                              overflow: TextOverflow.ellipsis,
                            )),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                color: const Color(0xff334155),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TypeAheadFormField(
                                        keepSuggestionsOnLoading: false,
                                        hideOnLoading: true,
                                        suggestionsBoxVerticalOffset: 0.0,
                                        suggestionsBoxDecoration:
                                            SuggestionsBoxDecoration(
                                                color: Color(0xff334155)),
                                        suggestionsCallback: (pattern) {
                                          return [
                                            "A",
                                            "B",
                                            "C",
                                            "D",
                                            "E",
                                            "F",
                                            "G",
                                            "H"
                                          ];
                                        },
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          controller: TextEditingController(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0),
                                          keyboardType: TextInputType.text,
                                          cursorColor: Colors.white,
                                          autofocus: true,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              top: 15.0,
                                            ),
                                            prefixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 4.0),
                                                child: Icon(
                                                  Icons.search,
                                                  color: Color(0xff64748B),
                                                )),
                                            hintText: 'Search',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xff64748B),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        itemBuilder: (context, item) {
                                          return Container(
                                            width: double.infinity,
                                            color: Color(0xFF0F172A),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(11.0),
                                              child: Text(
                                                item.toString(),
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                          ;
                                        },
                                        transitionBuilder: (context,
                                            suggestionsBox, controller) {
                                          return suggestionsBox;
                                        },
                                        onSuggestionSelected: (item) {})
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                elevation: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
