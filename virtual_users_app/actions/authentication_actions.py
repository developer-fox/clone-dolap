
import services.request_service as request_service
from services.local_db_service import localDbInstance
from services.socket_service import Socket
from model.user_model import UserModel
import services.file_service as file_service

def signup():
  try:
    randomUserData = request_service.getRandomUserInfo()
    createdUser = request_service.signupRequest(randomUserData)
    localDbInstance.saveNewUser(createdUser)
    return createdUser
  except Exception as error:
    if(error == "data Error"):
      signup()
    else:
      print("on authentication_actions/signup(): "+str(error))
      
def randomLogin():
  randomUserInDb = localDbInstance.getRandomUserInformationForLogin()
  loginedUser = request_service.loginRequest(randomUserInDb["username"], randomUserInDb["email"], randomUserInDb["password"], randomUserInDb["local_id"])
  localDbInstance.setUserLoginedInfo(loginedUser)
  currentSocket = Socket(loginedUser)
  currentSocket.activateUser()
  return loginedUser

def customLogin(local_id: int):
  result = localDbInstance.cursor.execute("select * from USERS WHERE id= ?",(local_id,)).fetchall()
  result = result[0]
  loginedUser = UserModel(result[2], result[3], result[4], result[5], result[6], result[7], result[8])
  loginedUser.addLocalId(result[0])
  return loginedUser

def customLogout(user: UserModel):
  currentSocket = Socket(user).deactivateUser()
  localDbInstance.customUserLogout(user)