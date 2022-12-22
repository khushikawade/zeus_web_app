import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeus/phase_module/new_phase.dart';
import 'package:zeus/services/model/resources_needed.dart';

// ignore: must_be_immutable
class CustomSearchDropdownSubTask extends StatefulWidget {
  bool? showSearchBar = false;
  List<PhasesSortedResources> items = [];
  String? label;
  String? hint;
  String? errorText;
  EdgeInsets? paddingForLabeltext;
  EdgeInsets? margin;
  double? fontsizeForLabel;
  PhasesSortedResources? initialValue;
  PhasesSortedResources? initalValueforPhase;
  String? type;

  Function(PhasesSortedResources value)? onChange;
  CustomSearchDropdownSubTask(
      {this.showSearchBar,
      required this.items,
      this.label,
      this.hint,
      this.margin,
      this.onChange,
      this.errorText,
      this.paddingForLabeltext,
      this.fontsizeForLabel,
      this.initialValue});

  @override
  State<CustomSearchDropdownSubTask> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CustomSearchDropdownSubTask> {
  PhasesSortedResources? selectedValue;

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.initialValue != null) {
      selectedValue = widget.initialValue;
    }
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.only(bottom: 18.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 57.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Color(0Xff334155)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    itemPadding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    buttonPadding: EdgeInsets.only(
                      left: 0.w,
                      right: 10,
                    ),
                    dropdownPadding: EdgeInsets.zero,
                    dropdownScrollPadding: EdgeInsets.zero,

                    isExpanded: true,
                    hint: Text(
                      widget.hint ?? "Select",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    items: widget.items
                        .map((item) => DropdownMenuItem<PhasesSortedResources>(
                              value: item,
                              child: Text(
                                item.department,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        if (widget.onChange != null) {
                          widget.onChange!(value as PhasesSortedResources);
                        }
                        selectedValue = value as PhasesSortedResources;
                      });
                    },

                    iconSize: 25.h,
                    scrollbarAlwaysShow: true,

                    iconDisabledColor: Color(0xff64748B),
                    iconEnabledColor: Color(0xff64748B),
                    dropdownMaxHeight: 150.h,
                    dropdownDecoration: BoxDecoration(color: Color(0xff0F172A)),

                    searchController: textEditingController,
                    searchInnerWidget:
                        widget.showSearchBar != null && widget.showSearchBar!
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Search for an item...',
                                    hintStyle: TextStyle(fontSize: 12.sp),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                    searchMatchFn: (item, searchValue) {
                      return (item.value.toString().contains(searchValue));
                    },
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          widget.errorText != null && widget.errorText!.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    top: 4.h,
                  ),
                  child: Text(widget.errorText ?? '',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 12.sp,
                          //height: 0.20.h,
                          color: Colors.red)),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}

class DropDownforPhase {
  String department = "";
  List<Details> details = [];
  DropDownforPhase(this.department, this.details);
}
