import 'package:flutter/cupertino.dart' show ChangeNotifier;
import 'package:zeus/services/service_class.dart';


class CreateProjectModel extends ChangeNotifier {
  Service service = Service();
  List _currencyName = [];

  getCurrencyList(List currencyName) async {
    // var list = await service.getCurrency(currencyName);
    // _currencyName = _currencyName;
    // notifyListeners();
    // _currencyName;
  }
}
