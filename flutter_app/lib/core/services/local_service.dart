
import 'package:clone_dolap/core/constants/enums/locale_keys_enum.dart';
import 'package:clone_dolap/core/init/cache/locale_manager.dart';
import '../init/network/response_models/login_with_email_response_model.dart';
import '../init/network/response_models/login_with_username_response_model.dart';

class LocalService{
  static LocalService? _instance;
  static LocalService get instance{
    _instance ??= LocalService._init();
    return _instance!;
  }

  LocalService._init();

  Future<void> saveLoginedUserTokensFromLocaleWithUsernameRequest(LoginWithUsernameResponseModel model) async{
    await LocaleManager.instance.setStringValue(PreferencesKeys.x_access_key, model.jwtToken);
    await LocaleManager.instance.setStringValue(PreferencesKeys.x_refresh_key, model.jwtRefreshToken);
    await LocaleManager.instance.setStringValue(PreferencesKeys.socket_access_key, model.websocketToken);
    await LocaleManager.instance.setStringValue(PreferencesKeys.socket_refresh_key, model.websocketRefreshToken);
  }

  Future<void> saveLoginedUserTokensFromLocaleWithEmailRequest(LoginWithEmailResponseModel model) async{
    await LocaleManager.instance.setStringValue(PreferencesKeys.x_access_key, model.jwtToken);
    await LocaleManager.instance.setStringValue(PreferencesKeys.x_refresh_key, model.jwtRefreshToken);
    await LocaleManager.instance.setStringValue(PreferencesKeys.socket_access_key, model.websocketToken);
    await LocaleManager.instance.setStringValue(PreferencesKeys.socket_refresh_key, model.websocketRefreshToken);
  }

}