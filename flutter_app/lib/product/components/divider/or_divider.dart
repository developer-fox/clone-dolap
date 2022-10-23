
import 'package:clone_dolap/core/extension/context_extension.dart';
import 'package:clone_dolap/core/extension/string_extension.dart';
import 'package:flutter/material.dart';

import '../../../core/init/language/locale_keys.g.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Divider(
          color: context.currentThemeData.colorScheme.secondary.withOpacity(.4),
          height: context.getDynamicWidth(6) + 4,
          thickness: .6,
        ),
        Center(
          child: Container(
            color: context.currentThemeData.canvasColor,
            width: context.getDynamicWidth(12),
            height: context.getDynamicWidth(6),
            child: Center(child: Text(LocaleKeys.login_or.locale, style: context.currentThemeData.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w100, color: context.currentThemeData.colorScheme.secondary))),
          ),
        ),
      ],
    );
  }
}

