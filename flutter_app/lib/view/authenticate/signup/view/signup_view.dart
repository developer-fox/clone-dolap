
import 'package:clone_dolap/core/base/state/base_state.dart';
import 'package:clone_dolap/core/constants/enums/locale_keys_enum.dart';
import 'package:clone_dolap/core/extension/string_extension.dart';
import 'package:clone_dolap/core/init/cache/locale_manager.dart';
import 'package:clone_dolap/core/init/language/locale_keys.g.dart';
import 'package:flutter/material.dart';

import '../../../../core/base/view/base_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends BaseState<SignupView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      onModelReady: () {
        if(LocaleManager.instance.getStringValue(PreferencesKeys.x_access_key) !=""){
          throw Exception("an user logined");
        }
      },
      onModelDispose: (){},
      onPageBuilder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.signup_appbarTitle.locale),
          ),
          body: Container(),
        );
      },
    );
  }
}
