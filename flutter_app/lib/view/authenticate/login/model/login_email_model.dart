
import '../../../../core/base/model/base_model.dart';

class LoginWithEmailRequestModel extends BaseModel<LoginWithEmailRequestModel> {
  // for requests
  String? email;
  String? password;
  // for responses
  String? jwtToken;
  String? jwtRefreshToken;
  String? websocketToken;
  String? websocketRefreshToken;
  LoginWithEmailRequestModel({
    this.email,
    this.password,
    this.jwtToken,
    this.jwtRefreshToken,
    this.websocketToken,
    this.websocketRefreshToken,
  });
  @override
  LoginWithEmailRequestModel fromJson(Map<String, Object> jsonData) {
    return LoginWithEmailRequestModel(
      jwtToken: (jsonData["tokens"] as Map)["jwt_token"]! as String,
      jwtRefreshToken: (jsonData["tokens"] as Map)["refresh_token"]! as String,
      websocketRefreshToken: (jsonData["socketTokens"] as Map)["websocket_refresh_token"]! as String,
      websocketToken: (jsonData["socketTokens"] as Map)["websocket_jwt_token"]! as String,
    );
  }

  @override
  Map<String, Object> toJson() {
    return {
      "email": email!,
      "password": password!
    };
  }
}
