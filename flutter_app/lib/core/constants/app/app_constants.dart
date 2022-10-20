

// uygulamanin genelinde kullanilacak sabitler bu sinif icerisinde tanimlanir.
// attribute'lere ulasmak icin:
//? ApplicationConstants.instance.<attribute_name>

class ApplicationConstants{

  static ApplicationConstants? _instance = ApplicationConstants._init();

  static ApplicationConstants get instance{
    _instance ??= ApplicationConstants._init();
    return _instance!;
  }


  ApplicationConstants._init();

  String FONT_FAMILY = "POPPINS";
  String LANG_ASSET_PATH = "asset/language";
  String EMAIL_REGEX = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+\$";
  String STRONG_PASSWORD_REGEX = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{8,})";
}

