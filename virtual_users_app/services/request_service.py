

import requests
import shutil
import services.file_service as file_service
from services.local_db_service import localDbInstance
from model.user_model import UserModel
from model.scraped_notice_model import ScrapedNoticeModel
import os
import math
import random

mainRoute = os.getenv("api_url")
randomUserApiRootUrl = os.getenv("randomuser_api_url")
strongPasswordApiRootUrl = os.getenv("strong_password_api_url")

rapidapiHeadersForRandomuserApi = {
  'X-RapidAPI-Key': str(os.getenv("x_rapidapi_key")),
  'X-RapidAPI-Host': str(os.getenv("x_rapidapi_host_randomuser")),
}

rapidapiParamsForRandomUserApi =  {"locale": 'en_US', "minAge": '18', "maxAge": '50', "domain": 'ugener.com'},

rapidapiHeadersForFamousQuotesApi = {
  'X-RapidAPI-Key': str(os.getenv("x_rapidapi_key")),
  'X-RapidAPI-Host': str(os.getenv("x_rapidapi_host_famous_quotes")),
}
rapidapiHeadersForStrongPasswordApi = {
  'X-RapidAPI-Key': str(os.getenv("x_rapidapi_key")),
  'X-RapidAPI-Host': str(os.getenv("x_rapidapi_host_strong_password")),
}

def loginedUserJwtHeaders(user: UserModel):
  return{
    "x-access-token": user.x_access_key,
    "x-access-refresh-token": user.x_refresh_key
  }

def isTokensReplaced(response,user: UserModel): # -> UserModel
  response = response.json()
  if(response["tokens"]["jwt_token"] != user.x_access_key):
    updatedUser = localDbInstance.updateUserJwtKey(user, response["tokens"]["jwt_token"])
    return updatedUser
  else:
    return user

def getRandomUserInfo(): # -> {"password", "email","username","picture_name", "phone_number"}

  randomUserResponse  = requests.get("{}/getuser".format(str(randomUserApiRootUrl)),headers=rapidapiHeadersForRandomuserApi)

  strongPasswordResponse = requests.get(strongPasswordApiRootUrl, headers= rapidapiHeadersForStrongPasswordApi)
  if(randomUserResponse.status_code == 200 and strongPasswordResponse.status_code == 200):
    randomUserResponse = randomUserResponse.json()
    result = {}

    result.update({"email":randomUserResponse["results"][0]["email"]})

    result.update({"username":randomUserResponse["results"][0]["login"]["username"]})

    result.update({"password": strongPasswordResponse.json()["random_password"]})
    profileImageUrl = randomUserResponse["results"][0]["picture"]["large"]
    phoneNumber = randomUserResponse["results"][0]["phone"]
    resultPhoneNumber = ""
    for i in phoneNumber:
      try:
        if(i.isnumeric()):
          resultPhoneNumber += i
        else:
          resultPhoneNumber += "4"
      except Exception as error:
        print('an exception occurred on requestService/getRandomUserInfo(): {}'.format(str(error)))
    result.update({"phone_number":resultPhoneNumber})
    try:
      profileImageRequest = requests.get(profileImageUrl, stream= True)
      result.update({"picture_name":randomUserResponse["results"][0]["login"]["uuid"]+"."+ profileImageUrl.split(".")[-1]})
      writingImageResult = file_service.writeUserProfileImage("./files/users/{}".format(result["picture_name"]), profileImageRequest)
      if(writingImageResult == False):
        return getRandomUserInfo()
      else:
        return result
    except Exception as error:
      print('Something went wrong: {}'.format(error))
      getRandomUserInfo()
    return result
  else: 
    print(randomUserResponse.text)
    return getRandomUserInfo()
  
def getRandomCommentContent(count=1):
  contents = []
  for i in range(count):
    response = requests.get("https://quotes15.p.rapidapi.com/quotes/random/", headers = rapidapiHeadersForFamousQuotesApi)
    if(response.status_code == 200):
      contents.append(response.json()["content"])
    else:
      return getRandomCommentContent(count= count)  
  return contents

