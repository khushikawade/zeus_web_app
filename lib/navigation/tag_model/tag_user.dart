
import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:zeus/navigation/tag_model/tagresponse.dart';
import 'package:zeus/url/service_class.dart';

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