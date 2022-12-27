import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vrouter/vrouter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:zeus/clickup_login/webview_page.dart';
import 'package:zeus/helper_widget/custom_search_dropdown.dart';
import 'package:zeus/home_module/home_module_1.dart';
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/project_module/create_project/create_project_model.dart';
import 'package:zeus/helper_widget/scroll_behaviour.dart';
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/project_module/create_project/create_project_model.dart';
import 'package:zeus/project_module/project_home/project_home_view_model.dart';
import 'package:zeus/routers/routers_class.dart';
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

// void main() {
//   runApp(
//     VRouter(
//       debugShowCheckedModeBanner: false, // VRouter acts as a MaterialApp
//       mode: VRouterMode.history, // Remove the '#' from the url
//       // logs: [VLogLevel.info], // Defines which logs to show, info is the default
//       routes: [
//         VWidget(
//           path: '/login',
//           widget: LoginWidget(),
//           stackedRoutes: [
//             ConnectedRoutes(), // Custom VRouteElement
//           ],
//         ),
//         // This redirect every unknown routes to /login
//         VRouteRedirector(
//           redirectTo: '/login',
//           path: r'*',
//         ),
//       ],
//     ),
//   );
// }

// // Extend VRouteElementBuilder to create your own VRouteElement
// class ConnectedRoutes extends VRouteElementBuilder {
//   static final String profile = 'profile';
//   static void toProfile(BuildContext context, String username) =>
//       context.vRouter.to('/$username/$profile');
//   static final String settings = 'settings';
//   static void toSettings(BuildContext context, String username) =>
//       context.vRouter.to('/$username/$settings');
//   static final String add_project = 'add_project';
//   static void toAddProject(BuildContext context, String username) =>
//       context.vRouter.to('/$username/$add_project');
//   @override
//   List<VRouteElement> buildRoutes() {
//     return [
//       VNester.builder(
//         // .builder constructor gives you easy access to VRouter data
//         path:
//             '/:username', // :username is a path parameter and can be any value
//         widgetBuilder: (_, state, child) => MyScaffold(
//           child,
//           currentIndex: state.names.contains(profile)
//               ? 0
//               : state.names.contains(settings)
//                   ? 1
//                   : 2,
//         ),
//         nestedRoutes: [
//           VWidget(
//             path: profile,
//             name: profile,
//             widget: ProfileWidget(),
//           ),
//           VWidget(
//             path: settings,
//             name: settings,
//             widget: SettingsWidget(),
//             // Custom transition
//             buildTransition: (animation, ___, child) {
//               return ScaleTransition(
//                 scale: animation,
//                 child: child,
//               );
//             },
//           ),
//           VWidget(
//             path: add_project,
//             name: add_project,
//             widget: AddScreenWidget(),
//           ),
//         ],
//       ),
//     ];
//   }
// }

// class LoginWidget extends StatefulWidget {
//   @override
//   _LoginWidgetState createState() => _LoginWidgetState();
// }

