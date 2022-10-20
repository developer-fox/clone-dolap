
import '../../../../core/base/model/base_model.dart';

class LoginWithUsernameRequestModel extends BaseModel<LoginWithUsernameRequestModel> {
  // for requests
  String? username;
  String? password;
  // for responses
  String? jwtToken;
  String? jwtRefreshToken;
  String? websocketToken;
  String? websocketRefreshToken;

  LoginWithUsernameRequestModel({
    this.username,
    this.password,
    this.jwtToken,
    this.jwtRefreshToken,
    this.websocketToken,
    this.websocketRefreshToken,
  });
  @override
  LoginWithUsernameRequestModel fromJson(Map<String, Object> jsonData) {
    return LoginWithUsernameRequestModel(
      jwtToken: (jsonData["tokens"] as Map)["jwt_token"]! as String,
      jwtRefreshToken: (jsonData["tokens"] as Map)["refresh_token"]! as String,
      websocketRefreshToken: (jsonData["socketTokens"] as Map)["websocket_refresh_token"]! as String,
      websocketToken: (jsonData["socketTokens"] as Map)["websocket_jwt_token"]! as String,
    );
  }

  @override
  Map<String, Object> toJson() {
    return {
      "username": username!,
      "password": password!
    };
  }
}
