

import requests
import shutil
import services.file_service as file_service
from services.local_db_service import localDbInstance
from model.user_model import UserModel
import os

mainRoute = os.getenv("api_url")
randomUserApiRootUrl = os.getenv("randomuser_api_url")
strongPasswordApiRootUrl = os.getenv("strong_password_api_url")

rapidapiHeadersForRandomuserApi = {
  'X-RapidAPI-Key': os.getenv("x_rapidapi_key"),
  'X-RapidAPI-Host': os.getenv("x_rapidapi_host_randomuser"),
}
rapidapiHeadersForStrongPasswordApi = {
  'X-RapidAPI-Key': os.getenv("x_rapidapi_key"),
  'X-RapidAPI-Host': os.getenv("x_rapidapi_host_strong_password"),
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

def getRandomUserInfo(): # -> {"password", "email","username","picture_name", "phone_number"}

  randomUserResponse  = requests.get(randomUserApiRootUrl +"/getuser",headers=rapidapiHeadersForRandomuserApi)

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
        i = int(i)
        resultPhoneNumber += str(i)
      except Exception as error:
        pass
    result.update({"phone_number":resultPhoneNumber})
    try:
      profileImageRequest = requests.get(profileImageUrl, stream= True)
      result.update({"picture_name":randomUserResponse["results"][0]["login"]["uuid"]+"."+ profileImageUrl.split(".")[-1]})
      writingImageResult = file_service.writeUserProfileImage("./files/{}".format(result["picture_name"]), profileImageRequest)
      if(writingImageResult == False):
        getRandomUserInfo()
      else:
        return result
    except Exception as error:
      print('Something went wrong: {}'.format(error))
      getRandomUserInfo()
    return result
  else: 
    getRandomUserInfo()
  
def signupRequest(data): # -> userModel
  res = requests.post(mainRoute+"/auth/signup",json=data)
  if(res.status_code == 200):
    res = res.json()
    user = UserModel(data["username"], data["email"], data["password"], res["tokens"]["jwt_token"], res["tokens"]["refresh_token"], res["socketTokens"]["websocket_jwt_token"], res["socketTokens"]["websocket_refresh_token"])
    user.x_refresh_key = user.x_refresh_key[0]
    user.addLocalImagePath("files/{}".format(data["picture_name"]))
    return user
  elif(res.status_code == 400):
    newRandomUserInfo = getRandomUserInfo()
    signupRequest(newRandomUserInfo)
  else:
    signupRequest(data)
  
def changeProfilePhoto(user: UserModel):
    file = {"profile_photo":(open(user.imagePath,'rb')),}
    response = requests.post(mainRoute+"/account/change_profile_photo",files = file, headers= loginedUserJwtHeaders(user))
    if(response.status_code == 200):
      return True
    else:
      return False
    #print('at request_service/changeProfilePhoto(): '+ str(error))

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
  
  