
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//? AppThemeLight.instance.<method_name> 
class AppThemeLight{

  static AppThemeLight? _instance =  AppThemeLight._init();
  static AppThemeLight get instance {
    _instance ??= AppThemeLight._init();
    return _instance!;
  }

  AppThemeLight._init();

  // uygulamada kullanilacak renkler bu sekilde belirtilmistir.
  //? AppThemeLight.instance.theme.ColorScheme.<attribute_name>
  ThemeData get theme => ThemeData(
    canvasColor: Colors.white,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color.fromRGBO(96, 212, 175,1),
      onPrimary: Colors.white, 
      secondary: Colors.grey.shade400, 
      onSecondary: Colors.black,
      error: const Color.fromRGBO(255, 51, 101, 1), 
      onError: Colors.black, 
      background: Colors.grey, 
      onBackground: Colors.black, 
      surface: Colors.lightGreen,
      onSurface: Colors.orange),
      appBarTheme:  AppBarTheme(
        actionsIconTheme: const IconThemeData(
          color: Colors.black87
        ),
        iconTheme: const IconThemeData(
          color: Colors.black87
        ),
        centerTitle: false,
        elevation: .4,
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.shade200,
        titleTextStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: Colors.black
        ),
      ),
      textTheme: TextTheme(
        headline1: GoogleFonts.notoSans(
          fontSize: 94,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5
        ),
        headline2: GoogleFonts.notoSans(
          fontSize: 59,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5
        ),
        headline3: GoogleFonts.notoSans(
          fontSize: 47,
          fontWeight: FontWeight.w400
        ),
        headline4: GoogleFonts.notoSans(
          fontSize: 33,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25
        ),
        headline5: GoogleFonts.notoSans(
          fontSize: 24,
          fontWeight: FontWeight.w400
        ),
        headline6: GoogleFonts.notoSans(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15
        ),
        subtitle1: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15
        ),
        subtitle2: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1
        ),
        bodyText1: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5
        ),
        bodyText2: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25
        ),
        button: GoogleFonts.notoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        caption: GoogleFonts.notoSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4
        ),
        overline: GoogleFonts.notoSans(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5
        ),
      )
  );



}

