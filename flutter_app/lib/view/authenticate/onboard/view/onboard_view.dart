
import 'package:clone_dolap/core/constants/navigation/navigation_constants.dart';
import 'package:clone_dolap/core/extension/context_extension.dart';
import 'package:clone_dolap/core/extension/string_extension.dart';
import 'package:clone_dolap/product/components/button/onboard_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/base/state/base_state.dart';
import '../../../../core/base/view/base_view.dart';
import '../../../../core/init/language/locale_keys.g.dart';
import '../../../../core/init/navigation/navigation_service.dart';

class OnboardView extends StatefulWidget {
  OnboardView({Key? key}) : super(key: key);

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends BaseState<OnboardView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      onModelReady: (){},
      onModelDispose: (){},
      onPageBuilder: (context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions:  [
              // cross icon button
              IconButton(
                onPressed: (){}, 
                icon: const FaIcon(FontAwesomeIcons.x, size: 20, color: Colors.black87),
                splashRadius: 24,
                ),
            ]
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.getDynamicWidth(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // top background Image
                Padding(
                  padding: EdgeInsets.only(bottom: context.normalValue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.getDynamicWidth(64),
                        child: Image.asset("asset/logo/onboard_logo.png",)),
                    ],
                  ),
                ),
                // login with email button
                OnboardButton(onPressed: ()=> NavigationService.instance.navigateToPage(path: NavigationConstants.LOGIN_VIEW), title: LocaleKeys.onBoard_loginWithEmailButtonTitle.locale , iconPath: "asset/logo/onboard_email_icon.png"),
                // login with trendyol button
                Padding(
                  padding: context.paddingNormalVertical,
                  child: OnboardButton(onPressed: (){}, title: LocaleKeys.onBoard_loginWithTrendyolButtonTitle.locale , iconPath: "asset/logo/trendyol_favicon.png"),
                ),
                // login with facebook button
                OnboardButton(onPressed: (){}, title: LocaleKeys.onBoard_loginWithFaceboolButtonTitle.locale , iconPath: "asset/logo/onboard_facebook_icon.png"),
                // signup text & textButton
                Padding(
                  padding: EdgeInsets.only(top: context.mediumValue),
                  child: RichText(
                    text: TextSpan(style: context.currentThemeData.textTheme.labelMedium,text: LocaleKeys.onBoard_signupInfoText.locale, children: [
                      TextSpan(text: LocaleKeys.onBoard_signupTextButton.locale, style: context.currentThemeData.textTheme.labelMedium?.copyWith(color: context.currentThemeData.colorScheme.primary, fontWeight: FontWeight.bold,), recognizer: TapGestureRecognizer()..onTap= ()=> NavigationService.instance.navigateToPage(path: NavigationConstants.SIGNUP_VIEW)),
                    ]),
                    ),
                ),
              ],
            ),
            
          ),
        );
      },
    );
  }
}

