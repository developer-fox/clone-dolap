
import 'package:clone_dolap/core/constants/app/network_constants.dart';
import 'package:clone_dolap/core/init/network/network_manager.dart';
import '../base/model/base_error.dart';
import '../constants/enums/response_error_types_enum.dart';
import '../init/network/request_models/login_with_email_request_model.dart';
import '../init/network/request_models/login_with_username_request_model.dart';
import '../init/network/response_models/login_with_email_response_model.dart';
import '../init/network/response_models/login_with_username_response_model.dart';

class RequestService{
  
  static RequestService? _instance =  RequestService._init();

  static RequestService get instance {
    _instance ??= RequestService._init();
    return _instance!;
  }

  RequestService._init();

  Future<Object?> loginWithEmailRequest(String email, String password)async{
    var result = await NetworkManagement.instance.postRequest<LoginWithEmailRequestModel, LoginWithEmailResponseModel>(
      path: NetworkConstants.loginWithEmailPath, 
      requestModel: LoginWithEmailRequestModel(email: email, password: password),
      responseModel: LoginWithEmailResponseModel.blank(),
      addErrorCondition: (response) {
        if(response.data is Map && response.data["errors"] != null){
          return BaseError(message: "fields is false", statusCode: 404, errorType: ResponseErrorTypesEnum.invalidValue);
        }
        return null;
      },
    );
    return result;
  }

  Future<Object?> loginWithUsernameRequest(String username, String password)async{
    var result = await NetworkManagement.instance.postRequest<LoginWithUsernameRequestModel, LoginWithUsernameResponseModel>(
      path: NetworkConstants.loginWithUsernamePath, 
      requestModel: LoginWithUsernameRequestModel(username: username, password: password),
      responseModel: LoginWithUsernameResponseModel.blank(),
      addErrorCondition: (response) {
        if(response.data is Map && response.data["errors"] != null){
          return BaseError(message: "fields is false", statusCode: 404, errorType: ResponseErrorTypesEnum.invalidValue);
        }
        return null;
      },
    );
    return result;
  }


}
