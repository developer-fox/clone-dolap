import 'package:bloc/bloc.dart';
import 'package:clone_dolap/core/base/model/base_error.dart';
import 'package:clone_dolap/core/base/model/base_request_model.dart';
import 'package:clone_dolap/core/base/model/base_response_model.dart';
import 'package:clone_dolap/core/constants/enums/response_error_types_enum.dart';
import 'package:meta/meta.dart';

part 'default_request_event.dart';
part 'default_request_state.dart';

class DefaultRequestBloc<ResponseModel extends BaseResponseModel<ResponseModel>> extends Bloc<DefaultRequestEvent, DefaultRequestState> {
  DefaultRequestBloc() : super(DefaultRequestInitialState()) {
    on<DefaultRequestEvent>(_onRequest);
  }

  Future<void> _onRequest(DefaultRequestEvent event, Emitter<DefaultRequestState> emit)async {
    if(event is DefaultRequestSendEvent){
      emit(DefaultRequestLoadingState());
      final fetchResult = await event.requestMethod;
      if(fetchResult is BaseError){
        emit(DefaultRequestErrorState(error: fetchResult));
      }
      if(fetchResult is ResponseModel){
        emit(DefaultRequestSuccessState<ResponseModel>(model: fetchResult));
      }
      if(fetchResult == null){
        emit(DefaultRequestErrorState(error: BaseError(message: "server error", statusCode: 503, errorType: ResponseErrorTypesEnum.nullStatusCode)));
      }

    }
  }


}
