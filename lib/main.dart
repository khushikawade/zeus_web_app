import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:vrouter/vrouter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:zeus/clickup_login/webview_page.dart';
import 'package:zeus/helper_widget/custom_search_dropdown.dart';
import 'package:zeus/home_module/home_module_1.dart';
import 'package:zeus/people_module/people_home/people_home.dart';
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/project_module/create_project/create_project_model.dart';
import 'package:zeus/helper_widget/scroll_behaviour.dart';
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/project_module/create_project/create_project_model.dart';
import 'package:zeus/project_module/project_home/project_home_view_model.dart';
import 'package:zeus/routers/route_constants.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/services/model/model_class.dart';
import 'package:zeus/services/response_model/tag_model/tag_user.dart';
import 'package:zeus/user_module/login_screen/login.dart';
import 'package:zeus/user_module/people_profile/screen/people_detail_view.dart';
import 'package:zeus/utility/constant.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:url_strategy/url_strategy.dart';
import 'home_module/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import 'package:vrouter/src/logs/vlogs.dart';

import 'project_module/project_home/project_home_view.dart';
import 'user_module/people_profile/screen/people_detail_view1.dart';

void main() async {
  // await GetStorage.init();
  // setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1366, 758),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) {
        print("Storage is login value --------------------- ${storage.read(isLogin)}");
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProjectHomeViewModel()),
            ChangeNotifierProvider(create: (_) => PeopleHomeViewModel()),
            ChangeNotifierProvider(create: (_) => TagDetail()),
            ChangeNotifierProvider(create: (_) => CreateProjectModel())
          ],
          child: VRouter(
            scrollBehavior: MyCustomScrollBehavior(),
            transitionDuration: Duration.zero,
            buildTransition: (animation, secondaryAnimation, child) => child,
            debugShowCheckedModeBanner: false,
            builder: FlutterSmartDialog.init(),
            mode: VRouterMode.history,
            initialUrl: storage.read(isLogin) == null
                ? RouteConstants.loginRoute
                : RouteConstants.homeRoute,
            routes: [

              VWidget(
                path: RouteConstants.loginRoute,
                widget: LoginScreen(
                  onSubmit: (value) {},
                ),
              ),
              VNester(
                path: RouteConstants.homeRoute,
                widgetBuilder: (child) => MyHomePage1(
                    child: child,
                    currentIndex: 1,
                ), // Child is the widget from nestedRoutes
                nestedRoutes: [
                  VWidget(
                      path: RouteConstants.projectRoute,
                      widget: ProjectHome()), //l
                  VWidget(path: RouteConstants.second, widget: SecondView()),
                  // VWidget(
                  //   path: RouteConstants.peopleRoute,
                  //   widget: PeopleHomeView(),
                  // ),
                  VWidget(
                      path: RouteConstants.peopleRoute,
                      name: RouteConstants.peopleRoute,
                      stackedRoutes: [
                        VNester.builder(
                          path: '/:username',
                          widgetBuilder: (_, state, child) =>
                              Builder(builder: (context) {
                            String peopleId =
                                context.vRouter.queryParameters['id']!;

                            print("Response ------------------ ${peopleId}");

                            return ProfileDetail1(
                              peopleId: peopleId,
                            );
                          }),
                          nestedRoutes: [
                            VWidget(
                                path: RouteConstants.peopleDetails,
                                name: RouteConstants.peopleDetails,
                                widget: Builder(builder: (context) {
                                  String peopleId =
                                      context.vRouter.queryParameters['id']!;

                                  print(
                                      "Response ------------------ ${peopleId}");

                                  return ProfileDetail1(
                                    peopleId: peopleId,
                                  );
                                })),
                          ],
                        ),
                      ],
                      widget: PeopleHomeView(),
                      transitionDuration: Duration(seconds: 1)),
                  VWidget(path: RouteConstants.four, widget: SecondView()),
                  VWidget(path: RouteConstants.five, widget: SecondView()),
                  VWidget(path: RouteConstants.six, widget: SecondView()),
                  //           VNester.builder(
                  //   path: RouteConstants.peopleRoute,
                  //   widgetBuilder: (_, state, child) => Builder(builder: (context) {
                  //     return PeopleHomeView();
                  //   }),
                  //   nestedRoutes: [
                  //     VWidget(
                  //         path: RouteConstants.peopleDetails,
                  //         name: RouteConstants.peopleDetails,
                  //         widget: Builder(builder: (context) {
                  //           String peopleId =
                  //               context.vRouter.queryParameters['id']!;
                  //           print("Response ------------------ ${peopleId}");
                  //           return ProfileDetail1(
                  //             peopleId: peopleId,
                  //           );
                  //         })),
                  //   ],
                  // ),
                ],
              ),
              VRouteRedirector(
                redirectTo: RouteConstants.homeRoute,
                path: r'*',
              ),
            ],
          ),
        );
      },
    );

    // return VRouter(
    //   initialUrl: storage.read("isLogin") == null
    //       ? MyRoutes.loginRoute
    //       : MyRoutes.homeRoute,
    //   debugShowCheckedModeBanner: false, // VRouter acts as a MaterialApp
    //   mode: VRouterMode.history, // Remove the '#' from the url
    //   // logs: [VLogLevel.info], // Defines which logs to show, info is the default
    //   routes: [
    //     VWidget(
    //       path: '/login',
    //       widget: LoginScreen(
    //         onSubmit: (value) {},
    //       ),
    //       stackedRoutes: [ConnectedRoutes()],
    //     ),
    //     // This redirect every unknown routes to /login
    //     VRouteRedirector(
    //       redirectTo: '/login',
    //       path: r'*',
    //     ),
    //   ],
    // );
  }
}

