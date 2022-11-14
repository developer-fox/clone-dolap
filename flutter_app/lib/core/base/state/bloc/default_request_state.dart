part of 'default_request_bloc.dart';

@immutable
abstract class DefaultRequestState {}

class DefaultRequestInitialState extends DefaultRequestState {
  DefaultRequestInitialState();
}

class DefaultRequestLoadingState extends DefaultRequestState {
  DefaultRequestLoadingState();
}

class DefaultRequestSuccessState<ResponseModel extends BaseResponseModel> extends DefaultRequestState{
  ResponseModel model;
  DefaultRequestSuccessState({required this.model});
}

class DefaultRequestErrorState extends DefaultRequestState {
  final BaseError error;
  DefaultRequestErrorState({
    required this.error,
  });
}
