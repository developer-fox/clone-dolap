
import 'package:clone_dolap/core/constants/enums/response_error_types_enum.dart';
import 'package:dio/dio.dart';
import '../../base/model/base_error.dart';
import '../../base/model/base_model.dart';
import '../../constants/app/network_constants.dart';
import '../../constants/enums/locale_keys_enum.dart';
import '../cache/locale_manager.dart';

class NetworkManagement{
  static NetworkManagement? _instance;
  static NetworkManagement get instance{
    _instance ??= NetworkManagement._init();
    return _instance!;
  }

  late final Dio _dio;

  List<int> definedErrorStatusCodes = [400,404,412,401,408,407];
  List<int> successStatusCodes = [200,201,202,];

  // burada manager sinifi instance nesnesini urettigi zaman dio nesnemizi de tanimladik. 
  NetworkManagement._init(){


    // BaseOptions nesneleri sayesinde dio paketi dahilinde network islemlerimizi daha kolay yapabiliriz.
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: "https://clone-dolap-api.herokuapp.com",
    );
    // dio nesnesi parametre olarak baseOptions alir. 
    _dio = Dio(baseOptions);

    // ornegin bu sekilde her network isleminde buradaki kontroller ve fonksiyonlar calisacak.
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        if(e.response != null) {
          handler.resolve(e.response!);
        }
        else{
          print(e);
        }
      },
      onRequest: (options, handler) {
        _tokenMiddleware(options, handler);
      },

    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        _compareAndReplaceHttpTokensMiddleware(e, handler);
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        _extractResponseData(e, handler);
      },
    ));
  }

  // get requestler icin method
  Future<Object?> getRequest<RequestModel extends BaseModel<RequestModel>>({required String path,  RequestModel? model}) async{
    var response = await _dio.request(path, data: model?.toJson(), options: Options(
      method: "get"
    ));
    return _postRequestReturnValueAccordingStatusCode(response, model);
  }

  // get requestler icin method
  Future<Object?> postRequest<RequestModel extends BaseModel<RequestModel>>({required String path,  RequestModel? model, BaseError? Function(Response<dynamic> response)? addErrorCondition}) async{
    var response = await _dio.post(path, data: model?.toJson());
    return _postRequestReturnValueAccordingStatusCode(response, model, addErrorCondition: addErrorCondition);
  }
  
  Map<PreferencesKeys,String> _getHttpTokensFromCache() {
    String xAccessKey = LocaleManager.instance.getStringValue(PreferencesKeys.x_access_key);
    String xRefreshKey = LocaleManager.instance.getStringValue(PreferencesKeys.x_refresh_key);
    if(xAccessKey == "" || xRefreshKey == "") {
      throw Exception("tokens not found in cache");
    }
    else{
      return {
        PreferencesKeys.x_access_key: xAccessKey,
        PreferencesKeys.x_refresh_key: xRefreshKey
      };
    }
  }

  bool _ispathNeedingTokens(String path) {
    if(
      path == NetworkConstants.loginWithEmailPath 
      || path == NetworkConstants.loginWithUsernamePath 
      ){
      return false;
    }
    else{
      return true;
    }
  }

  Future<void> _tokenMiddleware(RequestOptions options, RequestInterceptorHandler handler) async{
    if(_ispathNeedingTokens(options.path)){
      try {
        var tokens =  _getHttpTokensFromCache();
        options.headers["x-access-token"] = tokens[PreferencesKeys.x_access_key];
        options.headers["x-access-refresh-token"] = tokens[PreferencesKeys.x_refresh_key];
        handler.next(options);
      } on Exception catch (e) {
        if(e.toString().contains("tokens not found in cache")) print("going to the login...");
      }
    }
    else{
      handler.next(options);
    }
  }

  void _compareAndReplaceHttpTokensMiddleware(Response<dynamic> e, ResponseInterceptorHandler handler) {
    if(e.data["tokens"] != null && LocaleManager.instance.getStringValue(PreferencesKeys.x_access_key) != ""){
      if(
        (e.data["tokens"]["jwt_token"] != LocaleManager.instance.getStringValue(PreferencesKeys.x_access_key))
      ){
        LocaleManager.instance.setStringValue(PreferencesKeys.x_access_key, e.data["tokens"]["jwt_token"]);
        return handler.next(e);
      }
    }
    return handler.next(e);
  }

  void _extractResponseData(Response<dynamic> e, ResponseInterceptorHandler handler){
    if(e.data["tokens"] != null && (e.requestOptions.path != NetworkConstants.loginWithEmailPath && e.requestOptions.path != NetworkConstants.loginWithUsernamePath)){
      e.data = e.data["json"];
      return handler.resolve(e);
    }
    else{
      return handler.next(e);
    }
  }

  Object? _postRequestReturnValueAccordingStatusCode<RequestModel extends BaseModel<RequestModel>>(Response<dynamic> response, RequestModel? model, {BaseError? Function(Response<dynamic> response)? addErrorCondition}){

    if(addErrorCondition != null){
      if(addErrorCondition(response) is BaseError){
        return addErrorCondition(response);
      }
    }

    if(definedErrorStatusCodes.contains(response.statusCode)){
      switch (response.statusCode) {
        case 400:
          return BaseError(message: response.data, statusCode: response.statusCode!, errorType: ResponseErrorTypesEnum.invalidValue);
        case 404:
          return BaseError(message: response.data, statusCode: response.statusCode!, errorType: ResponseErrorTypesEnum.invalidValue);
        case 412:
          return BaseError(message: response.data, statusCode: response.statusCode!, errorType: ResponseErrorTypesEnum.invalidValue);
        case 401:
          return BaseError(message: response.data, statusCode: response.statusCode!, errorType: ResponseErrorTypesEnum.invalidValue);
        case 408:
          return BaseError(message: response.data, statusCode: response.statusCode!, errorType: ResponseErrorTypesEnum.invalidValue);
        case 407:
          return BaseError(message: response.data, statusCode: response.statusCode!, errorType: ResponseErrorTypesEnum.invalidValue);
        default:
          return BaseError(message: response.data, statusCode: response.statusCode!, errorType: ResponseErrorTypesEnum.undefinedError);
      }
    }
    else if(successStatusCodes.contains(response.statusCode)){
      if(response.data is List){
        return response.data.map((e) => model?.fromJson(e)).toList();
      }
      else{
        return model?.fromJson(response.data);
      }
    }
    else if(response.statusCode == null){
      return null;
    }
    else{
      return BaseError(message: response.data, statusCode: response.statusCode!, errorType: ResponseErrorTypesEnum.undefinedError);
    }
  }



}
