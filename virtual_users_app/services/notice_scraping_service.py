
import os
import time
import random
import uuid 
import requests
import math
from services.local_db_service import  localDbInstance
from services.file_service import *
from selenium import webdriver 
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options
from model.scraped_notice_model import ScrapedNoticeModel

dolapRoutes = {
  "main": "https://dolap.com",
  "searchQuery": "/ara?q=Erkek%20Giyim"
}

class ScrapingService:
  def __init__(self):
    driverOptions = Options()
    driverOptions.binary_location =  os.getenv("firefox_path")
    driverOptions.add_argument("--headless")
    self.driver = webdriver.Firefox(executable_path= os.getenv("geckodriver_path"),options= driverOptions) 

  def getSearchUrl(self,searchString, pageNumber= 1):
    return "https://dolap.com/ara?q={}&sayfa={}".format(searchString,pageNumber)

  def getSearchPage(self,searchString= None,maxPageNumber= 1,searchWithAbsoluteUrl = None, duration= 0):
    usersPageUrls = []
    detailsPageUrls = []
    for currentPageNumber in range(1,maxPageNumber+1):
      
      if(searchWithAbsoluteUrl == None):
        self.driver.get(self.getSearchUrl(searchString,pageNumber= currentPageNumber))
      else:
        self.driver.get("{main_url}?sayfa={pageNumber}".format(main_url=searchWithAbsoluteUrl,pageNumber= currentPageNumber))
      # found page notices on this step
      pageNotices = self.driver.find_elements(By.CLASS_NAME,"col-xs-6")
      for i in range(0,len(pageNotices)):
        currentElement = pageNotices[i]
        
        # go to the notice details page
        container = currentElement.find_element(By.CLASS_NAME,"img-block")
        customATag =  container.find_element(By.TAG_NAME,"a")
        detailsPageUrl = customATag.get_attribute("href")
        
        userDetailsContainer = currentElement.find_element(By.CLASS_NAME,"img-title-block")
        userDetailsLink = userDetailsContainer.find_element(By.TAG_NAME,"a").get_attribute("href")
        usersPageUrls.append(userDetailsLink)
        if(localDbInstance.searchInTookNotices(detailsPageUrl)):
          detailsPageUrls.append(detailsPageUrl)
        
      time.sleep(duration)
          
    return {"notice_urls": detailsPageUrls, "user_urls": usersPageUrls} 

  def getNoticeDetails(self,noticeDetailPagesUrl,topCategory):
    try:
      self.driver.get(noticeDetailPagesUrl)
      
      info_dict = {}
      # categories
      categories = {"top_category": topCategory}
      categoriesUl = self.driver.find_element(By.CLASS_NAME,"breadcrumb")
      categoryElements = categoriesUl.find_elements(By.TAG_NAME,"a")
      for j in range(0,len(categoryElements)):
        
        categoriesForDefault = {
          1: "medium_category",
          2: "bottom_category",
          3: "detail_category"
        }
        
        categoriesForHomeAndLife= {
          2: "medium_category",
          3: "bottom_category"
        }
                
        categoryName = categoriesForHomeAndLife if (topCategory == "Ev ve Yaşam" or topCategory== "Oyuncak & Kitap") else categoriesForDefault
        
        categoryKeys= list(categoryName.keys())
        if(categoryKeys.count(j) != 0):
          if(topCategory == "Ev ve Yaşam" or topCategory== "Oyuncak & Kitap"):
            categories.update({"detail_category": categoryElements[3].text})  
          categories.update({categoryName[j]: categoryElements[j].text})
        
        info_dict.update(categories)
        brand = categoriesUl.find_elements(By.TAG_NAME,"li")[-1].text.split(" - ")[0]
        sizeFullText = categoriesUl.find_elements(By.TAG_NAME,"li")[-1].text.split(" - ")[1].split(" ") if categoriesUl.find_elements(By.TAG_NAME,"li")[-1].text.count(" - ") != 0 else categoriesUl.find_elements(By.TAG_NAME,"li")[-1].text
        size = ""
        k= 0
        while(k < len(sizeFullText) -1):
          size += sizeFullText[k]
          size += " "
          k += 1
          
        size = size.strip()
          
        info_dict.update({"size":size, "brand":brand})
        
      # use case and cargo payer
      titles = self.driver.find_element(By.CLASS_NAME,"title-holder").find_elements(By.CLASS_NAME,"subtitle")
      useCase =  "Yeni & Etiketli" if titles[0].text == "Yeni ve Etiketli" else titles[0].text
      cargoPayer =  "buyer" if titles[1].text == "Alıcı Öder" else "saler"      
      info_dict.update({"use_case": useCase,"payer_of_cargo": cargoPayer})
      price = self.driver.find_element(By.CLASS_NAME,"price").text.split(" ")[0]
      priceFiltered = ""
      for ch in price:
        if(ch != "."):
          priceFiltered += ch
      
      randomNumber = random.randint(1,7)
      salingWithOffer = True if randomNumber > 2 else False
      info_dict.update({"saling_price": priceFiltered, "buying_price": float(priceFiltered)*(1.3),"selling_with_offer": salingWithOffer})        
      
      remarksBlock = self.driver.find_element(By.CLASS_NAME,"remarks-block")
      description = remarksBlock.find_element(By.TAG_NAME,"p").text
      color = remarksBlock.find_element(By.CLASS_NAME,"color-holder").find_element(By.TAG_NAME,"span").text
      colorImageUrl = remarksBlock.find_element(By.CLASS_NAME,"color-holder").find_element(By.CLASS_NAME,"lazy").get_attribute("src")
      info_dict.update({"color": color, "description": description})
      randomNumberForCargoSize = random.randint(1, 20)
      resultCargoSize = ""
      if(randomNumberForCargoSize<= 12):
        resultCargoSize = "Küçük Paket"
      elif(randomNumberForCargoSize > 12 and randomNumberForCargoSize <= 16):
        resultCargoSize = "Orta Paket"
      else:
        resultCargoSize = "Büyük Paket"
      info_dict.update({"size_of_cargo": resultCargoSize})
      imageUrls = []
      superUl = self.driver.find_element(By.CLASS_NAME,"p-slideset")
      elementsOfImg = superUl.find_elements(By.TAG_NAME,"img")
      for i in elementsOfImg:
        imageUrls.append(i.get_attribute("src"))
      imagePaths = []
      for i in imageUrls:
        response = requests.get(i, stream=True)
        imageFormat = i.split(".")[-1]
        filename = "files/notices/{}.{}".format(uuid.uuid4(),imageFormat)
        writeSingleNoticeImage(filename, response)
        imagePaths.append(filename)
      scrapedModel = ScrapedNoticeModel(info_dict= info_dict, photoPaths= imagePaths)
      self.driver.close()  
      return scrapedModel
    except Exception as error:
      print('An exception on noticeScrapingService/getNoticeDetails(): {}'.format(str(error)))
  def getNoticeUrlsFromUserDetailsPage(self, userDetailPageMainUrl):
    noticeUrls = []
    try:
      self.driver.get(userDetailPageMainUrl)
      noticesATag = self.driver.find_element(By.XPATH,r'/html/body/div[2]/main/div/div/div/div[1]/ul/li[1]/a').text
      noticesATag= noticesATag.split(" ")[1]
      noticesCount = ""
      for i in noticesATag:
        if(i == "(" or i == ")"):
          continue
        else:
          noticesCount += i
      noticesCount = int(noticesCount)
      pagesCount = math.ceil(noticesCount /18)
      for i in range(1, pagesCount+1):
        self.driver.get(userDetailPageMainUrl+"?sayfa={}".format(i))
        noticeContainers = self.driver.find_elements(By.CLASS_NAME,"col-xs-6")
        for container in noticeContainers:
          imgBlock = container.find_element(By.CLASS_NAME, "img-block")
          noticeUrl =  imgBlock.find_element(By.TAG_NAME,"a").get_attribute("href")
          noticeUrls.append(noticeUrl)
      return noticeUrls
    except Exception as error:
      print('exception on getNoticeUrlsFromUserDetailsPage: {}'.format(str(error)))
      self.getNoticeUrlsFromUserDetailsPage(userDetailPageMainUrl)
    