def signupRequest(data): # -> userModel
  randomNumber = random.randint(1, 3)
  if(randomNumber == 2):
    del data["username"]
  res = requests.post(mainRoute+"/auth/signup",json=data)
  if(res.status_code == 200):
    res = res.json()
    user = UserModel(data["username"] if randomNumber != 2 else res["info"], data["email"], data["password"], res["tokens"]["jwt_token"], res["tokens"]["refresh_token"], res["socketTokens"]["websocket_jwt_token"], res["socketTokens"]["websocket_refresh_token"])
    user.x_refresh_key = user.x_refresh_key[0]
    user.addLocalImagePath("files/users/{}".format(data["picture_name"]))
    return user
  elif(res.status_code == 400 or res.status_code == 412):
    newRandomUserInfo = getRandomUserInfo()
    return signupRequest(newRandomUserInfo)
  else:
    return signupRequest(data)

def changeProfilePhoto(user: UserModel):
  try:
    file = {"profile_photo":(open(user.imagePath,'rb')),}
    response = requests.post(mainRoute+"/account/change_profile_photo",files = file, headers= loginedUserJwtHeaders(user))
    if(response.status_code == 200):
      return True
    else:
      return False
  except Exception as error:
    print('at request_service/changeProfilePhoto(): '+ str(error))

def getProfileInformation(user: UserModel):
  response = requests.get(mainRoute+"/account/profile_info", headers= loginedUserJwtHeaders(user))
  checkedUser = isTokensReplaced(response, user)
  return checkedUser

def loginRequest(username: str,email: str,password: str, local_id: int):
  data =  {
    "email": email,
    "password": password  
  }
  response = requests.post(mainRoute+"/auth/login_with_email", json=data)
  if(response.status_code == 200):
    res = response.json()
    user = UserModel(username, email, password, res["tokens"]["jwt_token"], res["tokens"]["refresh_token"], res["socketTokens"]["websocket_jwt_token"], res["socketTokens"]["websocket_refresh_token"])
    user.x_refresh_key = user.x_refresh_key[0]
    user.addLocalId(local_id)
    return user
  else:
    print(response.text)
  
def createNoticeRequest(user: UserModel, scrapedNotice: ScrapedNoticeModel):
  headers = loginedUserJwtHeaders(user)
  response = requests.post(mainRoute+"/owned_notice/add_notice", json= scrapedNotice.modelToRequestBodyNotation(), headers=  headers)
  if(response.status_code == 200):
    responseBody = response.json()
    noticeId = responseBody["json"]["notice_id"]
    # "notice_images"
    files = []
    for path in scrapedNotice.photoPaths:
      files.append(("notice_images",(open(path,'rb')),))
    fileSendResponse = requests.post(mainRoute+ "/owned_notice/create_notice_photos/{}".format(noticeId),headers= headers, files= files)
    if(fileSendResponse.status_code != 200):
      print(fileSendResponse.text)
      return False
    else:
      return True
  else:
    print(response.text)
    print("an error occurred while creating new notice")
    print(scrapedNotice.modelToRequestBodyNotation())
    return False
  
def getHomePageNoticesRequest(user: UserModel, page=1, refresh= "false"):
  response = requests.get(mainRoute+"/account/get_home_notices/{page}/{refresh}".format(page= page, refresh= refresh), headers= loginedUserJwtHeaders(user))
  return response.json()["json"]["notices"]

def addCommentToNoticesRequest(user: UserModel, notice_id, content):
  json= {"notice_id": notice_id, "content": content}
  response = requests.post(mainRoute+"/comment/add_comment", headers = loginedUserJwtHeaders(user), json= json)
  if(response.status_code != 200):
    print(response.text)
    return False
  else:
    return True
  
def giveOfferRequest(user: UserModel,price: float, notice_id):
  json = {"notice_id": notice_id, "price": price}
  response = requests.post(mainRoute+"/offer/give_offer",json= json, headers= loginedUserJwtHeaders(user))
  if(response.status_code == 200):
    return True
  else:
    print(response.text)
    return False
  
def getNoticeDetails(notice_id):
  try:
    response = requests.get(mainRoute+"/public/notice_details/{}".format(notice_id))
    return response.json()
  except Exception as error:
    print('An exception occurred requestService/getNoticeDetails(): {}'.format(str(error)))
    
def userInfo(user_id):
  try:
    response = requests.get(mainRoute+"/public/user_info/{}".format(user_id))
    return response.json()
  except Exception as error:
    print('An exception on requestService/userInfo(): {}'.format(str(error)))
    
