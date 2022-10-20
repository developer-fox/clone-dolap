
import 'package:flutter/material.dart';


// bu sinif, ara bir state sinifidir. Bu sinif sayesinde state'lerimize ek ozellikler kazandirabilecegiz ve butun state'leri tek bir yerden yonetebilecegiz.
abstract class BaseState<T extends StatefulWidget> extends State<T>{
  // bu getter sayesinde gecerli tema bilgisini alacagiz.
  ThemeData get currentThemeData => Theme.of(context);

  // bu method ile ekran yuksekliginin verdigimiz double parametre katini alacagiz. bu sayede responsivity kazanabilecegiz.
  double dynamicHeight(double value) => MediaQuery.of(context).size.height * value;

  // bu method ile ekran genisliginin verdigimiz double parametre katini alacagiz. bu sayede responsivity kazanabilecegiz.
  double dynamicWidth( double value) => MediaQuery.of(context).size.width * value;

}


