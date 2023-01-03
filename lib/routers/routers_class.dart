import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import 'package:zeus/home_module/home_module_1.dart';
import 'package:zeus/people_module/people_home/people_home.dart';
import 'package:zeus/project_module/project_home/project_home_view.dart';
import 'package:zeus/user_module/login_screen/login.dart';
import 'package:zeus/user_module/people_profile/screen/people_detail_view1.dart';
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

class MyRoutes {}

class ConnectedRoutes extends VRouteElementBuilder {
  static final String project = 'project';

  static void toProject(BuildContext context, String username) =>
      context.vRouter.to('$username/$project');

  static final String home = 'home';

  static void toHome(BuildContext context, String username) =>
      context.vRouter.to('/$username/$home');

  static final String people = 'people';

  static void toPeople(BuildContext context, String username) {
    if (username.contains("/$project")) {
      username = username.replaceAll("/$project", "");
    }
    context.vRouter.to('$username/$people');
  }

  static final String people_detail = 'people_detail';

  static void toProfileDetails(
      BuildContext context, String username, String peopleId) {
    if (username.contains("/$people")) {
      username = username.replaceAll("/$people", "");
    }
    context.vRouter.to('$username/$people_detail', queryParameters: {"id": peopleId});
  }

  @override
  List<VRouteElement> buildRoutes() {
    return [
      VNester.builder(
        path: '/:username',
        widgetBuilder: (_, state, child) => MyHomePage1(
          child: child,
          currentIndex: state.names.contains(people)
              ? 3
              : state.names.contains(project)
                  ? 1
                  : 2,
        ),
        nestedRoutes: [
          VWidget(
            path: project,
            name: project,
            widget: ProjectHome(),
          ),
          VWidget(
              path: people,
              name: people,
              // stackedRoutes: [
              //   ConnectedRoutes(),
              // ],
              widget: PeopleHomeView(),
              transitionDuration: Duration(seconds: 1)),
        ],
      ),
      VNester.builder(
        path: '/:username',
        widgetBuilder: (_, state, child) => Builder(builder: (context) {
          String peopleId = context.vRouter.queryParameters['id']!;
          print("Response ------------------ ${peopleId}");
          return ProfileDetail1(
            peopleId: peopleId,
          );
        }),
        nestedRoutes: [
          VWidget(
              path: people_detail,
              name: people_detail,
              widget: Builder(builder: (context) {
                String peopleId = context.vRouter.queryParameters['id']!;
                print("Response ------------------ ${peopleId}");
                return ProfileDetail1(
                  peopleId: peopleId,
                );
              })),
        ],
      ),
      // VNester.builder(
      //   path: '/:username',
      //   widgetBuilder: (_, state, child) {
      //     // if (state.names.contains(people_detail)) {
      //     //   return Builder(builder: (context) {
      //     //     String peopleId = context.vRouter.queryParameters['id']!;
      //     //     print("Response ------------------ ${peopleId}");
      //     //     return ProfileDetail1(
      //     //       peopleId: peopleId,
      //     //     );
      //     //   });
      //     // } else {
      //     return MyHomePage1(
      //       child,
      //       currentIndex: state.names.contains(people)
      //           ? 3
      //           : state.names.contains(project)
      //               ? 1
      //               : 2,
      //     );
      //     //}
      //   },
      //   nestedRoutes: [
      //     VWidget(
      //         path: project,
      //         name: project,
      //         widget: ProjectHome(),
      //         transitionDuration: Duration(seconds: 1)),
      //     VWidget(
      //         path: people,
      //         name: people,
      //         // stackedRoutes: [
      //         //   ConnectedRoutes(),
      //         // ],
      //         widget: PeopleHomeView(),
      //         transitionDuration: Duration(seconds: 1)),
      //     // VWidget(
      //     //     path: people_detail,
      //     //     name: people_detail,
      //     //     widget: Builder(builder: (context) {
      //     //       String peopleId = context.vRouter.queryParameters['id']!;
      //     //       print("Response ------------------ ${peopleId}");
      //     //       return ProfileDetail1(
      //     //         peopleId: peopleId,
      //     //       );
      //     //     }),
      //     //     transitionDuration: Duration(seconds: 1)),
      //   ],
      // ),
    ];
  }
}
