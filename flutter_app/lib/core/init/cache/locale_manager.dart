import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/enums/locale_keys_enum.dart';

// shared_preferences islemlerini yapacagimiz ve yonetecegimiz manager class
//? LocaleManager.instance.<method_name> 
class LocaleManager{

  static LocaleManager? _instance =  LocaleManager._init();
  static LocaleManager get instance{
    _instance ??= LocaleManager._init();
    return _instance!;
  }

  SharedPreferences? _sharedPreferences;
  LocaleManager._init(){
    SharedPreferences.getInstance().then((value) => _sharedPreferences = value);
  }

  // shared_preferences olusturur
  static preferencesInit() async{
    instance._sharedPreferences ??= await SharedPreferences.getInstance();
    return;
  }

  // verilen key'e karsilik gelen string veriyi degistirir/olusturur.
  //? LocaleManager.instance.setStringValue(SharedPreferencesKeys.<enum_value>, "<string_value>");
  Future<void> setStringValue(PreferencesKeys key, String value) async {
    await _sharedPreferences?.setString(key.toString(), value);
  }

  // verilen key'e karsilik gelen string veriyi getirir.
  //? LocaleManager.instance.getStringValue(SharedPreferencesKeys.<enum_value>);
  String getStringValue(PreferencesKeys key) =>
    _sharedPreferences?.getString(key.toString()) ?? "";

  // verilen key'e karsilik gelen int veriyi degistirir/olusturur.
  //? LocaleManager.instance.setIntValue(SharedPreferencesKeys.<enum_value>, <int_value>>);
  Future<void> setIntValue(PreferencesKeys key, int value) async {
    await _sharedPreferences?.setInt(key.toString(), value);
  }

  // verilen key'e karsilik gelen int veriyi getirir.
  //? LocaleManager.instance.getStringValue(SharedPreferencesKeys.<enum_value>);
  int getIntValue(PreferencesKeys key) =>
    _sharedPreferences?.getInt(key.toString()) ?? 0;
}