def getUserSalingOffersRequest(user: UserModel):
  user.x_refresh_key = user.x_refresh_key[0]
  try:
    response = requests.get(mainRoute+"/offer/get_saling_offers", headers= loginedUserJwtHeaders(user))
    if(response.status_code == 200):
      return response.json()["json"]
    else:
      print(response.text)
  except Exception as error:
    print('An exception on requestService/getUserSalingOffersRequest(): {}'.format(str(error)))
    
def getUserBuyingOffersRequest(user: UserModel):
  user.x_refresh_key = user.x_refresh_key[0]
  try:
    response = requests.get(mainRoute+"/offer/get_buying_offers", headers= loginedUserJwtHeaders(user))
    if(response.status_code == 200):
      return response.json()["json"]
    else:
      print(response.text)
  except Exception as error:
    print('An exception on requestService/getUserBuyingOffersRequest(): {}'.format(str(error)))
  
def declineOfferRequest(user: UserModel,notice_id, offer_id):
  try:
    json= {"notice_id": notice_id, "offer_id": offer_id}
    response = requests.post(mainRoute+"/offer/decline_offer", json= json, headers= loginedUserJwtHeaders(user))
    if(response.status_code != 200):
      print(response.text)
      
  except Exception as error:
    print('An exception on requestService/declineOffer(): {}'.format(str(error)))
  
def acceptOfferRequest(user: UserModel,notice_id, offer_id):
  try:
    json= {"notice_id": notice_id, "offer_id": offer_id}
    response = requests.post(mainRoute+"/offer/accept_offer", json= json, headers= loginedUserJwtHeaders(user))
    if(response.status_code != 200):
      print(response.text)
  except Exception as error:
    print('An exception on requestService/acceptOffer(): {}'.format(str(error)))
  
def addToFavoritesRequest(user: UserModel, notice_id):
  try:
    response = requests.post(mainRoute+"/notice/add_to_favorites/{}".format(notice_id), headers= loginedUserJwtHeaders(user))
    if(response.status_code != 200):
      print(response.text)
  except Exception as error:
    print('An exception on requestService/addToFavoritesRequest(): {}'.format(str(error)))
  
def getCartRequest(user: UserModel):
  try:
    response = requests.get(mainRoute+"/sale/get_cart", headers=loginedUserJwtHeaders(user))
    if(response.status_code != 200):
      print(response.text)
    else:
      return response
  except Exception as error:
    print('An exception on requestService/getCartRequest(): {}'.format(str(error)))  
  
def addToCartRequest(user: UserModel, notice_id):
  try:
    json = {"notice_id": notice_id}
    response = requests.post(mainRoute+"/notice/add_to_cart", json= json, headers= loginedUserJwtHeaders(user))
    if(response.status_code != 200):
      print(response.text)
  except Exception as error:
    print('An exception on requestService/addToCartRequest(): {}'.format(str(error)))
  
def addToLookedNoticesRequest(user: UserModel, notice_id):
  json = {"notice_id": notice_id}
  try:
    response = requests.post(mainRoute+"/notice/add_looked_notice", json= json, headers= loginedUserJwtHeaders(user))
    if(response.status_code != 200):
      print(response.text)
  except Exception as error:
    print('An exception on requestService/addToLookedNoticesRequest(): {}'.format(str(error)))
    
def getRandomAddress(): 
  try:
    randomUserResponse  = requests.get(randomUserApiRootUrl +"/getuser",  headers=rapidapiHeadersForRandomuserApi)
    if(randomUserResponse.status_code == 200):
      randomUserResponse = randomUserResponse.json()
      result= {}
      address = {}
      address.update({"address_description": "any place in our planet"})
      address.update({"city":randomUserResponse["results"][0]["location"]["city"]})
      address.update({"county":randomUserResponse["results"][0]["location"]["state"]})
      address.update({"neighborhood": randomUserResponse["results"][0]["location"]["street"]["name"]})
      result.update({"address_informations": address})    

      contact = {
        "name": randomUserResponse["results"][0]["name"]["first"],
        "surname": randomUserResponse["results"][0]["name"]["last"],
        "credendial_id_number": randomUserResponse["results"][0]["login"]["md5"],
      }

      phoneNumber = randomUserResponse["results"][0]["phone"]
      resultPhoneNumber = ""
      for i in phoneNumber:
        if(i.isnumeric()):
          resultPhoneNumber += i
        else:
          resultPhoneNumber += "4"
      contact.update({"phone_number":resultPhoneNumber})
      result.update({"contact_informations": contact})
      result.update({"address_title": randomUserResponse["results"][0]["location"]["timezone"]["description"]})
      return result
    else: 
      getRandomUserInfo()    
  except Exception as error:
    print('an exception occurred on requestService/getRandomAddress(): {}'.format(str(error)))


