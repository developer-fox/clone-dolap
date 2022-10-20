
import 'package:clone_dolap/core/base/state/base_state.dart';
import 'package:clone_dolap/core/base/view/base_view.dart';
import 'package:clone_dolap/core/constants/enums/authentication_button_types_enum.dart';
import 'package:clone_dolap/core/extension/context_extension.dart';
import 'package:clone_dolap/core/extension/string_extension.dart';
import 'package:clone_dolap/core/init/language/locale_keys.g.dart';
import 'package:clone_dolap/core/services/local_service.dart';
import 'package:clone_dolap/core/services/request_service.dart';
import 'package:clone_dolap/product/components/button/authentication_button.dart';
import 'package:clone_dolap/product/components/dialog/login_invalid_informations_dialog.dart';
import 'package:clone_dolap/product/components/divider/or_divider.dart';
import 'package:clone_dolap/product/components/field/authentication_field.dart';
import 'package:clone_dolap/view/authenticate/login/model/login_email_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/base/model/base_error.dart';
import '../../../../core/base/model/base_model.dart';
import '../../../../core/constants/enums/response_error_types_enum.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/init/navigation/navigation_service.dart';
import '../model/login_username_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends BaseState<LoginView> {
  bool passwordFieldObscuring = true;
  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BaseView(
      onModelReady: (){},
      onModelDispose: (){},
      onPageBuilder: (context) {
        return Scaffold(
          appBar: AppBar(title: Text(LocaleKeys.login_appbarTitle.locale),),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                        width: context.getDynamicWidth(52),
                        child: Image.asset("asset/logo/onboard_logo.png",)),
                    ],
                  ),
                ),
                Padding(
                  padding: context.paddingNormalHorizontal,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                          // username || email field
                          AuthenticationField(
                            hintText: LocaleKeys.login_usernameFieldHintText.locale,
                            controller: emailFieldController,
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                return LocaleKeys.login_usernameFieldErrorText.locale;
                              }
                              else{
                                return null;
                              }
                            },
                          ),
                          // password field
                          Padding(
                            padding: EdgeInsets.only(top: context.mediumValue -10),
                            child: AuthenticationField(
                              hintText: LocaleKeys.login_passwordFieldHintText.locale, 
                              obscureText: passwordFieldObscuring,
                              controller: passwordFieldController,
                              validator: (value) {
                              if(value == null || value.isEmpty){
                                return LocaleKeys.login_passwordFieldErrorText.locale;
                              }
                              else if(!value.isStrongPassword){
                                return LocaleKeys.login_passwordWeakErrorText.locale;
                              }
                              else{
                                return null;
                              }
                              },
                              trailing: passwordFieldObscuring ? 
                                GestureDetector(
                                  onTap: () {  
                                    if(passwordFieldObscuring){
                                      setState(() {
                                        passwordFieldObscuring = false;
                                      });
                                    }
                                  },
                                  child: FaIcon(FontAwesomeIcons.eye, color: currentThemeData.colorScheme.secondary, size: 16),
                                )
                                :
                                GestureDetector(
                                  onTap: () {  
                                    if(!passwordFieldObscuring){
                                      setState(() {
                                        passwordFieldObscuring = true;
                                      });
                                    }
                                  },
                                  child: FaIcon(FontAwesomeIcons.eyeSlash, color: currentThemeData.colorScheme.secondary, size: 16),
                                )
                            ),
                          ),
                          ],
                        ),
                      ),
                      // forgot password button
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: (){}, 
                          child: Text(LocaleKeys.login_forgotPasswordButtonText.locale, style: context.currentThemeData.textTheme.caption?.copyWith(color: currentThemeData.colorScheme.primary, fontWeight: FontWeight.bold)), 
                        ),
                      ),
                      // login button
                      AuthenticationButton(
                        buttonType: AuthenticationButtonType.withCustomBackground, 
                        buttonText: LocaleKeys.login_loginButtonText.locale, 
                        onPressed: () async{
                          bool validation = _formKey.currentState!.validate();
                          if(validation){
                            Object? result;
                            if(emailFieldController.value.text.trim().isValidEmails){
                              result = await RequestService.instance.loginWithEmailRequest(emailFieldController.text.trim(), passwordFieldController.text);
                            }
                            else{
                              result = await RequestService.instance.loginWithUsernameRequest(emailFieldController.value.text, passwordFieldController.text);
                            }

                            if(result is BaseModel){
                              Map<bool,void Function()> ol = {
                                true:() async{
                                  LocalService.instance.saveLoginedUserTokensFromLocaleWithEmailRequest(result as LoginWithEmailRequestModel);
                                },
                                false: () async{
                                  LocalService.instance.saveLoginedUserTokensFromLocaleWithUsernameRequest(result as LoginWithUsernameRequestModel);
                                } 
                              };
                              ol[result is LoginWithEmailRequestModel]!();
                              NavigationService.instance.navigateToPageClear(path: NavigationConstants.HOME_VIEW);
                            }
                            else if(result is BaseError && result.errorType == ResponseErrorTypesEnum.invalidValue){
                              showDialog(
                                context: context, 
                                builder:(context) {
                                  return const LoginInvalidInformationsDialog();
                                },
                              );
                            }

                          }
                        }
                      ),
                      // or divider
                      Padding(
                        padding: context.paddingLowVertical,
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
                          onPressed: () {},
                          backgroundColor: Colors.blue.shade900,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: context.mediumValue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(LocaleKeys.login_signupInfoText.locale, style: context.currentThemeData.textTheme.titleSmall),
                            GestureDetector(
                              onTap: () => NavigationService.instance.navigateToPage(path: NavigationConstants.SIGNUP_VIEW),
                              child: Text(LocaleKeys.login_signupTextButton.locale,style: context.currentThemeData.textTheme.titleSmall?.copyWith(color: currentThemeData.colorScheme.primary))
                            ),
                          ],
                        ),
                      ),
                    ],
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