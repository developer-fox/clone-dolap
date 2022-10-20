
import 'package:clone_dolap/core/extension/context_extension.dart';
import 'package:flutter/material.dart';

class OnboardButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final String iconPath;
  const OnboardButton({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: context.normalValue, vertical: context.lowValue + 2),
        elevation: 0,
        backgroundColor:  context.currentThemeData.canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: context.currentThemeData.colorScheme.secondary,),
        ),
      ), 
      child: Row(
        children:  [
         SizedBox(
          height: context.getDynamicWidth(6),
          child:  Image.asset(iconPath),
         ),
          const Spacer(),
          Text(title,style: context.currentThemeData.textTheme.button,),
          const Spacer(),
        ],
      ),
    );
  }
}
