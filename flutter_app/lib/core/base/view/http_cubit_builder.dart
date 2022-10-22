
import 'package:clone_dolap/core/base/model/base_response_model.dart';
import 'package:clone_dolap/core/constants/enums/request_types_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clone_dolap/core/base/state/base_request_state.dart';
import '../../constants/enums/requesters_enum.dart';
import '../state/http_cubit.dart';
import '../state/http_cubit_states.dart';

class HttpCubitBuilder extends StatefulWidget {
  final RequestTypesEnum requestType;
  final RequestersEnum requester;
  final bool keepAlive;
  final Widget Function(BuildContext context) onInitial;
  final Widget Function(BuildContext context, BaseRequestSuccessState requestSuccessStateObject) onSuccess;
  final Widget Function(BuildContext context) onLoading;
  final Widget Function(BuildContext context, BaseRequestErrorState baseRequestStateObject) onError;

  const HttpCubitBuilder({
    Key? key,
    required this.onLoading,
    required this.onSuccess,
    required this.onError, 
    required this.onInitial, 
    required this.requestType,
    this.requester = RequestersEnum.client,
    this.keepAlive = false
  }) : super(key: key);

  @override
  State<HttpCubitBuilder> createState() => _HttpCubitBuilderState();
}

class _HttpCubitBuilderState extends State<HttpCubitBuilder> {
  bool isFirstBuildHappened = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HttpCubit, HttpCubitState>(
      buildWhen: (previous, current) {
        return previous != current && current.requestType == widget.requestType;
      },
      builder:(context, state) {
        if(widget.keepAlive || (widget.keepAlive == false && isFirstBuildHappened)){
          var requestStateObject = state.baseRequestStateObject;
          if(requestStateObject is BaseRequestSuccessState && state is StreamableRequest){
            return widget.onSuccess(context, requestStateObject);
          }
          else if(requestStateObject is BaseRequestLoadingState && state is StreamableRequest){
            return widget.onLoading(context);
          }
          else if(requestStateObject is BaseRequestErrorState && state is StreamableRequest){
            return widget.onError(context,requestStateObject);
          }
          else if((state is StreamableRequest && requestStateObject is BaseRequestInitialState) || state  is  HttpCubitInitialState){
            return widget.onInitial(context);
          }
          else{
            throw Exception("undefined case");
          }
        }
        else{
          isFirstBuildHappened = true;
          return widget.onInitial(context);
        }
      }
    );
  }
}


BaseRequestSuccessState<T> requestSuccesStateObjectConverter<T extends BaseResponseModel<T>>(BaseRequestSuccessState requestSuccessStateObject){
  return requestSuccessStateObject as BaseRequestSuccessState<T>;
}