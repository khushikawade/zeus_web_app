
import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:zeus/services/response_model/tag_model/tagresponse.dart';
import 'package:zeus/services/service_class.dart';

class TagDetail extends ChangeNotifier {
  Service service=Service();
  TagResponse? tagResponse;
  bool loading = false;

  Future<void> getTagData() async {
    loading = true;
    tagResponse = (await service.getTag());
    print("addtags");
    // print(peopleIdelResponse);
    loading = false;
    notifyListeners();
  }

 /* ProjectDetailResponse productData(){
    return projectDetailResponse!;
  }*/
}