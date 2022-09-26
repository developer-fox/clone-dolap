
import math
import services.request_service as request_service
from services.local_db_service import localDbInstance
from model.user_model import UserModel
from model.local_notice_model import LocalNotice
import services.file_service as file_service
from services.notice_scraping_service import ScrapingService
from actions.abstract_action_class import Action
import actions.authentication_actions 

class AccountActions(Action):
  def __init__(self):
    pass
  def changeProfilePhoto(self):
    requestResult = request_service.changeProfilePhoto(self.getSingleUser())
    if(requestResult):
      file_service.deleteUserProfileImageFromLocale(self.getSingleUser().imagePath)
    else:
      print("profile image changing process is not successful")
      
  def createNoticeSingle(self, noticeModel: LocalNotice):
    try:
      scraping = ScrapingService()
      result = scraping.getNoticeDetails(noticeModel.url, noticeModel.top_category)
      creatingResult =  request_service.createNoticeRequest(self.getSingleUser(), result)
      if(creatingResult):
        file_service.deleteCreatedNoticePhotosFromLocale(result.photoPaths)
        localDbInstance.deleteSingleNoticeLink(noticeModel)
      else:
        print(creatingResult)
    except Exception as error:
      print('An exception occurred AccountAction/createNoticeSingle(): {}'.format(str(error)))
  
  def createNoticeMultiple(self,userCount,noticePerUser):
    scraping = ScrapingService()
    authActions = AuthenticationActions()
    authActions.randomLoginMultiple(count= userCount)
    self.defineMultipleUsers(userModelsList= authActions.getMultipleUsers())
    
    noticePageUrls= scraping.getSearchPage("Erkek%20Giyim", maxPageNumber= math.ceil((userCount*noticePerUser)/18))["notice_urls"]
    print(len(noticePageUrls))
    currentUserIndex = 0
    currentNoticeIndex = 0
    while currentUserIndex < userCount:
      for i in range(noticePerUser):
        result = scraping.getNoticeDetails(noticePageUrls[currentNoticeIndex], "Erkek")
        creatingResult =  request_service.createNoticeRequest(authActions.getMultipleUsers()[currentUserIndex], result)
        if(creatingResult):
          localDbInstance.saveInTookNotices(noticePageUrls[currentNoticeIndex])
          file_service.deleteCreatedNoticePhotosFromLocale(result.photoPaths)
        currentNoticeIndex += 1
      currentUserIndex += 1

  def addAdress(self):
    addressInfo = request_service.getRandomAddress()
    request_service.addAddressRequest(self.getSingleUser(), addressInfo)

  def getAdresses(self):
    response = request_service.getAddressesRequest(self.getSingleUser())
    return response
  
  def getTakenNotices(self):
    response = request_service.getTakenNoticesRequest(self.getSingleUser())
    return response

  def getOwnNotices(self):
    response = request_service.getOwnNoticesRequest(self.getSingleUser())
    return response
  
  def followUser(self, user_id):
    response = request_service.followUserRequest(self.getSingleUser(), user_id)
  
  
  
  