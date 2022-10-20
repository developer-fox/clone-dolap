
import 'package:clone_dolap/core/constants/enums/locale_keys_enum.dart';
import 'package:clone_dolap/core/init/cache/locale_manager.dart';
import 'package:clone_dolap/view/authenticate/onboard/view/onboard_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'core/constants/app/app_constants.dart';
import 'core/init/language/language_manager.dart';
import 'core/init/navigation/navigation_route.dart';
import 'core/init/navigation/navigation_service.dart';
import 'core/init/theme/app_theme_light.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

 runApp(
    EasyLocalization(
      supportedLocales: LanguageManager.instance.supportedLocales,
      fallbackLocale:  LanguageManager.instance.trLocale,
      path: ApplicationConstants.instance.LANG_ASSET_PATH,
      child: const MyApp())
    );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocaleManager.preferencesInit();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      title: 'Flutter Demo',
      theme: AppThemeLight.instance.theme,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      onGenerateRoute: NavigationRoute.instance.generateRoute,
      navigatorKey: NavigationService.instance.navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isLogined;

  @override
  void initState() {
    // TODO: implement initState
    isLogined =  LocaleManager.instance.getStringValue(PreferencesKeys.x_access_key) != "" ; 
  }


  @override
  Widget build(BuildContext context) {
    if(isLogined){
      //TODO: replace home view
      return OnboardView();
    }
    else{
      return OnboardView();
    }
  }
}
