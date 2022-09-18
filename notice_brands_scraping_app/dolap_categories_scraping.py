import json
import time  # bekletme islemi icin time modulunden yararlanacagiz.
from selenium import webdriver  # bu modul sayesinde sanal tarayici calistiracagiz.

from selenium.webdriver.common.by import By # bu modul html iceriginden istedigimiz kisimlari almamiza yardimci olacak.



browser = webdriver.Edge("msedgedriver.exe") # ben microsoft edge kullandigim icin microsoft edge driveri yukledim. eger chrome kullaniyorsaniz "google chrome web driver" seklinde aratarak bulabilir ve indirebilirsiniz. indirdikten sonra driverinizi python dosyanizla ayni klasore koyun.

browser.get("https://dolap.com/markalar")

# ilgili baslik 47 sayfadan olustugu icin her sayfa uzerinde gezebilecek bir dongu yazdik.
  
  # ornek olarak basligin ilk sayfasinin linki su sekildedir --> https://eksisozluk.com/dokuz-eylul-universitesi--102608?p=1 
  # o halde biz ?p= parametresini her dongude 48'e kadar degistirerek butun sayfalarda gezinebiliriz.
  
  # sayfada content adindaki sinifa ait butun html elementlerini liste seklinde aldik.
containers = browser.find_elements(By.CLASS_NAME, 'block-holder')
  
items_dictionary= {}
index = 0
for icerik in containers:
  all_ul = icerik.find_elements(By.TAG_NAME, "ul")
  for ul in all_ul:
    all_li = ul.find_elements(By.TAG_NAME, "li")
    for li in all_li:
      all_a = li.find_elements(By.TAG_NAME,"a")
      for a in all_a:
        links = a.text
        items_dictionary.update({index: links})
        with open("brands.json","w") as outfile:
          json.dump(items_dictionary, outfile)
        index +=1
    # eger html elementimizin icerigi buca kelimesini iceriyorsa bunu yazdiriyoruz.
    # hata almamak icin kucuk bir bekleme ekledik.
  time.sleep(.6)
  
  
# islemlerimiz bittiginde sanal tarayiciyi kapatiyoruz. Bu olasi performans zafiyetlerini onlemek icin gereklidir.
browser.close()