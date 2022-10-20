
import 'package:clone_dolap/view/authenticate/signup/view/signup_view.dart';
import 'package:clone_dolap/view/home/view/home_view.dart';
import 'package:flutter/material.dart';

import '../../../view/architecture_testing/test_main.dart';
import '../../../view/architecture_testing/test_view.dart';
import '../../../view/authenticate/login/view/login_view.dart';
import '../../constants/navigation/navigation_constants.dart';

class NavigationRoute {
  static NavigationRoute? _instance = NavigationRoute._init();
  static NavigationRoute get instance {
    _instance ??= NavigationRoute._init();
    return _instance!;
  }

  NavigationRoute._init();

  // bu method icerisinde navigation islemleri yapilir.
  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      
      // gidilmesi gereken her bir sayfa bu sekilde case ile tanimlanir. 
      case NavigationConstants.TEST_VIEW:
        // normalNavigate() icerisinde gidilmesi gereken view parametre olarak verilir. eger disaridan veri modeli aliyorsa, args.arguments as <object_class> seklinde bu model verilir.
        return normalNavigate(TestView(string_content: args.arguments as Example,));
      case NavigationConstants.TEST_MAIN_VIEW:
      return normalNavigate(const MainView());
      case NavigationConstants.SIGNUP_VIEW:
      return normalNavigate(const SignupView());
      case NavigationConstants.LOGIN_VIEW:
      return normalNavigate(const LoginView());
      case NavigationConstants.HOME_VIEW:
      return normalNavigate(const HomeView());
      default:
        return normalNavigate(emptyScaffold);
    }
  }
}

Scaffold get emptyScaffold {
  return const Scaffold(
    body: Center(
      child: Text("core: navigation route default case"),
    ),
  );
}

MaterialPageRoute normalNavigate(Widget widget) {
  return MaterialPageRoute(builder: ((context) => widget));
}