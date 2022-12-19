import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomSearchDropdown extends StatefulWidget {
  bool? showSearchBar = false;
  List<DropdownModel> items = [];
  String? label;
  String? hint;
  String? errorText;
  EdgeInsets? paddingForLabeltext;
  double? fontsizeForLabel;

  Function(DropdownModel value)? onChange;
  CustomSearchDropdown(
      {this.showSearchBar,
      required this.items,
      this.label,
      this.hint,
      this.onChange,
      this.errorText,
      this.paddingForLabeltext,
      this.fontsizeForLabel});

  @override
  State<CustomSearchDropdown> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CustomSearchDropdown> {
  DropdownModel? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Color(0Xff334155)),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.label != null
                    ? Padding(
                        padding:widget.paddingForLabeltext ?? EdgeInsets.only(
                          top: 10.h,
                          left: 16.h,
                          right: 4.w,
                        ),
                        child: Text(
                          widget.label ?? "",
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: Color(0xff64748B),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 35.h,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      itemPadding: EdgeInsets.only(left: 12.w, right: 12.w),
                      buttonPadding: EdgeInsets.only(left: 0.w, right: 0.w),
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
                          .map((item) => DropdownMenuItem<DropdownModel>(
                                value: item,
                                child: Text(
                                  item.item,
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
                            widget.onChange!(value as DropdownModel);
                          }
                          selectedValue = value as DropdownModel;
                        });
                      },

                      dropdownMaxHeight: 150.h,
                      dropdownDecoration:
                          BoxDecoration(color: Color(0xff0F172A)),

                      searchController: textEditingController,
                      searchInnerWidget: widget.showSearchBar != null &&
                              widget.showSearchBar!
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
                                  hintStyle: const TextStyle(fontSize: 12),
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
                ),
                SizedBox(
                  height: 10.h,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 15.h, bottom: 9.h),
          child: Text(widget.errorText ?? '',
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
                height: 0.20,
                color: Colors.red,
              )),
        )
      ],
    );
  }
}

class DropdownModel {
  String id = "";
  String item = "";
  DropdownModel(this.id, this.item);
}
