import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zeus/services/model/model_class.dart';
import '../../services/service_class.dart';

class PeopleHomeViewModel with ChangeNotifier {
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
