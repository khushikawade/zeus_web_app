import 'package:flutter/material.dart';
import 'package:zeus/DemoClass.dart';
import 'package:zeus/navigator_tabs/people_idle/screen/people_idle.dart';
import '../navigation/navigation.dart';
import '../people_profile/screen/people_detail_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    //case '/ProfileScreen':
    //return MaterialPageRoute(builder: (_) =>  ProfileDetail());
    case '/peopleList':
      return MaterialPageRoute(builder: (_) => PeopleIdle());
    case '/home':
      return MaterialPageRoute(
          builder: (_) => MyHomePage(
                onSubmit: (String value) {},
                adOnSubmit: (String value) {},
              ));
    default:
      // If there is no such named route in the switch statement, e.g. /third
      return MaterialPageRoute(builder: (_) => PeopleIdle());
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
