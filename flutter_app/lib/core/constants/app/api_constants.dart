

// api eylemleri icin kullanilacak sabitler bu sinif icerisinde tanimlanir.
//? ApiConstants.instance.<attribute_name>
class ApiConstants{
  static ApiConstants? _instance = ApiConstants._init();
  static ApiConstants get instance{
    _instance ??= ApiConstants._init();
    return _instance!;
  }

  ApiConstants._init();
}
