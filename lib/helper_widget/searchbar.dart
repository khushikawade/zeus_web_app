import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SearchBarWidget extends StatelessWidget {
  final dynamic leading;
  final String? title;
  final dynamic subtitle;
  final dynamic trailing;
  final dynamic backColor;
  final double? height;
  final Widget? backIcon;
  final Widget? actionIcon;

  final bool? getsearchTap;

  const SearchBarWidget(
      {this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.backColor,
      this.height,
      this.backIcon,
      this.actionIcon,
      this.getsearchTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextField(
        // focusNode: viewModel!.searchFieldFocus,
        // controller: viewModel!.searchController,
        onChanged: (value) {
          // viewModel!.isChangedEditField = true;

          // if (value.isNotEmpty) {
          //   viewModel!.onItemChanged();
          // } else {
          //   viewModel!.noDataFound = false;
          //   viewModel!.searchTap = false;
          //   viewModel!.clearList();

          //   viewModel!.getSearchLocaldata();
          // }
        },
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          fillColor: Colors.white, //const Color(0xff1E293B),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: 'Search Project',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintStyle: const TextStyle(
              fontFamily: 'Inter',
              color: Color(0xff64748B),
              fontWeight: FontWeight.w400,
              fontSize: 14),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(
              Icons.search,
              size: 20,
              color: Color(0xff64748B),
            ),
          ),
        ),
      ),
    );
  }
  //testing
}
