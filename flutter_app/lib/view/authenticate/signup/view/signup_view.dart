
import 'package:clone_dolap/core/constants/enums/request_types_enum.dart';
import 'package:clone_dolap/core/base/state/base_state.dart';
import 'package:clone_dolap/core/base/state/http_cubit.dart';
import 'package:clone_dolap/core/base/view/http_cubit_builder.dart';
import 'package:clone_dolap/core/constants/enums/locale_keys_enum.dart';
import 'package:clone_dolap/core/extension/context_extension.dart';
import 'package:clone_dolap/core/extension/string_extension.dart';
import 'package:clone_dolap/core/init/cache/locale_manager.dart';
import 'package:clone_dolap/core/init/language/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/base/model/request_stream.dart';
import '../../../../core/base/view/base_view.dart';
import '../../../../core/init/network/request_models/login_with_email_request_model.dart';
import '../../../../core/services/request_service.dart';
import '../../login/model/login_email_model.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends BaseState<SignupView> {
    var dd = RequestStream<LoginWithEmailRequestModel, LoginWithEmailResponseModel>(requestMethod: RequestService.instance.loginWithEmailRequest("carmen.murillo@example.com", "ATzIt#i3k)EmPFdd")); 

    final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onModelReady:(context) {
        if(LocaleManager.instance.getStringValue(PreferencesKeys.x_access_key) !=""){
        //  throw Exception("an user logined");
        }
      },
      onPageBuilder: (context) {
        return Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text(LocaleKeys.signup_appbarTitle.locale),
          ),
          body: Column(
            children: [
              ElevatedButton(onPressed: () {
                context.read<HttpCubit>().addDefaultRequest<LoginWithEmailRequestModel, LoginWithEmailResponseModel>(requestType: RequestTypesEnum.loginWithEmail, requestMethod: RequestService.instance.loginWithEmailRequest("carmen.murillo@example.com", "ATzIt#i3k)EmPFdd"));
              }, 
              child: const Text("click")
              ),
              ElevatedButton(onPressed: () {
                context.read<HttpCubit>().addDefaultRequest<LoginWithEmailRequestModel, LoginWithEmailResponseModel>(requestType: RequestTypesEnum.loginWithEmail, requestMethod: RequestService.instance.loginWithEmailRequest("carmen.murillo@example.com", "ATzIt#i3k)EmPFdd"));
              }, 
              child: const Text("click")
              ),
              ElevatedButton(onPressed: (() {
                context.read<HttpCubit>().closeSubscriptionsWithRequestType(requestType: RequestTypesEnum.loginWithEmail);
              }), 
              child: HttpCubitBuilder(
                onLoading:(context) {
                  return CircularProgressIndicator(color: context.currentThemeData.colorScheme.primary);
                }, 
                onSuccess: (context, requestSuccessStateObject){
                  var convertedRequestModel = requestSuccesStateObjectConverter<LoginWithEmailResponseModel>(requestSuccessStateObject);
                  return Text(convertedRequestModel.data!.jwtToken);
                }, 
                onError:(context, baseRequestStateObject) {
                  return Text(baseRequestStateObject.error.message);
                }, 
                onInitial:(context) {
                  return const Text("on initial");
                }, 
                requestType: RequestTypesEnum.loginWithEmail
                ),
              )
            ],
          ),
        );
      },
    );
  }
}


