// /*
// import 'package:shared_preferences/shared_preferences.dart';
// import '../url/UserApi.dart';
// import '../url/user.dart';
//
// class UserPreferences {
//
//   Future<bool> saveUser(User user) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setInt('id',user.id!);
//     prefs.setString('name',user.name!);
//     prefs.setString('email',user.email!);
//     //prefs.setString('phone',user.phone!);
//     //prefs.setString('token',user.token!);
//     return prefs.commit();
//   }
//
//   Future<User> getUser ()  async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? id = prefs.getInt("id");
//     String? name = prefs.getString("name");
//     String? email = prefs.getString("email");
//     String? phone = prefs.getString("phone");
//     String? token = prefs.getString("token");
//
//     return User(
//       //  id: id,name: name,email: email,phone: phone,token: token,
//     );
//   }
//
//   void removeUser() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('id');
//     prefs.remove('name');
//     prefs.remove('email');
//     prefs.remove('phone');
//     prefs.remove('type');
//     prefs.remove('token');
//   }
//
//   Future<String?> getToken() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");
//     return token;
//   }
// }
// */
