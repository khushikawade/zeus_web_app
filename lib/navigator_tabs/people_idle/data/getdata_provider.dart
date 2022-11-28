import 'dart:collection';
import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../url/service_class.dart';
import '../model/model_class.dart';

class PeopleIdelClass with ChangeNotifier {
  Service service = Service();
  PeopleList? peopleList;
  bool loading = false;

  Future<void> getPeopleDataList({String? searchText}) async {
    print("Called -------------------------------------------- ");
    loading = true;
    try {
      peopleList = await service.getpeopleList(searchText);
      print("java");
    } catch (e) {
  
      print("Exception in parsing $e");
    }

    loading = false;
    notifyListeners();
  }
}
