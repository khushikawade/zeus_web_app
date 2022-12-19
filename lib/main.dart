import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:zeus/helper_widget/test_view.dart';
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/project_module/create_project/create_project_model.dart';
import 'package:zeus/project_module/project_detail/project_home_view_model.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/services/response_model/tag_model/tag_user.dart';
import 'package:zeus/user_module/login_screen/login.dart';
import 'package:zeus/utility/constant.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_strategy/url_strategy.dart';
import 'home_module/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  await GetStorage.init();
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProjectHomeViewModel()),
          ChangeNotifierProvider(create: (_) => PeopleHomeViewModel()),
          ChangeNotifierProvider(create: (_) => ProjectHomeViewModel()),
          ChangeNotifierProvider(create: (_) => TagDetail()),
          ChangeNotifierProvider(create: (_) => CreateProjectModel())
        ],
        child: ScreenUtilInit(
          designSize: const Size(1366, 758),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
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
              //home:
              //MyHomePageDropDown(),
              home: storage.read(isLogin) == null
                  ? LoginScreen(
                      onSubmit: (String value) {},
                    )
                  : MyHomePage(
                      onSubmit: (String value) {},
                      adOnSubmit: (String value) {},
                    ),
              navigatorObservers: [FlutterSmartDialog.observer],
              onGenerateRoute: generateRoute,
              debugShowCheckedModeBanner: false,
            ),
          ),
        ));
  }
}
