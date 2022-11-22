// ignore_for_file: file_names
import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:zeus/url/service_class.dart';
import '../project_idel_model/project_idel_response.dart';

class DataIdelClass extends ChangeNotifier {
  Service service=Service();
  PeopleIdelResponse? peopleIdelResponse;
  bool loading = false;

  Future<void> getPeopleIdel() async {
    loading = true;
    peopleIdelResponse = (await service.getIdel())!;
    print("javascript");
   // print(peopleIdelResponse);
    loading = false;
    notifyListeners();
  }
}