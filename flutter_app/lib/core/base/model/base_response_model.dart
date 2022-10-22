
abstract class BaseResponseModel<T>{
  T fromJson(Map<String, Object> jsonData);
}
