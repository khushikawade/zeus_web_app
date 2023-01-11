import 'package:shared_preferences/shared_preferences.dart';

class SharedPre {
  static const String isLogin = 'isLogin';
  static setStringValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static setBoolValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static setIntValue(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<String?>? getStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getString(key) : '';
  }

  static Future<bool?>? getBoolValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getBool(key) : false;
  }

  static Future<int?>? getIntValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getInt(key) : -1;
  }

  static Future<Future<bool>> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
