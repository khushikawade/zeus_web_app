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
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/project_module/create_project/create_project_model.dart';
import 'package:zeus/helper_widget/scroll_behaviour.dart';
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/project_module/create_project/create_project_model.dart';
import 'package:zeus/project_module/project_home/project_home_view_model.dart';
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
  await GetStorage.init();
  setPathUrlStrategy();
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
              onSystemPop: (vRedirector) async {
                if (vRedirector.historyCanBack()) {
                  vRedirector.historyBack();
                } else {
                  print("History not found -----------------------------");
                }
              },
              onPop: ((vRedirector) async {
                vRedirector.pop();
              }),
              debugShowCheckedModeBanner: false,
              mode: VRouterMode.history,
              initialUrl: storage.read("isLogin") == null
                  ? MyRoutes.loginRoute
                  : MyRoutes.homeRoute,
              routes: [
                VPopHandler(
                  onSystemPop: (vRedirector) async {
                    vRedirector.to(MyRoutes.homeRoute);
                  },
                  onPop: (vRedirector) async {
                    vRedirector.pop();
                  },
                  stackedRoutes: [
                    VWidget(
                      path: MyRoutes.homeRoute,
                      widget: MyHomePage1(ProjectHome(), currentIndex: 1),
                    ),
                  ],
                ),
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
                    widget: MyHomePage1(ProjectHome(), currentIndex: 1)),
                VWidget(
                    path: MyRoutes.peopleDetailsRoute,
                    name: MyRoutes.peopleDetailsRoute,
                    widget: Builder(builder: (context) {
                      String peopleId = context.vRouter.queryParameters['id']!;
                      print("Response ------------------ ${peopleId}");
                      return ProfileDetail1(
                        peopleId: peopleId,
                      );
                    })),
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
