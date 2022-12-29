import 'package:flutter/material.dart';
import 'package:zeus/people_module/people_home/people_home.dart';
import 'package:zeus/user_module/login_screen/login.dart';
import '../home_module/home_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // String? route;
  // Map? queryParameters;
  // if (settings.name != null) {
  //   var uriData = Uri.parse(settings.name!);
  //   route = uriData.path;
  //   queryParameters = uriData.queryParameters;

  //   print("Query param ------------------------------ ${queryParameters}");
  // }
  switch (settings.name) {
    case '/':
      print("Setting name f------------------------- ${settings.name}");
      return MaterialPageRoute(
          builder: (_) => LoginScreen(
                onSubmit: (v) {},
              ));
    case '/peopleList':
      return MaterialPageRoute(builder: (_) => PeopleHomeView());
    case '/home':
      return MaterialPageRoute(
          builder: (_) => MyHomePage(
                onSubmit: (String value) {},
                adOnSubmit: (String value) {},
              ));
    default:
      // If there is no such named route in the switch statement, e.g. /third
      return MaterialPageRoute(builder: (_) => PeopleHomeView());
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('ERROR'),
      ),
    );
  });
}
