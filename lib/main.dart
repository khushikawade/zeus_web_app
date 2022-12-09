import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:zeus/navigator_tabs/idle/data/DataClass.dart';
import 'package:zeus/navigator_tabs/people_idle/data/getdata_provider.dart';
import 'package:zeus/people_profile/editpage/edit_profile_model.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/utility/constant.dart';
import 'login_screen/login.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_strategy/url_strategy.dart';
import 'navigation/navigation.dart';
import 'package:provider/provider.dart';
import 'navigation/tag_model/tag_user.dart';
import 'navigator_tabs/idle/data/project_detail_data/ProjectDetailData.dart';

void main() async {
  await GetStorage.init();
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // bool?  isLogin;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DataIdelClass()),
          ChangeNotifierProvider(create: (_) => PeopleIdelClass()),
          ChangeNotifierProvider(create: (_) => ProjectDetail()),
          ChangeNotifierProvider(create: (_) => TagDetail()),
          ChangeNotifierProvider(create: (_) => EditPageModel())
        ],
        child:
            // MaterialApp(
            //   home: Example(),
            //   navigatorObservers: [FlutterSmartDialog.observer],
            //   builder: FlutterSmartDialog.init(),
            // )
            MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: FlutterSmartDialog.init(),
          home: MaterialApp(
            scrollBehavior: MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown
              },
            ),
            builder: (context, child) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, child!),
              maxWidth: 2000,
              minWidth: 1200,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(450, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                const ResponsiveBreakpoint.resize(1440, name: DESKTOP),
                const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
            ),
            home: //Rconst NewPhase(),
                storage.read(isLogin) == null
                    ? LoginScreen(
                        onSubmit: (String value) {},
                      )
                    : MyHomePage(
                        onSubmit: (String value) {},
                        adOnSubmit: (String value) {},
                      ),

            navigatorObservers: [FlutterSmartDialog.observer],
            // here
            // builder: FlutterSmartDialog.init(),
            onGenerateRoute: generateRoute,
            debugShowCheckedModeBanner: false,

            // onGenerateRoute: (RouteSettings settings) {
            //   return Routes.fadeThrough(settings, (context) {
            //     // switch (settings.name) {
            //     //   case Routes.home:
            //     //     return const ListPage();
            //     //   case Routes.post:
            //     //     return const PostPage();
            //     //   case Routes.style:
            //     //     return const TypographyPage();
            //     //   default:
            //     //     return const SizedBox.shrink();
            //     // }
            //   });
            // },
          ),
        ));
  }
  // return MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider(create: (_) => DataIdelClass()),
  //     ChangeNotifierProvider(create: (_) => PeopleIdelClass()),
  //     ChangeNotifierProvider(create: (_) => ProjectDetail()),
  //     ChangeNotifierProvider(create: (_) => TagDetail()),
  //     ChangeNotifierProvider(create: (_) => EditPageModel())
  //   ],
  //   child: MaterialApp(
  //     scrollBehavior: MyCustomScrollBehavior(),
  //     home: storage.read(isLogin) == null
  //         ? LoginScreen(
  //             onSubmit: (String value) {},
  //           )
  //         : MyHomePage(
  //             onSubmit: (String value) {},
  //             adOnSubmit: (String value) {},
  //           ),
  //     onGenerateRoute: generateRoute,
  //     debugShowCheckedModeBanner: false,
  //   ),
  // );
}

// import 'package:responsive_framework/responsive_framework.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => DataIdelClass()),
//           ChangeNotifierProvider(create: (_) => PeopleIdelClass()),
//           ChangeNotifierProvider(create: (_) => ProjectDetail()),
//           ChangeNotifierProvider(create: (_) => TagDetail()),
//           ChangeNotifierProvider(create: (_) => EditPageModel())
//         ],
//         child: MaterialApp(
//           builder: (context, child) => ResponsiveWrapper.builder(
//               BouncingScrollWrapper.builder(context, child!),
//               maxWidth: 2000,
//               minWidth: 1200,
//               defaultScale: true,
//               breakpoints: [
//                 const ResponsiveBreakpoint.resize(450, name: MOBILE),
//                 const ResponsiveBreakpoint.autoScale(800, name: TABLET),
//                 const ResponsiveBreakpoint.autoScale(1200, name: TABLET),
//                 const ResponsiveBreakpoint.resize(1440, name: DESKTOP),
//                 const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
//               ],
//               background: Container(color: const Color(0xFFF5F5F5))),
//           home: storage.read(isLogin) == null
//               ? LoginScreen(
//                   onSubmit: (String value) {},
//                 )
//               : MyHomePage(
//                   onSubmit: (String value) {},
//                   adOnSubmit: (String value) {},
//                 ),
//           onGenerateRoute: generateRoute,
//           debugShowCheckedModeBanner: false,
//           // onGenerateRoute: (RouteSettings settings) {
//           //   return Routes.fadeThrough(settings, (context) {
//           //     // switch (settings.name) {
//           //     //   case Routes.home:
//           //     //     return const ListPage();
//           //     //   case Routes.post:
//           //     //     return const PostPage();
//           //     //   case Routes.style:
//           //     //     return const TypographyPage();
//           //     //   default:
//           //     //     return const SizedBox.shrink();
//           //     // }
//           //   });
//           // },
//         ));
//   }
// }
