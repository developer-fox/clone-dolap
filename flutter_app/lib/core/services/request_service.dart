
import 'package:clone_dolap/core/constants/app/network_constants.dart';
import 'package:clone_dolap/core/init/network/network_manager.dart';
import 'package:clone_dolap/view/authenticate/login/model/login_username_model.dart';

import '../../view/authenticate/login/model/login_email_model.dart';
import '../base/model/base_error.dart';
import '../base/model/base_model.dart';
import '../constants/enums/response_error_types_enum.dart';

class RequestService{
  
  static RequestService? _instance =  RequestService._init();

  static RequestService get instance {
    _instance ??= RequestService._init();
    return _instance!;
  }

  RequestService._init();

  Future<Object?> loginWithEmailRequest(String email, String password)async{

    var result = await NetworkManagement.instance.postRequest<LoginWithEmailRequestModel>(
      path: NetworkConstants.loginWithEmailPath, 
      model: LoginWithEmailRequestModel(email: email, password: password),
      addErrorCondition: (response) {
        if(response.data is Map && response.data["errors"] != null){
          return BaseError(message: "fields is false", statusCode: 404, errorType: ResponseErrorTypesEnum.invalidValue);
        }
      },
    );
    return result;
  }

  Future<Object?> loginWithUsernameRequest(String username, String password)async{

    var result = await NetworkManagement.instance.postRequest<LoginWithUsernameRequestModel>(
      path: NetworkConstants.loginWithUsernamePath, 
      model: LoginWithUsernameRequestModel(username: username, password: password),
      addErrorCondition: (response) {
        if(response.data is Map && response.data["errors"] != null){
          return BaseError(message: "fields is false", statusCode: 404, errorType: ResponseErrorTypesEnum.invalidValue);
        }
      },
    );
    return result;
  }


}
