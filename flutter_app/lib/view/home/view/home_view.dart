
import 'package:clone_dolap/core/base/view/base_view.dart';
import 'package:clone_dolap/core/constants/enums/locale_keys_enum.dart';
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
        );  
      },
    );
  }
}