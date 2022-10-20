

import 'package:clone_dolap/core/extension/context_extension.dart';
import 'package:flutter/material.dart';

import 'package:clone_dolap/core/constants/enums/authentication_button_types_enum.dart';

class AuthenticationButton extends StatefulWidget {
  final AuthenticationButtonType buttonType;
  final String buttonText;
  final Widget? buttonTitleIcon;
  final void Function() onPressed;
  final Color? backgroundColor;
  const AuthenticationButton({
    Key? key,
    required this.buttonType,
    required this.buttonText,
    this.buttonTitleIcon,
    required this.onPressed,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<AuthenticationButton> createState() => _AuthenticationButtonState();
}

class _AuthenticationButtonState extends State<AuthenticationButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: widget.buttonType == AuthenticationButtonType.withClearBackground ? context.currentThemeData.canvasColor : widget.backgroundColor,
        side: widget.buttonType == AuthenticationButtonType.withCustomBackground ? 
        null
        : 
        BorderSide(
          width: 1,
          color: widget.backgroundColor ?? context.currentThemeData.colorScheme.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: context.lowValue + 3),
      ),
      child: (){
        switch (widget.buttonType) {
          case AuthenticationButtonType.withClearBackground:
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.buttonTitleIcon ?? const SizedBox(),
                Padding(
                  padding: EdgeInsets.only(left: widget.buttonTitleIcon == null ? 0: context.lowValue + 4),
                  child: Text(widget.buttonText, style: context.currentThemeData.textTheme.titleMedium?.copyWith(color: widget.backgroundColor)),
                ),
              ],
            );
          case AuthenticationButtonType.withCustomBackground:
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.buttonTitleIcon ?? const SizedBox(),
                Padding(
                  padding: EdgeInsets.only(left: widget.buttonTitleIcon == null ? 0: context.lowValue + 4),
                  child: Text(widget.buttonText, style: context.currentThemeData.textTheme.titleMedium?.copyWith(color: context.currentThemeData.colorScheme.onPrimary)),
                ),
              ],
            );
          default:
          return Container();
        }
      }(),
    );
  }
}
