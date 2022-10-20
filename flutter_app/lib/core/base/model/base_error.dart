
// hata sinifidir. Hata islemlerinde mesaj olusturmak icin direkt olarak bu sinifi kullanacagiz.
import 'package:clone_dolap/core/constants/enums/response_error_types_enum.dart';

class BaseError {
  final String message;
  final int statusCode;
  final ResponseErrorTypesEnum errorType;
  BaseError({
    required this.message,
    required this.statusCode,
    required this.errorType,
  });
}
