// internet islemlerinde kullanacagimiz veri ust sinifidir. Aldigimiz verileri efektif kullanabilmek icin bu veriler bu siniftan inherit ettigimiz siniflardan nesneler olusturacagiz.
abstract class BaseModel<T>{
  Map<String, Object> toJson();
  T fromJson(Map<String, Object> jsonData);
}