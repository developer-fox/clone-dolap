import '../../../base/model/base_request_model.dart';

class LoginWithUsernameRequestModel extends BaseRequestModel {
  // for requests
  String username;
  String password;
  LoginWithUsernameRequestModel({
    required this.username,
    required this.password,
  });

  

  @override
  Map<String, Object> toJson() {
    return {
      "email": username,
      "password": password
    };
  }
}
