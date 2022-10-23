
import 'package:flutter/material.dart';

import 'package:clone_dolap/core/base/state/base_state.dart';
import 'package:clone_dolap/core/extension/context_extension.dart';

class AuthenticationField extends StatefulWidget {
  final bool? obscureText;
  final String hintText;
  final Widget? trailing;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final TextEditingController controller;

  const AuthenticationField({
    Key? key,
    this.obscureText,
    required this.hintText,
    this.trailing,
    this.validator,
    required this.controller, 
    this.keyboardType,
  }) : super(key: key);

  @override
  State<AuthenticationField> createState() => _AuthenticationFieldState();
}

class _AuthenticationFieldState extends BaseState<AuthenticationField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      cursorColor: Colors.black87,
      cursorWidth: 1,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.obscureText ?? false,
      decoration: InputDecoration(
        label: Text(widget.hintText),
        contentPadding: EdgeInsets.symmetric(horizontal: context.getDynamicWidth(2)),
        hintStyle: currentThemeData.textTheme.bodyMedium,
        suffix: widget.trailing,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(color: currentThemeData.colorScheme.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(color: Colors.red.shade600, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(color: Colors.red.shade600, width: 1),
        ),
      ),
    );
  }
}



