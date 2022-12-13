// import 'package:flutter/material.dart';
// import 'package:zeus/people_module/people_home/people_home.dart';
// import '../home_module/home_page.dart';

// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     //case '/ProfileScreen':
//     //return MaterialPageRoute(builder: (_) =>  ProfileDetail());
//     case '/peopleList':
//       return MaterialPageRoute(builder: (_) => PeopleHomeView());
//     case '/home':
//       return MaterialPageRoute(
//           builder: (_) => MyHomePage(
//                 onSubmit: (String value) {},
//                 adOnSubmit: (String value) {},
//               ));
//     default:
//       // If there is no such named route in the switch statement, e.g. /third
//       return MaterialPageRoute(builder: (_) => PeopleHomeView());
//   }
// }

// Route<dynamic> _errorRoute() {
//   return MaterialPageRoute(builder: (_) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Error'),
//       ),
//       body: const Center(
//         child: Text('ERROR'),
//       ),
//     );
//   });
// }

class MyRoutes {
  static String loginRoute = "/login";
  static String homeRoute = "/home";
  static String peopleDetailsRoute = "/people_detail";
  static const String peopleRoute = "/people";
}
