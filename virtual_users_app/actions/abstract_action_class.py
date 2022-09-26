from abc import ABC, abstractmethod
from model.user_model import *
from services.request_service import getRandomUserInfo

class Action:
  
  # for single user actions
  def defineSingleUser(self, user: UserModel):
    self.processUser= user
  
  def setSingleUser(self, user: UserModel):
    self.processUser = user
  
  def getSingleUser(self):
    return self.processUser

  #for multiple user actions
  def defineMultipleUsers(self, userModelsList = []):
    self.processMultipleUsers = userModelsList
  
  def addToMultipleUsers(self, user):
    self.processMultipleUsers.append(user)
  
  def setMultipleUsers(self, userModelsList):
    self.processMultipleUsers = userModelsList
    
  def getMultipleUsers(self):
    return self.processMultipleUsers
