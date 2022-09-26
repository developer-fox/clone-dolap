
import services.request_service as request_service
from services.local_db_service import localDbInstance
from services.socket_service import Socket
from model.user_model import UserModel
import services.file_service as file_service
from actions.abstract_action_class import Action
from actions.account_actions import AccountActions
import random
import time

class AuthenticationActions(Action):
  def __init__(self):
    pass

  def signup(self):
    try:
      randomUserData = request_service.getRandomUserInfo()
      createdUser = request_service.signupRequest(randomUserData)
      localDbInstance.saveNewUser(createdUser)
      self.defineSingleUser(createdUser)
    except Exception as error:
      if(error == "data Error"):
        signup()
      else:
        print("on authentication_actions/signup(): "+str(error))

  def multipleSignup(self,count: int):
    signupedUsers = []
    for i in range(count):
      try:
        randomNumber = random.randint(1,2)
        randomUserData = request_service.getRandomUserInfo()
        createdUser = request_service.signupRequest(randomUserData)
        print("created user: {}".format(createdUser.username))
        localDbInstance.saveNewUser(createdUser)
        signupedUsers.append(createdUser)
        if(randomNumber == 2):
          accountAct = AccountActions()
          accountAct.setSingleUser(createdUser)
          accountAct.changeProfilePhoto()
      except Exception as error:
        if(error == "data Error"):
          signup()
        else:
          print("on authentication_actions/signup(): "+str(error))

    self.defineMultipleUsers(signupedUsers)

  def randomLogin(self):
    randomUserInDb = localDbInstance.getRandomUserInformationForLogin()
    loginedUser = request_service.loginRequest(randomUserInDb["username"], randomUserInDb["email"], randomUserInDb["password"], randomUserInDb["local_id"])
    localDbInstance.setUserLoginedInfo(loginedUser)
    currentSocket = Socket(loginedUser)
    currentSocket.activateUser()
    self.defineSingleUser(loginedUser)

  def randomLoginMultiple(self,count):
    self.setMultipleUsers([])
    for i in range(count):
      randomUserInDb = localDbInstance.getRandomUserInformationForLogin()
      loginedUser = request_service.loginRequest(randomUserInDb["username"], randomUserInDb["email"], randomUserInDb["password"], randomUserInDb["local_id"])
      localDbInstance.setUserLoginedInfo(loginedUser)
      currentSocket = Socket(loginedUser)
      currentSocket.activateUser()
      loginedUser.addSocket(currentSocket)
      self.addToMultipleUsers(loginedUser)
      time.sleep(.4)

  def customLogin(self,local_id: int):
    result = localDbInstance.cursor.execute("select * from USERS WHERE id= ?",(local_id,)).fetchall()
    result = result[0]
    loginedUser = UserModel(result[2], result[3], result[4], result[5], result[6], result[7], result[8])
    loginedUser.addLocalId(result[0])
    loginedUser.x_refresh_key = loginedUser.x_refresh_key[0]
    self.defineSingleUser(loginedUser)

  def customLogout(self):
    currentSocket = Socket(self.getSingleUser()).deactivateUser()
    localDbInstance.customUserLogout(self.getSingleUser())
    
  def multipleRandomLogin(self, count):
    try:
      usersList = localDbInstance.multipleRandomLogin(count)
      loginedUsers = []
      for user in usersList:
        currentLoginedUser = request_service.loginRequest(user.username, user.email, user.password, user.local_id)
        currentSocket = Socket(currentLoginedUser)
        currentLoginedUser.addSocket(currentSocket)
        loginedUsers.append(currentLoginedUser)
      self.defineMultipleUsers(userModelsList= loginedUsers)
    except Exception as error:
      print('An exception occurred: {}'.format(str(error)))      

  def findLocalUserWithObjectId(self, objectId):
    response = request_service.userInfo(objectId)
    localUser = localDbInstance.getLocalUserWithUsername(response["username"])
    self.defineSingleUser(localUser)
