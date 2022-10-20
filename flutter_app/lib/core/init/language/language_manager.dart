
import 'package:flutter/material.dart';

// dil yonetimi sinifidir.

//? dil paketine veri eklendiginde locale_keys.g.dart dosyasinin yeniden olusturulmasi gerekir.
//? locale_keys.g.dart dosyasini yeniden olusturmak icin su scriptli calistirin:
//? flutter pub run easy_localization:generate  -O lib/core/init/language -f keys -o locale_keys.g.dart -S asset/language

//? LanguageManager.instance.<method_name> 
class LanguageManager{

  static LanguageManager? _instance =  LanguageManager._init();

  static LanguageManager get instance {
    _instance ??= LanguageManager._init();
    return _instance!;
  }

  LanguageManager._init();
  
  final enLocale = const Locale('en', 'US');
  final trLocale = const Locale('tr', 'TR');

  List<Locale> get supportedLocales => [enLocale, trLocale];


}

