from actions.abstract_action_class import Action
from actions.authentication_actions import AuthenticationActions
from actions.account_actions import AccountActions
from actions.comment_actions import CommentActions
from actions.offer_actions import OfferActions
from actions.notice_actions import NoticeActions
from actions.sale_actions import SaleActions
from services.notice_scraping_service import ScrapingService
from services.local_db_service import localDbInstance
import services.request_service as request_service
from model.url_types_enum import UrlTypes
import time
import random
import math

class DefaultLifeCycle(Action):
  
  def __init__(self, usersCount= 25):
    self.defineMultipleUsers([])
    self.auth_actions = AuthenticationActions()
    self.comment_actions = CommentActions()
    self.account_actions = AccountActions()
    self.offer_actions = OfferActions()
    self.sale_actions = SaleActions()
    self.notice_actions = NoticeActions()
    self.cycleFunction(usersCount)

  def cycleFunction(self, usersCount):
      #self.auth_actions.multipleSignup(math.ceil(usersCount / 2))
      self.usersLogin(usersCount= usersCount)
      for i in range(usersCount *2):
        self.addRandomNoticeSingle()
      for i in range(usersCount*3):
        if(i%3 == 0):
          self.addSingleComment()
        if(i%13 == 0):
          self.cartsChecking()
        if(i%6 == 0):
          self.addToCartFromAcceptedOffers()
        if(i% 17 == 0):
          self.cancelBuying()
        if(i%4 == 0):
          self.surfingOnTheHomePage()
          self.addRatingRandomSingle()
          self.answerTheQuestionsOfOneNotice()
          self.salingOffersDeclineOrAccept()
        time.sleep(.4)  
      for loginedUser in self.getMultipleUsers():
        self.auth_actions.setSingleUser(loginedUser)
        self.auth_actions.customLogout()

  def usersLogin(self, usersCount):
    self.auth_actions.randomLoginMultiple(usersCount)
    self.setMultipleUsers(self.auth_actions.getMultipleUsers())
  
  def selectRandomUserIntoMultipleUsers(self):
    randomUserIndex = random.randint(0, len(self.getMultipleUsers())-1)
    currentRandomUser = self.getMultipleUsers()[randomUserIndex]
    return currentRandomUser
  
  def addSingleComment(self):
    user = self.selectRandomUserIntoMultipleUsers()
    notice_id = self.getRandomNoticeIdFromUsersHomePage(user)
    self.comment_actions.defineSingleUser(user)
    self.comment_actions.addRandomComment(notice_id)


  def getRandomNoticeIdFromUsersHomePage(self, user):
    #TODO: randint range end value will replace to 3 later
    randomPageNumber = random.randint(1,1)
    userHomePageNotices = request_service.getHomePageNoticesRequest(user, page=randomPageNumber,refresh="true")
    randomIndex = random.randint(1,len(userHomePageNotices)-1)
    notice_id = userHomePageNotices[randomIndex]["_id"]
    return notice_id
    
  def giveRandomSingleOffer(self):
    user = self.selectRandomUserIntoMultipleUsers()
    notice_id = self.getRandomNoticeIdFromUsersHomePage(user)
    noticeDetails = request_service.getNoticeDetails(notice_id)
    isNoticeSalingWithOffer = noticeDetails["price_details"]["selling_with_offer"]
    noticeSalerUser = noticeDetails["saler_user"]["username"]
    if(isNoticeSalingWithOffer and noticeSalerUser != user.username):
      self.offer_actions.defineSingleUser(user)
      self.offer_actions.giveOffer(notice_id)
    else:
      self.giveRandomSingleOffer()

  def addRandomNoticeSingle(self):
    randomLocalNotices = localDbInstance.getRandomNoticeLink()
    self.account_actions.defineSingleUser(self.selectRandomUserIntoMultipleUsers())
    self.account_actions.createNoticeSingle(randomLocalNotices[0])
  
  def salingOffersDeclineOrAccept(self):
    currentUser = self.selectRandomUserIntoMultipleUsers()
    response = request_service.getUserSalingOffersRequest(currentUser)
    if(len(response)> 0):
      for notice in response:
        for offer in notice["offers"]:
          randomNumber = random.randint(1, 8)
          self.offer_actions.setSingleUser(currentUser)
          if(randomNumber >3):
            self.offer_actions.declineOffer(notice["notice_id"], offer["_id"])
          else:
            self.offer_actions.acceptOffer(notice["notice_id"], offer["_id"])  
    
  def surfingOnTheHomePage(self):
      currentUser = self.selectRandomUserIntoMultipleUsers()
      randomNumber = random.randint(1,30)
      randomPageNumber = random.randint(1,1)
      userHomePageNotices = request_service.getHomePageNoticesRequest(currentUser, page=randomPageNumber,refresh="true")
      for notice in userHomePageNotices:
        self.notice_actions.setSingleUser(currentUser)
        if(randomNumber < 15):
          self.account_actions.setSingleUser(currentUser)
          self.account_actions.followUser(notice["saler_user"])
          self.notice_actions.addToLookedNotices(notice["_id"])
        if(randomNumber <=14 and randomNumber>= 10):
          self.notice_actions.addToCart(notice["_id"])          
        elif(randomNumber> 14 and randomNumber< 21):
          self.offer_actions.setSingleUser(currentUser)
          self.offer_actions.giveOffer(notice["_id"])
        elif(randomNumber>1 and randomNumber<8):
          self.notice_actions.addToFavorites(notice["_id"])
        else:
          continue
        
  def addToCartFromAcceptedOffers(self):
    randomNumber = random.randint(1,2)
    if(randomNumber == 2):
      currentUser = self.selectRandomUserIntoMultipleUsers()
      self.offer_actions.setSingleUser(currentUser)
      offers = self.offer_actions.getBuyingOffers()
      for currentOffer in offers:
        if(currentOffer["state"]== "accepted"):
          self.notice_actions.setSingleUser(currentUser)
          self.notice_actions.addToCart(currentOffer["notice"])

  def cartsChecking(self):
    selectedUser = self.selectRandomUserIntoMultipleUsers()
    self.sale_actions.setSingleUser(selectedUser)
    cart = self.sale_actions.getCart()
    if(len(cart["items"])>0):
      self.account_actions.setSingleUser(selectedUser)
      self.sale_actions.setSingleUser(selectedUser)
      addresses = self.account_actions.getAdresses()
      if(len(addresses["addresses"])>0):
        self.sale_actions.checkCart(addresses["addresses"][0]["_id"])
      else:
        self.account_actions.addAdress()
        addresses = self.account_actions.getAdresses()
        self.sale_actions.checkCart(addresses["addresses"][0]["_id"])
        
  def cancelBuying(self):
    randomNumber = random.randint(1,12)
    if(randomNumber == 10):
      selectedUser = self.selectRandomUserIntoMultipleUsers()
      self.account_actions.setSingleUser(selectedUser)
      for i in self.account_actions.getTakenNotices()["taken_notices"]:
        objectId = i["_id"]
        statesLength = len(i["states"])
        lastState = i["states"][statesLength-1]
        if(lastState["state_type"]== "Onaylandı"):
          saleAct = SaleActions()
          saleAct.setSingleUser(account_actions.getSingleUser())
          saleAct.cancelBuying(objectId)
          break

  def addRatingRandomSingle(self):
    user = self.selectRandomUserIntoMultipleUsers()
    self.comment_actions.setSingleUser(user)
    self.comment_actions.addRating()

  def answerTheQuestionsOfOneNotice(self):
    selectedUser = self.selectRandomUserIntoMultipleUsers()
    self.account_actions.setSingleUser(selectedUser)
    response = self.account_actions.getOwnNotices()
    if(response is not None):
      notices = response["json"]["notices"]
      if(len(notices)>0):
        randomIndex = random.randint(0,len(notices)-1)
        for comment in notices[randomIndex]["notice_questions"]:
          self.comment_actions.setSingleUser(selectedUser)
          notice_id = notices[randomIndex]["_id"]
          comment_id = comment["_id"]
          self.comment_actions.addAnswerToNotice(notice_id, comment_id)  