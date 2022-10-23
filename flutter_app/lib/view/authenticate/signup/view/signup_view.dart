
import 'package:clone_dolap/core/constants/enums/authentication_button_types_enum.dart';
import 'package:clone_dolap/core/extension/context_extension.dart';
import 'package:clone_dolap/core/extension/string_extension.dart';
import 'package:clone_dolap/core/init/language/locale_keys.g.dart';
import 'package:clone_dolap/product/components/button/authentication_button.dart';
import 'package:clone_dolap/product/components/divider/or_divider.dart';
import 'package:clone_dolap/product/components/field/authentication_field.dart';
import 'package:clone_dolap/product/components/field/authentication_password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/base/state/base_state.dart';
import '../../../../core/base/view/base_view.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/init/navigation/navigation_service.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends BaseState<SignupView> {

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool electronicNotificationCheckboxValue = false;
  late double formHeight;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      onModelReady: (baseContext) {
        formHeight = context.getDynamicHeight(30);
      },
      onPageBuilder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.signup_appbarTitle.locale),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: context.paddingNormal,
              child: Column(
                children: [
                  // fields
                  Form(
                    key: formKey,
                    child: SizedBox(
                      height: formHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // username field
                          AuthenticationField(
                            hintText: LocaleKeys.signup_usernameFieldHintText.locale, controller: usernameController, validator: (value) {
                              if(value == null || value.isEmpty){
                                return LocaleKeys.signup_nonNullableFieldErrorText.locale;
                              }
                              return null;
                            },),
                          // email field
                          AuthenticationField(hintText: LocaleKeys.signup_emailFieldHintText.locale, controller: emailController, validator: (value) {
                            if(value == null || value.isEmpty){
                              return LocaleKeys.signup_nonNullableFieldErrorText.locale;
                            }
                            else if(!value.isValidEmails){
                              return LocaleKeys.signup_emailIsNotEmail.locale;
                            }
                            else{
                              return null;
                            }
                          },),
                          // phone number field
                          AuthenticationField(
                            hintText: LocaleKeys.signup_phoneFieldHintText.locale, 
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                            validator:(value) {
                              if(value == null || value.isEmpty){
                                return LocaleKeys.signup_nonNullableFieldErrorText.locale;
                              }
                              else if(!value.isValidatePhoneNumber){
                                return LocaleKeys.signup_phoneNumberIsNotPhoneNumber.locale;
                              }
                              else{
                                return null;
                              }
                            },
                            ),
                          // password field
                          AuthenticationPasswordField(
                            controller: passwordController,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // electronic notification
                  Padding(
                    padding: context.paddingNormalVertical,
                    child: Row(
                      children: [
                        Checkbox(value: electronicNotificationCheckboxValue, 
                          onChanged:(value) {
                            setState(() {
                              electronicNotificationCheckboxValue = value ?? false;
                            });
                          },
                          fillColor: MaterialStateProperty.resolveWith((states) => currentThemeData.colorScheme.primary),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        // info text
                        SizedBox(
                          width: context.getDynamicWidth(80),
                          child: RichText(
                            text: TextSpan(
                              text: LocaleKeys.signup_discountNotificationsCheckBoxPart1.locale,
                              style: currentThemeData.textTheme.bodySmall,
                              children: [
                                TextSpan(
                                  text: LocaleKeys.signup_discountNotificationsCheckBoxPart2.locale,
                                  style: currentThemeData.textTheme.bodySmall!.copyWith(color: currentThemeData.colorScheme.primary),
                                  recognizer: TapGestureRecognizer()..onTap = (){
                                  }
                                ),
                                TextSpan(
                                  text: LocaleKeys.signup_discountNotificationsCheckBoxPart3.locale,
                                  style: currentThemeData.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // signup information
                  RichText(
                    text: TextSpan(
                      text: LocaleKeys.signup_signupConditionsTextPart1.locale,
                      style: currentThemeData.textTheme.bodySmall!.copyWith(fontSize: 9),
                      children: [
                        TextSpan(
                          text: LocaleKeys.signup_signupConditionsTextPart2_withGesture.locale,
                          style: currentThemeData.textTheme.bodySmall!.copyWith(fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: LocaleKeys.signup_signupConditionsTextPart3.locale,
                          style: currentThemeData.textTheme.bodySmall!.copyWith(fontSize: 9),
                        ),
                        TextSpan(
                          text: LocaleKeys.signup_signupConditionsTextPart4_withGesture.locale,
                          style: currentThemeData.textTheme.bodySmall!.copyWith(fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: LocaleKeys.signup_signupConditionsTextPart5.locale,
                          style: currentThemeData.textTheme.bodySmall!.copyWith(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                  // signup button
                  Padding(
                    padding: EdgeInsets.only(top: context.normalValue, bottom: context.lowValue),
                    child: AuthenticationButton(
                      buttonType: AuthenticationButtonType.withCustomBackground, 
                      buttonText: LocaleKeys.signup_signupButtonTitle.locale,
                      onPressed: () {
                        bool validation = formKey.currentState!.validate();
                        if(validation){
                          //* signup request
                        }
                        else{
                          setState(() {
                            formHeight = context.getDynamicHeight(40);
                          });
                        }
                      }, 
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: context.lowValue),
                    child: const OrDivider(),
                  ),
                  // login with trendyol
                  AuthenticationButton(
                    buttonType: AuthenticationButtonType.withCustomBackground, 
                    buttonText: LocaleKeys.login_loginWithTrendyolButtonTitle.locale,
                    backgroundColor: const Color.fromRGBO(255, 103, 32, 1),
                    buttonTitleIcon: Image.asset("asset/logo/trendyol_favicon.png", color: Colors.white, width: context.getDynamicWidth(4.2),),
                    onPressed: (){},
                  ),
                  // login with facebook
                  Padding(
                    padding: EdgeInsets.only(top: context.lowValue),
                    child: AuthenticationButton(
                      buttonType: AuthenticationButtonType.withClearBackground,
                      buttonText: LocaleKeys.login_loginWithFaceboolButtonTitle.locale,
                      buttonTitleIcon: Image.asset("asset/logo/onboard_facebook_icon.png", width: context.getDynamicWidth(5),), 
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context, 
                          builder:(context) {
                            return WillPopScope(
                              onWillPop: () => Future.value(false),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LoadingAnimationWidget.beat(color: context.currentThemeData.colorScheme.primary, size: context.getDynamicWidth(12)),
                                    ElevatedButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("asdasd"),
                                      )
                                  ],
                                ),
                              ),
                            );
                          },);
                      },
                      backgroundColor: Colors.blue.shade900,
                    ),
                  ),
                  // login textButton
                  Padding(
                    padding: context.paddingNormalVertical,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocaleKeys.signup_loginInfoText.locale, style: context.currentThemeData.textTheme.bodyMedium),
                        GestureDetector(
                          onTap: () {
                            NavigationService.instance.navigateToPage(path: NavigationConstants.LOGIN_VIEW);
                          },
                          child: Text(LocaleKeys.signup_loginTextButton.locale, style: context.currentThemeData.textTheme.bodyMedium!.copyWith(color: currentThemeData.colorScheme.primary, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ],
              ),
              ),
          ),
        );
      },
    );
  }
}


