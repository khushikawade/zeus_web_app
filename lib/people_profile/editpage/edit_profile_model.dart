import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:zeus/url/service_class.dart';

import '../../url/service_class.dart';

class EditPageModel extends ChangeNotifier {
  Service service = Service();
  List _currencyName = [];

  getCurrencyList(List currencyName) async {
    // var list = await service.getCurrency(currencyName);
    // _currencyName = _currencyName;
    // notifyListeners();
    // _currencyName;
  }
}
