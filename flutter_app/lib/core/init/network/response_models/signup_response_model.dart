
import '../../../base/model/base_response_model.dart';

class SignupResponseModel extends BaseResponseModel<SignupResponseModel> {
  String username;
  String jwtToken;
  String jwtRefreshToken;
  String websocketToken;
  String websocketRefreshToken;
  SignupResponseModel({
    required this.username,
    required this.jwtToken,
    required this.jwtRefreshToken,
    required this.websocketToken,
    required this.websocketRefreshToken,
  });


  @override
  SignupResponseModel fromJson(Map<String, Object> jsonData) {
    return SignupResponseModel(
      jwtToken: (jsonData["tokens"] as Map)["jwt_token"]! as String,
      jwtRefreshToken: (jsonData["tokens"] as Map)["refresh_token"]! as String,
      websocketRefreshToken: (jsonData["socketTokens"] as Map)["websocket_refresh_token"]! as String,
      websocketToken: (jsonData["socketTokens"] as Map)["websocket_jwt_token"]! as String,
      username: jsonData["info"]! as String,
    );
  }

  static SignupResponseModel blank(){
    return SignupResponseModel(
      jwtToken: "",
      jwtRefreshToken: "",
      websocketToken: "",
      websocketRefreshToken: "",
      username: ""
    );
  }

}
