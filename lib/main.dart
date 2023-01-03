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
          child: VRouter(
            debugShowCheckedModeBanner: false,
            builder: FlutterSmartDialog.init(),
            mode: VRouterMode.history,
            initialUrl: storage.read("isLogin") == null
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
                    currentIndex: 1), // Child is the widget from nestedRoutes
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
                  VWidget(path: RouteConstants.four, widget: FourthView()),
                  VWidget(path: RouteConstants.five, widget: FifthView()),
                  VWidget(path: RouteConstants.six, widget: SixView()),
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
  }
}
