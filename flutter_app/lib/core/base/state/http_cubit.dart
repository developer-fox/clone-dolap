
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clone_dolap/core/constants/enums/request_types_enum.dart';
import '../../constants/enums/requesters_enum.dart';
import '../model/base_request_model.dart';
import '../model/base_response_model.dart';
import '../model/request_stream.dart';
import 'base_request_state.dart';
import 'http_cubit_states.dart';

class HttpCubit extends Cubit<HttpCubitState>{
  HttpCubit(): super(HttpCubitInitialState());

  Map<RequestTypesEnum,List<SubscriptionAndRequestType>> calledSubcriptionsFromClient = {};
  Map<RequestTypesEnum,List<SubscriptionAndRequestType>> calledSubcriptionsFromAuto = {};

  Future<void> addDefaultRequest<RequestModel extends BaseRequestModel, ResponseModel extends BaseResponseModel<ResponseModel>>({required RequestTypesEnum requestType,required Future<Object?> requestMethod, RequestersEnum requester = RequestersEnum.client}) async {

    var requestStream = RequestStream<RequestModel,ResponseModel>(requestMethod: requestMethod);

    StreamSubscription subscription = requestStream.streamController.stream.listen((event) { 
      emit(StreamableRequest(baseRequestStateObject: event, requestType: requestType));
    });

    if(requester == RequestersEnum.client){
      if(calledSubcriptionsFromClient[requestType] != null){
        calledSubcriptionsFromClient[requestType]?.add(SubscriptionAndRequestType(subscription: subscription, requestType: requestType));
      }
      else{
        calledSubcriptionsFromClient[requestType] = [SubscriptionAndRequestType(subscription: subscription,  requestType: requestType)];
      }
    }

    else{
      if(calledSubcriptionsFromAuto[requestType] != null){
        calledSubcriptionsFromAuto[requestType]?.add(SubscriptionAndRequestType(subscription: subscription, requestType: requestType));
      }
      else{
        calledSubcriptionsFromAuto[requestType] = [SubscriptionAndRequestType(subscription: subscription,  requestType: requestType)];
      }
    }
    await requestStream.sendRequest();
  }

  Future<void> closeSubscriptionsWithRequestType({required RequestTypesEnum requestType,  RequestersEnum requester = RequestersEnum.client}) async{
    if(requester == RequestersEnum.client){
      if(calledSubcriptionsFromClient[requestType] != null){
        emit(StreamableRequest(baseRequestStateObject: BaseRequestInitialState(), requestType: requestType));
        for(var subscriptionWithRequester in calledSubcriptionsFromClient[requestType]!) {
            await subscriptionWithRequester.subscription.cancel().then((value) {
              calledSubcriptionsFromClient.remove(requestType);
            });
        }
      }
    }
    else{
      if(calledSubcriptionsFromAuto[requestType] != null){
        emit(StreamableRequest(baseRequestStateObject: BaseRequestInitialState(), requestType: requestType));
        for(var subscriptionWithRequester in calledSubcriptionsFromAuto[requestType]!) {
            await subscriptionWithRequester.subscription.cancel().then((value) {
              calledSubcriptionsFromAuto.remove(requestType);
            });
        }
      }
    }
  }

}

class SubscriptionAndRequestType {
  StreamSubscription subscription;
  RequestTypesEnum requestType;
  SubscriptionAndRequestType({
    required this.subscription,
    required this.requestType,
  });
}
