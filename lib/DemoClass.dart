import 'dart:async';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:zeus/utility/colors.dart';

class ListSearch extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  const ListSearch({Key? key, required this.onSubmit});

  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch> {
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  final double width = 20;
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _submitted = false;
  bool _addSubmitted = false;
  String name_ = '';
  String name = '';

  void _submit() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(name_);
      //   createProject();
      /*  Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(onSubmit: (String value) {  }, adOnSubmit: (String value) {  },)));*/
    }
  }

  @override
  void initState() {
    //addTag=_addTag;
    // getTagpeople();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.99,
          margin: const EdgeInsets.only(left: 30.0, right: 25.0),
          height: 50.0,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 6.0, left: 16.0),
                  child: const Text(
                    "Name",
                    style: TextStyle(
                        fontSize: 11.0,
                        color: Color(0xff64748B),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 5.0, left: 0.0),
                height: 20.0,
                child: TextFormField(
                  controller: emailController,
                  cursorColor: const Color(0xffFFFFFF),
                  style: const TextStyle(color: Color(0xffFFFFFF)),
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      errorStyle: TextStyle(fontSize: 14, height: 0.20),
                      contentPadding: EdgeInsets.only(
                        bottom: 16.0,
                        top: 0.0,
                        right: 10,
                        left: 15.0,
                      ),
                      border: InputBorder.none,
                      hintText: 'Enter name',
                      hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xffFFFFFF),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500)),
                  validator: (value) {
                    //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    if (value!.isEmpty) {
                      return 'Please enter';
                    }
                    return null;
                  },
                  onChanged: (text) => setState(() => name_ = text),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            _submit();
          },
          child: Container(
            height: 48,
            width: 300,
            color: ColorSelect.black_color,
            child: Text("CLicl"),
          ),
        ),
      ],
    );
  }
}

class Country {
  const Country({
    required this.name,
    required this.size,
  });

  final String name;
  final int size;

  @override
  String toString() {
    return '$name ($size)';
  }
}
