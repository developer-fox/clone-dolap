import '../../../base/model/base_request_model.dart';

class LoginWithEmailRequestModel extends BaseRequestModel {
  // for requests
  String email;
  String password;
  LoginWithEmailRequestModel({
    required this.email,
    required this.password,
  });

  

  @override
  Map<String, Object> toJson() {
    return {
      "email": email,
      "password": password
    };
  }
}