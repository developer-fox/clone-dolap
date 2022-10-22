
import 'package:clone_dolap/core/base/model/base_response_model.dart';

class LoginWithEmailResponseModel extends BaseResponseModel<LoginWithEmailResponseModel> {

  // for responses
  String jwtToken;
  String jwtRefreshToken;
  String websocketToken;
  String websocketRefreshToken;
  LoginWithEmailResponseModel({
    required this.jwtToken,
    required this.jwtRefreshToken,
    required this.websocketToken,
    required this.websocketRefreshToken,
  });

  @override
  LoginWithEmailResponseModel fromJson(Map<String, Object> jsonData) {
    return LoginWithEmailResponseModel(
      jwtToken: (jsonData["tokens"] as Map)["jwt_token"]! as String,
      jwtRefreshToken: (jsonData["tokens"] as Map)["refresh_token"]! as String,
      websocketRefreshToken: (jsonData["socketTokens"] as Map)["websocket_refresh_token"]! as String,
      websocketToken: (jsonData["socketTokens"] as Map)["websocket_jwt_token"]! as String,
    );
  }

  static LoginWithEmailResponseModel blank(){
    return LoginWithEmailResponseModel(jwtToken: "", jwtRefreshToken: "", websocketToken: "", websocketRefreshToken: "");
  }

}