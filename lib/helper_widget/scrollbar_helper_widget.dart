import 'package:flutter/material.dart';

class CustomScrollBar extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;

  const CustomScrollBar({
    required this.scrollController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: Color(0xff4B5563),
      radius: Radius.circular(5.65218),
      thickness: 9,
      scrollbarOrientation: ScrollbarOrientation.right,
      thumbVisibility: true,
      controller: scrollController,
      child: child,
    );
  }
}
