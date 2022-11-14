
import 'package:clone_dolap/core/base/view/base_view.dart';
import 'package:clone_dolap/core/constants/enums/locale_keys_enum.dart';
import 'package:clone_dolap/core/extension/context_extension.dart';
import 'package:clone_dolap/core/init/cache/locale_manager.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      onPageBuilder:(context) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("on home view"),
                Text(LocaleManager.instance.getStringValue(PreferencesKeys.x_access_key)),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: context.currentThemeData.canvasColor,
            elevation: 3,
            height: context.getDynamicHeight(6.4),

            destinations: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_outlined,size: 26 ,color: context.currentThemeData.colorScheme.primary),
                Text("anasayfa", style: context.currentThemeData.textTheme.caption!.copyWith(color: context.currentThemeData.colorScheme.primary)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_outlined,size: 26, color: context.currentThemeData.colorScheme.secondary),
                Text("anasayfa", style: context.currentThemeData.textTheme.caption!.copyWith(color: context.currentThemeData.colorScheme.secondary)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_box_outlined,size: 26, color: context.currentThemeData.colorScheme.secondary),
                Text("anasayfa", style: context.currentThemeData.textTheme.caption!.copyWith(color: context.currentThemeData.colorScheme.secondary)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,size: 26, color: context.currentThemeData.colorScheme.secondary),
                Text("anasayfa", style: context.currentThemeData.textTheme.caption!.copyWith(color: context.currentThemeData.colorScheme.secondary)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline_rounded,size: 26, color: context.currentThemeData.colorScheme.secondary),
                Text("anasayfa", style: context.currentThemeData.textTheme.caption!.copyWith(color: context.currentThemeData.colorScheme.secondary)),
              ],
            ),
          ],),
        );  
      },
    );
  }
}