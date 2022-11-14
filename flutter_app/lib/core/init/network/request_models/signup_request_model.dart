
import 'package:clone_dolap/core/base/model/base_request_model.dart';

class SignupRequestModel extends BaseRequestModel {
  String username;
  String email;
  String password;
  String phoneNumber;
  SignupRequestModel({
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  Map<String, Object> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "phone_number": phoneNumber
    };
  }
}
