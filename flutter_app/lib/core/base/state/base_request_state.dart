
import 'package:clone_dolap/core/base/model/base_error.dart';
import 'package:clone_dolap/core/base/model/base_response_model.dart';

abstract class BaseRequestState{}

class BaseRequestInitialState extends BaseRequestState{}

class BaseRequestLoadingState extends BaseRequestState{}

class BaseRequestSuccessState<T extends BaseResponseModel<T>> extends BaseRequestState {
  T? data;
  BaseRequestSuccessState({
    required this.data,
  });
}

class BaseRequestErrorState extends BaseRequestState {
  BaseError error;
  BaseRequestErrorState({
    required this.error,
  });
}