def addAddressRequest(user: UserModel, address_informations):
  json = {
    "address_title": address_informations["address_title"],
    "contact_informations": address_informations["contact_informations"], 
    "address_informations": address_informations["address_informations"]
  }
  try:
    response = requests.post(mainRoute+"/account/add_address",json= json, headers= loginedUserJwtHeaders(user))
    if(response.status_code != 200):
      print(response.text)
  except Exception as error:
    print('An exception on requestService/addAddressRequest(): {}'.format(str(error)))
    
def getAddressesRequest(user: UserModel):
  try:
    response = requests.get(mainRoute+"/account/get_addresses", headers= loginedUserJwtHeaders(user))
    if(response.status_code != 200):
      print(response.text)
    else:
      return response.json()["json"]
  except Exception as error:
    print('An exception on requestService/getAddressesRequest(): {}'.format(str(error)))

def checkCartRequest(user: UserModel, address_id):
  try:
    json = {"address_id": address_id}
    response = requests.post(mainRoute+"/sale/check_cart", headers= loginedUserJwtHeaders(user), json= json)
    if(response.status_code != 200):
      print(response.text)
  except Exception as error:
    print('An exception on requestService/checkCartRequest(): {}'.format(str(error)))

def getTakenNoticesRequest(user: UserModel):
  try:
    response = requests.get(mainRoute+"/account/get_taken_notices", headers= loginedUserJwtHeaders(user))
    if(response.status_code != 200):
      print(response.text)
    else:
      return response.json()["json"]
  except:
    print('An exception on requestService/getTakenNoticesRequest(): {}'.format(str(error)))

def cancelBuyingRequest(user: UserModel, soldNoticeId):
  try:
    json = {"sold_notice_id": soldNoticeId}
    response = requests.post(mainRoute+"/sale/cancel_buying", headers= loginedUserJwtHeaders(user), json= json)
    if(response.status_code != 200):
      print(response.text)
  except Exception as error:
    print('An exception on requestService/cancelBuyingRequest(): {}'.format(str(error)))

def getOwnNoticesRequest(user: UserModel):
  try:
    response = requests.get(mainRoute+"/account/get_own_notices", headers=loginedUserJwtHeaders(user))
    if(response.status_code != 200):
      print(response.text)
    else:
      return response.json()
  except Exception as error:
    print('An exception on requestService/getOwnNoticesRequest(): {}'.format(str(error)))

def addAnswerToNoticeRequest(user: UserModel,notice_id,comment_id):
  try:
    content = getRandomCommentContent()[0]
    json = {"content": content,"notice_id": notice_id, "comment_id": comment_id}
    response = requests.post(mainRoute+"/comment/add_answer", headers= loginedUserJwtHeaders(user), json= json)
    if(response.status_code != 200):
      print(response.text)
  except Exception as error:
    print('An exception on requestService/addAnswerToNoticeRequest(): {}'.format(str(error)))

def followUserRequest(user: UserModel, user_id):
  try:
    json = {"user_id": user_id}
    response = requests.post(mainRoute+"/other_user/follow_user", headers= loginedUserJwtHeaders(user), json= json)
    if(response.status_code != 200):
      print(response.text)
  except Exception as error:
    print('An exception on requestService/followUserRequest(): {}'.format(str(error)))

def getUserRatingsRequest(user,user_id,page=1):
  try:
    json = {
      "user_id": user_id,
    }
    response = requests.get(mainRoute+"/comment/get_user_ratings/{}".format(page), headers= loginedUserJwtHeaders(user), json= json)
    return response.json()["json"]
  except Exception as error:
    print('An exception on requestService/getUserRatingsRequest(): {}'.format(str(error)))

def addRatingRequest(user,data):
  try:
    response = requests.post(mainRoute+"/comment/add_rating", headers= loginedUserJwtHeaders(user), json= data)
    if(response.status_code != 200):
      print(response.text)
  except:
    print('An exception on requestService/addRatingRequest(): {}'.format(str(error)))
