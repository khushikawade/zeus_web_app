import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import 'package:zeus/home_module/home_module_1.dart';
import 'package:zeus/people_module/people_home/people_home.dart';
import 'package:zeus/project_module/project_home/project_home_view.dart';
import 'package:zeus/user_module/login_screen/login.dart';
import '../home_module/home_page.dart';

// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     // case '/peopleList':
//     //   return MaterialPageRoute(builder: (_) => PeopleHomeView());
//     case '/home':
//       return MaterialPageRoute(
//           builder: (_) => MyHomePage(
//                 onSubmit: (String value) {},
//                 adOnSubmit: (String value) {},
//               ));
//     default:
//       // If there is no such named route in the switch statement, e.g. /third
//       return MaterialPageRoute(
//           builder: (_) => LoginScreen(
//                 onSubmit: ((value) {}),
//               ));
//   }
// }

class MyRoutes {
  static String loginRoute = "/login";
  static String homeRoute = "/home";
  static String peopleDetailsRoute = "/people_detail";
  static const String peopleRoute = "/people";
  static const String clickUpWebView = "/webview";
}

class ConnectedRoutes extends VRouteElementBuilder {
  static final String project = 'project';

  static void toProject(BuildContext context, String username) =>
      context.vRouter.to('/$username/$project', isReplacement: false);

  static final String people = 'people';

  static void toPeople(BuildContext context, String username) =>
      context.vRouter.to('$username/$people', isReplacement: true);

  static final String profile_details = 'profile_details';

  static void toProfileDetails(BuildContext context, String username) =>
      context.vRouter.to('$username/$profile_details', isReplacement: false);

  @override
  List<VRouteElement> buildRoutes() {
    return [
      VNester.builder(
        path: '/:username',
        widgetBuilder: (_, state, child) {
          return MyHomePage1(
            child,
            currentIndex: state.names.contains(people)
                ? 3
                : state.names.contains(project)
                    ? 1
                    : 2,
          );
        },
        nestedRoutes: [
          VWidget(
              path: project,
              name: project,
              widget: ProjectHome(),
              transitionDuration: Duration(seconds: 1)),
          VWidget(
              path: people,
              name: people,
              widget: PeopleHomeView(),
              transitionDuration: Duration(seconds: 1)),
        ],
      ),
    ];
  }
}