// import 'package:flutter/material.dart';
// import 'package:vrouter/vrouter.dart';

// main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return VRouter(
//       debugShowCheckedModeBanner: false,
//       routes: [
//         VNester(
//           path: null,
//           widgetBuilder: (child) => MyScaffold(child: child),
//           nestedRoutes: [
//             // Handles the systemPop event
//             VPopHandler(
//               onSystemPop: (vRedirector) async {
//                 // DO check if going back is possible
//                 if (vRedirector.historyCanBack()) {
//                   vRedirector.historyBack();
//                 }
//               },
//               stackedRoutes: [
//                 VWidget(
//                     path: '/',
//                     widget:
//                         HomeScreen(title: 'Home', color: Colors.blueAccent)),
//                 VWidget(
//                     path: '/social',
//                     widget: BasicScreen(
//                         title: 'Social', color: Colors.greenAccent)),
//                 VWidget(
//                     path: '/settings',
//                     widget: BasicScreen(
//                         title: 'Settings', color: Colors.redAccent)),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class MyScaffold extends StatelessWidget {
//   final Widget child;

//   const MyScaffold({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: child,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _indexFromUrl(context),
//         onTap: (index) => _navigateToIndex(context, index),
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.supervisor_account_sharp), label: 'social'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.settings), label: 'settings'),
//         ],
//       ),
//     );
//   }

//   int _indexFromUrl(BuildContext context) {
//     switch (context.vRouter.url) {
//       case '/':
//         return 0;
//       case '/social':
//         return 1;
//       case '/settings':
//         return 2;
//     }

//     throw 'Unknown url: ${context.vRouter.url}';
//   }

//   void _navigateToIndex(BuildContext context, int index) {
//     final to = context.vRouter.to;
//     switch (index) {
//       case 0:
//         return to('/');
//       case 1:
//         return to('/social');
//       case 2:
//         return to('/settings');
//     }
//   }
// }

// class BasicScreen extends StatelessWidget {
//   final String title;
//   final Color color;
//   final Widget? child;

//   const BasicScreen({required this.title, required this.color, this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         centerTitle: true,
//         leading: context.vRouter.historyCanBack()
//             ? BackButton(onPressed: context.vRouter.historyBack)
//             : null,
//         actions: [
//           if (context.vRouter.historyCanForward())
//             Transform.rotate(
//               angle: 3.14,
//               child: BackButton(onPressed: context.vRouter.historyForward),
//             ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: 200,
//               height: 50,
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: color, width: 3),
//                 ),
//                 child: Center(
//                   child: Text('This is your ${title.toLowerCase()}'),
//                 ),
//               ),
//             ),
//             if (child != null) ...[SizedBox(height: 20), child!],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   final String title;
//   final Color color;

//   const HomeScreen({required this.title, required this.color});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int count = 0;

//   @override
//   Widget build(BuildContext context) {
//     return BasicScreen(
//       title: widget.title,
//       color: widget.color,
//       // VNavigationGuard allows you to react to navigation events locally
//       child: VWidgetGuard(
//         // When entering or updating the route, we try to get the count from the history state
//         // This history state will be restored when using historyBack to go back here
//         afterEnter: (context, __, ___) => getCountFromState(context),
//         child: ElevatedButton(
//           style: buttonStyle,
//           onPressed: () {
//             VRouter.of(context).to(
//               context.vRouter.url,
//               isReplacement:
//                   true, // We use replacement to override the history entry
//               historyState: {'count': '${count + 1}'},
//             );
//             setState(() => count++);
//           },
//           child: Text(
//             'Your pressed this button $count times',
//             style: TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }

//   void getCountFromState(BuildContext context) {
//     setState(() =>
//         count = int.parse(VRouter.of(context).historyState['count'] ?? '0'));
//   }

//   final buttonStyle = ButtonStyle(
//     shape: MaterialStateProperty.all(
//       RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18.0),
//       ),
//     ),
//     padding: MaterialStateProperty.all(
//       EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//     ),
//   );
// }
