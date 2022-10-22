import '../../constants/enums/request_types_enum.dart';
import 'base_request_state.dart';

abstract class HttpCubitState{
  late BaseRequestState? baseRequestStateObject;
  late RequestTypesEnum? requestType;
}

class HttpCubitInitialState implements HttpCubitState{
  @override
  BaseRequestState? baseRequestStateObject;
  @override
  RequestTypesEnum? requestType;
}

class StreamableRequest implements HttpCubitState{
  @override
  BaseRequestState? baseRequestStateObject;
  @override
  RequestTypesEnum? requestType;
  StreamableRequest({
    required this.baseRequestStateObject,
    required this.requestType,
  });  

}
