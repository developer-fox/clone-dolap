
import 'dart:async';
import 'package:clone_dolap/core/base/model/base_error.dart';
import 'package:clone_dolap/core/base/model/base_request_model.dart';
import 'package:clone_dolap/core/base/model/base_response_model.dart';
import 'package:clone_dolap/core/base/state/base_request_state.dart';

class RequestStream<RequestModel extends BaseRequestModel, ResponseModel extends BaseResponseModel<ResponseModel>> {
  Future<Object?> requestMethod;
  final StreamController<BaseRequestState?> streamController = StreamController<BaseRequestState?>();
  RequestStream({
    required this.requestMethod,
  });

  Future<void> sendRequest() async{
    streamController.add(BaseRequestLoadingState());
    var result = await requestMethod;
    if(result is BaseError){
      streamController.add(BaseRequestErrorState(error: result));
    }
    else if(result is ResponseModel){
      streamController.add(BaseRequestSuccessState<ResponseModel>(data: result));
    }
    else{
      streamController.add(null);
    }
  }
}