// class _LoginWidgetState extends State<LoginWidget> {
//   String name = 'bob';
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text('Enter your name to connect: '),
//                 Container(
//                   width: 200,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black),
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: TextFormField(
//                       textAlign: TextAlign.center,
//                       onChanged: (value) => name = value,
//                       initialValue: 'bob',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             // This FAB is shared and shows hero animations working with no issues
//             FloatingActionButton(
//               heroTag: 'FAB',
//               onPressed: () {
//                 setState(() => (_formKey.currentState!.validate())
//                     ? ConnectedRoutes.toProfile(context, name)
//                     : null);
//               },
//               child: Icon(Icons.login),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TestHome extends StatefulWidget {
//   @override
//   _TestHomeState createState() => _TestHomeState();
// }

// class _TestHomeState extends State<TestHome> {
//   String name = 'bob';
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text('Enter your name to connect: '),
//                 Container(
//                   width: 200,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black),
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: TextFormField(
//                       textAlign: TextAlign.center,
//                       onChanged: (value) => name = value,
//                       initialValue: 'bob',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             // This FAB is shared and shows hero animations working with no issues
//             FloatingActionButton(
//               heroTag: 'FAB',
//               onPressed: () {
//                 setState(() => (_formKey.currentState!.validate())
//                     ? ConnectedRoutes.toProfile(context, name)
//                     : null);
//               },
//               child: Icon(Icons.login),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MyScaffold extends StatelessWidget {
//   final Widget child;
//   int currentIndex = 0;
//   MyScaffold(this.child, {required this.currentIndex});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('You are connected'),
//       ),
//       // bottomNavigationBar: BottomNavigationBar(
//       //   currentIndex: currentIndex,
//       //   items: [
//       //     BottomNavigationBarItem(
//       //         icon: Icon(Icons.person_outline), label: 'Profile'),
//       //     BottomNavigationBarItem(
//       //         icon: Icon(Icons.info_outline), label: 'Info'),
//       //   ],
//       //   onTap: (int index) {
//       //     // We can access this username via the path parameters
//       //     final username = VRouter.of(context).pathParameters['username']!;
//       //     if (index == 0) {
//       //       ConnectedRoutes.toProfile(context, username);
//       //     } else {
//       //       ConnectedRoutes.toSettings(context, username);
//       //     }
//       //   },
//       // ),
//       //body: child,
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           NavigationRail(
//             selectedIndex: currentIndex,
//             extended: false,
//             onDestinationSelected: ((index) {
//               print("Index value -------------------- ${index}");
//               currentIndex = index;
//               print("currentIndex value -------------------- ${currentIndex}");
//               final username = VRouter.of(context).pathParameters['username']!;
//               if (currentIndex == 0) {
//                 ConnectedRoutes.toProfile(context, username);
//               } else if (currentIndex == 1) {
//                 ConnectedRoutes.toSettings(context, username);
//               } else if (currentIndex == 2) {
//                 ConnectedRoutes.toAddProject(context, username);
//               }
//             }),
//             destinations: [
//               NavigationRailDestination(
//                   icon: Icon(Icons.person), label: Text("Profile")),
//               NavigationRailDestination(
//                   icon: Icon(Icons.settings), label: Text("Settings")),
//               NavigationRailDestination(
//                   icon: Icon(Icons.add), label: Text("Add People")),
//             ],
//           ),
//           currentIndex == 0
//               ? ProfileWidget()
//               : currentIndex == 1
//                   ? SettingsWidget()
//                   : AddScreenWidget(),
//         ],
//       ),
//       // This FAB is shared with login and shows hero animations working with no issues
//       floatingActionButton: FloatingActionButton(
//         heroTag: 'FAB',
//         onPressed: () => VRouter.of(context).to('/login'),
//         child: Icon(Icons.logout),
//       ),
//     );
//   }
// }

// class ProfileWidget extends StatefulWidget {
//   @override
//   _ProfileWidgetState createState() => _ProfileWidgetState();
// }

// class _ProfileWidgetState extends State<ProfileWidget> {
//   int count = 0;
//   @override
//   Widget build(BuildContext context) {
//     // VNavigationGuard allows you to react to navigation events locally
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextButton(
//               onPressed: () {
//                 VRouter.of(context).to(
//                   context.vRouter.url,
//                   isReplacement: true,
//                   historyState: {'count': '${count + 1}'},
//                 );
//                 setState(() => count++);
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   color: Colors.blueAccent,
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//                 child: Text(
//                   'Your pressed this button $count times',
//                   style: buttonTextStyle,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'This number is saved in the history state so if you are on the web leave this page and hit the back button to see this number restored!',
//               style: textStyle,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void getCountFromState(BuildContext context) {
//     setState(() {
//       count = (VRouter.of(context).historyState['count'] == null)
//           ? 0
//           : int.tryParse(VRouter.of(context).historyState['count'] ?? '') ?? 0;
//     });
//   }
// }

// class SettingsWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Container(
//         color: Colors.yellow,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Did you see the custom animation when coming here?',
//                 style: textStyle.copyWith(fontSize: textStyle.fontSize! + 2),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AddScreenWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Container(
//         color: Colors.green,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Welcome to the green screen',
//                 style: textStyle.copyWith(fontSize: textStyle.fontSize! + 2),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// final textStyle = TextStyle(color: Colors.black, fontSize: 16);
// final buttonTextStyle = textStyle.copyWith(color: Colors.white);

void main() async {
  await GetStorage.init();
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
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProjectHomeViewModel()),
            ChangeNotifierProvider(create: (_) => PeopleHomeViewModel()),
            ChangeNotifierProvider(create: (_) => ProjectHomeViewModel()),
            ChangeNotifierProvider(create: (_) => TagDetail()),
            ChangeNotifierProvider(create: (_) => CreateProjectModel())
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: FlutterSmartDialog.init(),
            home: VRouter(
              debugShowCheckedModeBanner: false,
              mode: VRouterMode.history,
              initialUrl: storage.read("isLogin") == null
                  ? MyRoutes.loginRoute
                  : MyRoutes.homeRoute,
              routes: [
                VWidget(
                  path: MyRoutes.loginRoute,
                  widget: LoginScreen(
                    onSubmit: (value) {},
                  ),
                  stackedRoutes: [
                    ConnectedRoutes(),
                  ],
                ),
                VWidget(
                    path: MyRoutes.homeRoute,
                
                    widget: MyHomePage1( ProjectHome(), currentIndex: 1)),
                VRouteRedirector(
                  redirectTo: MyRoutes.loginRoute,
                  path: r'*',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String name = 'bob';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Enter your name to connect: '),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      onChanged: (value) => name = value,
                      initialValue: 'bob',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            // This FAB is shared and shows hero animations working with no issues
            FloatingActionButton(
              heroTag: 'FAB',
              onPressed: () {
                // setState(() => (_formKey.currentState!.validate())
                //     ? ConnectedRoutes.toProfile(context, name)
                //     : null);
              },
              child: Icon(Icons.login),
            )
          ],
        ),
      ),
    );
  }
}
