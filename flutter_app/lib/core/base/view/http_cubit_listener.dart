
import 'package:clone_dolap/core/base/state/http_cubit.dart';
import 'package:clone_dolap/core/base/state/http_cubit_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/enums/request_types_enum.dart';
import '../../constants/enums/requesters_enum.dart';
import '../state/base_request_state.dart';

class HttpCubitListener extends StatefulWidget {
  final RequestTypesEnum requestType;
  final RequestersEnum requester;
  final bool keepAlive;
  final Widget? childWidget;
  final void Function(BuildContext context) onInitial;
  final void Function(BuildContext context, BaseRequestSuccessState requestSuccessStateObject) onSuccess;
  final void Function(BuildContext context) onLoading;
  final void Function(BuildContext context, BaseRequestErrorState baseRequestStateObject) onError;

  const HttpCubitListener({Key? key, 
  this.requester = RequestersEnum.client, 
  this.keepAlive = false, 
  this.childWidget,
  required this.requestType, 
  required this.onInitial, 
  required this.onSuccess, 
  required this.onLoading, 
  required this.onError, 
  }) : super(key: key);

  @override
  State<HttpCubitListener> createState() => _HttpCubitListenerState();
}

class _HttpCubitListenerState extends State<HttpCubitListener> {

  bool isFirstListenHappened = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HttpCubit, HttpCubitState>(
      child: widget.childWidget,
      listenWhen: (previous, current) {
        return previous != current && current.requestType == widget.requestType;
      },
      listener:(context, state) {
        if(widget.keepAlive || (widget.keepAlive == false && isFirstListenHappened)){
          var requestStateObject = state.baseRequestStateObject;
          if(requestStateObject is BaseRequestSuccessState && state is StreamableRequest){
            widget.onSuccess(context, requestStateObject);
          }
          else if(requestStateObject is BaseRequestLoadingState && state is StreamableRequest){
            widget.onLoading(context);
          }
          else if(requestStateObject is BaseRequestErrorState && state is StreamableRequest){
            widget.onError(context,requestStateObject);
          }
          else if((state is StreamableRequest && requestStateObject is BaseRequestInitialState) || state  is  HttpCubitInitialState){
            widget.onInitial(context);
          }
          else{
            throw Exception("undefined case");
          }
        }
        else{
          isFirstListenHappened = true;
          widget.onInitial(context);
        }
      },
    );
  }
}

