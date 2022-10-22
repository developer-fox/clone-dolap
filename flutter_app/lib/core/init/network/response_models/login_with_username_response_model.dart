
import 'package:clone_dolap/core/base/model/base_response_model.dart';

class LoginWithUsernameResponseModel extends BaseResponseModel<LoginWithUsernameResponseModel> {

  // for responses
  String jwtToken;
  String jwtRefreshToken;
  String websocketToken;
  String websocketRefreshToken;
  LoginWithUsernameResponseModel({
    required this.jwtToken,
    required this.jwtRefreshToken,
    required this.websocketToken,
    required this.websocketRefreshToken,
  });

  @override
  LoginWithUsernameResponseModel fromJson(Map<String, Object> jsonData) {
    return LoginWithUsernameResponseModel(
      jwtToken: (jsonData["tokens"] as Map)["jwt_token"]! as String,
      jwtRefreshToken: (jsonData["tokens"] as Map)["refresh_token"]! as String,
      websocketRefreshToken: (jsonData["socketTokens"] as Map)["websocket_refresh_token"]! as String,
      websocketToken: (jsonData["socketTokens"] as Map)["websocket_jwt_token"]! as String,
    );
  }

  static LoginWithUsernameResponseModel blank(){
    return LoginWithUsernameResponseModel(jwtToken: "", jwtRefreshToken: "", websocketToken: "", websocketRefreshToken: "");
  }
}
