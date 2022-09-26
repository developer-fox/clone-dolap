

from actions.abstract_action_class import Action
from actions.authentication_actions import AuthenticationActions
from actions.account_actions import AccountActions
from services.notice_scraping_service import ScrapingService
from services.local_db_service import localDbInstance
import services.file_service as FileService
from model.url_types_enum import UrlTypes
import random

class InitializationActions(Action):
  def __init__(self,signingUsersCount= 150):
    print("in the InitializationActions")
    self.signingNewUsers(count= signingUsersCount)
    self.loadLocalNoticeLinks()
    self.setIsInitializedFromConfig()
    
  urlsAndTopCategories = [
    {"url": "https://dolap.com/ust-giyim", "top_category": "Kadın","url_type": UrlTypes.Default},
    {"url": "https://dolap.com/elbise", "top_category": "Kadın","url_type": UrlTypes.Default},
    {"url": "https://dolap.com/kalin-topuklu", "top_category": "Kadın","url_type": UrlTypes.Default},
    {"url": "https://dolap.com/kalin-topuklu", "top_category": "Kadın","url_type": UrlTypes.Default},
    {"url": "https://dolap.com/ince-topuklu", "top_category": "Kadın","url_type": UrlTypes.Default},
    {"url": "https://dolap.com/taki", "top_category": "Kadın","url_type": UrlTypes.Default},
    {"url": "https://dolap.com/sapka", "top_category": "Kadın","url_type": UrlTypes.Default},
    {"url": "https://dolap.com/kol-cantasi", "top_category": "Kadın","url_type": UrlTypes.Default},
    {"url": "Erkek+Giyim", "top_category": "Erkek","url_type": UrlTypes.Search},
    {"url": "Erkek%20Alt%20Giyim", "top_category": "Erkek","url_type": UrlTypes.Search},
    {"url": "Dekorasyon", "top_category": "Ev ve Yaşam","url_type": UrlTypes.Search},
    {"url": "Ev%20Tekstili", "top_category": "Ev ve Yaşam","url_type": UrlTypes.Search},
    {"url": "Oyuncak%20%26%20Kitap", "top_category": "Oyuncak & Kitap","url_type": UrlTypes.Search},
  ]

  def loadLocalNoticeLinks(self):
    for j in self.urlsAndTopCategories:
      searchPageLink = j["url"]
      topCategory = j["top_category"]
      urlType = j["url_type"]
      if(urlType == UrlTypes.Default):
        noticeUrlsList = ScrapingService().getSearchPage(searchWithAbsoluteUrl= searchPageLink,maxPageNumber= 250, duration= .3)["notice_urls"]
      else:
        noticeUrlsList = ScrapingService().getSearchPage(searchString= searchPageLink,maxPageNumber= 250, duration= .3)["notice_urls"]
      savedLinksCount = 0
      for noticeLink in noticeUrlsList:
        if(localDbInstance.searchInNoticeLinks(noticeLink)):
          localDbInstance.saveInNoticeLinks((topCategory,noticeLink))
          savedLinksCount += 1

      print("added new {} links".format(str(savedLinksCount)))

  def signingNewUsers(self, count):
    authActions = AuthenticationActions()
    authActions.multipleSignup(count)
    self.defineMultipleUsers(authActions.getMultipleUsers())
  
  def setIsInitializedFromConfig(self):
    localDbInstance.addValueFromConfigWithKey("is_initialized", True)