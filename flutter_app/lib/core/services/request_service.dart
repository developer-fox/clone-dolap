
import 'package:clone_dolap/core/constants/app/network_constants.dart';
import 'package:clone_dolap/core/init/network/network_manager.dart';
import 'package:clone_dolap/core/init/network/request_models/signup_request_model.dart';
import '../base/model/base_error.dart';
import '../constants/enums/response_error_types_enum.dart';
import '../init/network/request_models/login_with_email_request_model.dart';
import '../init/network/request_models/login_with_username_request_model.dart';
import '../init/network/response_models/login_with_email_response_model.dart';
import '../init/network/response_models/login_with_username_response_model.dart';
import '../init/network/response_models/signup_response_model.dart';

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

  Future<Object?> signupRequest(String username, String password, String email, String phoneNumber) async{
    var result = await NetworkManagement.instance.postRequest<SignupRequestModel,SignupResponseModel>(
      path: NetworkConstants.signupPath,
      requestModel: SignupRequestModel(username: username, email: email, password: password, phoneNumber: phoneNumber),
      responseModel: SignupResponseModel.blank(),
      addErrorCondition: (response) {
        if(response.statusCode == 400){
          String resultMessage = "";
          for(var currentError in response.data["errors"]){
            String errorMessage = currentError["msg"];
            resultMessage += errorMessage;
            resultMessage += "/";
          }
          return BaseError(message: resultMessage, statusCode: 400, errorType: ResponseErrorTypesEnum.invalidValue);
        }
        return null;
      },
    );
    return result;
  }


}
