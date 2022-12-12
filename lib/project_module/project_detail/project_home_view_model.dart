import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:zeus/services/response_model/project_idel_response.dart';
import 'package:zeus/services/service_class.dart';
import '../../services/response_model/project_detail_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectHomeViewModel extends ChangeNotifier {
  Service service = Service();
  ProjectDetailResponse? projectDetailResponse;
  ProjectDetailsResponse? projectDetailsResponse;
  bool loading = false;
  bool showProfile = false;

  Future<void> getProjectDetail(String id) async {
    loading = true;
    projectDetailResponse = (await service.getIdelDetail(id));

    print("projectDetailData");
    // print(peopleIdelResponse);
    loading = false;
    notifyListeners();
  }

  Future<void> getPeopleIdel({String? searchText}) async {
    loading = true;
    projectDetailsResponse = (await service.getIdel(searchText))!;
    print("javascript");
    // print(peopleIdelResponse);
    loading = false;
    notifyListeners();
  }

  void apiCall(id) {
    getPeopleIdel();
    getProjectDetail(id);
    notifyListeners();
  }

  Future<bool> changeProfile() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('val') == 'q') {
      // print('hello q');
      showProfile = true;
    } else if (prefs.getString('val') == 'r') {
      // print('hello r');
      showProfile = true;
    } else {
      showProfile = false;
    }
    notifyListeners();
    return showProfile;
  }

  ProjectDetailResponse productData() {
    return projectDetailResponse!;
  }




}
