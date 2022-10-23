
import 'package:flutter/material.dart';
import 'package:clone_dolap/core/extension/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/base/state/base_state.dart';
import '../../../core/init/language/locale_keys.g.dart';
import 'authentication_field.dart';

class AuthenticationPasswordField extends StatefulWidget {
  final TextEditingController controller;
  const AuthenticationPasswordField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<AuthenticationPasswordField> createState() => _AuthenticationPasswordFieldState();
}

class _AuthenticationPasswordFieldState extends BaseState<AuthenticationPasswordField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationPasswordFieldCubit,bool>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return AuthenticationField(
          hintText: LocaleKeys.login_passwordFieldHintText.locale, 
          obscureText: state,
          controller: widget.controller,
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
          trailing: state ? 
            GestureDetector(
              onTap: () {  
                if(state){
                  context.read<AuthenticationPasswordFieldCubit>().changeObscuring(false);
                }
              },
              child: FaIcon(FontAwesomeIcons.eye, color: currentThemeData.colorScheme.secondary, size: 16),
            )
            :
            GestureDetector(
              onTap: () {  
                if(!state){
                  context.read<AuthenticationPasswordFieldCubit>().changeObscuring(true);
                }
              },
              child: FaIcon(FontAwesomeIcons.eyeSlash, color: currentThemeData.colorScheme.secondary, size: 16),
            )
        );
      },
    );
  }
}

class AuthenticationPasswordFieldCubit extends Cubit<bool>{
  AuthenticationPasswordFieldCubit():super(false);

  void changeObscuring(bool newValue){
    emit(newValue);
  }

}
